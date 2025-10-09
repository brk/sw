#!/bin/sh
set -eu # Exit on error, treat unset variables as error

# --- Configuration ---
FISH_VERSION="4.1.2"

REPO_OWNER="fish-shell"
REPO_NAME="fish-shell"
INSTALL_DIR="$HOME/.local/bin"
BINARY_NAME="fish"

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
check_command "tar"
check_command "mv"
check_command "chmod"
check_command "uname"
check_command "mktemp"

# --- Determine System Architecture and OS ---
ARCH=$(uname -m)
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

TARGET_ARCH=""
case "$ARCH" in
    x86_64) TARGET_ARCH="x86_64" ;;
    aarch64|arm64) TARGET_ARCH="aarch64" ;;
    *) error_exit "Unsupported architecture: $ARCH" ;;
esac

log "Detected System: Arch=$TARGET_ARCH, OS=$OS"

# --- Construct Download URL ---
EXE_TARBALL="${BINARY_NAME}-${FISH_VERSION}-${OS}-${TARGET_ARCH}.tar.xz"
DOWNLOAD_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/download/${FISH_VERSION}/${EXE_TARBALL}"

log "Download URL: $DOWNLOAD_URL"

# --- Download and Extract ---
cd "$INSTALL_DIR"
log "Downloading $EXE_TARBALL to $INSTALL_DIR..."
if ! curl -sSLO "$DOWNLOAD_URL"; then
    error_exit "Failed to download $EXE_TARBALL. Check URL and network."
fi
log "Download complete."

tar -xf "$EXE_TARBALL" && rm "$EXE_TARBALL"

# --- Install Binary ---
chmod +x "$BINARY_NAME"

# --- Sanity Check ---
INSTALL_PATH="$INSTALL_DIR/$BINARY_NAME"
if "$INSTALL_PATH" --version > /dev/null 2>&1; then
    FISH_VERSION=$("$INSTALL_PATH" --version)
    log "Successfully installed $FISH_VERSION"
else
    error_exit "Installation seems to have failed. '$INSTALL_PATH --version' did not run correctly."
fi

exit 0
