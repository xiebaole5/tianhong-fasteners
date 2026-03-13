#!/bin/sh
# verify_erp_version.sh
# Scans the repository for ERP version references and prints a summary.
# POSIX sh compatible.
#
# Usage: sh scripts/verify_erp_version.sh [repo_root]
#   repo_root  Optional path to the repository root. Defaults to the directory
#              containing this script's parent (i.e., the repo root).

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="${1:-$(cd "$SCRIPT_DIR/.." && pwd)}"

echo "=============================================="
echo " ERP Version Reference Scanner"
echo " Repository: $REPO_ROOT"
echo "=============================================="
echo ""

FOUND=0

# Search patterns for ERP version strings
PATTERNS="erp_version erp-version erpVersion ERP_VERSION erp.*version version.*erp"

echo "--- Files containing ERP version references ---"
for pat in $PATTERNS; do
    results=$(grep -ril "$pat" "$REPO_ROOT" \
        --exclude-dir=".git" \
        --exclude-dir=".agent" \
        --exclude-dir="node_modules" \
        2>/dev/null)
    if [ -n "$results" ]; then
        echo ""
        echo "Pattern: '$pat'"
        for f in $results; do
            echo "  $f"
            grep -in "$pat" "$f" | while IFS= read -r line; do
                echo "    $line"
            done
            FOUND=$((FOUND + 1))
        done
    fi
done

echo ""
echo "--- Files containing 'ERP' or 'erp' (text files only) ---"
erp_files=$(grep -ril "erp" "$REPO_ROOT" \
    --include="*.yml" \
    --include="*.yaml" \
    --include="*.json" \
    --include="*.php" \
    --include="*.md" \
    --include="*.toml" \
    --include="*.txt" \
    --include="*.sh" \
    --include="*.env" \
    --exclude-dir=".git" \
    --exclude-dir=".agent" \
    --exclude-dir="node_modules" \
    2>/dev/null)

if [ -n "$erp_files" ]; then
    for f in $erp_files; do
        echo "  $f"
        FOUND=$((FOUND + 1))
    done
else
    echo "  (none found)"
fi

echo ""
echo "--- package.json version (website/project) ---"
pkg="$REPO_ROOT/package.json"
if [ -f "$pkg" ]; then
    ver=$(grep '"version"' "$pkg" | head -1)
    echo "  $ver"
fi

echo ""
echo "--- Summary ---"
echo "  Total files with ERP references: $FOUND"
echo ""
echo "  Expected ERP baseline version : v1.0.0"
echo "  See docs/ERP_VERSION_CHANGE.md for migration notes."
echo "=============================================="
