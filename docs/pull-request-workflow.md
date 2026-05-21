# Pull Request Workflow

This document describes the full lifecycle of a pull request (PR) in the `railctl` repository — what runs automatically, what requires manual intervention, and what gates must pass before merging.

---

## Overview

```
Developer pushes branch
        │
        ▼
┌──────────────────────┐
│   PR Opened           │
│                       │
│  ✅ Unit tests (auto) │
│                       │
│  ⏳ Review (wait)     │
└──────────┬────────────┘
           │
     Admin reviews code
           │
     ┌─────┴──────┐
     └─────┬──────┘
           │
           ▼
┌──────────────────────┐
└──────────┬────────────┘
           │
     Admin approves PR
           │
           ▼
┌──────────────────────┐
│  All Gates Pass?      │
│  ✅ Unit tests        │
│  ✅ 1 approval        │
│  ✅ Conversations     │
│     resolved          │
└──────────┬────────────┘
           │
     Rebase & merge
           │
           ▼
┌──────────────────────┐
│  Merged to main       │
│                       │
└──────────────────────┘
```

---

## What Runs Automatically

### On Every Push to a PR Branch

| Workflow | File | What it does | Duration |
|----------|------|-------------|----------|
| **PR Tests** | `.github/workflows/pr.yml` | Builds the binary, runs all unit + integration tests (`go test ./...`), posts results as a PR comment | ~2 min |

This requires **no human action** — it triggers on every push to any PR targeting `main`.

### On Merge to `main`

| Workflow | File | What it does | Duration |
|----------|------|-------------|----------|

This is an automatic safety net. If E2E tests fail after merge, the team is notified immediately.

---

## E2E Testing

E2E tests run **locally** — they are not part of the CI pipeline. Contributors run them against the live Railway API using their own tokens before submitting PRs.

See [CONTRIBUTING.md](../CONTRIBUTING.md) and [tests/e2e/README.md](../tests/e2e/README.md) for setup instructions.

---

## Merge Gates

All of the following must pass before the "Merge" button becomes available:

### 1. Required Status Checks

| Check | Source | Required |
|-------|--------|----------|
| **`test`** | `pr.yml` — unit + integration tests | ✅ Must pass |

Both checks must be **up-to-date** with `main` (`strict: true`). If `main` advances after the checks ran, they must re-run. This prevents merging stale branches.

### 2. Required Reviews

| Rule | Setting |
|------|---------|
| Minimum approvals | **1** |
| Dismiss stale reviews | ✅ Yes — new pushes invalidate prior approvals |

### 3. Conversation Resolution

All PR review comments and threads must be **resolved** before merging.

### 4. Linear History (Rebase Only)

Merge commits are **not allowed**. PRs must be merged via **rebase** or **squash** to maintain a clean, linear commit history.

---

## CODEOWNERS

Certain paths require approval from `@kubenoops/maintainers`:

| Path | Owner | Why |
|------|-------|-----|
| `.github/` | `@kubenoops/maintainers` | CI/CD pipeline changes |
| `Makefile` | `@kubenoops/maintainers` | Build system changes |
| `tests/e2e/` | `@kubenoops/maintainers` | E2E test infrastructure |

If a PR modifies these paths, an admin review is automatically requested.

---

## Step-by-Step Example

Here's a complete example of the PR lifecycle:

```
1. Developer creates a branch and pushes:
   $ git checkout -b feat/add-widget
   $ git push -u origin feat/add-widget

2. Opens a PR → Unit tests run automatically
   ✅ PR Tests (test) — passed

3. Admin reviews the code
   - Checks logic, test coverage, and security-sensitive files
   - Leaves comments if changes are needed

4. Admin approves the PR:
   ✅ 1/1 approvals

5. All conversations resolved:
   ✅ No unresolved threads

6. Merge button becomes available:
   🟢 "Rebase and merge"

7. After merge, Pre-release is auto-created
```

---

## Running Tests Locally

Before pushing, developers should run tests locally:

```bash
# Unit + integration tests (always run before pushing)
make test

# Smoke E2E (~1 min, requires Railway token)
make test-smoke

# Full E2E suite (~10 min, requires Railway token)
make test-e2e
```

---

## Quick Reference

| Question | Answer |
|----------|--------|
| Are E2E tests in CI? | No — run locally by contributors |
| Can I skip unit tests? | No — `test` is a required status check |
| How do I run E2E? | Locally — see CONTRIBUTING.md |
| Can I force push to main? | No — force pushes are disabled |
| What merge strategy? | Rebase only (linear history enforced) |
| Do stale approvals count? | No — new pushes dismiss prior approvals |
