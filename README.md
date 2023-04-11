# Installation

`$ git clone --recursive https://github.com/mattin4d/dotfiles.git .dotfiles && cd .dotfiles && ./install`

## Install Script Usage
`--help` Shows usage
`--uninstall` Removes managed config files
`-X` Installs X related config files (.Xresources and such)

## Bashrc hooks
Bashrc hooks can be used to set variables or add extra bash configurations that aren't managed in this repo.

### Before
File `~/.bashrc_local_before` is sourced before files in bash.d

Variables
- `ENABLE_MOTD` Enables a motd (see bash.d/90-motd)
- `ENABLE_SSH_AGENT` Enables a `restart-ssh-agent` alias (see bash.d/92-ssh-agent)
- `ENABLE_TMUX_LS` Enables listing tmux sessions (see bash.d/95-tmux)
- `ENABLE_SCREEN_LS` Enables listing screen sessions (see bash.d/95-screen)

### After
File `~/.bashrc_local_after` is sourced after files in bash.d
