gitx() {
  local msg="${1:-Add latest changes}"
  git add --all && git commit -m "$msg" && git push
}
