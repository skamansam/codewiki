---
description: Retrieve and apply relevant programming methodologies before writing code
---

# Workflow: Retrieve and Apply Methodologies

This workflow is triggered before writing code, making technical decisions, or when the user asks about coding practices.

## Steps

1. **Read the wiki index**
   - Use the Obsidian REST API to read `{{WIKI_FOLDER}}/wiki/index.md`
   - Parse the index to identify relevant methodology pages
   - Look for pages with tags related to the current task

2. **Read relevant methodology pages**
   - For each relevant methodology identified, read the full page content
   - Also read any related concept pages that might be relevant

3. **Apply methodologies to the current task**
   - Review the methodologies and identify which ones apply to the current situation
   - Incorporate the methodologies into the code or solution being developed
   - Add comments or explanations referencing the methodologies

4. **Handle conflicts**
   - If two methodologies conflict, ask the user for clarification
   - Present the conflicting methodologies and ask which one should take precedence

5. **Synthesize and communicate**
   - Briefly explain which methodologies were applied and why
   - Reference the specific methodology pages using wiki links
