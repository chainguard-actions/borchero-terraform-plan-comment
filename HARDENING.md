<!-- markdownlint-disable -->

# Hardening Report: borchero--terraform-plan-comment/v3.1.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **borchero--terraform-plan-comment/v3.1.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): In `.github/workflows/release.yml`, the `run:` block for the 'Get major version' step directly interpolates `${{ github.ref_name }}` into a shell command: `MAJOR=$(echo ${{ github.ref_name }} | cut -d'.' -f1 | cut -c2-)`. The expression is substituted by the YAML template engine before the shell ever sees it, allowing an attacker-controlled tag name to inject arbitrary shell commands (e.g. a tag named `v1.0.0; malicious-command`).

Locations:

- `.github/workflows/release.yml:20`

### github-env-injection (severity: high)

In `.github/workflows/release.yml`, the 'Get major version' `run:` block writes `$MAJOR` — a value derived from the untrusted `${{ github.ref_name }}` expression — to `$GITHUB_OUTPUT` without the required sanitization step (`printf '%s' "$MAJOR" | tr -d '\n\r'`). A newline embedded in the tag name could inject additional key=value pairs into the output file: `echo "major=$MAJOR" >> $GITHUB_OUTPUT`.

Locations:

- `.github/workflows/release.yml:21`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed both findings in `.github/workflows/release.yml` 'Get major version' step: (1) Moved `${{ github.ref_name }}` into an `env:` block as `REF_NAME` and replaced the direct interpolation in the shell command with `$REF_NAME`, eliminating the script-injection risk. (2) Added `safe=$(printf '%s' "$MAJOR" | tr -d '\n\r')` and used `$safe` when writing to `$GITHUB_OUTPUT`, preventing newline-based injection into the output file. Also quoted `$GITHUB_OUTPUT` for best practice.

