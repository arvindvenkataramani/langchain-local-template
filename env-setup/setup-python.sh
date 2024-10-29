#!/bin/zsh

# Source formatting utilities
SCRIPT_DIR=$(dirname "$0")
source "${SCRIPT_DIR}/format.sh"

print_step "Python Environment Setup"

# Detect Python command
print_step "Detecting Python Installation"
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
    print_success "Found python3 command"
elif command -v python &> /dev/null; then
    # Check if python refers to Python 3
    PYTHON_VERSION=$(python --version 2>&1)
    if [[ $PYTHON_VERSION == Python\ 3* ]]; then
        PYTHON_CMD="python"
        print_success "Found python command (Python 3)"
    else
        print_error "Python 3 is required but wasn't found"
        exit 1
    fi
else
    print_error "Python 3 is required but wasn't found"
    exit 1
fi

# Check Python version
print_step "Checking Python Version"
PY_VERSION=$($PYTHON_CMD -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
print_success "Detected Python $PY_VERSION"

if (( ${PY_VERSION%.*} < 3 )) || (( ${PY_VERSION%.*} == 3 && ${PY_VERSION#*.} < 9 )); then
    print_error "Python 3.9 or higher is required (found $PY_VERSION)"
    exit 1
fi

# Create virtual environment
print_step "Setting Up Virtual Environment"
if [ -d "venv" ]; then
    print_warning "Virtual environment already exists"
    print_warning "To recreate it, remove the venv directory and run this script again"
else
    echo "Creating new virtual environment..."
    $PYTHON_CMD -m venv venv
    print_success "Virtual environment created"
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate
print_success "Virtual environment activated"

# Upgrade pip
print_step "Upgrading pip"
echo "Running pip upgrade..."
pip install --upgrade pip >/dev/null 2>&1
print_success "pip upgraded successfully"

print_step "Setup Complete!"
echo -e "${BOLD}Next steps:${NC}"
echo "1. ${GREEN}Activate${NC} the virtual environment:"
print_command "source venv/bin/activate"
echo "2. Run the LangChain setup script:"
print_command "./env-setup/setup_langchain.sh"

# Add a final blank line
echo ""
