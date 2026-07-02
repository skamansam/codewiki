---
name: codewiki
description: A self-contained skill for LLM agents to store and retrieve programming methodologies via Obsidian REST API
---

# CodeWiki Skill

## Overview

CodeWiki is a self-contained skill for LLM agents that enables storing and retrieving programming methodologies via the Obsidian REST API. It allows agents to maintain a persistent knowledge base that compounds over time.

## Prerequisites

1. Obsidian installed and running
2. Obsidian Local REST API plugin installed and enabled
3. API key from Obsidian plugin settings

## Skill Description

This skill provides two main capabilities:

### Store Methodology

When the user explicitly states a programming preference (e.g., "always use descriptive variable names"):

1. Check if CodeWiki is initialized in the Obsidian vault (look for `CodeWiki/wiki/index.md`)
2. If not initialized, download and run the initialization script from https://github.com/skamansam/codewiki
3. Use the Obsidian REST API to read `CodeWiki/schema/workflows/store-methodology.md`
4. Follow the workflow to store the methodology
5. Create/update the methodology page via API
6. Update the index and log

### Retrieve Methodologies

Before writing code or making technical decisions:

1. Check if CodeWiki is initialized in the Obsidian vault
2. If not initialized, ask the user to initialize it first
3. Use the Obsidian REST API to read `CodeWiki/schema/workflows/retrieve-methodologies.md`
4. Follow the workflow to retrieve relevant methodologies
5. Apply the methodologies to the current task
6. Reference the methodologies in comments/explanations

## Initialization

The first time CodeWiki is used, it needs to be initialized in the Obsidian vault:

```bash
# Download and run the initialization script
curl -fsSL https://raw.githubusercontent.com/skamansam/codewiki/main/init_wiki.sh | bash -s -- --api-key YOUR_API_KEY
```

This creates a `CodeWiki/` folder in your Obsidian vault with:
- `wiki/index.md` - Catalog of all wiki pages
- `wiki/log.md` - Operation log
- `schema/AGENTS.md` - Schema and API documentation
- `schema/workflows/` - Workflow definitions

## API Configuration

- **API URL**: `http://localhost:27124` (default)
- **API Key**: Get from Obsidian plugin settings
- **Content-Type**: `text/markdown`
- **Wiki Folder**: `CodeWiki` (default)

## Required Agent Capabilities

1. **HTTP Requests** - Make GET/PUT/POST/PATCH requests with custom headers
2. **Markdown Processing** - Parse YAML frontmatter, generate wiki links `[[Page Title]]`
3. **Workflow Following** - Read and follow multi-step procedures
4. **Script Execution** - Ability to download and run shell scripts (for initialization)

## Usage Pattern

When this skill is active:

1. **Before coding**: Automatically retrieve relevant methodologies from the wiki
2. **When user states preferences**: Automatically store them as methodologies
3. **On first use**: Prompt user for API key and initialize the wiki

## Troubleshooting

**API Connection Failed**: Ensure Obsidian is running with the plugin enabled
**404 Errors**: Wiki not initialized - run the initialization script
**Methodologies Not Applied**: Verify the agent is following the retrieve workflow

## More Information

Full documentation: https://github.com/skamansam/codewiki
