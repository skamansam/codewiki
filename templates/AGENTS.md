# AGENTS.md - CodeWiki Schema for Programming Methodologies

## Overview

This document defines the schema and conventions for the CodeWiki system used to store and retrieve programming methodologies, techniques, and best practices. The wiki is maintained by LLM agents and serves as a persistent knowledge base that compounds over time.

## Directory Structure

```
{{WIKI_FOLDER}}/
├── raw/           # Source documents (immutable - LLM reads from here)
├── wiki/          # LLM-generated markdown files (LLM writes here)
└── schema/        # Configuration files (this file, workflows)
```

## Wiki Layer Structure

The wiki contains the following types of pages:

### Methodology Pages
- **Path**: `{{WIKI_FOLDER}}/wiki/methodologies/{methodology-name}.md`
- **Purpose**: Store specific programming methodologies, coding standards, and techniques
- **Format**: Markdown with YAML frontmatter

### Concept Pages
- **Path**: `{{WIKI_FOLDER}}/wiki/concepts/{concept-name}.md`
- **Purpose**: Cross-cutting concepts that span multiple methodologies
- **Format**: Markdown with YAML frontmatter and cross-references

### Source Pages
- **Path**: `{{WIKI_FOLDER}}/wiki/sources/{source-name}.md`
- **Purpose**: Summaries of ingested source documents
- **Format**: Markdown with YAML frontmatter linking to raw sources

### Index and Log
- **Path**: `{{WIKI_FOLDER}}/wiki/index.md` - Catalog of all wiki pages
- **Path**: `{{WIKI_FOLDER}}/wiki/log.md` - Chronological record of operations

## Page Format

All wiki pages must follow this format:

```markdown
---
title: Page Title
type: methodology|concept|source
tags: [tag1, tag2, tag3]
created: YYYY-MM-DD
related: [[Related Page 1]], [[Related Page 2]]
---

# Page Title

Content here...
```

## Obsidian REST API Usage

### Base Configuration
- **API URL**: {{API_URL}}
- **Authentication**: Bearer token from Obsidian Settings → Local REST API with MCP
- **Content-Type**: `text/markdown` for file operations

### Key Endpoints

#### Read a File
```http
GET /vault/{filename}
Headers:
  Accept: text/markdown or application/vnd.olrapi.note+json
  Authorization: Bearer {API_KEY}
```

#### Create/Update a File
```http
PUT /vault/{filename}
Headers:
  Content-Type: text/markdown
  Authorization: Bearer {API_KEY}
Body: {markdown content}
```

#### Append to a File
```http
POST /vault/{filename}
Headers:
  Content-Type: text/markdown
  Authorization: Bearer {API_KEY}
Body: {content to append}
```

#### Patch a Section (Heading/Block/Frontmatter)
```http
PATCH /vault/{filename}
Headers:
  Content-Type: text/markdown
  Operation: append|prepend|replace
  Target-Type: heading|block|frontmatter
  Target: {target name}
  Authorization: Bearer {API_KEY}
Body: {content}
```

## Skills for LLM Agents

### Skill: Store Methodology
When the user explicitly states a programming preference or methodology:

1. Extract the methodology statement
2. Check if a similar methodology already exists in `{{WIKI_FOLDER}}/wiki/methodologies/`
3. If it exists, update it with the new information
4. If it doesn't exist, create a new page with proper structure
5. Update `{{WIKI_FOLDER}}/wiki/index.md` to include the new page
6. Append an entry to `{{WIKI_FOLDER}}/wiki/log.md` with timestamp and action

### Skill: Retrieve Relevant Methodologies
Before writing code or making technical decisions:

1. Read `{{WIKI_FOLDER}}/wiki/index.md` to find relevant methodology pages
2. Read the full content of relevant methodology pages
3. Apply the methodologies to the current task
4. Reference the methodologies in comments or explanations
5. If methodologies conflict, ask the user for clarification

## Naming Conventions

- **Methodology pages**: Use kebab-case, descriptive names (e.g., `variable-naming-conventions.md`)
- **Concept pages**: Use kebab-case (e.g., `error-handling-patterns.md`)
- **Source pages**: Use source identifier or title (e.g., `clean-code-summary.md`)
- **All pages**: Use `.md` extension

## Cross-Reference Format

Use Obsidian's wiki-link format for cross-references:
- `[[Page Title]]` for basic links
- `[[Page Title|Display Text]]` for custom display text
- `[[Page Title#Heading]]` for heading anchors

## Frontmatter Fields

Required fields:
- `title`: Page title
- `type`: methodology|concept|source
- `created`: ISO date (YYYY-MM-DD)

Optional fields:
- `tags`: Array of tags for categorization
- `related`: Array of related page links
- `updated`: ISO date when last modified
