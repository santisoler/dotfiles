cenv() {
read -r -d '' CENV_HELP <<-'EOF'
Usage: cenv [COMMAND] [FILE]

Detect, activate, delete, and update conda environments.
FILE should be a conda .yml environment file.
If FILE is not given, assumes it is environment.yml.
Automatically finds the environment name from FILE.

Commands:

  None     Activates the environment
  da       Deactivate the environment
  rm       Delete the environment
  up       Update the environment

EOF

    envfile="environment.yml"

    # Parse the command line arguments
    if [[ $# -gt 2 ]]; then
        >&2 echo "Invalid argument(s): $@";
        return 1;
    elif [[ $# == 0 ]]; then
        cmd="activate"
    elif [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "$CENV_HELP";
        return 0;
    elif [[ "$1" == "da" ]]; then
        cmd="deactivate"
    elif [[ "$1" == "rm" ]]; then
        cmd="delete"
        if [[ $# == 2 ]]; then
            envfile="$2"
        fi
    elif [[ "$1" == "up" ]]; then
        cmd="update"
        if [[ $# == 2 ]]; then
            envfile="$2"
        fi
    elif [[ $# == 1 ]]; then
        envfile="$1"
        cmd="activate"
    else
        >&2 echo "Invalid argument(s): $@";
        return 1;
    fi

    # Check if the file exists
    if [[ ! -e "$envfile" ]]; then
        >&2 echo "Environment file not found:" $envfile;
        return 1;
    fi

    # Get the environment name from the yaml file
    envname=$(grep "name: *" $envfile | sed -n -e 's/name: //p')

    # Execute one of these actions: activate, update, delete
    if [[ $cmd == "activate" ]]; then
        mamba activate "$envname";
    elif [[ $cmd == "deactivate" ]]; then
        mamba deactivate;
    elif [[ $cmd == "update" ]]; then
        >&2 echo "Updating environment:" $envname;
        mamba activate "$envname";
        mamba env update -f "$envfile"
    elif [[ $cmd == "delete" ]]; then
        >&2 echo "Removing environment:" $envname;
        mamba deactivate;
        mamba env remove --name "$envname";
    fi
}
