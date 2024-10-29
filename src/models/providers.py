# src/models/providers.py
from typing import Protocol, Any, Dict
from langchain_community.llms import Ollama, OpenAI
from .configs import get_provider_config

class ModelProvider(Protocol):
    """Protocol defining what a provider must implement"""
    def create_model(self, model_name: str, **kwargs) -> Any:
        """Create a model instance"""
        ...

class OllamaProvider:
    def create_model(self, model_name: str, **kwargs) -> Ollama:
        config = get_provider_config("ollama")
        return Ollama(
            model=model_name,
            base_url=config["base_url"],
            **kwargs
        )

class LMStudioProvider:
    def create_model(self, model_name: str, **kwargs) -> OpenAI:
        config = get_provider_config("lmstudio")
        return OpenAI(
            base_url=config["base_url"],
            api_key="not-needed",
            **kwargs
        )

# Map provider types to their implementations
PROVIDER_CLASSES = {
    "ollama": OllamaProvider(),
    "lmstudio": LMStudioProvider(),
}

def get_provider(provider_type: str) -> ModelProvider:
    """Get a provider instance by type"""
    if provider_type not in PROVIDER_CLASSES:
        raise ValueError(
            f"Unknown provider type: {provider_type}. "
            f"Available providers: {list(PROVIDER_CLASSES.keys())}"
        )
    return PROVIDER_CLASSES[provider_type]
