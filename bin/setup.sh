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

main() {
  local node_version="$1"
  echo ">>>>Setting up a javascript project<<<<"
  install_node "$node_version"
  init_project
  install_webpack
}


[[ "${BASH_SOURCE[0]}" = "$0" ]] && main "$@"
