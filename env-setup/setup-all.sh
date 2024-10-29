#!/bin/zsh

# Source formatting utilities
SCRIPT_DIR=$(dirname "$0")
source "${SCRIPT_DIR}/format.sh"

print_step "Starting Complete Setup Process"

# Run Python setup
print_step "Setting up Python Environment"
"${SCRIPT_DIR}/setup-python.sh"
if [ $? -ne 0 ]; then
    print_error "Python setup failed"
    exit 1
fi

# Activate virtual environment
print_step "Activating Virtual Environment"
source venv/bin/activate
if [ $? -ne 0 ]; then
    print_error "Failed to activate virtual environment"
    exit 1
fi
print_success "Virtual environment activated"

# Install LangChain
print_step "Installing LangChain"
if [[ "$1" == "--with-dev" ]]; then
    print_warning "Installing with development dependencies"
    "${SCRIPT_DIR}/setup-langchain.sh" --with-dev
else
    "${SCRIPT_DIR}/setup-langchain.sh"
fi
if [ $? -ne 0 ]; then
    print_error "LangChain setup failed"
    exit 1
fi

print_step "Setup Complete! 🎉"
echo -e "${BOLD}To start working:${NC}"
echo "1. In any new terminal, activate the virtual environment:"
print_command "source venv/bin/activate"
echo "2. Start your LLM service (Ollama or LM Studio)"
echo "3. Begin development!"

# Add a final blank line
echo ""
