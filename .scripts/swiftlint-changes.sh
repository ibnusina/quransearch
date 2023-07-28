#!/bin/bash

function convertToGitHubActionsLoggingCommands() {
    sed -E 's/^(.*):([0-9]+):([0-9]+): (error|[^:]+): (.*)/::\4 file=\1,line=\2,col=\3::\5/'
}

changedFiles=$(git --no-pager diff --name-only --relative $1 $(git merge-base $1 $2) -- '*.swift' | grep -Ev 'Test|test|Pods')

if [ -z "$changedFiles" ]
then
    echo "No Swift file changed"
    exit
fi

errors=""
while read file; do
    if [[ -f $file ]]; then
        error="$(swiftlint $file | grep error | convertToGitHubActionsLoggingCommands)"
        errors+="$error"
    fi
done <<<$(echo "$changedFiles")

if [[ ! -z $errors ]]; then
    set -o pipefail && echo "$errors"
    exit 1
fi


# errors=$(swiftlint "$@" -- $changedFiles | grep error | convertToGitHubActionsLoggingCommands)
# if [[ ! -z $errors ]]; then
#     set -o pipefail && echo "$errors"
#     exit 1
# fi