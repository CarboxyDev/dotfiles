ports() {
  echo "Active Listening Ports:"
  echo "PORT\tPID\tPROCESS\tSTATE" | column -t -s $'\t'
  lsof -iTCP -sTCP:LISTEN -n -P | awk 'NR>1 {split($9,a,":"); printf "%s\t%s\t%s\tLISTEN\n", a[2], $2, $1}' | sort -n | column -t -s $'\t'
}

size() {
  local target="${1:-.}"
  local max_depth="${2:-1}"
  du -h -d "$max_depth" "$target" | /usr/bin/sort -rh | awk '{print $2 "\t" $1}' | column -t
}

dev() {
  if [ -f package.json ]; then
    if command -v pnpm >/dev/null && jq -e '.scripts.dev' package.json >/dev/null 2>&1; then pnpm dev
    elif command -v bun >/dev/null && jq -e '.scripts.dev' package.json >/dev/null 2>&1; then bun run dev
    else npm run dev
    fi
  else
    echo "No package.json"
  fi
}

rgg() {
  local pattern="$1"
  local extensions="${2:-ts,tsx,js,jsx,json}"

  if [ -z "$pattern" ]; then
    echo "Usage: rgg <pattern> [extensions]"
    echo "Default extensions: ts,tsx,js,jsx,json"
    return 1
  fi

  echo "Searching for '$pattern' in: $extensions"
  echo ""
  rg -n --type-add "code:*.{$extensions}" -t code "$pattern"
}

killport() {
  if [ -z "$1" ]; then
    echo "Usage: killport <port>"
    return 1
  fi
  lsof -ti:$1 | xargs kill -9
}
