#! /bin/sh
#
# create-new-release.sh
# Copyright (C) 2022 rmelo <rmelo@r-melo-lnx>
#
# Distributed under terms of the MIT license.
#

set -o errexit    # stop the script each time a command fails
set -o nounset    # stop if you attempt to use an undef variable

function bash_traceback() {
    local lasterr="$?"
    set +o xtrace
    local code="-1"
    local bash_command=${BASH_COMMAND}
    echo "Error in ${BASH_SOURCE[1]}:${BASH_LINENO[0]} ('$bash_command' exited with status $lasterr)"
    if [ ${#FUNCNAME[@]} -gt 2 ]; then
        # Print out the stack trace described by $function_stack
        echo "Traceback of ${BASH_SOURCE[1]} (most recent call last):"
        for ((i=0; i < ${#FUNCNAME[@]} - 1; i++)); do
            local funcname="${FUNCNAME[$i]}"
            [ "$i" -eq "0" ] && funcname=$bash_command
            echo -e "  $i: ${BASH_SOURCE[$i+1]}:${BASH_LINENO[$i]}\t$funcname"
        done
    fi
    echo "Exiting with status ${code}"
    exit "${code}"
}

# provide an error handler whenever a command exits nonzero
trap 'bash_traceback' ERR

# propagate ERR trap handler functions, expansions and subshells
set -o errtrace

# Getting script to install helm.
SCRIPT_PATH=$(dirname $(realpath -s $0))
curl -fsSL -o "${SCRIPT_PATH}/install_helm.sh" https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod +x "${SCRIPT_PATH}/install_helm.sh"

# Getting new helm version
awk 'BEGIN {open_bracket = 0} /checkDesiredVersion\(\) *{/ { l = $0; gsub(/[^{]/, "", l); open_bracket = open_bracket + length(l); print; while (getline) if (open_bracket > 0 ) { l = $0; gsub(/[^{]/, "",l); open_bracket = open_bracket + length(l); i=$0; gsub(/[^}]/, "",i); open_bracket = open_bracket - length(i); print; }}' scripts/install_helm.sh > /tmp/f1.sh
HAS_CURL=true
set +o nounset    # stop if you attempt to use an undef variable
source /tmp/f1.sh
checkDesiredVersion 2> /dev/null
set -o nounset    # stop if you attempt to use an undef variable
git tag | grep -q "$TAG" || echo "New version available, You should create a new tag $TAG."
