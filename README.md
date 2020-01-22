# My confguration files

## How yo install

Clone the repo:

    git clone https://www.github.com/santisoler/dotfiles

Enter into the cloned directory:

    cd dotfiles

And run the `copy.sh` script.
Maybe you will need to give it permissions:

    chmod 744 copy.sh
    ./copy.sh

The script will copy every file inside `dotfiles` into your home folder.
It makes a numbered backup for every existing file that will be overwritten.
The script allows arguments that will be passed to `cp` command.

For example, if you want confirmation for every file that will be overwritten
(recommended if this is your first time copying this dotfiles):

    ./copy.sh -i

If you don't want to make backups of existing files (use carefully!):

    ./copy.sh --backup=none


## Hot how to load Tilix configurations

Tilix uses dconf to manage its configurations. Therefore you need to use it to load them
from the `tilix` file:

```bash
dconf load /com/gexperts/Tilix/ < tilix
```

## How to install packages on conda_packages.txt

Use `xargs` to pass the packages detailed on `conda_packages.txt` as arguments
to conda:

```
xargs conda install -c conda-forge < conda_packages.txt
```
