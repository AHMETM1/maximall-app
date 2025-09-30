# FluxStore Localization Scripts

This folder contains the optimized translation automation scripts for FluxStore localization.

## 📁 Files Overview

### **Core Scripts**
- **`translate_missing.sh`** - Main shell script for running translations
- **`translate_optimized.py`** - Optimized Python translation engine with high batch success rates
- **`retranslate.sh`** - Shell script for re-translating existing files with high-quality LLM
- **`retranslate_existing.py`** - Python engine for improving existing translations

### **Configuration**
- **`config.example`** - Example Azure OpenAI configuration file
- **`requirements.txt`** - Python dependencies

### **Documentation**
- **`QUICK_START.md`** - Quick setup and usage guide
- **`TRANSLATION_README.md`** - Comprehensive documentation

### **Environment**
- **`venv/`** - Python virtual environment (auto-created)

## 🚀 Quick Usage

```bash
# 1. Set up credentials
cp config.example .env
# Edit .env with your Azure OpenAI details

# 2. Install dependencies
./translate_missing.sh -i

# 3. Run translation
./translate_missing.sh -l es fr de

# 4. Retranslate existing files (improve quality)
./retranslate.sh -l es fr de

# 5. Retranslate English file (improve source text quality)
./retranslate.sh -l en

# 5. Check help
./translate_missing.sh -h
./retranslate.sh -h
```

## 🔧 Script Features

### **translate_optimized.py**
- **High batch success rates** (85%+ with batch size 30)
- **Automatic retries** (up to 3 attempts per batch)
- **Smart fallbacks** to individual translation when needed
- **Multiple JSON parsing strategies** for better reliability
- **Detailed progress tracking** and success rate reporting

### **translate_missing.sh**
- **Easy-to-use wrapper** for the Python script
- **Automatic dependency management** (creates venv)
- **Flexible language selection** (all or specific languages)
- **Configurable batch sizes** for optimal performance
- **Environment validation** and error handling

### **retranslate.sh**
- **High-quality re-translation** of existing language files
- **Automatic backup creation** before retranslating
- **Selective filtering** to retranslate only specific keys
- **Batch processing** for efficient LLM usage
- **Safety features** with backup and validation
- **English file support** for improving source text quality

## 📊 Performance

| Batch Size | Success Rate | Fallback Rate | Recommended For |
|------------|--------------|---------------|-----------------|
| 10 | ~95% | ~5% | Testing, small datasets |
| 20 | ~90% | ~10% | Medium datasets |
| 30 | ~85% | ~15% | **Production (default)** |
| 50 | ~70% | ~30% | Large datasets, fast processing |

## 🛠️ Maintenance

- **Clean virtual environment**: `rm -rf venv && ./translate_missing.sh -i`
- **Update dependencies**: `pip install -r requirements.txt --upgrade`
- **Test connection**: Use the script with a small batch size first

## 📝 Notes

- All scripts use Azure OpenAI for high-quality translations
- Batch processing is optimized for cost and speed efficiency
- Fallback to individual translation ensures 100% completion
- Scripts automatically handle JSON formatting and validation
- Retranslation script creates backups before modifying files
- Use filters to selectively improve specific translation keys 