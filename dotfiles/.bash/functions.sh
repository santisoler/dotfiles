# Bash functions

# ex - archive extractor
# ----------------------
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# conda functions
condaon() {
    export PATH=$CONDA_PREFIX/bin:$PATH
}

condaoff() {
    export PATH=`echo $PATH | sed -n -e 's@'"$CONDA_PREFIX"'/bin:@@p'`
}

coff() {
    # Deactivate the conda environment
    source deactivate
}

cenv() {
    # Activate and delete conda environments using the yml files.
    # Finds the env name from the environment file (given or assumes environment.yml in
    # current directory).
    # Usage:
    #   1. Activate using the environment.yml in the current directory:
    #      $ cenv
    #   2. Activate using the given enviroment file:
    #      $ cenv my_env_file.yml
    #   3. Delete an environment using the given file (deactivates environments first):
    #      $ cenv rm my_env_file.yml

    if [[ $# == 0 ]]; then
        envfile="environment.yml"
        cmd="activate"
    elif [[ $# == 1 ]]; then
        envfile="$1"
        cmd="activate"
    elif [[ $# == 2 ]] && [[ "$1" == "rm" ]]; then
        envfile="$2"
        cmd="delete"
    else
        #errcho "Invalid argument(s): $@";
        echo "Invalid argument(s): $@";
        return 1;
    fi

    # Check if the file exists
    if [[ ! -e "$envfile" ]]; then
        #errcho "Environment file not found:" $envfile;
        echo "Environment file not found:" $envfile;
        return 1;
    fi

    # Get the environment name from a conda yml file
    envname=$(grep "name: *" $envfile | sed -n -e 's/name: //p')

    if [[ $cmd == "activate" ]]; then
        source activate "$envname";
    elif [[ $cmd == "delete" ]]; then
        errcho "Removing environment:" $envname;
        source deactivate;
        conda env remove --name "$envname";
    fi
}

