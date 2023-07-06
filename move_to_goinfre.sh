#!/bin/bash


### ANSI CODE
ANSI_RESET="\033[0m"
ANSI_BOLD="\033[1m"
ANSI_ITALIC="\033[3m"
ANSI_UNDERLINE="\033[4m"
ANSI_GREEN="\033[32m"
ANSI_RED="\033[31m"
ANSI_YELLOW="\033[33m"


### create the ROOT directory in goinfre
ROOT="$HOME/goinfre/move_to_goinfre"
### mkdir -p $ROOT

is_exists() {
	if [[ -e $1 ]]; then return 0; else return 1; fi
}
is_symlink() {
	if [[ -L $1 ]]; then return 0; else return 1; fi
}
is_directory() {
	if [[ -d $1 ]] && ! is_symlink $1; then return 0; else return 1; fi
}

print_obj() {
	printf "$ANSI_YELLOW$ANSI_BOLD$ANSI_UNDERLINE$1:\n$ANSI_RESET"
}
creating_goinfredir() {
	if ! is_exists $1; then
		printf "$ANSI_BOLD$ANSI_GREEN\tcreating goinfre directory\n$ANSI_RESET"
		mkdir -p $1;
	fi
}
removing_goinfreobj() {
	if is_exists $1; then
		printf "$ANSI_BOLD$ANSI_GREEN\tremoving goinfre object\n$ANSI_RESET"
		rm -rf $1;
	fi
}
removing_goinfreobj_nondir() {
	if is_exists $1 && ! is_directory $1; then
		printf "$ANSI_BOLD$ANSI_GREEN\tremoving goinfre object non directory\n$ANSI_RESET"
		rm -rf $1;
	fi
}
moving_homedir_to_goinfre() {
	printf "$ANSI_BOLD$ANSI_GREEN\tmoving home directory to goinfre\n$ANSI_RESET"
	mkdir -p $(dirname "$2")
	mv $1 $2
}
creating_symlink() {
	if is_symlink $2; then
		printf "$ANSI_BOLD$ANSI_GREEN\tremoving home symbolic link\n$ANSI_RESET"
		rm -rf $2;
	fi
	printf "$ANSI_BOLD$ANSI_GREEN\tcreating home symbolic link\n$ANSI_RESET"
	ln -s $1 $2
}


### the moving function
moving_to_goinfre() {
	GOFR_OBJ="$ROOT/$1"
	HOME_OBJ="$HOME/$1"
	print_obj $1
	if is_directory $HOME_OBJ; then
		removing_goinfreobj $GOFR_OBJ
		moving_homedir_to_goinfre $HOME_OBJ $GOFR_OBJ
	elif ! is_directory $GOFR_OBJ; then
		removing_goinfreobj_nondir $GOFR_OBJ
		creating_goinfredir $GOFR_OBJ
	fi
	creating_symlink $GOFR_OBJ $HOME_OBJ
}

remove_object() {
	GOFR_OBJ="$ROOT/$1"
	HOME_OBJ="$HOME/$1"
}


### The things you want to move to goinfre
OBJECTS=(
	"Library/Caches"
	".brew"
	".cargo"
	".rustup"
	".nvm"
	".npm"
	"Library/Containers/com.docker.docker"
	".docker"
	"Library/Application Support/Code"
	".vscode"
)

IFS=$'\0'

### move what you want here
for ((i=0; i<${#OBJECTS[@]}; i++))
do
    moving_to_goinfre ${OBJECTS[i]}
done
