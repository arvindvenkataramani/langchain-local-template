# LangChain Local LLM Template

A template for building LangChain applications with local LLMs (Ollama, LM Studio). This template provides a structured foundation for developing applications that interact with locally-hosted large language models.

## Project Structure

```
langchain-local-template/
├── src/                  # Source code
│   └── models/          # Model-related code
├── tests/               # Test files
├── config/              # Configuration files
│   ├── models.yaml     # Model definitions
│   └── providers.yaml  # Provider settings
└── data/               # Data directory
    ├── inputs/         # Input files
    └── outputs/        # Generated outputs
```

## Prerequisites

- Python 3.9 or higher
- Ollama or LM Studio installed and running locally
- VS Code (recommended for development)

## Setup

1. Create a new repository using this template
2. Clone your new repository
3. Set up a Python virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: .\venv\Scripts\activate
   ```
4. Install dependencies:
   ```bash
   # Basic installation
   pip install -r requirements.txt

   # For development (includes testing and code quality tools)
   pip install ".[dev]"
   ```

## Configuration

1. Configure your models in `config/models.yaml`
2. Configure your providers in `config/providers.yaml`
3. Ensure your local LLM service (Ollama/LM Studio) is running

## Development

This template includes several tools for development:

- `black`: Code formatting
- `ruff`: Linting
- `mypy`: Type checking
- `pytest`: Testing
- VS Code configurations for Python development

VS Code will automatically:
- Format code on save
- Show type hints
- Run linting
- Provide intelligent code completion

## Testing

Run tests using pytest:
```bash
pytest tests/
```

## Project Organization

- `src/models/`: Core model interaction code
- `config/`: YAML configuration files
- `data/`: Input and output data
- `tests/`: Test files
- `env-setup/`: Environment setup scripts
- `.vscode/`: VS Code configuration

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests
5. Create a pull request

## License

[Your chosen license]

#### Badges
[![Python 3.9+](https://img.shields.io/badge/python-3.9+-blue.svg)](https://www.python.org/downloads/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/yourusername/langchain-local-template/graphs/commit-activity)
[![Template](https://img.shields.io/badge/GitHub-Template-green?logo=github)](https://github.com/yourusername/langchain-local-template/generate)
[![LangChain](https://img.shields.io/badge/🦜_LangChain-Powered-blue)](https://github.com/langchain-ai/langchain)
