#!/bin/zsh

# Exit if not in a virtual environment
if [[ "$VIRTUAL_ENV" == "" ]]; then
    echo "Virtual environment not activated"
    exit 1
fi

# Install main project dependencies from pyproject.toml
pip install -e .

# Install development dependencies
pip install -e ".[dev]"

# Simple verification that langchain installed correctly
python -c "import langchain; print(f'LangChain version: {langchain.__version__}')"