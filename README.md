# dotfiles
---

This repository contains most of my dotfiles which I make use of on a regular basis.

Some commands/modules listed in some dotfiles might require third-party installations.

I use these dotfiles exclusively on macOS.

## Caps Lock window switching

Hammerspoon listens for F19 to switch to the previously focused window. At
login, the Caps Lock helper automatically chooses the remapper:

- If Karabiner has a Caps Lock to F19 rule, Karabiner remains in charge.
- Otherwise, macOS `hidutil` maps Caps Lock to F19 without Karabiner.

To force one behavior on a particular Mac, put `native` or `karabiner` in
`~/.config/dotfiles/capslock-remapper`, then log out and back in.
