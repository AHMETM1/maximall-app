./translate_missing.sh --batch-size 30
#!/bin/bash

# FluxStore Localization Translation Script
# This script uses Azure AI services to translate missing keys in language files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
L10N_DIR="$SCRIPT_DIR/../lib/src/l10n"

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Python is available
check_python() {
    if ! command -v python3 &> /dev/null; then
        print_error "Python 3 is not installed or not in PATH"
        exit 1
    fi
    
    print_info "Python 3 found: $(python3 --version)"
}

# Function to install Python dependencies
install_dependencies() {
    print_info "Installing Python dependencies..."
    
    if [ ! -f "$SCRIPT_DIR/requirements.txt" ]; then
        print_error "requirements.txt not found"
        exit 1
    fi
    
    # Create virtual environment if it doesn't exist
    if [ ! -d "$SCRIPT_DIR/venv" ]; then
        print_info "Creating virtual environment..."
        python3 -m venv "$SCRIPT_DIR/venv"
    fi
    
    # Activate virtual environment and install dependencies
    source "$SCRIPT_DIR/venv/bin/activate"
    pip install -r "$SCRIPT_DIR/requirements.txt"
    print_success "Dependencies installed successfully"
}

# Function to check environment variables
check_environment() {
    print_info "Checking environment variables..."
    
    if [ -z "$AZURE_OPENAI_ENDPOINT" ]; then
        print_warning "AZURE_OPENAI_ENDPOINT not set"
    fi
    
    if [ -z "$AZURE_OPENAI_API_KEY" ]; then
        print_warning "AZURE_OPENAI_API_KEY not set"
    fi
    
    if [ -z "$AZURE_OPENAI_DEPLOYMENT_NAME" ]; then
        print_warning "AZURE_OPENAI_DEPLOYMENT_NAME not set"
    fi
    
    if [ -z "$AZURE_OPENAI_ENDPOINT" ] || [ -z "$AZURE_OPENAI_API_KEY" ] || [ -z "$AZURE_OPENAI_DEPLOYMENT_NAME" ]; then
        print_error "Please set the required Azure OpenAI environment variables:"
        echo "  AZURE_OPENAI_ENDPOINT"
        echo "  AZURE_OPENAI_API_KEY"
        echo "  AZURE_OPENAI_DEPLOYMENT_NAME"
        echo ""
        echo "You can set them in a .env file or export them in your shell."
        exit 1
    fi
    
    print_success "Environment variables are set"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -l, --languages LANG    Specific languages to process (e.g., 'fr es de')"
    echo "  -d, --l10n-dir DIR      Path to l10n directory (default: lib/src/l10n)"
    echo "  -i, --install-deps      Install Python dependencies"
    echo "  --azure-endpoint URL    Azure OpenAI endpoint"
    echo "  --api-key KEY           Azure OpenAI API key"
    echo "  --deployment-name NAME  Azure OpenAI deployment name"
    echo "  --batch-size SIZE       Number of texts to translate in each batch (default: 20)"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Process all languages"
    echo "  $0 -l fr es de                       # Process only French, Spanish, German"
    echo "  $0 -i                                # Install dependencies only"
    echo "  $0 --l10n-dir /path/to/l10n          # Use custom l10n directory"
    echo ""
    echo "Environment Variables:"
    echo "  AZURE_OPENAI_ENDPOINT       Azure OpenAI endpoint URL"
    echo "  AZURE_OPENAI_API_KEY        Azure OpenAI API key"
    echo "  AZURE_OPENAI_DEPLOYMENT_NAME Azure OpenAI deployment name"
}

# Function to run the translation script
run_translation() {
    local languages="$1"
    local l10n_dir="$2"
    local azure_endpoint="$3"
    local api_key="$4"
    local deployment_name="$5"
    local batch_size="$6"
    
    print_info "Starting translation process..."
    
    # Build command
    local cmd="source $SCRIPT_DIR/venv/bin/activate && python3 $SCRIPT_DIR/translate_optimized.py"
    
    if [ -n "$l10n_dir" ]; then
        cmd="$cmd --l10n-dir $l10n_dir"
    fi
    
    if [ -n "$languages" ]; then
        cmd="$cmd --languages $languages"
    fi
    
    if [ -n "$azure_endpoint" ]; then
        cmd="$cmd --azure-endpoint $azure_endpoint"
    fi
    
    if [ -n "$api_key" ]; then
        cmd="$cmd --api-key $api_key"
    fi
    
    if [ -n "$deployment_name" ]; then
        cmd="$cmd --deployment-name $deployment_name"
    fi
    
    if [ -n "$batch_size" ]; then
        cmd="$cmd --batch-size $batch_size"
    fi
    
    print_info "Running: $cmd"
    eval $cmd
    
    if [ $? -eq 0 ]; then
        print_success "Translation process completed successfully!"
    else
        print_error "Translation process failed!"
        exit 1
    fi
}

# Main script
main() {
    local languages=""
    local l10n_dir="$L10N_DIR"
    local install_deps=false
    local azure_endpoint=""
    local api_key=""
    local deployment_name=""
    local batch_size=""
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -l|--languages)
                languages="$2"
                shift 2
                ;;
            -d|--l10n-dir)
                l10n_dir="$2"
                shift 2
                ;;
            -i|--install-deps)
                install_deps=true
                shift
                ;;
            --azure-endpoint)
                azure_endpoint="$2"
                shift 2
                ;;
            --api-key)
                api_key="$2"
                shift 2
                ;;
            --deployment-name)
                deployment_name="$2"
                shift 2
                ;;
            --batch-size)
                batch_size="$2"
                shift 2
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Check if l10n directory exists
    if [ ! -d "$l10n_dir" ]; then
        print_error "L10n directory not found: $l10n_dir"
        exit 1
    fi
    
    # Check Python
    check_python
    
    # Install dependencies if requested
    if [ "$install_deps" = true ]; then
        install_dependencies
        exit 0
    fi
    
    # Check environment variables (only if not provided via command line)
    if [ -z "$azure_endpoint" ] && [ -z "$api_key" ] && [ -z "$deployment_name" ]; then
        check_environment
    fi
    
    # Run translation
    run_translation "$languages" "$l10n_dir" "$azure_endpoint" "$api_key" "$deployment_name" "$batch_size"
}

# Run main function with all arguments
main "$@" 