#!/usr/bin/env sh
echo "Running $0 as [$(whoami)] within [$(pwd)]"

set -eou pipefail

process_init_files() {
	echo "** Running shell scripts (*.sh) within $(dirname $1)/ **"
	local f
	for f; do
		case "$f" in
			*.sh)
				[[ ! -x "$f" ]] && echo "Changing exec flag on [$f]" && chmod +x $f

				if [ -x "$f" ]; then
					echo "$0: running $f"
					"$f"
					echo
				else
					echo "$0: sourcing $f"
					. "$f"
				fi
				;;
			*)
                echo "$0: ignoring $f" ;;
		esac
	done
	echo "** Completed $(dirname $1)/ entrypoint startup scripts **"
	echo 
}

process_init_files /container-init.d/*

echo "$0 - Running [$@]"
exec "$@"