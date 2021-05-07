#!/bin/bash

set -Ceuo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../"

if (( $# != 1 )); then
  echo 'Invalid number of arguments'
  exit 1
fi

readonly vendor_name="${1%%/*}"
readonly vendor_name_lower="${vendor_name,,}"
readonly vendor_name_pascal="$(echo "${vendor_name}" | sed -r 's/(^|[_-]+)(.)/\U\2\E/g')"
readonly package_name="${1##*/}"
readonly package_name_lower="${package_name,,}"
readonly package_name_pascal="$(echo "${package_name}" | sed -r 's/(^|[_-]+)(.)/\U\2\E/g')"

# `git grep -Il ''` means https://stackoverflow.com/questions/18973057/how-to-list-all-text-non-binary-files-in-a-git-repository/24350112#24350112
git grep -Il '' | grep -v install.sh | xargs sed -i "s/{{ NGMY_COMPOSER_PACKAGE_NAME }}/${vendor_name_lower}\/${package_name_lower}/g"
git grep -Il '' | grep -v install.sh | xargs sed -i "s/{{ NGMY_COMPOSER_AUTOLOAD_NAMESPACE_PREFIX }}/${vendor_name_pascal}\\\\\\\\${package_name_pascal}\\\\\\\\/g"
git grep -Il '' | grep -v install.sh | xargs sed -i "s/{{ NGMY_LARADOCK_CONTAINER_PREFIX }}/laradock-${vendor_name_lower}-${package_name_lower}/g"
git grep -Il '' | grep -v install.sh | xargs sed -i "s/{{ NGMY_PHP_NAMESPACE_PREFIX }}/${vendor_name_pascal}\\\\${package_name_pascal}/g"
