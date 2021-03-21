#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")/../"

if (( $# != 1 )); then
  echo 'Invalid number of arguments'
  exit 1
fi

sed -i '/- name: Install myself to test myself/{n;n;d;}' .github/workflows/php.yml
sed -i '/- name: Install myself to test myself/{n;d;}' .github/workflows/php.yml
sed -i '/- name: Install myself to test myself/d' .github/workflows/php.yml

(
  ./install_scripts/replace-variables.sh "$1"
)

git submodule init
git submodule update

cp .envrc.dist .envrc.local
direnv allow .

laradockctl my:up
laradockctl workspace:composer update --lock

rm -rf install_scripts
