# Mac setup notes

The useful parts of my Mac setup, in one place. This is a guide for rebuilding
my workflow, not a list of everything installed on the old machine.

## First steps

1. Install Xcode Command Line Tools, Homebrew, and Git.
2. Clone this repo. Review `Brewfile`, then run `brew bundle --file=Brewfile`
   to install the core command-line tools and font.
3. Read `install.sh`, run it, restart the shell, and check what works.
4. Add apps and accounts as needed. Revisit the manual settings at the end.

## Apps worth setting up

| App | Why it matters | Config here? |
| --- | --- | --- |
| Ghostty | Main terminal | Yes, `ghostty/config` |
| Hammerspoon | App shortcuts and window switching | Yes, `.hammerspoon/init.lua` plus the Caps Lock helper |
| VS Code | Editor | Settings and keybindings are in `.vscode/`, but `install.sh` does not link them |
| Chrome | Browser used by Hammerspoon shortcuts | No, use browser sync for personal preferences |
| Codex | AI coding workflow, also in Hammerspoon shortcuts | No |

Other apps I may want again: Raycast, Rectangle, Docker, Bruno, Notion, and
Figma. Decide which are useful on the new Mac before installing them. The
Hammerspoon config also references some apps that may no longer be installed;
update those bindings instead of installing an app just to satisfy a shortcut.

## Terminal and development tools

- **Shell basics:** `starship`, `zoxide`, `fzf`, `fd`, `bat`, `eza`, `ripgrep`,
  `jq`, and `yazi`. These support the prompt, aliases, search, previews, and
  navigation in `.zshrc`, `.alias.zsh`, and `.functions.zsh`.
- **Git workflow:** `gh`, `git-delta`, and `lazygit`. Check `.gitconfig` and
  authenticate Git hosts separately on the new Mac.
- **Editor and builds:** `neovim`, `uv`, Node via `nvm`, and Java 21/Maven if
  needed. `.zshrc` also has paths for Bun, Cargo, Go, and GHCup. Install only
  the runtimes used by current projects, then remove stale PATH entries.
- **Zsh plugins:** `install.sh` clones `zsh-autosuggestions` and
  `zsh-syntax-highlighting`. A Nerd Font is useful for terminal icons.

`Brewfile` installs the core tools above. Install optional runtimes and apps
only when needed.

## Config covered by this repo

`install.sh` links the shell files, `.gitconfig`, Ghostty and Starship configs,
Hammerspoon config, and the Caps Lock LaunchAgent/helper. iTerm color themes
are saved under `iterm2/` but are not imported by the script.

The `.vscode/` files are saved here but must be copied or linked to the chosen
editor manually. Editor extensions, app settings, browser extensions, and
macOS preferences are not restored by `install.sh`.

## Manual checks after setup

- [ ] Choose the editor, browser, and optional apps I actually want.
- [ ] Restore editor extensions, font, and theme. Check the saved `.vscode/`
      settings and confirm the `code` command is available for `.zshrc`'s
      `EDITOR` setting.
- [ ] Check Ghostty, Starship, shell aliases, and fuzzy-search shortcuts.
- [ ] Grant Hammerspoon permissions; test F1-F6 app shortcuts and Caps Lock
      switching. The repo's helper uses Karabiner's F19 mapping if present,
      otherwise macOS `hidutil`.
- [ ] Recreate personal SSH keys and sign in to Git and other services.
- [ ] Review keyboard, trackpad, display, Raycast, and Rectangle preferences
      that were set through app interfaces.

## Note for an AI agent

Use this file with `README.md`, `install.sh`, and the actual config files.
Inspect the new Mac first, ask which optional apps and runtimes I still want,
then install and verify the essentials. Treat saved paths and app shortcuts as
things to check, not requirements to preserve.
