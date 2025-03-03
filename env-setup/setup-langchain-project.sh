#!/bin/bash
# Script to set up LangChain project dependencies using Pipenv

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Setting up LangChain project dependencies...${NC}"

# Check if we're in the project directory (contains pyproject.toml)
if [ ! -f "pyproject.toml" ]; then
    echo -e "${RED}Error: pyproject.toml not found.${NC}"
    echo -e "Are you in the project root directory?"
    exit 1
fi

# Check if Pipenv is installed
if ! command -v pipenv &> /dev/null; then
    echo -e "${RED}Pipenv not found. Please install it first.${NC}"
    echo -e "You can run the setup-mac-python-env.sh script to install it."
    exit 1
fi

# Initialize Pipenv environment
echo -e "${GREEN}Initializing Pipenv environment...${NC}"
pipenv --python $(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)

# Install project dependencies in development mode
echo -e "${GREEN}Installing project dependencies...${NC}"
pipenv install -e .

# Install development dependencies
echo -e "${GREEN}Installing development dependencies...${NC}"
pipenv install -e ".[dev]"

# Verify installation
echo -e "${GREEN}Verifying LangChain installation...${NC}"
pipenv run python -c "import langchain; print(f'LangChain version: {langchain.__version__}')"

echo
echo -e "${GREEN}LangChain project setup complete!${NC}"
echo -e "To activate the environment, run:"
echo -e "  ${GREEN}pipenv shell${NC}"
echo
echo -e "${YELLOW}To run a script in the environment without activating:${NC}"
echo -e "  pipenv run python src/your_script.py$"
echo
echo -e "${GREEN}Your project is ready for development!${NC}"
