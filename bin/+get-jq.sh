#!/bin/sh
set -eu # Exit on error, treat unset variables as error

# --- Configuration ---
JQ_VERSION="1.8.1"

REPO_OWNER="jqlang"
REPO_NAME="jq"
INSTALL_DIR="$HOME/.local/bin"
BINARY_NAME="jq"

# --- Helper Functions ---
log() {
    echo "INFO($0): $@"
}

error_exit() {
    echo "ERROR($0): $@" >&2
    exit 1
}

# --- Check for required commands ---
check_command() {
    command -v "$1" >/dev/null 2>&1 || error_exit "$1 is not installed. Please install it and try again."
}

check_command "curl"
check_command "mkdir"
check_command "mv"
check_command "chmod"
check_command "uname"
check_command "mktemp"

# --- Determine System Architecture and OS ---
ARCH=$(uname -m)
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

TARGET_ARCH=""
case "$ARCH" in
    x86_64) TARGET_ARCH="amd64" ;;
    aarch64|arm64) TARGET_ARCH="arm64" ;;
    i386|i686) TARGET_ARCH="i386" ;;
    *) error_exit "Unsupported architecture: $ARCH" ;;
esac

log "Detected System: Arch=$TARGET_ARCH, OS=$OS"

# --- Construct Download URL ---
EXE_FILENAME="${BINARY_NAME}-${OS}-${TARGET_ARCH}"
DOWNLOAD_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/download/${REPO_NAME}-${JQ_VERSION}/${EXE_FILENAME}"

log "Download URL: $DOWNLOAD_URL"

# --- Download and Extract ---
cd "$INSTALL_DIR"
log "Downloading $EXE_FILENAME to $INSTALL_DIR..."
if ! curl -sSLO "$DOWNLOAD_URL"; then
    error_exit "Failed to download $EXE_FILENAME. Check URL and network."
fi
log "Download complete."

# --- Install Binary ---
chmod +x "$EXE_FILENAME"
mv "$EXE_FILENAME" "$BINARY_NAME"

# --- Sanity Check ---
INSTALL_PATH="$INSTALL_DIR/$BINARY_NAME"
if "$INSTALL_PATH" --version > /dev/null 2>&1; then
    JQ_VERSION=$("$INSTALL_PATH" --version)
    log "Successfully installed $JQ_VERSION"
else
    error_exit "Installation seems to have failed. '$INSTALL_PATH --version' did not run correctly."
fi

exit 0
