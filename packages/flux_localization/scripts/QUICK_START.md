# Quick Start Guide - FluxStore Translation System

## 🚀 Quick Setup (5 minutes)

### 1. Install Dependencies
```bash
cd packages/flux_localization
./translate_missing.sh -i
```

### 2. Set Up Azure OpenAI
1. Create a `.env` file:
```bash
cp config.example .env
```

2. Edit `.env` with your Azure OpenAI credentials:
```env
AZURE_OPENAI_ENDPOINT=https://your-resource.openai.azure.com/
AZURE_OPENAI_API_KEY=your-api-key-here
AZURE_OPENAI_DEPLOYMENT_NAME=gpt-4
```

### 3. Test Missing Keys Detection
```bash
python3 test_missing_keys.py
```

### 4. Run Translation
```bash
# Translate all missing keys for all languages
./translate_missing.sh

# Or translate specific languages
./translate_missing.sh -l fr es de
```

## 📊 Current Status

Based on the latest scan:
- **58 language files** need updates
- **870 unique missing keys** detected
- **Most languages** missing 24 keys (the 4 new ones)
- **Some languages** missing many more (e.g., Kurdish: 870 keys, Tigrinya: 485 keys)

## 💰 Cost Estimate

For translating the 4 new keys across 58 languages:
- **GPT-4**: ~$2-4
- **GPT-3.5-turbo**: ~$0.20-0.40

## 🔧 Troubleshooting

### Common Issues:
1. **"Python 3 not found"** → Install Python 3.7+
2. **"Azure credentials not found"** → Check your `.env` file
3. **"Translation failed"** → Verify Azure OpenAI service status

### Get Help:
```bash
./translate_missing.sh --help
python3 translate_missing_keys.py --help
```

## 📝 What Gets Translated

The system will translate these 4 new keys:
- `cancelOrderSuccess`
- `cancelOrderFailed` 
- `areYouSureCancelOrder`
- `areYouSureRefundOrder`

## 🎯 Next Steps

1. **Set up Azure OpenAI** (if not already done)
2. **Run the translation** for your priority languages
3. **Review translations** for accuracy
4. **Commit changes** to your repository

## 📚 Full Documentation

See [TRANSLATION_README.md](TRANSLATION_README.md) for complete documentation. 