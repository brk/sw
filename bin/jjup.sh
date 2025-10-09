#!/bin/sh
set -eu # Exit on error, treat unset variables as error

# --- Configuration ---
REPO_OWNER="jj-vcs"
REPO_NAME="jj"
INSTALL_DIR="$HOME/.local/bin"
BINARY_NAME="jj"

# --- Helper Functions ---
log() {
    echo "INFO: $@"
}

error_exit() {
    echo "ERROR: $@" >&2
    exit 1
}

# --- Check for required commands ---
check_command() {
    command -v "$1" >/dev/null 2>&1 || error_exit "$1 is not installed. Please install it and try again."
}

check_command "curl"
check_command "jq"
check_command "tar"
check_command "mkdir"
check_command "mv"
check_command "chmod"
check_command "uname"
check_command "mktemp"

# --- Determine System Architecture and OS ---
ARCH=$(uname -m)
OS=$(uname -s)

TARGET_ARCH=""
case "$ARCH" in
    x86_64) TARGET_ARCH="x86_64" ;;
    aarch64|arm64) TARGET_ARCH="aarch64" ;;
    *) error_exit "Unsupported architecture: $ARCH" ;;
esac

TARGET_OS_TRIPLE=""
case "$OS" in
    Linux) TARGET_OS_TRIPLE="unknown-linux-musl" ;;
    Darwin) TARGET_OS_TRIPLE="apple-darwin" ;;
    *) error_exit "Unsupported operating system: $OS" ;;
esac

log "Detected System: Arch=$TARGET_ARCH, OS=$TARGET_OS_TRIPLE"


# --- Get Latest Release Tag ---
API_URL="https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest"
log "Fetching latest release tag from $API_URL..."

# Fetch and sanitize the output before passing to jq
# tr -dc '[:print:]' removes non-printable characters including tab, newline, and carriage return.
# This helps with stricter jq versions (like 1.7+) that might error on unescaped control chars.
# GitHub can return JSON with un-escaped newlines.
# We assign to a variable first to make error checking on curl's output itself (if needed) easier,
# though for jq parsing errors, the combined pipeline is what matters.
# The direct pipe is fine here as curl -s suppresses progress, and -L handles redirects.
# Errors from curl (network etc) would likely result in non-JSON output, which jq would also fail on.

TMP_FILE=/tmp/jjup.json
if ! $(curl -sL "$API_URL" > $TMP_FILE); then
    error_exit "curl command failed to fetch release information from $API_URL"
fi

# Sanitize for jq 1.7+
# [:print:] includes space. We also explicitly allow tab, newline, carriage return.
# Other control characters (0x00-0x1F, except 0x09, 0x0A, 0x0D) will be deleted.
# This is a common approach to clean up potentially "dirty" JSON input.
SANITIZED_JSON_INPUT=/tmp/jjup2.json
cat $TMP_FILE | tr -dc '[:print:]\t' > $SANITIZED_JSON_INPUT
rm $TMP_FILE

if ! LATEST_TAG=$(cat $SANITIZED_JSON_INPUT | jq -r '.tag_name'); then
    error_exit "Failed to parse release information with jq. Raw response (first 500 chars): $(echo "$LATEST_TAG_JSON_RAW" | head -c 500)"
fi

rm $SANITIZED_JSON_INPUT

if [ -z "$LATEST_TAG" ] || [ "$LATEST_TAG" = "null" ]; then
    error_exit "Could not determine latest release tag after parsing. Parsed tag: '$LATEST_TAG'. Sanitized JSON (first 500 chars): $(cat "$SANITIZED_JSON_INPUT" | head -c 500)"
fi
log "Latest release tag: $LATEST_TAG"

# --- Construct Download URL ---
TARBALL_FILENAME="${REPO_NAME}-${LATEST_TAG}-${TARGET_ARCH}-${TARGET_OS_TRIPLE}.tar.gz"
DOWNLOAD_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/download/${LATEST_TAG}/${TARBALL_FILENAME}"

log "Download URL: $DOWNLOAD_URL"

