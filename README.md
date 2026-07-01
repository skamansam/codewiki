# CodeWiki - Programming Methodologies Knowledge Base

A pattern for building personal knowledge bases using LLMs, specifically designed for storing and retrieving programming methodologies, techniques, and best practices.

This repository contains the initialization script and templates for creating a CodeWiki in your Obsidian vault via the REST API. The actual wiki data lives in your Obsidian vault, not in this repository.

## Quick Start

1. Install and configure the Obsidian Local REST API plugin
2. Run the initialization script to create the wiki in your Obsidian vault via API
3. Add the wiki integration to your project's AGENTS.md
4. Start using it with your LLM agent

## Repository Structure

```
codewiki/
├── README.md              # This file
├── init_wiki.sh          # Script to initialize wiki via Obsidian API
└── templates/             # Template files for wiki structure
    ├── index.md
    ├── log.md
    ├── AGENTS.md
    ├── store-methodology.md
    └── retrieve-methodologies.md
```

The wiki itself (CodeWiki/, wiki/, schema/, raw/ directories) is created in your Obsidian vault when you run the initialization script.

## Integration Guide

All wiki files are created and managed via the Obsidian REST API or MCP - no manual file copying required.

### Step 1: Install Obsidian Local REST API Plugin

1. Open Obsidian
2. Go to Settings → Community Plugins → Browse
3. Search for "Local REST API with MCP"
4. Install and enable the plugin
5. In plugin settings:
   - Note your API key (shown in the settings)
   - Note the server URL (default: `http://localhost:27124`)
   - Choose between HTTPS (secure) or HTTP (insecure) mode
   - If using HTTPS, you may need to trust the self-signed certificate

### Step 2: Initialize Wiki via API

Run the provided shell script to create the wiki structure in your Obsidian vault via the REST API. This ensures all wiki data is handled through the API from the start.

#### Prerequisites

1. Ensure you have `curl` and `sed` installed (most systems have these by default)
2. Ensure Obsidian is running with your vault open
3. Ensure the Local REST API plugin is installed and enabled

#### Run the Initialization Script

```bash
./init_wiki.sh --api-key YOUR_API_KEY [--url http://localhost:27124] [--wiki-folder CodeWiki]
```

**Parameters:**
- `--api-key`: Your Obsidian API key (required) - get it from Settings → Local REST API with MCP
- `--url`: Obsidian API base URL (default: `http://localhost:27124`)
- `--wiki-folder`: Name of the wiki folder in your vault (default: `CodeWiki`)

**Example:**
```bash
./init_wiki.sh --api-key "your-api-key-here" --wiki-folder "programming-wiki"
```

The script will:
- Verify the connection to Obsidian
- Process template files from the `templates/` directory
- Replace variables (`{{WIKI_FOLDER}}`, `{{DATE}}`, `{{API_URL}}`) with actual values
- Upload all files via the REST API to your vault
- Create the wiki structure in your specified folder
- Initialize `wiki/index.md` and `wiki/log.md`
- Create `schema/AGENTS.md` with all conventions and API skills
- Create the workflow files for storing and retrieving methodologies

All files are created via the REST API, ensuring consistency with how the LLM agent will interact with the wiki.

#### Template Files

The script uses template files in the `templates/` directory:
- `templates/index.md` - Template for wiki index
- `templates/log.md` - Template for operation log
- `templates/AGENTS.md` - Template for schema documentation
- `templates/store-methodology.md` - Template for store workflow
- `templates/retrieve-methodologies.md` - Template for retrieve workflow

You can customize these templates before running the script if needed. The following variables are automatically replaced:
- `{{WIKI_FOLDER}}` - Your configured wiki folder name
- `{{DATE}}` - Current date in YYYY-MM-DD format
- `{{API_URL}}` - Your configured API URL

### Step 3: Add Wiki Integration to Your Project's AGENTS.md

If your project already has an `AGENTS.md` file (or similar configuration file for your LLM agent), add the following section:

