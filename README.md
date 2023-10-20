# Installation

```
$ git clone --recursive https://github.com/mattin4d/dotfiles.git .dotfiles && cd .dotfiles && ./install
```

## Install Script Usage
- `--help` Shows usage
- `--update-submodules` Update submodules to latest versions
- `--uninstall` Removes managed config files
- `-X` Installs X related config files (.Xresources and such)

## Bashrc hooks
Bashrc hooks can be used to set variables or add additional local configurations.

### Before
File `~/.bashrc_local_before` is sourced before files in `bashrc.d`

Variables Available:
- `DOTFILES_ENABLE_GIT_PROMPT` Enables a git prompt (see bashrc.d/50-git-prompt)
- `DOTFILES_ENABLE_TMUX_LS` Enables listing tmux sessions (see bashrc.d/95-tmux)
- `DOTFILES_ENABLE_SCREEN_LS` Enables listing screen sessions (see bashrc.d/95-screen)

### After
File `~/.bashrc_local_after` is sourced after files in bashrc.d

This is where you would want to put most customizations, especially if overriding defaults in this repo.

## Bash profile hooks
Bash profile hooks can be used to set variables or add additional local configurations.

### Before
File `~/.bash_profile_local_before` is sourced before files in `bash_profile.d`

Variables Available:
- `DOTFILES_ENABLE_NEOFETCH` Enables neofetch if installed (see `bash_profile.d/50-neofetch`)
- `DOTFILES_ENABLE_MOTD` Enables a motd w/ kernel info & uptime (see `bash_profile.d/51-motd`)
- `DOTFILES_ENABLE_SSH_AGENT` Enables ssh-agent (see `bash_profile.d/90-ssh-agent`)

### After
File `~/.bash_profile_local_after` is sourced after files in `bash_profile.d`, and before sourcing `~/.bashrc`

This is where you would want to put most customizations, especially if overriding defaults in this repo.

## TODO / Future improvements
- Fix git prompt PS1 bug on Alpine Linux
- Handle backup/restore of original config files on install/uninstall
