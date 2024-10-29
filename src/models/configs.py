# src/models/configs.py
from dataclasses import dataclass
from typing import Dict, Any
import yaml
from pathlib import Path

@dataclass
class ModelConfig:
    model_name: str
    provider: str
    params: Dict[str, Any]

class ConfigLoader:
    def __init__(self):
        self.config_dir = Path("config")
        self._load_configs()

    def _load_configs(self):
        """Load all configuration files"""
        # Load providers
        with open(self.config_dir / "providers.yaml") as f:
            self.providers = yaml.safe_load(f)

        # Load models
        with open(self.config_dir / "models.yaml") as f:
            self.models = yaml.safe_load(f)

    def get_provider_config(self, provider_name: str) -> Dict[str, Any]:
        """Get provider configuration"""
        if provider_name not in self.providers:
            raise ValueError(f"Unknown provider: {provider_name}")
        return self.providers[provider_name]

    def get_model_config(self, model_name: str = None) -> ModelConfig:
        """Get model configuration"""
        if model_name is None:
            model_name = self.models["default_model"]

        if model_name not in self.models["models"]:
            raise ValueError(f"Unknown model: {model_name}")

        model_config = self.models["models"][model_name]
        provider_config = self.providers[model_config["provider"]]

        # Merge provider defaults with model-specific params
        params = provider_config["default_params"].copy()
        params.update(model_config.get("params", {}))

        return ModelConfig(
            model_name=model_config["model_name"],
            provider=model_config["provider"],
            params=params
        )

# Create singleton instance
config = ConfigLoader()

def get_model_config(model_name: str = None) -> ModelConfig:
    """Convenience function to get model configuration"""
    return config.get_model_config(model_name)

def get_provider_config(provider_name: str) -> Dict[str, Any]:
    """Convenience function to get provider configuration"""
    return config.get_provider_config(provider_name)