```markdown
## CodeWiki Integration

This project uses CodeWiki for storing and retrieving programming methodologies.

### Wiki Location
- Wiki directory: `CodeWiki/` (or your chosen subfolder name from --wiki-folder) in your Obsidian vault
- Schema file: `CodeWiki/schema/AGENTS.md` (in your vault, read via API)
- Index file: `CodeWiki/wiki/index.md` (in your vault, read via API)

### Obsidian REST API Configuration
- API URL: `http://localhost:27124` (or your configured URL)
- API Key: {your API key from Obsidian settings}
- Content-Type: `text/markdown`

### Required Skills

The LLM agent must have the following capabilities:

1. **HTTP Request Skill** - Ability to make HTTP requests to the Obsidian REST API
   - GET requests to read files (including schema and workflow files from the vault)
   - PUT/POST/PATCH requests to create/update files
   - Header handling for authentication and content types

2. **Markdown Processing Skill** - Ability to parse and generate markdown
   - Parse YAML frontmatter
   - Generate wiki links in Obsidian format `[[Page Title]]`
   - Maintain consistent formatting

### Workflow Instructions

Before writing code or making technical decisions:
1. Use the API to read `CodeWiki/schema/workflows/retrieve-methodologies.md` from your vault
2. Follow the workflow to retrieve and apply relevant methodologies

When the user states a programming preference:
1. Use the API to read `CodeWiki/schema/workflows/store-methodology.md` from your vault
2. Follow the workflow to store the methodology in the wiki

### API Endpoints Reference

Key endpoints (full documentation in `CodeWiki/schema/AGENTS.md`):

- Read file: `GET /vault/{filename}`
- Create/update file: `PUT /vault/{filename}`
- Append to file: `POST /vault/{filename}`
- Patch section: `PATCH /vault/{filename}` (with Operation, Target-Type, Target headers)
- Open in Obsidian: `POST /open/{filename}`

### Example API Usage

```http
# Read the index
GET /vault/CodeWiki/wiki/index.md
Headers:
  Accept: text/markdown
  Authorization: Bearer {API_KEY}

# Create a methodology page
PUT /vault/CodeWiki/wiki/methodologies/variable-naming.md
Headers:
  Content-Type: text/markdown
  Authorization: Bearer {API_KEY}
Body:
  ---
  title: Descriptive Variable Naming
  type: methodology
  tags: [naming, code-quality]
  created: 2026-06-30
  ---

  # Descriptive Variable Naming

  ## Principle
  Always use descriptive variable names...
```

### MCP Server Alternative

