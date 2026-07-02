#!/bin/bash
#
# Initialize CodeWiki in Obsidian vault via REST API.
#
# This script processes template files and uploads them to Obsidian via the REST API,
# ensuring all wiki data is handled through the API rather than manual file operations.
#
# Usage:
#   ./init_wiki.sh --api-key YOUR_API_KEY [--url http://localhost:27124] [--wiki-folder CodeWiki]
#
# Requirements:
#   - Obsidian Local REST API plugin installed and enabled
#   - Obsidian running with your vault open
#   - curl (for HTTP requests)
#   - sed (for template variable replacement)

set -e

# Default values
API_URL="https://localhost:27124"
WIKI_FOLDER="CodeWiki"
INSECURE=false
SKIP_SSL_VALIDATION=false
DATE=$(date +%Y-%m-%d)
TEMPLATES_DIR="$(dirname "$0")/templates"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --api-key)
            API_KEY="$2"
            shift 2
            ;;
        --url)
            API_URL="$2"
            shift 2
            ;;
        --wiki-folder)
            WIKI_FOLDER="$2"
            shift 2
            ;;
        --insecure)
            INSECURE=true
            API_URL="http://localhost:27124"
            shift
            ;;
        --skip-ssl-validation)
            SKIP_SSL_VALIDATION=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 --api-key YOUR_API_KEY [--url https://localhost:27124] [--wiki-folder CodeWiki] [--insecure] [--skip-ssl-validation]"
            echo ""
            echo "Options:"
            echo "  --api-key              Obsidian Local REST API key (required)"
            echo "  --url                  Obsidian API base URL (default: https://localhost:27124)"
            echo "  --wiki-folder          Wiki folder name in vault (default: CodeWiki)"
            echo "  --insecure             Use HTTP instead of HTTPS (default: HTTPS)"
            echo "  --skip-ssl-validation Skip SSL certificate validation (for self-signed certs)"
            echo "  -h, --help             Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Check required arguments
if [ -z "$API_KEY" ]; then
    echo "Error: --api-key is required"
    echo "Use -h or --help for usage information"
    exit 1
fi

# Check if templates directory exists
if [ ! -d "$TEMPLATES_DIR" ]; then
    echo "Error: Templates directory not found: $TEMPLATES_DIR"
    exit 1
fi

# Check for required commands
command -v curl >/dev/null 2>&1 || { echo "Error: curl is required but not installed"; exit 1; }
command -v sed >/dev/null 2>&1 || { echo "Error: sed is required but not installed"; exit 1; }

echo "Initializing LLM Wiki in folder: $WIKI_FOLDER"
echo "------------------------------------------------"

# Function to check API connection
check_connection() {
    echo "Checking connection to Obsidian API..."
    echo "  URL: $API_URL"
    echo "  Insecure mode (HTTP): $INSECURE"
    echo "  Skip SSL validation: $SKIP_SSL_VALIDATION"

    if [ "$INSECURE" = true ] || [ "$SKIP_SSL_VALIDATION" = true ]; then
        echo "  Using curl with -k flag (skip SSL validation)"
        echo "  Verbose curl output:"
        curl -v -k "$API_URL/" -H "Authorization: Bearer $API_KEY" 2>&1
        response=$(curl -s -k "$API_URL/" -H "Authorization: Bearer $API_KEY")
    else
        echo "  Using curl without -k flag (secure)"
        echo "  Verbose curl output:"
        curl -v "$API_URL/" -H "Authorization: Bearer $API_KEY" 2>&1
        response=$(curl -s "$API_URL/" -H "Authorization: Bearer $API_KEY")
    fi

    echo "  Raw response:"
    echo "$response"
    echo ""

    if [ -z "$response" ]; then
        echo "✗ Connection failed: Empty response"
        echo "  Possible causes:"
        echo "    - Obsidian is not running"
        echo "    - Local REST API plugin is not enabled"
        echo "    - Wrong protocol (try --insecure for HTTP mode)"
        echo "    - Wrong port (default is 27124)"
        echo "    - SSL certificate issue (try --skip-ssl-validation)"
        return 1
    fi

    if echo "$response" | grep -q '"authenticated": true'; then
        echo "✓ Connected to Obsidian API"
        return 0
    else
        echo "✗ Connection failed: Not authenticated"
        echo "  Response did not contain 'authenticated':true"
        return 1
    fi
}

# Function to process template and upload
process_and_upload() {
    local template_file="$1"
    local target_path="$2"

    # Read template and replace variables
    content=$(cat "$template_file")
    content=$(echo "$content" | sed "s/{{WIKI_FOLDER}}/$WIKI_FOLDER/g")
    content=$(echo "$content" | sed "s/{{DATE}}/$DATE/g")
    content=$(echo "$content" | sed "s|{{API_URL}}|$API_URL|g")

    # Upload via API
    url="$API_URL/vault/$target_path"
    if [ "$INSECURE" = true ] || [ "$SKIP_SSL_VALIDATION" = true ]; then
        response=$(curl -s -k -w "\n%{http_code}" -X PUT "$url" \
            -H "Authorization: Bearer $API_KEY" \
            -H "Content-Type: text/markdown" \
            -d "$content")
    else
        response=$(curl -s -w "\n%{http_code}" -X PUT "$url" \
            -H "Authorization: Bearer $API_KEY" \
            -H "Content-Type: text/markdown" \
            -d "$content")
    fi

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n-1)

    if [ "$http_code" = "200" ] || [ "$http_code" = "204" ]; then
        echo "✓ Created: $target_path"
        return 0
    else
        echo "✗ Failed to create $target_path: HTTP $http_code"
        echo "  Response: $body"
        return 1
    fi
}

# Check connection
if ! check_connection; then
    exit 1
fi

# Process and upload files
echo ""
echo "Creating wiki files..."

# Create index.md
process_and_upload "$TEMPLATES_DIR/index.md" "$WIKI_FOLDER/wiki/index.md"

# Create log.md
process_and_upload "$TEMPLATES_DIR/log.md" "$WIKI_FOLDER/wiki/log.md"

# Create AGENTS.md
process_and_upload "$TEMPLATES_DIR/AGENTS.md" "$WIKI_FOLDER/schema/AGENTS.md"

# Create store-methodology workflow
process_and_upload "$TEMPLATES_DIR/store-methodology.md" "$WIKI_FOLDER/schema/workflows/store-methodology.md"

# Create retrieve-methodologies workflow
process_and_upload "$TEMPLATES_DIR/retrieve-methodologies.md" "$WIKI_FOLDER/schema/workflows/retrieve-methodologies.md"

echo ""
echo "------------------------------------------------"
echo "✓ Wiki initialization complete!"
echo "  Wiki folder: $WIKI_FOLDER"
echo "  Next steps:"
echo "  1. Add the wiki integration to your project's AGENTS.md"
echo "  2. Configure your LLM agent with the API credentials"
echo "  3. Start storing and retrieving methodologies"
