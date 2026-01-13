---
name: update
description: Check for and apply kickstart configuration updates. Merges template changes with user customizations for CLAUDE.md and settings.json, requiring approval before any modifications.
---

# Update Kickstart Configuration

You are checking for and applying configuration updates from the kickstart plugin.

## Important Principles

1. **Never overwrite user customizations without approval**
2. **Show exactly what will change before applying**
3. **Preserve project-specific content**
4. **User has final say on all changes**

## Process

### Step 1: Read Current Configuration

```bash
cat .claude/CLAUDE.md 2>/dev/null
cat .claude/settings.json 2>/dev/null
```

If no `.claude/CLAUDE.md` exists, suggest running `/init` instead.

### Step 2: Identify the Template Used

Look at the project's CLAUDE.md to determine which template was used:
- Check for SvelteKit markers (`svelte`, `bun run`)
- Check for Next.js markers (`next`, `npm run`)
- Default to base template if unclear

### Step 3: Compare with Latest Template

Read the appropriate template from `${CLAUDE_PLUGIN_ROOT}/templates/`:

```bash
cat ${CLAUDE_PLUGIN_ROOT}/templates/sveltekit/CLAUDE.md.template
# or
cat ${CLAUDE_PLUGIN_ROOT}/templates/base/CLAUDE.md.template
```

### Step 4: Identify Differences

Compare the current project config with the template structure:

1. **Template sections** - Standard sections from the template
2. **User sections** - Custom sections the user added
3. **Modified sections** - Template sections the user customized

### Step 5: Present Changes for Approval

Use AskUserQuestion to show the user what would change:

**Example format:**

"I found the following updates available from kickstart:

**New sections:**
- Added 'Performance Guidelines' section

**Updated sections:**
- 'Git Workflow' has new worktree cleanup instructions

**Your customizations (will be preserved):**
- 'Project-Specific Notes' section
- Custom commands you added

Would you like to apply these updates?"

Options:
- Apply all updates (preserving my customizations)
- Show me the diff first
- Skip this update

### Step 6: Apply Updates (if approved)

If the user approves:

1. **Preserve user content:**
   - Project name and description
   - Custom commands
   - Project-specific notes
   - Any sections not in the template

2. **Update template content:**
   - Replace template sections with new versions
   - Add any new sections from the template

3. **Write the merged result**

### Step 7: Update GitHub Workflows (if applicable)

Check if workflow templates have been updated:

```bash
ls ${CLAUDE_PLUGIN_ROOT}/templates/*/github/workflows/
```

Ask user if they want to update workflows too:
- Show what would change
- Get approval before overwriting

### Step 8: Update Permissions (settings.json)

Check if the project has a `.claude/settings.json` file. If it exists, compare it with the template to find new permissions.

**Read the template permissions:**

```bash
cat ${CLAUDE_PLUGIN_ROOT}/templates/sveltekit/settings.json
# or for base template:
cat ${CLAUDE_PLUGIN_ROOT}/templates/base/settings.json.template
```

**Compare permissions:**

1. Parse the `permissions.allow` array from both files
2. Identify permissions in the template that are NOT in the user's settings.json
3. These are "new permissions" available from kickstart updates

**If new permissions are found**, present them to the user:

"I found new permissions available from kickstart:

**New permissions:**
- `Bash(bun run check:*)` - Type checking
- `Bash(gh workflow:*)` - GitHub workflow commands

These allow Claude to run additional commands automatically without prompting.

Would you like to add these permissions?"

Options:
- Add all new permissions
- Let me review each one
- Skip permissions update

**If "Add all new permissions":**
Merge the new permissions into the user's existing `permissions.allow` array, preserving any custom permissions the user may have added.

**If "Let me review each one":**
Use AskUserQuestion with multiSelect to let the user pick which permissions to add.

**Merge Strategy for settings.json:**

```
Permission Status          Action
───────────────────────────────────────────────
In template, not in user   Offer to add (new)
In user, not in template   Keep (user custom)
In both                    Keep as-is
```

**Important:** Never remove permissions the user has added, even if they're not in the template. Users may have added project-specific permissions.

### Step 9: Confirm Completion

Summarize what was updated:
- Which CLAUDE.md sections were refreshed
- Which new permissions were added to settings.json
- What customizations were preserved
- Remind user to review the changes

## Merge Strategy

When merging template updates with user customizations:

```
Template Section     User Modified?     Action
─────────────────────────────────────────────────
Git Workflow         No                 Replace with new
Git Workflow         Yes                Ask user: keep theirs or take new?
Commands             Always custom      Preserve user's
Project Notes        Always custom      Preserve user's
New Section          N/A                Add to end
```

## Example Merged Output

```markdown
# my-project

Brief description here.

## Tech Stack
SvelteKit 5, Bun, Tailwind

## Commands
<!-- User's custom commands preserved -->
- `bun run dev` - Dev server
- `bun run build` - Production build

<!-- NEW: Added from template update -->
## Performance Guidelines
New guidelines from kickstart update...

## Project-Specific Notes
<!-- User's custom notes preserved -->
This project uses a specific API...
```

## If No Updates Available

Tell the user:
"Your configuration is up to date with kickstart v{version}. No changes needed."

Check plugin version:
```bash
cat ${CLAUDE_PLUGIN_ROOT}/plugin.json | grep version
```
