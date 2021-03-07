#!/bin/bash

LIBRARY_NAME="$1"
LIBRARY_NAME_LOWER="${LIBRARY_NAME,,}"
LIBRARY_NAME_PASCAL="$(echo "${LIBRARY_NAME}" | sed -r 's/(^|[_-]+)(.)/\U\2\E/g')"

sed -i "s/ngmy\/library/ngmy\/${LIBRARY_NAME_LOWER}/g" composer.json
sed -i "s/Ngmy\\\\\\\\Library/Ngmy\\\\\\\\${LIBRARY_NAME_PASCAL}/g" composer.json
sed -i "s/Ngmy\\\\Library/Ngmy\\\\${LIBRARY_NAME_PASCAL}/g" tests/TestCase.php
sed -i "s/COMPOSE_PROJECT_NAME=laradock-library/COMPOSE_PROJECT_NAME=laradock-${LIBRARY_NAME_LOWER}/g" .laradock/env-development

git submodule init
git submodule update