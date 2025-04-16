# Fish implementation of the yavanna bash function
# written by leouieda, released under MIT licence.
# Repo: https://github.com/leouieda/dotfiles

function yv
    # Parse arguments (allow one argument as max)
    argparse --name "foo" --max-args 1 -- $argv
    or return

    # Check which action should be performed
    if count $argv > /dev/null
        set cmd "$argv[1]"
    else
        set cmd "activate"
    end

    # Exit if no environment.yml is found
    set envfile "environment.yml"
    if test ! -f $envfile
        echo "No 'environment.yml' was found." 1>&2
        return 1
    end

    # Get the environment name from a conda yml file
    set envname $(grep "name: *" $envfile | sed -n -e 's/name: //p')

    # Execute commands
    switch "$cmd"
        # Activate the environment
        case "activate"
            # Activate env only if it's not currently activated
            if [ $CONDA_DEFAULT_ENV != $envname ]
                conda deactivate
                conda activate "$envname"
            end
        # Create the environment
        case "cr"
            echo "Creating environment:" $envname 1>&2
            conda env create -f "$envfile"
            conda activate "$envname"
        # Update the environment
        case "up"
            echo "Updating environment:" $envname 1>&2
            conda activate "$envname"
            conda env update -f "$envfile"
        # Remove the environment
        case "rm"
            echo "Removing environment:" $envname 1>&2
            if [ $CONDA_DEFAULT_ENV != $envname ]
                conda deactivate
            end
            conda env remove --name "$envname"
        case '*'
            echo "Invalid argument: $cmd" 1>&2
            return 1
    end

    return 0
end


function activate_conda_env --on-variable PWD
    # Activate conda environment after changing directory
    set envfile "environment.yml"
    if test -f $envfile
        yv
    end
end
