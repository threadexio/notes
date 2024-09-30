#!/usr/bin/env bash
set -eu

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR/.."

date="$(date --rfc-3339=date)"
git reset

"$SCRIPT_DIR/lint.sh"

git add notes/
git commit -s -m "lec($date): update notes"
