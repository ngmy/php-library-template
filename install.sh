#!/bin/bash

if (( $# != 1 )); then
  echo 'Invalid number of arguments'
  exit 1
fi

LIBRARY_NAME="$1"
LIBRARY_NAME_LOWER="${LIBRARY_NAME,,}"
LIBRARY_NAME_PASCAL="$(echo "${LIBRARY_NAME}" | sed -r 's/(^|[_-]+)(.)/\U\2\E/g')"
DIRECTORY_NAME="$(basename "$(git rev-parse --show-toplevel)")"

sed -i "s/ngmy\/library/ngmy\/${LIBRARY_NAME_LOWER}/g" composer.json
sed -i "s/Ngmy\\\\\\\\Library/Ngmy\\\\\\\\${LIBRARY_NAME_PASCAL}/g" composer.json
sed -i "s/COMPOSE_PROJECT_NAME=laradock-library/COMPOSE_PROJECT_NAME=laradock-${DIRECTORY_NAME}/g" .laradock/env-development
sed -i "s/laradock-library_workspace_1/laradock-${DIRECTORY_NAME}_workspace_1/g" .vim/coc-settings.json
find src -type f -name '*.php' | xargs sed -i "s/Ngmy\\\\Library/Ngmy\\\\${LIBRARY_NAME_PASCAL}/g"
find tests -type f -name '*.php' | xargs sed -i "s/Ngmy\\\\Library/Ngmy\\\\${LIBRARY_NAME_PASCAL}/g"

git submodule init
git submodule update

cp .envrc.dist .envrc.local
direnv allow .
