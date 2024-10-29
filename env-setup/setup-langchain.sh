#!/bin/zsh

# Source formatting utilities
SCRIPT_DIR=$(dirname "$0")
source "${SCRIPT_DIR}/format.sh"

print_step "LangChain Setup"

# Check virtual environment
if [[ "$VIRTUAL_ENV" == "" ]]; then
    print_error "Virtual environment is not activated"
    echo "Please run:"
    print_command "source venv/bin/activate"
    exit 1
fi

# Install main project dependencies
print_step "Installing Main Dependencies"
echo "Installing from pyproject.toml..."
pip install -e .
print_success "Main dependencies installed"

# Verify LangChain installation
print_step "Verifying LangChain Installation"
if python -c "import langchain; print(f'LangChain {langchain.__version__} installed successfully')" ; then
    print_success "LangChain verification passed"
else
    print_error "LangChain verification failed"
    exit 1
fi

# Install development dependencies
print_step "Installing Development Dependencies"
echo "Installing development packages..."
pip install -e ".[dev]"
print_success "Development dependencies installed"

# Verify dev tools
print_step "Verifying Development Tools"
if black --version >/dev/null 2>&1 && \
   ruff --version >/dev/null 2>&1 && \
   pytest --version >/dev/null 2>&1; then
    print_success "Development tools verification passed"
else
    print_error "Some development tools are missing"
    exit 1
fi

print_step "Setup Complete!"
echo -e "${BOLD}Next steps:${NC}"
echo "1. Configure your models in config/models.yaml"
echo "2. Start your local LLM service:"
print_command "Ollama: ollama serve"
print_command "or"
print_command "LM Studio: Start via application"

# Add a final blank line
echo ""