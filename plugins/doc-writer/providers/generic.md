# Provider: Generic / Unknown Platform

Use this provider when the git remote does not match GitHub or Azure DevOps, or as a fallback when API posting is not possible.

## Behaviour

In generic mode the documentation changes are committed locally as normal, but **no summary is posted to a remote platform**. Instead, a report is written to a local file describing what was updated.

---

## Writing the Report File

Write the update summary to:

```
doc-update-report.md
```

**File format:**

```markdown
# Documentation Update Report

Generated: <ISO 8601 timestamp>
Branch: <current branch>
Base: <base branch>
Commit: <HEAD SHA>

---

## Files Modified

<list of files with description of what was changed and why>

## Files Created

<list of newly created doc files>

## No Changes Required

<if no doc-impacting changes were found, state this here>
```

---

## Committing

Commit documentation changes and push using the standard git flow even in generic mode:

```bash
git add <doc-files>
git commit -m "docs: update documentation for PR changes"
git push origin HEAD
```

If `git push` is not possible (no remote write access), skip the push and note it in the report file.

---

## Follow-Up PR (Post-merge)

In generic mode, a follow-up PR cannot be opened automatically. Instead:

1. Push the docs branch: `git push origin <docs-branch>`
2. Append a note to `doc-update-report.md` instructing the user to open a PR manually

---

## Output

On completion:

```
Documentation updated: <N> files modified, <N> files created — report written to doc-update-report.md
```
