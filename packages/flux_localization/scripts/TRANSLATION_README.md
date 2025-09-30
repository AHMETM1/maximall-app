# FluxStore Localization Translation System

This system automatically translates missing keys in FluxStore localization files using Azure AI services. It leverages the [Azure Co-op Translator](https://github.com/Azure/co-op-translator) approach for high-quality, context-aware translations.

## Features

- **Automatic Detection**: Automatically detects missing translation keys by comparing with the English base file
- **Azure AI Integration**: Uses Azure OpenAI services for high-quality translations
- **Context-Aware**: Provides context about the translation key for better accuracy
- **Batch Processing**: Can process all languages or specific languages
- **Preserves Formatting**: Maintains placeholders, special characters, and formatting
- **Error Handling**: Graceful error handling with detailed logging

## Prerequisites

1. **Python 3.7+** installed on your system
2. **Azure OpenAI Service** with a deployed model (GPT-4 or GPT-3.5-turbo recommended)
3. **Azure OpenAI API Key** and endpoint

## Setup

### 1. Install Dependencies

```bash
# Navigate to the flux_localization directory
cd packages/flux_localization

# Install Python dependencies
./translate_missing.sh -i
```

### 2. Configure Azure OpenAI

Create a `.env` file in the `packages/flux_localization` directory:

```bash
# Copy the example configuration
cp config.example .env

# Edit the .env file with your Azure OpenAI credentials
nano .env
```

Fill in your Azure OpenAI credentials:

```env
AZURE_OPENAI_ENDPOINT=https://your-resource.openai.azure.com/
AZURE_OPENAI_API_KEY=your-api-key-here
AZURE_OPENAI_DEPLOYMENT_NAME=gpt-4
```

### 3. Set Up Azure OpenAI Service

1. Go to the [Azure Portal](https://portal.azure.com)
2. Create or navigate to your Azure OpenAI resource
3. Deploy a model (GPT-4 or GPT-3.5-turbo)
4. Note down the endpoint URL and deployment name
5. Generate an API key

## Usage

### Basic Usage

```bash
# Translate missing keys for all languages
./translate_missing.sh

# Translate missing keys for specific languages
./translate_missing.sh -l fr es de

# Install dependencies only
./translate_missing.sh -i
```

### Advanced Usage

```bash
# Use custom l10n directory
./translate_missing.sh -d /path/to/l10n

# Provide credentials via command line
./translate_missing.sh --azure-endpoint https://your-resource.openai.azure.com/ --api-key your-key --deployment-name gpt-4

# Process only specific languages with custom directory
./translate_missing.sh -l fr es de -d /custom/l10n/path
```

### Python Script Direct Usage

```bash
# Run the Python script directly
python3 translate_missing_keys.py --languages fr es de

# With custom parameters
python3 translate_missing_keys.py \
  --l10n-dir lib/src/l10n \
  --languages fr es de \
  --azure-endpoint https://your-resource.openai.azure.com/ \
  --api-key your-key \
  --deployment-name gpt-4
```

## Supported Languages

The system supports all languages currently in the FluxStore localization:

- **European**: English (en), French (fr), German (de), Spanish (es), Italian (it), Portuguese (pt_BR, pt_PT), Dutch (nl), Swedish (sv), Danish (da), Finnish (fi), Norwegian (no), Polish (pl), Czech (cs), Slovak (sk), Hungarian (hu), Romanian (ro), Bulgarian (bg), Croatian (hr), Serbian (sr), Slovenian (sl), Estonian (et), Latvian (lv), Lithuanian (lt), Greek (el), Albanian (sq), Bosnian (bs), Macedonian (mk), Montenegrin (cnr)

- **Asian**: Chinese (zh, zh_CN, zh_TW), Japanese (ja), Korean (ko), Vietnamese (vi), Thai (th), Indonesian (id), Malay (ms), Filipino (tl), Hindi (hi), Bengali (bn), Tamil (ta), Telugu (te), Kannada (kn), Malayalam (ml), Marathi (mr), Gujarati (gu), Punjabi (pa), Urdu (ur), Nepali (ne), Sinhala (si), Khmer (km), Lao (lo), Burmese (my), Mongolian (mn), Kazakh (kk), Kyrgyz (ky), Uzbek (uz), Tajik (tg), Turkmen (tk), Georgian (ka), Armenian (hy), Azerbaijani (az)

- **Middle Eastern**: Arabic (ar), Hebrew (he), Persian (fa), Kurdish (ku), Turkish (tr), Amharic (am), Tigrinya (ti)

- **African**: Swahili (sw), Hausa (ha), Yoruba (yo), Igbo (ig), Zulu (zu), Afrikaans (af), Somali (so), Amharic (am), Tigrinya (ti)

## How It Works

1. **Detection**: The script compares the English base file (`intl_en.arb`) with all other language files to identify missing keys
2. **Translation**: For each missing key, it sends the English text to Azure OpenAI with context about the key
3. **Processing**: Azure AI translates the text while preserving placeholders and formatting
4. **Update**: The translated text is added to the appropriate language file

## Translation Quality

The system uses advanced prompts to ensure high-quality translations:

- **Context Awareness**: Each translation includes context about the key name
- **Mobile App Focus**: Translations are optimized for mobile app interfaces
- **Placeholder Preservation**: Variables like `{variable}` are preserved
- **Formatting Maintenance**: Special characters and formatting are maintained
- **Natural Language**: Translations are natural and appropriate for the target language

## Error Handling

The system includes comprehensive error handling:

- **Missing Files**: Gracefully handles missing language files
- **API Errors**: Retries on temporary API failures
- **Invalid Responses**: Falls back to original text if translation fails
- **Logging**: Detailed logging for debugging and monitoring

## Monitoring and Logging

The script provides detailed logging:

```bash
# Example log output
2024-01-15 10:30:15 - INFO - Reading base file: lib/src/l10n/intl_en.arb
2024-01-15 10:30:15 - INFO - Found 45 target language files
2024-01-15 10:30:15 - INFO - Missing keys in lib/src/l10n/intl_fr.arb: 4 keys
2024-01-15 10:30:15 - INFO - Total unique missing keys: 4
2024-01-15 10:30:15 - INFO - Processing language: fr
2024-01-15 10:30:16 - INFO - Translated 'Your cancel request has been submitted successfully!' to French: 'Votre demande d'annulation a été soumise avec succès !'
2024-01-15 10:30:16 - INFO - Updated lib/src/l10n/intl_fr.arb with 4 new translations
```

## Cost Considerations

Azure OpenAI usage incurs costs based on:

- **Model Used**: GPT-4 is more expensive than GPT-3.5-turbo
- **Token Usage**: Each translation consumes tokens
- **Number of Languages**: More languages = more API calls

**Estimated Costs** (as of 2024):
- GPT-4: ~$0.03 per 1K input tokens, ~$0.06 per 1K output tokens
- GPT-3.5-turbo: ~$0.0015 per 1K input tokens, ~$0.002 per 1K output tokens

For a typical FluxStore localization with 4 missing keys across 45 languages:
- **GPT-4**: ~$0.50-1.00
- **GPT-3.5-turbo**: ~$0.05-0.10

## Troubleshooting

### Common Issues

1. **"Azure OpenAI credentials not found"**
   - Check that your `.env` file exists and contains the correct credentials
   - Verify environment variables are set correctly

2. **"Python 3 is not installed"**
   - Install Python 3.7 or higher
   - Ensure `python3` is in your PATH

3. **"Translation failed"**
   - Check your Azure OpenAI service status
   - Verify your API key and endpoint are correct
   - Check your deployment name

4. **"No missing keys found"**
   - This is normal if all language files are up to date
   - Check that the English base file has the latest keys

### Debug Mode

For detailed debugging, you can run the Python script directly:

```bash
python3 translate_missing_keys.py --languages fr --l10n-dir lib/src/l10n
```

## Contributing

To contribute to the translation system:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This translation system is part of the FluxStore project and follows the same license terms.

## Support

For support with the translation system:

1. Check the troubleshooting section above
2. Review the logs for error messages
3. Open an issue in the FluxStore repository
4. Include relevant log output and configuration details 