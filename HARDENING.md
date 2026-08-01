<!-- markdownlint-disable -->

# Hardening Report: borchero--terraform-plan-comment/v3.2.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **borchero--terraform-plan-comment/v3.2.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): ${{ github.ref_name }} is directly interpolated inside a run: shell command. The expression is substituted by the YAML template engine before the shell sees it, allowing a specially crafted release name to inject arbitrary shell commands. Offending line: MAJOR=$(echo ${{ github.ref_name }} | cut -d'.' -f1 | cut -c2-). Fix: use an env: variable and quote it in the shell.

Locations:

- `.github/workflows/release.yml:20`

### github-env-injection (severity: high)

The run: block derives MAJOR from ${{ github.ref_name }} and writes it to $GITHUB_OUTPUT without the required sanitization step (printf '%s' "$MAJOR" | tr -d '\n\r'). A newline in the release name could inject arbitrary key=value pairs into the output file. Offending line: echo "major=$MAJOR" >> $GITHUB_OUTPUT

Locations:

- `.github/workflows/release.yml:21`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed both findings in .github/workflows/release.yml:
1. script-injection (line 20): Moved ${{ github.ref_name }} out of the run: shell command into an env: variable (REF_NAME). The shell script now uses "$REF_NAME" safely.
2. github-env-injection (line 21): Added sanitization step using `printf '%s' "$MAJOR" | tr -d '\n\r'` to strip newlines before writing to $GITHUB_OUTPUT, preventing newline injection. Also quoted $GITHUB_OUTPUT reference.

