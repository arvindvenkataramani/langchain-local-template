# src/models/factory.py
from typing import Optional, Dict, Any
from dataclasses import dataclass
from .configs import get_model_config
from .providers import get_provider

@dataclass
class ModelInstance:
    """Represents a configured model instance ready for use"""
    name: str
    provider: str
    model: Any  # The actual LangChain model instance

class ModelFactory:
    def __init__(self):
        self._active_models: Dict[str, ModelInstance] = {}
    
    def create_model(self, model_name: Optional[str] = None, force_new: bool = False) -> ModelInstance:
        """Create or retrieve a model instance"""
        # Get configuration from YAML
        config = get_model_config(model_name)
        
        # Create a unique identifier for this configuration
        model_id = f"{config.provider}-{config.model_name}"
        
        # Return existing instance if we have one and don't force new
        if not force_new and model_id in self._active_models:
            return self._active_models[model_id]
        
        # Get the provider and create the model
        provider = get_provider(config.provider)
        model = provider.create_model(
            model_name=config.model_name,
            **config.params
        )
        
        # Create and store the instance
        instance = ModelInstance(
            name=config.model_name,
            provider=config.provider,
            model=model
        )
        
        self._active_models[model_id] = instance
        return instance
    
    def list_active_models(self) -> list[str]:
        """List all currently active model instances"""
        return list(self._active_models.keys())

# Create a singleton instance
_factory = ModelFactory()

def get_model(model_name: Optional[str] = None, force_new: bool = False) -> ModelInstance:
    """Convenience function to get a model instance"""
    return _factory.create_model(model_name, force_new)

def list_active_models() -> list[str]:
    """List all active models"""
    return _factory.list_active_models()
