#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")/../"

if (( $# != 1 )); then
  echo 'Invalid number of arguments'
  exit 1
fi

VENDOR_NAME="${1%%/*}"
VENDOR_NAME_LOWER="${VENDOR_NAME,,}"
VENDOR_NAME_PASCAL="$(echo "${VENDOR_NAME}" | sed -r 's/(^|[_-]+)(.)/\U\2\E/g')"
PACKAGE_NAME="${1##*/}"
PACKAGE_NAME_LOWER="${PACKAGE_NAME,,}"
PACKAGE_NAME_PASCAL="$(echo "${PACKAGE_NAME}" | sed -r 's/(^|[_-]+)(.)/\U\2\E/g')"
DIRECTORY_NAME="$(basename "$(git rev-parse --show-toplevel)")"

# `git grep -Il ''` means https://stackoverflow.com/questions/18973057/how-to-list-all-text-non-binary-files-in-a-git-repository/24350112#24350112
git grep -Il '' | grep -v install.sh | xargs sed -i "s/{{ NGMY_COMPOSER_PACKAGE_NAME }}/${VENDOR_NAME_LOWER}\/${PACKAGE_NAME_LOWER}/g"
git grep -Il '' | grep -v install.sh | xargs sed -i "s/{{ NGMY_COMPOSER_AUTOLOAD_NAMESPACE_PREFIX }}/${VENDOR_NAME_PASCAL}\\\\\\\\${PACKAGE_NAME_PASCAL}\\\\\\\\/g"
git grep -Il '' | grep -v install.sh | xargs sed -i "s/{{ NGMY_LARADOCK_CONTAINER_PREFIX }}/laradock-${DIRECTORY_NAME}/g"
git grep -Il '' | grep -v install.sh | xargs sed -i "s/{{ NGMY_PHP_NAMESPACE_PREFIX }}/${VENDOR_NAME_PASCAL}\\\\${PACKAGE_NAME_PASCAL}/g"
