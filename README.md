# LangChain Local LLM Template

A template for building LangChain applications with local LLMs (Ollama, LM Studio). This template provides a structured foundation for developing applications that interact with locally-hosted large language models.

## Project Structure

```
langchain-local-template/
├── env-setup/          # Environment setup scripts
├── src/                # Source code
│   └── models/         # Model-related code
├── tests/              # Test files
├── config/             # Configuration files
│   ├── models.yaml     # Model definitions
│   └── providers.yaml  # Provider settings
└── data/               # Data directory
    ├── inputs/         # Input files
    └── outputs/        # Generated outputs
```

## Prerequisites

- Python 3.11
- Ollama or LM Studio installed and running locally
- VS Code (recommended for development)

## Setup

### Make a copy of this repo
   ```bash
   gh repo create your-new-project \
   --template yourusername/langchain-local-template \
   --clone
   ```
Or, on GitHub:
* Go to the repository page.
* Click on the "Use this template" button.
* Choose Create a new repository.
* Name your new repository and set it to public or private as desired.

### Automated setup
First, make the setup scripts executable
   ```bash
   chmod +x env-setup/*.sh
   ```
Then run the setup script.
   ```bash
   ./env-setup/setup-all.sh
   ```

You can also run the individual setup scripts: 
   ```bash
   ./env-setup/setup-python.sh
   source venv/bin/activate
   ./env-setup/setup-langchain.sh
   ```


### Manual setup
1. Set up a Python virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: .\venv\Scripts\activate
   ```
2. Install dependencies:
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
Choose a license when you copy this template.

#### Badges
[![Python 3.9+](https://img.shields.io/badge/python-3.9+-blue.svg)](https://www.python.org/downloads/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/yourusername/langchain-local-template/graphs/commit-activity)
[![Template](https://img.shields.io/badge/GitHub-Template-green?logo=github)](https://github.com/yourusername/langchain-local-template/generate)
[![LangChain](https://img.shields.io/badge/🦜_LangChain-Powered-blue)](https://github.com/langchain-ai/langchain)
