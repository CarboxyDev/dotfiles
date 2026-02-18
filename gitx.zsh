gitx() {
  if [[ "$1" == "-m" ]]; then
    local msg="${2:-Add latest changes}"
  else
    local msg="${1:-Add latest changes}"
  fi
  git add --all && git commit -m "$msg"
}
