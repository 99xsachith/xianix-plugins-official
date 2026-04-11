# Provider: GitHub

Use this provider when `git remote get-url origin` contains `github.com`.

## Prerequisites

The `gh` CLI must be installed and authenticated. Verify with:

```bash
gh auth status
```

If not authenticated, the user needs to run `gh auth login` or set the `GITHUB_TOKEN` environment variable.

---

## Fetching Issue Details

Fetch the full issue with metadata, labels, milestone, and comments:

```bash
gh issue view ${ISSUE_NUMBER} --json number,title,body,state,labels,assignees,milestone,comments,projectItems
```

Extract from the JSON response:
- `title` — issue title
- `body` — issue description
- `state` — OPEN / CLOSED
- `labels[].name` — existing labels
- `assignees[].login` — assigned users
- `milestone.title` — milestone name
- `comments[].body` — prior discussion and context

---

## Finding Related Issues

Find issues in the same milestone:

```bash
gh issue list --milestone "${MILESTONE}" --json number,title,state,labels --limit 20
```

Find issues with the same label:

```bash
gh issue list --label "${LABEL}" --json number,title,state --limit 20
```

Search by keyword from the issue body:

```bash
gh issue list --search "${KEYWORD}" --json number,title,state --limit 10
```

---

## Posting the Elaboration

The original issue body is **never modified**. All analysis is posted as **separate comments** — one per aspect. This preserves the author's description and creates a reviewable discussion thread.

### Comment Order

Post each aspect as its own comment using `gh issue comment`. Each comment must have a clear heading so the thread is scannable.

| # | Comment | Heading | Source |
|---|---------|---------|--------|
| 1 | Summary & Verdict | `## 📋 Elaboration Summary` | Orchestrator (compiled) |
| 2 | Intent & User Context | `## 🔍 Intent & User Context` | intent-analyst |
| 3 | User Journey | `## 🗺️ User Journey` | journey-mapper |
| 4 | Personas | `## 👥 Personas` | persona-analyst |
| 5 | Domain Context | `## 🏢 Domain Context` | domain-analyst |
| 6 | Gaps, Risks & Dependencies | `## ⚠️ Gaps, Risks & Dependencies` | gap-risk-analyst |

**Skip** comments 3 (Journey) and 4 (Personas) if the sub-agent found nothing relevant (e.g., a narrow bug fix with a single obvious persona).

### Posting each comment

```bash
gh issue comment ${ISSUE_NUMBER} --body "${COMMENT_BODY}"
```

For multi-line content, use a heredoc:

```bash
gh issue comment ${ISSUE_NUMBER} --body "$(cat <<'EOF'
## 📋 Elaboration Summary

${SUMMARY_CONTENT}
EOF
)"
```

---

## Applying the Verdict Label

After posting all comments, apply the verdict label:

```bash
gh issue edit ${ISSUE_NUMBER} --add-label "${VERDICT_LABEL}"
```

| Plugin verdict | GitHub label |
|---|---|
| `GROOMED` | `groomed` |
| `NEEDS CLARIFICATION` | `needs-clarification` |
| `NEEDS DECOMPOSITION` | `needs-decomposition` |

---

## Posting Unresolved Questions

If the gap-risk-analyst identified unresolved questions, post each as a **separate comment** after the analysis comments, tagging the relevant person:

```bash
gh issue comment ${ISSUE_NUMBER} --body "❓ **Unresolved Question**

${QUESTION_TEXT} — @${PERSON}"
```

---

## Resolving the Issue

If no issue number was passed as an argument:

1. Parse the GitHub remote to get `{owner}` and `{repo}`:

```bash
git remote get-url origin
# e.g. https://github.com/org/repo.git  →  owner=org, repo=repo
```

2. List recent issues: `gh issue list --limit 10 --json number,title`

---

## Output

On completion:

```
Elaboration posted on issue #<number>: <verdict> — <N> comments — <N> unresolved questions
```
