#!/bin/bash

# FluxStore Retranslation Script
# This script re-translates existing language files with high-quality LLM translations

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

# Function to check environment variables
check_environment() {
    print_info "Checking environment variables..."
    
    local missing_vars=()
    
    if [ -z "$AZURE_OPENAI_ENDPOINT" ]; then
        print_warning "AZURE_OPENAI_ENDPOINT not set"
        missing_vars+=("AZURE_OPENAI_ENDPOINT")
    fi
    
    if [ -z "$AZURE_OPENAI_API_KEY" ]; then
        print_warning "AZURE_OPENAI_API_KEY not set"
        missing_vars+=("AZURE_OPENAI_API_KEY")
    fi
    
    if [ -z "$AZURE_OPENAI_DEPLOYMENT_NAME" ]; then
        print_warning "AZURE_OPENAI_DEPLOYMENT_NAME not set"
        missing_vars+=("AZURE_OPENAI_DEPLOYMENT_NAME")
    fi
    
    if [ ${#missing_vars[@]} -gt 0 ]; then
        print_error "Please set the required Azure OpenAI environment variables:"
        printf '  %s\n' "${missing_vars[@]}"
        echo
        print_info "You can set them in a .env file or export them in your shell."
        exit 1
    fi
    
    print_success "Environment variables are set"
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

# Function to show help
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -l, --languages LANG    Specific languages to retranslate (e.g., 'fr es de')"
    echo "  -d, --l10n-dir DIR      Path to l10n directory (default: lib/src/l10n)"
    echo "  -i, --install-deps      Install Python dependencies"
    echo "  --batch-size SIZE       Number of texts to retranslate in each batch (default: 20)"
    echo "  --filters FILTERS       Only retranslate keys containing these strings"
    echo "  --no-backup             Skip creating backup files"
    echo "  --azure-endpoint URL    Azure OpenAI endpoint"
    echo "  --api-key KEY           Azure OpenAI API key"
    echo "  --deployment-name NAME  Azure OpenAI deployment name"
    echo
    echo "Examples:"
    echo "  $0                                    # Retranslate all languages"
    echo "  $0 -l fr es de                       # Retranslate only French, Spanish, German"
    echo "  $0 -i                                # Install dependencies only"
    echo "  $0 --batch-size 15                   # Use smaller batch size"
    echo "  $0 --filters error login             # Only retranslate keys containing 'error' or 'login'"
    echo "  $0 --no-backup                       # Skip backup creation"
    echo
    echo "Environment Variables:"
    echo "  AZURE_OPENAI_ENDPOINT       Azure OpenAI endpoint URL"
    echo "  AZURE_OPENAI_API_KEY        Azure OpenAI API key"
    echo "  AZURE_OPENAI_DEPLOYMENT_NAME Azure OpenAI deployment name"
    echo
    echo "Note: This script will create backup files before retranslating unless --no-backup is used."
}

# Function to run the retranslation script
run_retranslation() {
    local languages="$1"
    local l10n_dir="$2"
    local azure_endpoint="$3"
    local api_key="$4"
    local deployment_name="$5"
    local batch_size="$6"
    local filters="$7"
    local no_backup="$8"
    
    print_info "Starting retranslation process..."
    
    # Build command
    local cmd="source $SCRIPT_DIR/venv/bin/activate && python3 $SCRIPT_DIR/retranslate_existing.py"
    
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
    
    if [ -n "$filters" ]; then
        cmd="$cmd --filters $filters"
    fi
    
    if [ "$no_backup" = "true" ]; then
        cmd="$cmd --no-backup"
    fi
    
    print_info "Executing: $cmd"
    eval $cmd
}

# Main script logic
main() {
    # Parse command line arguments
    local languages=""
    local l10n_dir="$L10N_DIR"
    local install_deps=false
    local azure_endpoint=""
    local api_key=""
    local deployment_name=""
    local batch_size="100"
    local filters=""
    local no_backup=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
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
            --filters)
                filters="$2"
                shift 2
                ;;
            --no-backup)
                no_backup=true
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Check Python
    check_python
    
    # Install dependencies if requested
    if [ "$install_deps" = true ]; then
        install_dependencies
        exit 0
    fi
    
    # Check environment variables
    check_environment
    
    # Run retranslation
    run_retranslation "$languages" "$l10n_dir" "$azure_endpoint" "$api_key" "$deployment_name" "$batch_size" "$filters" "$no_backup"
}

# Run main function
main "$@" 