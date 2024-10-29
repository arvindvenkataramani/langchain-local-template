#!/bin/zsh

# Source formatting utilities
SCRIPT_DIR=$(dirname "$0")
source "${SCRIPT_DIR}/format.sh"

print_step "LangChain Setup"

# Check if virtual environment is activated
if [[ "$VIRTUAL_ENV" == "" ]]; then
    print_error "Virtual environment is not activated"
    echo "Please run:"
    print_command "source venv/bin/activate"
    exit 1
fi

print_step "Installing LangChain and Dependencies"

# Install basic requirements
echo "Installing basic requirements..."
pip install -r requirements.txt >/dev/null 2>&1
print_success "Basic requirements installed"

# Check if dev installation is requested
if [[ "$1" == "--with-dev" ]]; then
    print_step "Installing Development Dependencies"
    echo "Installing development packages..."
    pip install ".[dev]" >/dev/null 2>&1
    print_success "Development packages installed"
    
    # Install pre-commit hooks if .git directory exists
    if [ -d ".git" ]; then
        if command -v pre-commit &> /dev/null; then
            print_step "Setting Up Pre-commit Hooks"
            pre-commit install
            print_success "Pre-commit hooks installed"
        fi
    fi
fi

print_step "Verifying Installation"
python -c "import langchain; print(f'LangChain version: {langchain.__version__}')"

print_step "Setup Complete!"
echo -e "${BOLD}Next steps:${NC}"
echo "1. Configure your models in config/models.yaml"
echo "2. Configure your providers in config/providers.yaml"
echo "3. Start your local LLM service:"
print_command "Ollama: ollama serve"
print_command "or"
print_command "LM Studio: Start via application"

# Add a final blank line
echo ""
