#!/usr/bin/env bash
set -eo pipefail
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR/.."

usage() {
	echo "usage: $0 [mode]"
	echo ""
	echo "By default the script lints the notes/ directory once and exits."
	echo "If \`mode\` is 'watch' then the script watches for changes inside"
	echo "the notes/ directory and relints every file in it."
}

lint() {
	markdownlint-cli2 \
		notes/ \
		'#notes/**/*.swp'
}

watch() {
	while true; do
		echo "waiting for a change..."
		inotifywait -rq \
			-e modify \
			-e close_write \
			-e move \
			-e create \
			-e delete \
			notes/
		clear

		lint || true
	done
}

main() {
	if [ -z "$1" ]; then
		lint	
	elif [ "$1" == "help" ]; then
		usage
	elif [ "$1" == "watch" ]; then
		watch
	else
		echo "unknown mode"
		usage
	fi
}

main "$@"