If your LLM agent supports MCP (Model Context Protocol):
1. Use the MCP server exposed by the Obsidian plugin
2. Connect via `POST /mcp/` endpoint
3. Use MCP tools instead of direct HTTP requests
4. This provides the same capabilities as structured tools
```

### Step 4: If Your Project Doesn't Have an AGENTS.md

If your project doesn't have an AGENTS.md file, you can either:

**Option A:** Create a new `AGENTS.md` in your project root with the content from Step 3

**Option B:** Create a `.devin/AGENTS.md` or `.windsurf/AGENTS.md` (depending on your agent) with the content from Step 3

**Option C:** Add the wiki instructions directly to your existing configuration file (e.g., `CLAUDE.md`, `INSTRUCTIONS.md`, etc.)

## Required LLM Agent Capabilities

Your LLM agent needs the following capabilities to use this wiki system:

### 1. HTTP Requests
The agent must be able to make HTTP requests with:
- Custom headers (Authorization, Content-Type, etc.)
- Different HTTP methods (GET, POST, PUT, PATCH)
- Request bodies

### 2. Markdown Processing
The agent should be able to:
- Parse YAML frontmatter
- Generate properly formatted markdown
- Create Obsidian-style wiki links `[[Page Title]]`

### 3. Workflow Following
The agent should be able to:
- Read workflow files via API from the vault
- Follow the workflow procedures
- Execute multi-step processes
- Maintain context across steps

## Testing the Integration

### Test 1: Verify API Connection

Ask your LLM agent to:
1. Make a GET request to `/` (the root endpoint) to verify the connection
2. Check that the response shows `authenticated: true`

### Test 2: Store a Methodology

Tell your LLM agent:
1. "Store this methodology: always use descriptive variable names"
2. The agent should follow the `store-methodology.md` workflow
3. The agent will use the API to create the file in your vault
4. Check in Obsidian that a new file appears in your wiki folder
5. Check that the index is updated and the log has a new entry

### Test 3: Retrieve Methodologies

Ask your LLM agent to:
1. "Write a function to validate user input"
2. The agent should follow the `retrieve-methodologies.md` workflow
3. The agent will use the API to read relevant methodologies
4. The agent should reference any relevant methodologies in its response

## Using the Wiki in Your Development Workflow

### For Developers

1. **Obsidian as the IDE**: Keep Obsidian open on one side, your code editor on the other
2. **Real-time updates**: As the LLM agent updates the wiki, you'll see changes in Obsidian
3. **Graph view**: Use Obsidian's graph view to see connections between methodologies
4. **Search**: Use Obsidian's search to find relevant methodologies

### For LLM Agents

1. **Before coding**: Always retrieve relevant methodologies
2. **When user states preferences**: Store them as methodologies
3. **Periodically**: Run lint workflow to keep wiki healthy
4. **When in doubt**: Query the wiki for guidance

## Customization

### Adjusting the Directory Structure

If you want to use a different directory structure:
1. Use the `--wiki-folder` parameter when running `init_wiki.sh`
2. Customize the template files in `templates/` before running the script
3. Update the paths in your project's AGENTS.md integration section

### Adding New Workflow Types

To add new workflows (e.g., for ingesting sources, querying, linting):
1. Create a new template file in `templates/` (e.g., `templates/ingest-source.md`)
2. Add the file to the `init_wiki.sh` script to upload it
3. Reference it in your project's AGENTS.md

### Changing Page Formats

To change the methodology page format:
1. Update the template in `templates/AGENTS.md` or `templates/store-methodology.md`
2. Re-run `init_wiki.sh` to upload the updated templates via API
3. The LLM agent will use the updated format for new pages

## Troubleshooting

### API Connection Issues

**Problem**: Agent can't connect to Obsidian API
- **Solution**: Check that Obsidian is running and the plugin is enabled
- **Solution**: Verify the API URL and API key in your configuration
- **Solution**: If using HTTPS, ensure the certificate is trusted or switch to HTTP mode

### File Not Found Errors

**Problem**: Agent gets 404 errors when trying to read wiki files
- **Solution**: Ensure you've run `init_wiki.sh` to create the wiki structure in your vault
- **Solution**: Check that the file paths in requests are vault-relative (e.g., `CodeWiki/wiki/index.md`)
- **Solution**: Verify the wiki folder name matches what you configured with `--wiki-folder`

### Methodologies Not Being Applied

**Problem**: Agent doesn't reference methodologies when writing code
- **Solution**: Ensure the `retrieve-methodologies.md` workflow is being followed
- **Solution**: Check that the index.md is being read before coding
- **Solution**: Verify the agent has the workflow instructions in its AGENTS.md

## Advanced Usage

### Using MCP Instead of REST API

If your LLM agent supports MCP:
1. Connect to the MCP server exposed by the Obsidian plugin
2. Use MCP tools instead of HTTP requests
3. The MCP server provides the same capabilities as structured tools
4. Read the schema documentation from your vault via API for MCP connection details

### Integrating with Other Tools

- **Dataview**: Add YAML frontmatter to pages for dynamic queries
- **Marp**: Generate presentations from wiki content
- **Git**: Version control your wiki (it's just markdown files)
- **Search engines**: Integrate with qmd or similar for large-scale search

## Contributing

This is a pattern, not a rigid framework. Adapt it to your needs:
- Change the directory structure
- Modify the page formats
- Add new workflow types
- Integrate with other tools

The key principles are:
- Persistent, compounding knowledge
- LLM does the maintenance
- Human does the curation and direction
