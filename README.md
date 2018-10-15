# My confguration files

## How yo install

Clone the repo:

    git clone https://www.github.com/santis19/dotfiles

Enter into the cloned directory:

    cd dotfiles

And run the `copy.sh` script.
Maybe you will need to give it permissions:

    chmod 744 copy.sh
    ./copy.sh

The script will copy every file inside `dotfiles` into your home folder.
The script allows arguments that will be passed to `cp` command.
For example:

    ./copy.sh -f     # force the copy of every file
    ./copy.sh -b     # backup original files

