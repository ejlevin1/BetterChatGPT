#!/bin/sh
set -e

echo "Running $0 as [$(whoami)] within [$(pwd)]"

get_env_vars_with_prefix() {
	local env_prefix="${1-}"
	[[ -z "${env_prefix}" ]] && die "Must specify prefix in order to list."

	local result=""
	IFS=$'\n'; set -f
	for env_line in $(printenv | sort | grep "${env_prefix}" || echo) 
	do 
		local env_var=$(echo "${env_line}" | awk -F= '{ print $1 }')
		echo "Found [${env_var}]" >&2
		result="${result} ${env_var}"
	done
	set +f; unset IFS
	echo "${result}"
}

for env_var in $(get_env_vars_with_prefix "VITE_") 
do
    env_val=$(printenv $env_var)
	echo "Adding [${env_var} = $(printenv $env_var)]" >&2
    echo "${env_var}=\"${env_val}\"" >> .env
done

echo "Generated .env file:"  >&2
echo "----- START -----"  >&2
cat /home/appuser/app/.env  >&2
echo "------ END ------"  >&2