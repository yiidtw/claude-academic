#!/usr/bin/env bash
# Integration test: compile every venue template and verify PDF output.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATES="$PROJECT_DIR/templates"

VENUES=(neurips icml acl aaai cvpr iclr)
PASS=0
FAIL=0
declare -A RESULTS

for venue in "${VENUES[@]}"; do
  TMPDIR=$(mktemp -d "/tmp/test_${venue}_XXXXXX")
  # Copy all venue files (sty, bst, fancyhdr, natbib, etc.)
  cp "$TEMPLATES/$venue"/* "$TMPDIR/"
  # Copy shared references.bib
  cp "$TEMPLATES/references.bib" "$TMPDIR/"

  echo "--- Compiling $venue ---"
  if (cd "$TMPDIR" && latexmk -pdf -interaction=nonstopmode template.tex > compile.log 2>&1); then
    if [ -f "$TMPDIR/template.pdf" ]; then
      echo "  PASS: $venue (PDF generated)"
      RESULTS[$venue]="PASS"
      PASS=$((PASS + 1))
    else
      echo "  FAIL: $venue (no PDF despite exit 0)"
      RESULTS[$venue]="FAIL"
      FAIL=$((FAIL + 1))
    fi
  else
    echo "  FAIL: $venue (compilation error)"
    echo "  Last 20 lines of log:"
    tail -20 "$TMPDIR/compile.log" | sed 's/^/    /'
    RESULTS[$venue]="FAIL"
    FAIL=$((FAIL + 1))
  fi
  rm -rf "$TMPDIR"
done

echo ""
echo "========== Summary =========="
printf "%-10s %s\n" "Venue" "Result"
printf "%-10s %s\n" "-----" "------"
for venue in "${VENUES[@]}"; do
  printf "%-10s %s\n" "$venue" "${RESULTS[$venue]}"
done
echo ""
echo "Passed: $PASS / ${#VENUES[@]}"

if [ "$FAIL" -gt 0 ]; then
  echo "FAILED: $FAIL venue(s) did not compile."
  exit 1
fi
echo "All venues compiled successfully."
exit 0
