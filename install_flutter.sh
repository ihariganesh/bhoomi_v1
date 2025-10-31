#!/bin/bash

# Flutter Installation Script for Linux
# This script will install Flutter SDK and configure your environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Flutter SDK Installation Script     ║${NC}"
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo ""

# Function to print success message
success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Function to print error message
error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to print warning message
warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Function to print info message
info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if Flutter is already installed
if command -v flutter &> /dev/null; then
    success "Flutter is already installed!"
    flutter --version
    echo ""
    read -p "Do you want to reinstall? (y/n): " reinstall
    if [ "$reinstall" != "y" ]; then
        exit 0
    fi
fi

# Create installation directory
INSTALL_DIR="$HOME"
FLUTTER_DIR="$INSTALL_DIR/flutter"

echo ""
info "Flutter will be installed to: $FLUTTER_DIR"
echo ""

# Check for existing Flutter installation
if [ -d "$FLUTTER_DIR" ]; then
    warning "Flutter directory already exists at $FLUTTER_DIR"
    read -p "Remove existing installation? (y/n): " remove_existing
    if [ "$remove_existing" = "y" ]; then
        info "Removing existing Flutter installation..."
        rm -rf "$FLUTTER_DIR"
        success "Removed existing installation"
    else
        error "Installation cancelled. Please remove $FLUTTER_DIR manually."
        exit 1
    fi
fi

# Download Flutter SDK
echo ""
info "Downloading Flutter SDK (this may take a few minutes)..."
cd "$INSTALL_DIR"

FLUTTER_VERSION="3.24.5"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"

if wget -q --show-progress "$FLUTTER_URL" -O flutter.tar.xz; then
    success "Flutter SDK downloaded successfully"
else
    error "Failed to download Flutter SDK"
    exit 1
fi

# Extract Flutter
info "Extracting Flutter SDK..."
if tar xf flutter.tar.xz; then
    success "Flutter SDK extracted successfully"
    rm flutter.tar.xz
else
    error "Failed to extract Flutter SDK"
    exit 1
fi

# Add Flutter to PATH
info "Configuring PATH..."

# Detect shell
SHELL_RC=""
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_RC="$HOME/.bashrc"
else
    SHELL_RC="$HOME/.profile"
fi

# Check if PATH is already configured
if grep -q "flutter/bin" "$SHELL_RC" 2>/dev/null; then
    warning "Flutter PATH already configured in $SHELL_RC"
else
    echo "" >> "$SHELL_RC"
    echo "# Flutter SDK" >> "$SHELL_RC"
    echo "export PATH=\"\$PATH:$FLUTTER_DIR/bin\"" >> "$SHELL_RC"
    success "Added Flutter to PATH in $SHELL_RC"
fi

# Export PATH for current session
export PATH="$PATH:$FLUTTER_DIR/bin"

# Verify installation
echo ""
info "Verifying Flutter installation..."
if "$FLUTTER_DIR/bin/flutter" --version &> /dev/null; then
    success "Flutter installed successfully!"
    echo ""
    "$FLUTTER_DIR/bin/flutter" --version
else
    error "Flutter installation verification failed"
    exit 1
fi

# Run flutter doctor
echo ""
info "Running Flutter Doctor to check for additional dependencies..."
echo "════════════════════════════════════════════════════════════"
"$FLUTTER_DIR/bin/flutter" doctor

# Install additional dependencies
echo ""
echo "════════════════════════════════════════════════════════════"
info "Checking for additional required packages..."

# Check for required tools
MISSING_TOOLS=()

if ! command -v git &> /dev/null; then
    MISSING_TOOLS+=("git")
fi

if ! command -v curl &> /dev/null; then
    MISSING_TOOLS+=("curl")
fi

if ! command -v unzip &> /dev/null; then
    MISSING_TOOLS+=("unzip")
fi

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    warning "Missing required tools: ${MISSING_TOOLS[*]}"
    echo ""
    echo "Install them with:"
    echo "  Ubuntu/Debian: sudo apt-get install ${MISSING_TOOLS[*]}"
    echo "  Fedora: sudo dnf install ${MISSING_TOOLS[*]}"
    echo "  Arch: sudo pacman -S ${MISSING_TOOLS[*]}"
fi

echo ""
echo "════════════════════════════════════════════════════════════"
success "Flutter installation complete!"
echo ""
info "To use Flutter in the current terminal, run:"
echo "  source $SHELL_RC"
echo ""
info "Or open a new terminal window."
echo ""
info "Next steps:"
echo "  1. Open a new terminal or run: source $SHELL_RC"
echo "  2. Navigate to your project: cd /home/hari/Desktop/pro/bhoomi_v1"
echo "  3. Install dependencies: flutter pub get"
echo "  4. Run the app: flutter run"
echo ""
echo "Or simply run: ./start.sh"
echo ""
success "Happy coding! 🚀"
