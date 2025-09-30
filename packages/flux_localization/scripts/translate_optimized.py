#!/usr/bin/env python3
"""
Optimized translation script with better batch success rates
"""

import os
import json
import argparse
import logging
import time
from pathlib import Path
from typing import Dict, List, Optional
import openai
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class OptimizedTranslator:
    def __init__(self, azure_endpoint: str = None, api_key: str = None, deployment_name: str = None):
        """Initialize the translator with Azure OpenAI credentials."""
        self.azure_endpoint = azure_endpoint or os.getenv('AZURE_OPENAI_ENDPOINT')
        self.api_key = api_key or os.getenv('AZURE_OPENAI_API_KEY')
        self.deployment_name = deployment_name or os.getenv('AZURE_OPENAI_DEPLOYMENT_NAME')
        
        if not all([self.azure_endpoint, self.api_key, self.deployment_name]):
            raise ValueError("Missing Azure OpenAI credentials")
        
        self.client = openai.AzureOpenAI(
            azure_endpoint=self.azure_endpoint,
            api_key=self.api_key,
            api_version="2024-02-15-preview"
        )
        
        # Language mapping
        self.language_names = {
            'am': 'Amharic', 'ar': 'Arabic', 'az': 'Azerbaijani', 'bg': 'Bulgarian',
            'bn': 'Bengali', 'bs': 'Bosnian', 'ca': 'Catalan', 'cs': 'Czech',
            'da': 'Danish', 'de': 'German', 'el': 'Greek', 'en': 'English',
            'es': 'Spanish', 'et': 'Estonian', 'fa': 'Persian', 'fi': 'Finnish',
            'fr': 'French', 'he': 'Hebrew', 'hi': 'Hindi', 'hu': 'Hungarian',
            'id': 'Indonesian', 'it': 'Italian', 'ja': 'Japanese', 'ka': 'Georgian',
            'kk': 'Kazakh', 'km': 'Khmer', 'kn': 'Kannada', 'ko': 'Korean',
            'ku': 'Kurdish', 'lo': 'Lao', 'lt': 'Lithuanian', 'mr': 'Marathi',
            'ms': 'Malay', 'my': 'Burmese', 'nl': 'Dutch', 'no': 'Norwegian',
            'pl': 'Polish', 'pt_BR': 'Portuguese (Brazil)', 'pt_PT': 'Portuguese (Portugal)',
            'ro': 'Romanian', 'ru': 'Russian', 'si': 'Sinhala', 'sk': 'Slovak',
            'sq': 'Albanian', 'sr': 'Serbian', 'sv': 'Swedish', 'sw': 'Swahili',
            'ta': 'Tamil', 'te': 'Telugu', 'th': 'Thai', 'ti': 'Tigrinya',
            'tr': 'Turkish', 'uk': 'Ukrainian', 'ur': 'Urdu', 'uz': 'Uzbek',
            'vi': 'Vietnamese', 'zh': 'Chinese (Simplified)', 'zh_CN': 'Chinese (Simplified)',
            'zh_TW': 'Chinese (Traditional)'
        }

    def translate_batch_optimized(self, texts: Dict[str, str], target_language: str, batch_size: int = 30) -> Dict[str, str]:
        """Optimized batch translation with better success rates."""
        language_name = self.language_names.get(target_language, target_language)
        translations = {}
        
        # Split texts into batches
        text_items = list(texts.items())
        batches = [text_items[i:i + batch_size] for i in range(0, len(text_items), batch_size)]
        
        logger.info(f"Translating {len(texts)} texts to {language_name} in {len(batches)} batches")
        
        batch_success_count = 0
        individual_fallback_count = 0
        
        for batch_idx, batch in enumerate(batches, 1):
            batch_texts = {key: text for key, text in batch}
            
            # Try batch translation with retries
            batch_translations = self._try_batch_with_retries(batch_texts, target_language, language_name, batch_idx)
            
            if batch_translations:
                translations.update(batch_translations)
                batch_success_count += 1
                logger.info(f"✅ Batch {batch_idx}/{len(batches)} completed successfully")
            else:
                # Fallback to individual translation
                logger.warning(f"⚠️ Batch {batch_idx} failed, using individual translation")
                individual_fallback_count += 1
                
                for key, text in batch:
                    translation = self._translate_single_optimized(text, target_language, language_name)
                    translations[key] = translation
                    time.sleep(0.1)  # Small delay to avoid rate limits
        
        # Summary
        total_batches = len(batches)
        success_rate = (batch_success_count / total_batches) * 100 if total_batches > 0 else 0
        
        logger.info(f"📊 Translation Summary:")
        logger.info(f"   - Total batches: {total_batches}")
        logger.info(f"   - Successful batches: {batch_success_count}")
        logger.info(f"   - Individual fallbacks: {individual_fallback_count}")
        logger.info(f"   - Batch success rate: {success_rate:.1f}%")
        
        return translations

    def _try_batch_with_retries(self, texts: Dict[str, str], target_language: str, language_name: str, batch_idx: int, max_retries: int = 2) -> Optional[Dict[str, str]]:
        """Try batch translation with retries and improved prompts."""
        
        for attempt in range(max_retries + 1):
            try:
                # Improved prompt for better JSON responses
                prompt = self._create_optimized_prompt(texts, language_name)
                
                logger.info(f"Making API call for batch {batch_idx} (attempt {attempt + 1})")
                
                response = self.client.chat.completions.create(
                    model=self.deployment_name,
                    messages=[
                        {
                            "role": "system", 
                            "content": "You are a professional translator. You MUST return ONLY a valid JSON object with the exact same keys as the input, translated to the target language. Do not include any explanations or additional text."
                        },
                        {"role": "user", "content": prompt}
                    ],
                    temperature=0.1,  # Lower temperature for more consistent JSON
                    max_tokens=3000,
                    timeout=90
                )
                
                response_text = response.choices[0].message.content.strip()
                
                # Try to parse JSON with multiple strategies
                translations = self._parse_json_response(response_text, texts)
                
                if translations:
                    return translations
                else:
                    logger.warning(f"Batch {batch_idx} attempt {attempt + 1}: Invalid JSON response")
                    
            except Exception as e:
                logger.warning(f"Batch {batch_idx} attempt {attempt + 1} failed: {str(e)}")
                
            # Wait before retry
            if attempt < max_retries:
                time.sleep(2)
        
        return None

    def _create_optimized_prompt(self, texts: Dict[str, str], language_name: str) -> str:
        """Create an optimized prompt for better batch translation success."""
        
        # Create a cleaner JSON structure
        clean_texts = {}
        for key, text in texts.items():
            # Clean the text for better translation
            clean_text = text.strip()
            if clean_text:
                clean_texts[key] = clean_text
        
        return f"""Translate the following English texts to {language_name}.

IMPORTANT: Return ONLY a JSON object with the exact same keys and translated values.

Input texts:
{json.dumps(clean_texts, ensure_ascii=False, indent=2)}

Rules:
1. Keep placeholders like {{variable}} unchanged
2. Maintain the same tone and style
3. Ensure natural, app-appropriate translations
4. Return ONLY the JSON object, no explanations

JSON response:"""

    def _parse_json_response(self, response_text: str, original_texts: Dict[str, str]) -> Optional[Dict[str, str]]:
        """Parse JSON response with multiple fallback strategies."""
        
        # Strategy 1: Direct JSON parsing
        try:
            translations = json.loads(response_text)
            if self._validate_translations(translations, original_texts):
                return translations
        except json.JSONDecodeError:
            pass
        
        # Strategy 2: Extract JSON from response
        try:
            start_idx = response_text.find('{')
            end_idx = response_text.rfind('}') + 1
            
            if start_idx != -1 and end_idx > start_idx:
                json_text = response_text[start_idx:end_idx]
                translations = json.loads(json_text)
                if self._validate_translations(translations, original_texts):
                    return translations
        except (json.JSONDecodeError, ValueError):
            pass
        
        # Strategy 3: Try to fix common JSON issues
        try:
            # Remove common prefixes/suffixes
            cleaned = response_text.strip()
            if cleaned.startswith('```json'):
                cleaned = cleaned[7:]
            if cleaned.endswith('```'):
                cleaned = cleaned[:-3]
            
            translations = json.loads(cleaned)
            if self._validate_translations(translations, original_texts):
                return translations
        except (json.JSONDecodeError, ValueError):
            pass
        
        return None

    def _validate_translations(self, translations: Dict[str, str], original_texts: Dict[str, str]) -> bool:
        """Validate that all required keys are present in translations."""
        if not isinstance(translations, dict):
            return False
        
        # Check if all original keys are present
        for key in original_texts.keys():
            if key not in translations:
                return False
        
        return True

    def _translate_single_optimized(self, text: str, target_language: str, language_name: str) -> str:
        """Optimized single text translation."""
        try:
            prompt = f"""Translate to {language_name}: "{text}"
Return only the translation."""

            response = self.client.chat.completions.create(
                model=self.deployment_name,
                messages=[{"role": "user", "content": prompt}],
                temperature=0.3,
                max_tokens=200,
                timeout=30
            )
            
            translation = response.choices[0].message.content.strip()
            
            # Clean up common issues
            if translation.startswith('"') and translation.endswith('"'):
                translation = translation[1:-1]
            
            return translation
            
        except Exception as e:
            logger.error(f"Single translation failed for '{text}': {str(e)}")
            return text  # Return original as fallback

    def get_missing_keys(self, base_file: str, target_files: List[str]) -> List[str]:
        """Get the list of keys that are missing from target files."""
        logger.info(f"Reading base file: {base_file}")
        
        with open(base_file, 'r', encoding='utf-8') as f:
            base_data = json.load(f)
        
        base_keys = set(base_data.keys())
        missing_keys = []
        
        for target_file in target_files:
            if not os.path.exists(target_file):
                logger.warning(f"Target file not found: {target_file}")
                continue
                
            with open(target_file, 'r', encoding='utf-8') as f:
                target_data = json.load(f)
            
            target_keys = set(target_data.keys())
            file_missing = base_keys - target_keys
            
            if file_missing:
                logger.info(f"Missing keys in {target_file}: {len(file_missing)} keys")
                missing_keys.extend(list(file_missing))
        
        # Remove duplicates and sort
        missing_keys = sorted(list(set(missing_keys)))
        logger.info(f"Total unique missing keys: {len(missing_keys)}")
        return missing_keys

    def update_language_file(self, file_path: str, new_translations: Dict[str, str], missing_keys: List[str]) -> bool:
        """Update a language file with new translations."""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            updated = False
            for key in missing_keys:
                if key in new_translations and key not in data:
                    data[key] = new_translations[key]
                    updated = True
            
            if updated:
                with open(file_path, 'w', encoding='utf-8') as f:
                    json.dump(data, f, ensure_ascii=False, indent='\t')
                logger.info(f"Updated {file_path} with {len([k for k in missing_keys if k in new_translations])} new translations")
                return True
            else:
                logger.info(f"No updates needed for {file_path}")
                return False
                
        except Exception as e:
            logger.error(f"Failed to update {file_path}: {str(e)}")
            return False

    def process_language_files(self, l10n_dir: str, languages_to_process: List[str] = None, batch_size: int = 30):
        """Process all language files with optimized translation."""
        l10n_path = Path(l10n_dir)
        base_file = l10n_path / "intl_en.arb"
        
        if not base_file.exists():
            raise FileNotFoundError(f"Base file not found: {base_file}")
        
        # Get all language files
        all_files = list(l10n_path.glob("intl_*.arb"))
        target_files = [f for f in all_files if f.name != "intl_en.arb"]
        
        # Filter by specified languages
        if languages_to_process:
            target_files = [f for f in target_files if any(lang in f.name for lang in languages_to_process)]
        
        logger.info(f"Found {len(target_files)} target language files")
        
        # Read base file
        with open(base_file, 'r', encoding='utf-8') as f:
            base_data = json.load(f)
        
        base_keys = set(base_data.keys())
        
        # Process each language file
        for target_file in target_files:
            language_code = target_file.stem.replace('intl_', '')
            logger.info(f"Processing language: {language_code}")
            
            # Get missing keys for this specific file
            with open(target_file, 'r', encoding='utf-8') as f:
                target_data = json.load(f)
            
            target_keys = set(target_data.keys())
            file_missing_keys = base_keys - target_keys
            
            if file_missing_keys:
                texts_to_translate = {key: base_data[key] for key in file_missing_keys if key in base_data}
                
                if texts_to_translate:
                    logger.info(f"Translating {len(texts_to_translate)} missing keys for {language_code}")
                    new_translations = self.translate_batch_optimized(texts_to_translate, language_code, batch_size)
                    self.update_language_file(str(target_file), new_translations, list(file_missing_keys))
                else:
                    logger.info(f"No texts to translate for {language_code}")
            else:
                logger.info(f"No missing keys for {language_code}")

def main():
    parser = argparse.ArgumentParser(description='Optimized translation script')
    parser.add_argument('--l10n-dir', default='lib/src/l10n', help='Path to l10n directory')
    parser.add_argument('--languages', nargs='+', help='Specific languages to process')
    parser.add_argument('--batch-size', type=int, default=30, help='Batch size (default: 30)')
    parser.add_argument('--azure-endpoint', help='Azure OpenAI endpoint')
    parser.add_argument('--api-key', help='Azure OpenAI API key')
    parser.add_argument('--deployment-name', help='Azure OpenAI deployment name')
    
    args = parser.parse_args()
    
    try:
        translator = OptimizedTranslator(
            azure_endpoint=args.azure_endpoint,
            api_key=args.api_key,
            deployment_name=args.deployment_name
        )
        
        translator.process_language_files(args.l10n_dir, args.languages, args.batch_size)
        
    except Exception as e:
        logger.error(f"Script failed: {str(e)}")

if __name__ == "__main__":
    main() 