# My configuration files

## What's in here?

This repo contains my personal configuration files so I can easily and quickly
set up any fresh-installed system with my favourite tools and appearance.

The configuration files are divided in folders, one per application or software.
This way is easy to copy only some configurations without the need to manually
scrape through the full collection of dotfiles.

For example:

- `bin`: contains a `bin` folder that hosts some of my personal scripts.
- `conda`: contains a `.condarc` file and an `environment.yml` for creating
    a `default` conda environment.
- `git`: contains global `.gitconfig` and `.gitignore` files.
- `mpv`: configurations for the mpv video player.
- `nvim`: contains configuration files for Neovim (and for VIM).
- `terminator`: configuration for Terminator (terminal emulator with tiling
    capabilities).
- `zathura`: configurations for the zathura document reader.
- `zsh`: configurations for the zsh shell.


## How to copy the files

Clone the repo:

```
git clone https://www.github.com/santisoler/dotfiles
```

or

```
git clone git@github.com:santisoler/dotfiles
```

Enter into the cloned directory:

```
cd dotfiles
```

Use `cp` to manually copy the dotfiles for certain
category.

For example, to copy only the Neovim dotfiles:

```
cp -r nvim/. ~
```
