# My configuration files

## What's in here?

This repo contains my personal configuration files so I can easily and quickly
set up any fresh-installed system with my favourite tools and appearance.

My files are divided in folders:

- `dotfiles/`: dotfiles for any DE or WM
- `i3/`: dotfiles for i3-gaps WM
- `others/`: other configuration files (unused or that need some update)

I also keep a list of the packages I normally use in YAML files:

- `packages.yml`:
- `yay_packages.yml`:

These files can be used along [Settle](https://github.com/santisoler/settle)
for a quick and interactive way of installing them.
For example:

```
settle packages.yml
```

and

```
settle -p yay yay_packages.yml
```

## How to copy them

Clone the repo:

```
git clone https://www.github.com/santisoler/dotfiles
```

Enter into the cloned directory:

```
cd dotfiles
```

Copy every file from the `dotfiles` folder to your `$HOME` using the `copy` script:

```
bash copy
```

Alternatively, you can use `cp` to do it manually.
You can add some extra arguments for backing up the original files and more.
For example:

```
cp -r --backup=numbered i3/. -t ~
```


