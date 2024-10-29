# src/test_chat.py
from models.factory import get_model
import sys

def test_model(model_name=None):
    """Test a model with a simple interaction"""
    try:
        # Get model instance
        print(f"Loading model: {model_name or 'default'}")
        model_instance = get_model(model_name)
        
        print(f"Successfully loaded {model_instance.name} using {model_instance.provider} provider")
        
        # Test prompt
        test_prompt = "Give me a one-word response to verify you're working."
        print("\nSending test prompt...")
        response = model_instance.model(test_prompt)
        print(f"Response: {response}")
        
        # Interactive mode
        print("\nEntering interactive mode (type 'quit' to exit)")
        while True:
            user_input = input("\nPrompt: ")
            if user_input.lower() in ['quit', 'exit']:
                break
                
            response = model_instance.model(user_input)
            print(f"\nResponse: {response}")
            
    except Exception as e:
        print(f"Error: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    # Get model name from command line if provided
    model_name = sys.argv[1] if len(sys.argv) > 1 else None
    test_model(model_name)