# --- Create Temporary Directory ---
TMP_DIR=$(mktemp -d -t jj-install-XXXXXX)
log "Created temporary directory: $TMP_DIR"

trap 'log "Cleaning up temporary directory: $TMP_DIR"; rm -rf "$TMP_DIR"' EXIT INT TERM

# --- Download and Extract ---
cd "$TMP_DIR" # IMPORTANT: operations are now relative to TMP_DIR
log "Downloading $TARBALL_FILENAME to $TMP_DIR..."
if ! curl -sSLO "$DOWNLOAD_URL"; then
    error_exit "Failed to download $TARBALL_FILENAME. Check URL and network."
fi
log "Download complete."

# --- MODIFIED SECTION for tar extraction ---
# Path of the binary *inside* the tarball.
# Primary attempt: "./jj" (as observed in current jj releases)
BINARY_PATH_IN_ARCHIVE_PRIMARY="./$BINARY_NAME"
# Fallback attempt: "jj" (if the './' prefix is ever dropped)
BINARY_PATH_IN_ARCHIVE_FALLBACK="$BINARY_NAME"

log "Attempting to extract '$BINARY_PATH_IN_ARCHIVE_PRIMARY' from $TARBALL_FILENAME..."
if ! tar -xzf "$TARBALL_FILENAME" "$BINARY_PATH_IN_ARCHIVE_PRIMARY" 2>/dev/null; then
    log "Extraction with '$BINARY_PATH_IN_ARCHIVE_PRIMARY' failed or file not found with that path."
    log "Attempting to extract '$BINARY_PATH_IN_ARCHIVE_FALLBACK' instead..."
    if ! tar -xzf "$TARBALL_FILENAME" "$BINARY_PATH_IN_ARCHIVE_FALLBACK"; then
        # If both attempts fail, list contents for debugging before erroring
        log "Listing archive contents for debugging:"
        tar -tf "$TARBALL_FILENAME" || log "Could not list archive contents."
        error_exit "Failed to extract '$BINARY_NAME' from $TARBALL_FILENAME. Searched for '$BINARY_PATH_IN_ARCHIVE_PRIMARY' and '$BINARY_PATH_IN_ARCHIVE_FALLBACK' at the archive root."
    fi
fi

# After successful extraction, tar places the file (e.g., "./jj" or "jj")
# into the current directory ($TMP_DIR) as just "jj".
if [ ! -f "$BINARY_NAME" ]; then
    error_exit "'$BINARY_NAME' not found in $TMP_DIR after attempting extraction. This is unexpected."
fi
log "'$BINARY_NAME' extracted successfully to $TMP_DIR/$BINARY_NAME."
# --- END MODIFIED SECTION ---

# --- Install Binary ---
log "Ensuring $INSTALL_DIR exists..."
mkdir -p "$INSTALL_DIR"

INSTALL_PATH="$INSTALL_DIR/$BINARY_NAME"
log "Moving $BINARY_NAME to $INSTALL_PATH..." # $BINARY_NAME here refers to $TMP_DIR/$BINARY_NAME
mv "$BINARY_NAME" "$INSTALL_PATH"
chmod +x "$INSTALL_PATH"

log "$BINARY_NAME installed successfully to $INSTALL_PATH"

# --- Final Instructions ---
case ":$PATH:" in
    *":$INSTALL_DIR:"*)
        log "$INSTALL_DIR is already in your PATH."
        ;;
    *)
        log "IMPORTANT: $INSTALL_DIR is not in your PATH."
        log "You may need to add it by adding the following to your shell configuration file (e.g., ~/.bashrc, ~/.zshrc, ~/.profile):"
        log "  export PATH=\"$INSTALL_DIR:\$PATH\""
        log "Then, source the file or open a new terminal."
        ;;
esac

if "$INSTALL_PATH" --version > /dev/null 2>&1; then
    JJ_VERSION=$("$INSTALL_PATH" --version)
    log "Successfully installed: $JJ_VERSION"
else
    error_exit "Installation seems to have failed. '$INSTALL_PATH --version' did not run correctly."
fi

log "Installation complete!"
# Trap will handle cleanup of $TMP_DIR
exit 0
