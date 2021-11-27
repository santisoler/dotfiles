# Bash functions


# ---------------
# Mamba functions
# ---------------
mambaon() {
    mamba activate
}

mambaoff() {
    mamba activate base; mamba deactivate
}

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


# ---------------
# Other functions
# ---------------
# ex - archive extractor
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

# colors
colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}
