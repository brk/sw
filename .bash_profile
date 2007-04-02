# Sourced at login.
# Exported variables go here, most other stuff goes in .bashrc


export PATH=~/sw/bin:$PATH
export LD_LIBRARY_PATH=~/sw/lib:$LD_LIBRARY_PATH

export CDPATH=".:..:~:~/links/"
# always append last history line at every prompt
export PROMPT_COMMAND='history -a'
export HISTIGNORE="[\t ]:&:[bf]g:exit"
export EDITOR="vim"
# Make all grep calls use full extended regular expressions 
export GREP_OPTIONS="-E --color=auto"

# user@host  in titlebar, YYYY-MM-DD HH:MM:SS <GREEN>~/path</GREEN> $
titlebar="\e]2;\u@\h:\w\a"
color="\e[32;1m"
reset="\e[0m"
export PS1="\[$titlebar\]\D{%F} \t \[$color\]\w/\[$reset\] \$ "

mkcd () { mkdir $1 && cd $1; }

try_include () {
        if [ -f $1 ]; then
                source $1
        fi
}

try_include .bashrc
