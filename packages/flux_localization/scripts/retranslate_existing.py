#!/usr/bin/env python3
"""
Re-translate existing language files using high-quality LLM translations
This script improves existing translations by re-translating them with Azure OpenAI
"""

import os
import json
import argparse
import logging
import time
from pathlib import Path
from typing import Dict, List, Optional, Tuple
import openai
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class Retranslator:
    def __init__(self, azure_endpoint: str = None, api_key: str = None, deployment_name: str = None):
        """Initialize the retranslator with Azure OpenAI credentials."""
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

    def load_language_file(self, file_path: str) -> Tuple[Dict[str, str], str]:
        """Load a language file and return its data and language code."""
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Extract language code from filename
        language_code = Path(file_path).stem.replace('intl_', '')
        return data, language_code

    def should_retranslate(self, key: str, value: str, filters: List[str] = None) -> bool:
        """Determine if a key should be retranslated based on filters."""
        if not filters:
            return True
        
        # Check if any filter matches the key
        for filter_str in filters:
            if filter_str.lower() in key.lower():
                return True
        
        return False

    def retranslate_batch(self, texts: Dict[str, str], target_language: str, batch_size: int = 200) -> Dict[str, str]:
        """Retranslate texts in batches with high-quality LLM translations."""
        language_name = self.language_names.get(target_language, target_language)
        translations = {}
        
        # Split texts into batches
        text_items = list(texts.items())
        batches = [text_items[i:i + batch_size] for i in range(0, len(text_items), batch_size)]
        
        logger.info(f"Retranslating {len(texts)} texts to {language_name} in {len(batches)} batches")
        
        batch_success_count = 0
        individual_fallback_count = 0
        
        for batch_idx, batch in enumerate(batches, 1):
            batch_texts = {key: text for key, text in batch}
            
            # Try batch retranslation with retries
            batch_translations = self._try_batch_retranslation(batch_texts, target_language, language_name, batch_idx)
            
            if batch_translations:
                translations.update(batch_translations)
                batch_success_count += 1
                logger.info(f"✅ Batch {batch_idx}/{len(batches)} completed successfully")
            else:
                # Fallback to individual retranslation
                logger.warning(f"⚠️ Batch {batch_idx} failed, using individual retranslation")
                individual_fallback_count += 1
                
                for key, text in batch:
                    translation = self._retranslate_single(text, target_language, language_name)
                    translations[key] = translation
                    time.sleep(0.1)  # Small delay to avoid rate limits
        
        # Summary
        total_batches = len(batches)
        success_rate = (batch_success_count / total_batches) * 100 if total_batches > 0 else 0
        
        logger.info(f"📊 Retranslation Summary:")
        logger.info(f"   - Total batches: {total_batches}")
        logger.info(f"   - Successful batches: {batch_success_count}")
        logger.info(f"   - Individual fallbacks: {individual_fallback_count}")
        logger.info(f"   - Batch success rate: {success_rate:.1f}%")
        
        return translations

    def _try_batch_retranslation(self, texts: Dict[str, str], target_language: str, language_name: str, batch_idx: int, max_retries: int = 2) -> Optional[Dict[str, str]]:
        """Try batch retranslation with retries and improved prompts."""
        
        for attempt in range(max_retries + 1):
            try:
                # Improved prompt for high-quality retranslation
                prompt = self._create_retranslation_prompt(texts, language_name)
                
                logger.info(f"Making API call for batch {batch_idx} (attempt {attempt + 1})")
                
                response = self.client.chat.completions.create(
                    model=self.deployment_name,
                    messages=[
                        {
                            "role": "system", 
                            "content": "You are a professional translator specializing in mobile app localization. You MUST return ONLY a valid JSON object with the exact same keys as the input, providing high-quality, natural translations to the target language. Focus on accuracy, cultural appropriateness, and maintaining the app's tone."
                        },
                        {"role": "user", "content": prompt}
                    ],
                    temperature=0.2,  # Slightly higher for better quality
                    max_tokens=4000,
                    timeout=120
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
                time.sleep(3)
        
        return None

    def _create_retranslation_prompt(self, texts: Dict[str, str], language_name: str) -> str:
        """Create an optimized prompt for high-quality retranslation."""
        
        # Create a cleaner JSON structure
        clean_texts = {}
        for key, text in texts.items():
            # Clean the text for better translation
            clean_text = text.strip()
            if clean_text:
                clean_texts[key] = clean_text
        
        return f"""Please provide high-quality translations of the following English texts to {language_name}.

IMPORTANT: Return ONLY a JSON object with the exact same keys and translated values.

Input texts:
{json.dumps(clean_texts, ensure_ascii=False, indent=2)}

Translation Guidelines:
1. Keep placeholders like {{variable}} unchanged
2. Maintain the same tone and style as the original
3. Ensure translations are natural, culturally appropriate, and suitable for a mobile app
4. Use proper grammar and punctuation for {language_name}
5. Consider the context of mobile app localization
6. Return ONLY the JSON object, no explanations

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

    def _retranslate_single(self, text: str, target_language: str, language_name: str) -> str:
        """High-quality single text retranslation."""
        try:
            prompt = f"""Please provide a high-quality translation of this text to {language_name}:

"{text}"

Guidelines:
- Keep placeholders like {{variable}} unchanged
- Ensure natural, culturally appropriate translation
- Maintain the app's tone and style
- Use proper grammar and punctuation

Return only the translation:"""

            response = self.client.chat.completions.create(
                model=self.deployment_name,
                messages=[{"role": "user", "content": prompt}],
                temperature=0.3,
                max_tokens=300,
                timeout=60
            )
            
            translation = response.choices[0].message.content.strip()
            
            # Clean up common issues
            if translation.startswith('"') and translation.endswith('"'):
                translation = translation[1:-1]
            
            return translation
            
        except Exception as e:
            logger.error(f"Single retranslation failed for '{text}': {str(e)}")
            return text  # Return original as fallback

    def backup_file(self, file_path: str) -> str:
        """Create a backup of the original file."""
        backup_path = f"{file_path}.backup.{int(time.time())}"
        with open(file_path, 'r', encoding='utf-8') as src:
            with open(backup_path, 'w', encoding='utf-8') as dst:
                dst.write(src.read())
        logger.info(f"Created backup: {backup_path}")
        return backup_path

    def retranslate_file(self, file_path: str, batch_size: int = 20, filters: List[str] = None, create_backup: bool = True) -> bool:
        """Retranslate an entire language file."""
        try:
            # Load the file
            data, language_code = self.load_language_file(file_path)
            logger.info(f"Processing {language_code} file with {len(data)} entries")
            
            # Create backup if requested
            if create_backup:
                self.backup_file(file_path)
            
            # Filter texts to retranslate
            texts_to_retranslate = {}
            for key, value in data.items():
                if key != "@@locale" and self.should_retranslate(key, value, filters):
                    texts_to_retranslate[key] = value
            
            if not texts_to_retranslate:
                logger.info(f"No texts to retranslate for {language_code}")
                return True
            
            logger.info(f"Retranslating {len(texts_to_retranslate)} texts for {language_code}")
            
            # Retranslate in batches
            new_translations = self.retranslate_batch(texts_to_retranslate, language_code, batch_size)
            
            # Update the data with new translations
            updated_count = 0
            for key, translation in new_translations.items():
                if key in data and data[key] != translation:
                    data[key] = translation
                    updated_count += 1
            
            # Write back to file
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent='\t')
            
            logger.info(f"✅ Updated {file_path} with {updated_count} improved translations")
            return True
            
        except Exception as e:
            logger.error(f"Failed to retranslate {file_path}: {str(e)}")
            return False

    def retranslate_language_files(self, l10n_dir: str, languages_to_process: List[str] = None, 
                                 batch_size: int = 20, filters: List[str] = None, create_backup: bool = True):
        """Retranslate multiple language files."""
        l10n_path = Path(l10n_dir)
        
        # Get all language files
        all_files = list(l10n_path.glob("intl_*.arb"))
        
        # If specific languages are requested, include English if it's in the list
        if languages_to_process and 'en' in languages_to_process:
            target_files = all_files  # Include all files including English
        else:
            target_files = [f for f in all_files if f.name != "intl_en.arb"]  # Exclude English by default
        
        # Filter by specified languages with exact matching
        if languages_to_process:
            filtered_files = []
            for f in target_files:
                # Extract language code from filename (remove 'intl_' prefix and '.arb' suffix)
                file_lang = f.name.replace('intl_', '').replace('.arb', '')
                
                # Check for exact language code match
                if file_lang in languages_to_process:
                    filtered_files.append(f)
                else:
                    # Also check for language codes that might be part of compound codes
                    # e.g., 'zh' should match 'zh_CN' and 'zh_TW'
                    for lang in languages_to_process:
                        if file_lang.startswith(lang + '_') or file_lang == lang:
                            filtered_files.append(f)
                            break
            
            target_files = filtered_files
        
        logger.info(f"Found {len(target_files)} language files to retranslate")
        
        success_count = 0
        for target_file in target_files:
            logger.info(f"Processing {target_file.name}")
            if self.retranslate_file(str(target_file), batch_size, filters, create_backup):
                success_count += 1
        
        logger.info(f"✅ Retranslation complete: {success_count}/{len(target_files)} files processed successfully")

def main():
    parser = argparse.ArgumentParser(description='Retranslate existing language files with high-quality LLM translations')
    parser.add_argument('--l10n-dir', default='lib/src/l10n', help='Path to l10n directory')
    parser.add_argument('--languages', nargs='+', help='Specific languages to retranslate')
    parser.add_argument('--batch-size', type=int, default=20, help='Batch size (default: 20)')
    parser.add_argument('--filters', nargs='+', help='Only retranslate keys containing these strings')
    parser.add_argument('--no-backup', action='store_true', help='Skip creating backup files')
    parser.add_argument('--azure-endpoint', help='Azure OpenAI endpoint')
    parser.add_argument('--api-key', help='Azure OpenAI API key')
    parser.add_argument('--deployment-name', help='Azure OpenAI deployment name')
    
    args = parser.parse_args()
    
    try:
        retranslator = Retranslator(
            azure_endpoint=args.azure_endpoint,
            api_key=args.api_key,
            deployment_name=args.deployment_name
        )
        
        retranslator.retranslate_language_files(
            args.l10n_dir, 
            args.languages, 
            args.batch_size, 
            args.filters, 
            not args.no_backup
        )
        
    except Exception as e:
        logger.error(f"Script failed: {str(e)}")

if __name__ == "__main__":
    main() 