# Detect and migrate modified Sylius templates between two versions

Identifies ShopBundle templates that changed between two Sylius tags on GitHub,
then applies the Tailwind CSS / daisyUI migration for each of them.

**Usage:** `/check-sylius-updates v2.2.3 v2.2.4`

`$ARGUMENTS` = two space-separated tags, e.g. `v2.2.3 v2.2.4`
If a single tag is provided, it is used as `TO_VERSION` and the memorized version is `FROM_VERSION`.
If no argument, compare the memorized version with the latest GitHub release.

---

## Steps

### 1. Determine FROM_VERSION and TO_VERSION

- **2 arguments**: `FROM_VERSION` = first, `TO_VERSION` = second.
- **1 argument**: `TO_VERSION` = provided argument. `FROM_VERSION` = version memorized in project memory (`v2.2.3` as of 2026-03-28).
- **0 arguments**: `FROM_VERSION` = memorized version. Fetch the latest release as `TO_VERSION`:

```bash
gh api repos/Sylius/Sylius/releases/latest --jq '.tag_name'
```

**Memorized version (current vendor): `v2.2.3`**

### 2. Call the GitHub Compare API

```bash
gh api "repos/Sylius/Sylius/compare/{FROM_VERSION}...{TO_VERSION}" \
  --jq '{
    status: .status,
    total_commits: .total_commits,
    files_count: (.files | length),
    template_files: [
      .files[] | select(.filename | contains("Bundle/ShopBundle/templates")) | {
        file: .filename,
        status: .status
      }
    ]
  }'
```

**If `files_count` == 300 and `total_commits` > 300**: the response is truncated.
In that case, proceed to step 2b.

### 2b. Fallback for large diffs (if truncated)

Iterate over commits in the range, filtering by path:

```bash
# Page 1
gh api "repos/Sylius/Sylius/commits?sha={TO_VERSION}&per_page=100&page=1" \
  --jq '.[] | {sha: .sha, message: .commit.message}'

# For each commit SHA, fetch modified files
gh api "repos/Sylius/Sylius/commits/{SHA}" \
  --jq '.files[] | select(.filename | contains("Bundle/ShopBundle/templates")) | {file: .filename, status: .status}'
```

Continue until reaching a commit older than `FROM_VERSION` (verify with the compare).

> Note: this step is expensive in API calls. Prefer patch-to-patch comparisons to avoid this case.

### 3. Filter and classify templates

For each file found, extract the relative path from `templates/`:

- Source: `src/Sylius/Bundle/ShopBundle/templates/{path}`
- Theme:  `themes/TailwindTheme/templates/bundles/SyliusShopBundle/{path}`

Classify files into 3 categories:
- **To update**: `modified` file AND present in the theme
- **To create**: `added` OR `modified` file AND absent from the theme
- **Removed upstream**: `removed` file (check if present in the theme to delete it)

```bash
# Check if a template exists in the theme
ls themes/TailwindTheme/templates/bundles/SyliusShopBundle/{path} 2>/dev/null
```

### 4. Display the detection report

Present a structured report before starting migrations:

```
## Sylius templates modified between {FROM_VERSION} and {TO_VERSION}

### To update in the theme (X files)
- account/order/show/content/breadcrumbs.html.twig [modified]

### To create in the theme (Y files)
- checkout/summary/content/main.html.twig [added]

### Removed upstream — to verify (Z files)
- ...
```

If no ShopBundle templates have changed, stop here.

### 5. Migrate each template — file by file

Process files in this order: `modified` first, then `added`.
**Do not process multiple files in parallel** — proceed one by one and wait for validation if necessary.

#### Case A — `modified` file (already existed in the theme)

The goal is to integrate upstream changes into the existing Tailwind version **without overwriting work already done**.

1. Fetch the old version of the source file (before the change) via the GitHub API:
```bash
gh api "repos/Sylius/Sylius/contents/{path}?ref={FROM_VERSION}" --jq '.content' | base64 -d
```

2. Read the new version from the local vendor:
```
vendor/sylius/sylius/src/Sylius/Bundle/ShopBundle/templates/{path}
```

3. Analyze **what changed** between the two Bootstrap versions:
   - New HTML structure added?
   - Twig attribute modified (block, variable, include)?
   - Business logic added/modified?
   - Simple Bootstrap CSS class correction?

4. Read the existing Tailwind version in the theme:
```
themes/TailwindTheme/templates/bundles/SyliusShopBundle/{path}
```

5. Apply the equivalent change in the Tailwind version:
   - If it's a Twig logic change → port it as-is
   - If it's an HTML addition with Bootstrap classes → convert to Tailwind/daisyUI
   - If it's a Bootstrap CSS correction → adapt to Tailwind
   - Keep all Symfony UX Live components intact (`data-controller`, `data-model`, etc.)

#### Case B — `added` file (new upstream, absent from the theme)

Bootstrap → Tailwind conversion from scratch:

1. Read the source file from the local vendor
2. Create the target directory if necessary
3. Convert by applying the mapping table rules (see CLAUDE.md)
4. Use daisyUI for interactive components
5. Use the `heading` class for `h1`–`h6` headings

#### Case C — `removed` file (removed upstream)

1. Check if the file exists in the theme
2. If yes: notify the user and ask for confirmation before deletion — the theme file may have a reason to exist independently

### 6. Write / update CHANGELOG.md

After processing all files, append a new entry to `CHANGELOG.md` at the project root.

- If `CHANGELOG.md` does not exist, create it with a header.
- If it already exists, **prepend** the new entry (most recent first).

Entry format:

```markdown
## Sylius {FROM_VERSION} → {TO_VERSION} — {YYYY-MM-DD}

### Updated templates
- `account/order/show/content/breadcrumbs.html.twig` — upstream change ported to Tailwind

### Added templates
- `checkout/summary/content/new-file.html.twig` — new upstream template converted to Tailwind

### Removed upstream
- `old/template.html.twig` — removed upstream; theme copy kept pending manual review
```

Omit sections that have no entries (e.g. omit "### Removed upstream" if nothing was removed).
If no template changed, write a single line: `_No ShopBundle template changes in this release._`

### 7. Update the memorized version

After processing all files, if `TO_VERSION` matches the version in `vendor/sylius/sylius/composer.json`:
- Update `~/.claude/projects/-Users-adeliom-Documents-Projets-SyliusTailwindcssPlugin/memory/project_plugin_context.md`: line `Sylius version in vendor` → new version + today's date.
- Update this file: **Memorized version** and **Usage** example.

### 8. Final summary

```
## Migration complete

- X files updated
- Y files created
- Z files removed upstream (awaiting decision)

CHANGELOG.md updated with entry for {FROM_VERSION} → {TO_VERSION}.
Reference version updated: {TO_VERSION} ({date})
```
