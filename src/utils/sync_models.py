# src/utils/sync_models_v2.py
import requests
import yaml
from pathlib import Path
import sys
from typing import Dict, Any, Optional
import re

# Default parameters for unknown model families
DEFAULT_PARAMS = {
    "temperature": 0.7,    # Balance between creativity and consistency
    "top_p": 0.9,         # Nucleus sampling threshold
    "context_length": 4096 # Conservative default context window
}

# Model family definitions with their parameters
MODEL_FAMILIES = {
    "llama": {
        "patterns": [r"llama\d*", r"wizard-cobra", r"neural-chat"],
        "base_params": {
            "context_length": 4096,
            "temperature": 0.7,
            "top_p": 0.9,
            "repeat_penalty": 1.1,
            "top_k": 40,
            "presence_penalty": 0,
            "frequency_penalty": 0,
        },
        "variants": {
            "code": {
                "temperature": 0.3,
                "repeat_penalty": 1.2,
                "top_p": 0.95,
                "stop_sequences": ["\n\n", "```"],
            },
            "chat": {
                "temperature": 0.7,
                "presence_penalty": 0.2,
                "frequency_penalty": 0.2,
            }
        }
    },
    "mistral": {
        "patterns": [r"mistral\d*", r"mixtral\d*"],
        "base_params": {
            "context_length": 8192,
            "temperature": 0.7,
            "top_p": 0.9,
            "repeat_penalty": 1.1,
            "top_k": 50,
            "presence_penalty": 0,
            "frequency_penalty": 0,
        },
        "variants": {
            "instruct": {
                "temperature": 0.6,
                "top_p": 0.95,
            }
        }
    },
    "gemma": {
        "patterns": [r"gemma\d*"],
        "base_params": {
            "context_length": 8192,
            "temperature": 0.7,
            "top_p": 0.9,
            "repeat_penalty": 1.1,
            "top_k": 40,
            "presence_penalty": 0,
            "frequency_penalty": 0,
        }
    },
    "deepseek": {
        "patterns": [r"deepseek"],
        "base_params": {
            "context_length": 4096,
            "temperature": 0.5,
            "top_p": 0.95,
            "repeat_penalty": 1.1,
            "mirostat": 2,
            "mirostat_eta": 0.1,
        },
        "variants": {
            "coder": {
                "temperature": 0.3,
                "repeat_penalty": 1.2,
                "top_p": 0.95,
                "stop_sequences": ["\n\n", "```"],
            }
        }
    }
}

def get_ollama_models() -> list[Dict[str, Any]]:
    """Get list of models from Ollama API"""
    try:
        response = requests.get("http://localhost:11434/api/tags")
        if response.status_code == 200:
            return response.json()["models"]
        else:
            print(f"Error accessing Ollama API: {response.status_code}")
            sys.exit(1)
    except requests.RequestException as e:
        print(f"Error connecting to Ollama: {e}")
        print("Please ensure Ollama is running on http://localhost:11434")
        sys.exit(1)

def detect_model_family(model_name: str) -> tuple[Optional[str], Optional[str]]:
    """
    Detect model family and variant from model name
    Returns: (family_name, variant_type)
    """
    model_name_lower = model_name.lower()
    
    for family, info in MODEL_FAMILIES.items():
        for pattern in info["patterns"]:
            if re.search(pattern, model_name_lower):
                # Detect variant
                variant = None
                if "variants" in info:
                    if "code" in model_name_lower or "coder" in model_name_lower:
                        variant = "code" if "code" in info["variants"] else "coder"
                    elif "chat" in model_name_lower:
                        variant = "chat"
                    elif "instruct" in model_name_lower:
                        variant = "instruct"
                
                return family, variant
    
    return None, None

def get_model_params(family: str, variant: Optional[str] = None) -> Dict[str, Any]:
    """Get parameters for a model family and variant"""
    if family not in MODEL_FAMILIES:
        return DEFAULT_PARAMS.copy()
    
    # Start with base parameters
    params = MODEL_FAMILIES[family]["base_params"].copy()
    
    # Apply variant-specific parameters if available
    if variant and "variants" in MODEL_FAMILIES[family]:
        variant_params = MODEL_FAMILIES[family]["variants"].get(variant, {})
        params.update(variant_params)
    
    return params

def generate_models_config():
    """Generate new models configuration based on available Ollama models"""
    # Get Ollama models
    print("Fetching models from Ollama...")
    ollama_models = get_ollama_models()
    
    # Prepare new configuration
    config = {
        "default_model": None,
        "models": {}
    }
    
    # Track model families found
    families_found = set()
    unmatched_models = []
    
    # Process each model
    for model in ollama_models:
        model_name = model["name"]
        family, variant = detect_model_family(model_name)
        
        if family:
            families_found.add(family)
            params = get_model_params(family, variant)
            
            config["models"][model_name] = {
                "provider": "ollama",
                "model_name": model_name,
                "family": family,
                "variant": variant,
                "params": params
            }
        else:
            unmatched_models.append(model_name)
            # Add with default parameters
            config["models"][model_name] = {
                "provider": "ollama",
                "model_name": model_name,
                "params": DEFAULT_PARAMS.copy()
            }
    
    # Set default model preferring certain families in order
    preferred_families = ["mistral", "llama", "gemma", "deepseek"]
    for family in preferred_families:
        if family in families_found:
            # Find the most basic variant of this family
            for model_name, model_info in config["models"].items():
                if model_info.get("family") == family and not model_info.get("variant"):
                    config["default_model"] = model_name
                    break
            if config["default_model"]:
                break
    
    # If no preferred family found, use first model
    if not config["default_model"] and config["models"]:
        config["default_model"] = next(iter(config["models"].keys()))
    
    return config, families_found, unmatched_models

def save_yaml(file_path: Path, data: Dict[str, Any]):
    """Save YAML file"""
    try:
        with open(file_path, 'w') as f:
            yaml.dump(data, f, sort_keys=False, indent=2)
    except Exception as e:
        print(f"Error saving {file_path}: {e}")
        sys.exit(1)

def main():
    """Generate new models configuration file"""
    # Get project root (assuming script is in src/utils)
    project_root = Path(__file__).parent.parent.parent
    new_config_path = project_root / "config" / "models_ollama_synced.yaml"
    
    # Generate new configuration
    print("Analyzing available models...")
    config, families_found, unmatched_models = generate_models_config()
    
    # Save new configuration
    print(f"Saving new configuration to {new_config_path}...")
    save_yaml(new_config_path, config)
    
    # Print summary
    print("\nConfiguration Generation Summary:")
    print(f"Total models configured: {len(config['models'])}")
    print(f"Default model: {config['default_model']}")
    
    # Print families found
    print("\nModel families detected:")
    for family in families_found:
        variants = {
            model["variant"] 
            for model in config["models"].values() 
            if "family" in model and model["family"] == family and "variant" in model and model["variant"]
        }
        variant_str = f" (variants: {', '.join(variants)})" if variants else ""
        print(f"- {family}{variant_str}")
    
    # Print unmatched models
    if unmatched_models:
        print("\nModels using default parameters:")
        for model in unmatched_models:
            print(f"- {model}")
        print(f"\nDefault parameters applied: {DEFAULT_PARAMS}")

if __name__ == "__main__":
    main()