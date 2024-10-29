#!/bin/zsh

# Source formatting utilities
SCRIPT_DIR=$(dirname "$0")
source "${SCRIPT_DIR}/format.sh"

print_step "Python Environment Setup"

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    print_error "Homebrew is not installed"
    echo "Please install Homebrew first:"
    print_command "https://brew.sh"
    exit 1
fi

# Check if Python 3.11 is installed via Homebrew
if ! brew list python@3.11 &> /dev/null; then
    print_error "Python 3.11 is not installed via Homebrew"
    echo "Please install it using:"
    print_command "brew install python@3.11"
    exit 1
fi

PYTHON_CMD="/opt/homebrew/bin/python3.11"

# Create virtual environment
print_step "Setting Up Virtual Environment"
if [ -d "venv" ]; then
    print_warning "Virtual environment already exists"
    print_warning "To recreate it, remove the venv directory and run this script again"
    exit 1
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
pip install --upgrade pip
print_success "pip upgraded successfully"

print_step "Setup Complete!"
echo -e "${BOLD}Next steps:${NC}"
echo "1. ${GREEN}Activate${NC} the virtual environment:"
print_command "source venv/bin/activate"
echo "2. Run the LangChain setup script:"
print_command "./env-setup/setup-langchain.sh"

# Add a final blank line
echo ""