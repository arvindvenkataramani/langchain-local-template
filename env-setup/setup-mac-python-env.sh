#!/bin/bash
# Script to install Python and Pipenv via Homebrew

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Setting up Python development environment on macOS...${NC}"

# Check if Homebrew is installed
if ! command -v brew &> /dev/null
then
    echo -e "${YELLOW}Homebrew not found. Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo -e "${GREEN}Homebrew is already installed. Updating...${NC}"
    brew update
fi

# Install Python (latest version)
echo -e "${GREEN}Installing Python...${NC}"
brew install python

# Install Pipenv
echo -e "${GREEN}Installing Pipenv...${NC}"
brew install pipenv

# Set up PATH for Homebrew Python and Pipenv
echo -e "${GREEN}Setting up PATH...${NC}"

# Check if .zshrc exists (macOS default shell)
if [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
# Check if .bashrc exists
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
# Check if .bash_profile exists
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_RC="$HOME/.bash_profile"
else
    SHELL_RC="$HOME/.zshrc"
    touch "$SHELL_RC"
fi

# Add Homebrew Python to PATH if not already included
if ! grep -q 'export PATH="/usr/local/opt/python/libexec/bin:$PATH"' "$SHELL_RC"; then
    echo -e "\n# Set Homebrew Python as default" >> "$SHELL_RC"
    echo 'export PATH="/usr/local/opt/python/libexec/bin:$PATH"' >> "$SHELL_RC"
fi

# Add Pipenv environment variables
if ! grep -q "PIPENV_VENV_IN_PROJECT" "$SHELL_RC"; then
    echo -e "\n# Pipenv configuration" >> "$SHELL_RC"
    echo 'export PIPENV_VENV_IN_PROJECT=1' >> "$SHELL_RC"
fi

# Display Python version
echo -e "${GREEN}Python setup complete!${NC}"
echo -e "${YELLOW}To apply the changes, run: source $SHELL_RC${NC}"
echo -e "${YELLOW}Or restart your terminal.${NC}"
echo

# Display Python and Pipenv versions
echo -e "${GREEN}Installed versions:${NC}"
echo -n "Python: "
python3 --version
echo -n "Pipenv: "
pipenv --version

echo
echo -e "${GREEN}Setup complete! You're ready to develop Python applications on macOS.${NC}"
