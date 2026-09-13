import json

# Helper module for Shuffle SOAR execute_python node
# Sanitizes inputs and formats prompts for Google Gemini API

def build_gemini_payload(alert_content, prompt_system_text):
    full_prompt = prompt_system_text + "\n\nALERT DATA:\n" + alert_content
    # Sanitize backslashes, double quotes, and newlines to prevent HTTP 400 Bad Request
    clean_prompt = full_prompt.replace('\\', '\\\\').replace('"', "'").replace('\n', '\\n')
    
    return {
        "contents": [
            {
                "parts": [
                    {"text": clean_prompt}
                ]
            }
        ]
    }
