#! /usr/bin/env bash
THIS_DIR="$(dirname "${BASH_SOURCE[0]}")"
ROOT_DIR="$(cd "$THIS_DIR/.." && pwd)"

export CURRENT_PID="$$"
die() {
  echo "ERROR >> $1" >/dev/stderr
  exit 1
  kill -9 "$CURRENT_PID"
}

ok() {
  echo -n ""
}

install_node() {
  local version="$1"
  . $HOME/.bash_profile >/dev/null 2>&1 && command -v nvm || die "NVM couldnot be found"
  [[ -f "$ROOT_DIR/.nvmrc" ]] || echo "$version" > "$ROOT_DIR/.nvmrc"
  nvm install
  ok
}

init_project() {
  command -v npm || die "NPM couldnot be found"
  command -v npx || die "NPX couldnot be found"
  [[ -f "$ROOT_DIR/package.json" ]] || npm init -y
  ok
}

install_webpack() {
  npm install --save-dev webpack
  npm install --save-dev webpack-cli
  ok
}

create_dir_structure() {
  mkdir -p "$ROOT_DIR/src"
  mkdir -p "$ROOT_DIR/dist"
  touch "$ROOT_DIR/src/index.js"
  touch "$ROOT_DIR/dist/index.html"
  ok
}

fix_package_json() {
  sed -i -e 's#"main": "index.js"#"private": true#g;' "$ROOT_DIR/package.json"
  ok
}

install_common_external_dependencies() {
  npm install --save lodash
  npm install --save jquery
  ok
}

main() {
  local node_version="$1"
  echo ">>>>Setting up a javascript project<<<<"
  install_node "$node_version"
  init_project
  install_webpack
  create_dir_structure
  fix_package_json
  install_common_external_dependencies
}


[[ "${BASH_SOURCE[0]}" = "$0" ]] && main "$@"
