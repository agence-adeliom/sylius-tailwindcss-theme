## Claude Code integration

If you use [Claude Code](https://claude.ai/code) in your Sylius project, you can leverage the maintenance commands bundled with this theme to keep your customized templates in sync with upstream Sylius updates.

### Setup

Copy the commands you need from the theme package into your project's Claude commands folder:

```bash
# Create the commands directory if it doesn't exist
mkdir -p .claude/commands

# Copy the Sylius update tracking command
cp vendor/agence-adeliom/sylius-tailwindcss-theme/.claude/commands/check-sylius-updates.md .claude/commands/check-sylius-updates.md
```

Then open Claude Code in your project root and run:

```
/check-sylius-updates
```

This will automatically detect which ShopBundle templates changed between your current Sylius version and the latest release, migrate each one, and write a `CHANGELOG.md` to track the history.

> **Note:** After copying, edit the `Memorized version` line in `.claude/commands/check-sylius-updates.md` to match the Sylius version currently installed in your project.

### Available commands

| Command file | Purpose |
|---|---|
| `check-sylius-updates.md` | Detect Sylius template changes between two versions and migrate them |

### Example prompts (no setup required)

You can also interact with Claude Code directly without copying any files. Here are ready-to-use prompts:

**Check for template changes between two Sylius versions:**
```
Compare the ShopBundle templates between Sylius v2.2.3 and v2.2.4.
List which templates in themes/TailwindTheme/templates/bundles/SyliusShopBundle/
need to be updated, and apply the Tailwind CSS equivalent of each upstream change.
```

**Update a single overridden template after a Sylius upgrade:**
```
The file vendor/sylius/sylius/src/Sylius/Bundle/ShopBundle/templates/checkout/complete/content/items.html.twig
changed in the latest Sylius update. Read the current vendor version and the overridden version in
themes/TailwindTheme/templates/bundles/SyliusShopBundle/checkout/complete/content/items.html.twig,
then apply the upstream changes while keeping all Tailwind CSS classes intact.
```

**Audit all overridden templates for outdated content:**
```
For each template in themes/TailwindTheme/templates/bundles/SyliusShopBundle/,
compare it with the matching source in vendor/sylius/sylius/src/Sylius/Bundle/ShopBundle/templates/
and report any structural differences (missing blocks, removed variables, changed includes)
that suggest the theme template may be out of date.
```
