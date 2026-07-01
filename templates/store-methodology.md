---
description: Store a programming methodology in the wiki when the user explicitly states a preference
---

# Workflow: Store Programming Methodology

This workflow is triggered when the user explicitly states a programming preference, coding standard, or technique (e.g., "never use short variable names and be as descriptive as possible").

## Steps

1. **Extract the methodology statement**
   - Identify the core principle or rule being stated
   - Note any context or examples provided
   - Clarify with the user if the statement is ambiguous

2. **Check for existing similar methodologies**
   - Read `{{WIKI_FOLDER}}/wiki/index.md` to find existing methodology pages
   - Search for pages with similar tags or titles
   - If a similar methodology exists, prepare to update it instead of creating a duplicate

3. **Create or update the methodology page**
   - Generate a descriptive, kebab-case filename (e.g., `variable-naming-conventions.md`)
   - Create the page in `{{WIKI_FOLDER}}/wiki/methodologies/` with proper structure
   - Use the Obsidian REST API to create/update the file

4. **Update the index**
   - Read `{{WIKI_FOLDER}}/wiki/index.md`
   - Add the new or updated methodology to the appropriate section
   - Write the updated index back to the wiki

5. **Log the operation**
   - Append an entry to `{{WIKI_FOLDER}}/wiki/log.md` with timestamp and action

6. **Confirm with the user**
   - Briefly summarize what was stored
   - Provide a link to the created/updated page
