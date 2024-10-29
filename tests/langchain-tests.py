# tests/test_model_loading.py
import pytest
from src.models.factory import get_model

def test_model_loading():
    """Test that we can load a model from config"""
    model = get_model("llama2")
    assert model is not None
    assert model.provider == "ollama"

# tests/test_chat_responses.py
def test_basic_response():
    """Test that model gives reasonable responses"""
    model = get_model("llama2")
    response = model.model("What is 2+2?")
    assert "4" in response.lower()

# tests/test_config_loading.py
from src.models.configs import get_model_config

def test_config_loading():
    """Test that we can load configurations"""
    config = get_model_config("llama2")
    assert config.model_name == "llama2"
    assert config.provider == "ollama"
    assert "temperature" in config.params

# tests/test_error_handling.py
def test_invalid_model():
    """Test error handling for invalid model names"""
    with pytest.raises(ValueError):
        get_model("nonexistent_model")
