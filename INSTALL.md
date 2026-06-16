# Installation Guide

Three installation options for the documentation quality skills family.

## Option 1: Individual Skills (Recommended)

Install skills as top-level commands while keeping them organized in the family repository.

```bash
ln -sf ~/projects/doc-quality-skills/skills/doc-accuracy-audit ~/.claude/skills/doc-accuracy-audit
ln -sf ~/projects/doc-quality-skills/skills/doc-quality-audit ~/.claude/skills/doc-quality-audit
ln -sf ~/projects/doc-quality-skills/skills/doc-quality-revise ~/.claude/skills/doc-quality-revise
ln -sf ~/projects/doc-quality-skills/skills/doc-quality-check ~/.claude/skills/doc-quality-check
```

**Skills become available as:**
- `/doc-accuracy-audit`
- `/doc-quality-audit`
- `/doc-quality-revise`
- `/doc-quality-check`

**Advantages:**
- Backward compatible with existing usage
- Skills appear at top level in skill lists
- Easy to invoke individually

## Option 2: Family Directory

Install the entire family directory as a skill namespace.

```bash
ln -sf ~/projects/doc-quality-skills ~/.claude/skills/doc-quality-skills
```

**Skills become available as:**
- `/doc-quality-skills/doc-accuracy-audit`
- `/doc-quality-skills/doc-quality-audit`
- `/doc-quality-skills/doc-quality-revise`
- `/doc-quality-skills/doc-quality-check`

**Advantages:**
- Single symlink installation
- Clear namespace organization
- Easier to remove (one symlink to delete)

**Disadvantages:**
- Longer invocation paths

## Option 3: Project-Local Installation

Copy skills to a project's `.claude/skills/` directory for project-specific usage.

```bash
# Create project skills directory
mkdir -p .claude/skills

# Copy individual skills
cp -r ~/projects/doc-quality-skills/skills/doc-accuracy-audit .claude/skills/
cp -r ~/projects/doc-quality-skills/skills/doc-quality-audit .claude/skills/
cp -r ~/projects/doc-quality-skills/skills/doc-quality-revise .claude/skills/
cp -r ~/projects/doc-quality-skills/skills/doc-quality-check .claude/skills/
```

**Skills become available as:**
- `/doc-accuracy-audit` (when in this project)
- `/doc-quality-audit` (when in this project)
- `/doc-quality-revise` (when in this project)
- `/doc-quality-check` (when in this project)

**Advantages:**
- Project-scoped availability
- No global installation required
- Can customize skills per project

**Disadvantages:**
- Must copy to each project
- Updates require re-copying
- More disk space (duplicates)

## Verifying Installation

After installation, reload your skill system, then verify:

```bash
ls -la ~/.claude/skills/ | grep doc-
```

Should show your installed skills.

Test by invoking any skill:
```
/doc-quality-audit
```

## Updating

**For symlinked installations (Options 1 & 2):**
1. Pull updates to `~/projects/doc-quality-skills/`
2. Symlinks automatically point to updated versions
3. Reload your skill system

**For copied installations (Option 3):**
1. Pull updates to `~/projects/doc-quality-skills/`
2. Re-copy changed skills to `.claude/skills/`
3. Reload your skill system

## Uninstallation

**Individual skills (Option 1):**
```bash
rm ~/.claude/skills/doc-accuracy-audit
rm ~/.claude/skills/doc-quality-audit
rm ~/.claude/skills/doc-quality-revise
rm ~/.claude/skills/doc-quality-check
```

**Family directory (Option 2):**
```bash
rm ~/.claude/skills/doc-quality-skills
```

**Project-local (Option 3):**
```bash
rm -rf .claude/skills/doc-accuracy-audit
rm -rf .claude/skills/doc-quality-audit
rm -rf .claude/skills/doc-quality-revise
rm -rf .claude/skills/doc-quality-check
```

## Troubleshooting

**Skills don't appear after installation:**
- Reload skills (command varies by tool)
- Check symlink targets: `ls -la ~/.claude/skills/`
- Verify SKILL.md exists in each skill directory

**Invocation doesn't work:**
- Check for typos in skill names
- Verify you've reloaded after installation

**"Skill not found" errors:**
- Ensure symlinks or copies are in `~/.claude/skills/` (not subdirectories)
- Check file permissions: `chmod -R u+r ~/.claude/skills/`
