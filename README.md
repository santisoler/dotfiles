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
- `xfce`: a few configurations for the XFCE desktop environment. The look and
    feel of XFCE is changed through the `post_install` script.
- `zathura`: configurations for the zathura document reader.
- `zsh`: configurations for the zsh shell.

Besides, there are a few more files in this repo:

- `post_install`: post install script for running some small tasks
    automatically.
- `manjaro.yml`, `yay.yml` and `flatpak.yml`: YAML files that contain list of
  packages grouped in categories. These files are used as inputs for
  `select_packages`.
- `duckduckgo.json`: Custom theme for [](duckduckgo.com)


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

Run the `post_install` script and answer Yes to the first question:

```
./post_install
```

Alternatively, you can use `cp` to manually copy the dotfiles for certain
category.

For example, to copy only the Neovim dotfiles:

```
cp -r nvim/. ~
```
