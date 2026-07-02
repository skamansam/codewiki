# CodeWiki - Programming Methodologies Knowledge Base

A pattern for building personal knowledge bases using LLMs, specifically designed for storing and retrieving programming methodologies, techniques, and best practices.

This repository contains a self-contained skill for LLM agents that enables storing and retrieving programming methodologies via the Obsidian REST API. The actual wiki data lives in your Obsidian vault, not in this repository.

## Quick Start

### Option A: Install via npx skills (Recommended)

```bash
npx skills add skamansam/codewiki --skill codewiki
```

Then enable the skill in your LLM agent and start using it.

### Option B: Manual Installation

1. Install and configure the Obsidian Local REST API plugin
2. Clone this repository
3. Enable the CodeWiki skill in your LLM agent
4. The agent will automatically initialize the wiki on first use

## Repository Structure

```
codewiki/
├── README.md              # This file
├── skills/
│   └── codewiki/
│       └── SKILL.md       # Self-contained skill definition for LLM agents
├── init_wiki.sh          # Script to initialize wiki via Obsidian API
└── templates/             # Template files for wiki structure
    ├── index.md
    ├── log.md
    ├── AGENTS.md
    ├── store-methodology.md
    └── retrieve-methodologies.md
```

The wiki itself (CodeWiki/, wiki/, schema/, raw/ directories) is created in your Obsidian vault when the skill is first used.

## Using CodeWiki as a Skill

CodeWiki is designed as a self-contained skill that LLM agents can discover and use without any configuration in your project files.

### How It Works

When the CodeWiki skill is enabled in your LLM agent:

1. **First Use**: The agent detects that CodeWiki is not initialized and prompts you for your Obsidian API key
2. **Initialization**: The agent downloads and runs the initialization script to create the wiki structure in your Obsidian vault
3. **Automatic Storage**: When you state programming preferences (e.g., "always use descriptive variable names"), the agent automatically stores them
4. **Automatic Retrieval**: Before writing code, the agent automatically retrieves relevant methodologies

### No Project Configuration Needed

Unlike traditional integrations, CodeWiki doesn't require:
- Adding anything to your AGENTS.md
- Committing files to your repository
- Manual setup in each project

Simply enable the skill in your LLM agent and it works across all your projects.

## Skill Definition

See `skills/codewiki/SKILL.md` for the complete skill definition that LLM agents can discover and use.

## Manual Initialization (Optional)

While the skill can auto-initialize on first use, you can also manually initialize the wiki:

### Prerequisites

1. Install Obsidian Local REST API plugin
2. Ensure Obsidian is running with your vault open
3. Note your API key from plugin settings

### Run the Initialization Script

```bash
curl -fsSL https://raw.githubusercontent.com/skamansam/codewiki/main/init_wiki.sh | bash -s -- --api-key YOUR_API_KEY
```

**Options:**
- `--insecure` - Use HTTP instead of HTTPS (for HTTP mode)
- `--skip-ssl-validation` - Skip SSL certificate validation (for self-signed certificates in HTTPS mode)

**Examples:**
```bash
# For HTTP mode
curl -fsSL https://raw.githubusercontent.com/skamansam/codewiki/main/init_wiki.sh | bash -s -- --api-key YOUR_API_KEY --insecure

# For HTTPS with self-signed certificate
curl -fsSL https://raw.githubusercontent.com/skamansam/codewiki/main/init_wiki.sh | bash -s -- --api-key YOUR_API_KEY --skip-ssl-validation
```

This creates a `CodeWiki/` folder in your Obsidian vault with the wiki structure.

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
