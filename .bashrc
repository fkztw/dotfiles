# If not running interactively, don't do anything
[ -z "$PS1" ] && return

HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=5000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi


shopt -s autocd
shopt -s cdspell

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


# we love UTF-8 environment!
#export LANG=zh_TW.UTF-8
#export LC_CTYPE=zh_TW.UTF-8
#export LC_ALL=zh_TW.UTF-8

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=vim


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


# completion for ssh hosts
complete -W "$(echo $(grep '^ssh ' $HOME/.bash_history | sort -u | sed 's/^ssh //'))" ssh

# completion ignore the prefix 'sudo'
complete -cf sudo
complete -cf man

# search history using up/down keys
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'
bind '"\C-p":history-search-backward'
bind '"\C-n":history-search-forward'


# color definition
COLOR_END='\[\e[m\]'
COLOR_BLACK='\[\e[0;30m\]'
COLOR_RED='\[\e[0;31m\]'
COLOR_GREEN='\[\e[0;32m\]'
COLOR_YELLOW='\[\e[0;33m\]'
COLOR_BLUE='\[\e[0;34m\]'
COLOR_PURPLE='\[\e[0;35m\]'
COLOR_CYAN='\[\e[0;36m\]'
COLOR_WHITE='\[\e[0;37m\]'
COLOR_L_BLACK='\[\e[1;30m\]'
COLOR_L_RED='\[\e[1;31m\]'
COLOR_L_GREEN='\[\e[1;32m\]'
COLOR_L_YELLOW='\[\e[1;33m\]'
COLOR_L_BLUE='\[\e[1;34m\]'
COLOR_L_PURPLE='\[\e[1;35m\]'
COLOR_L_CYAN='\[\e[1;36m\]'
COLOR_L_WHITE='\[\e[1;37m\]'



# my bash prompt
PS1='┌─'$COLOR_L_RED'[ \d-\t ]'$COLOR_END              # date
PS1+=$COLOR_L_YELLOW' \u '$COLOR_END                   # user
PS1+=$COLOR_L_BLACK'@'$COLOR_END                       # @
PS1+=$COLOR_L_GREEN' \h '$COLOR_END                    # host
PS1+=$COLOR_L_PURPLE'$(git_branch)'$COLOR_END          # git branch
PS1+='\n'                                              # new line
PS1+='└─'$COLOR_L_CYAN'[\w]'$COLOR_END                 # work directory
PS1+='-'$COLOR_L_WHITE'[$(distro_name)] \$ '$COLOR_END # distrobution name
PS1+='$(update_info)'                                  # update some info.

# let me google that for you
google () {
    local tmp=`echo -n $@`
    w3m "www.google.com/search?hl=en&q=$tmp";
}


# an fake autojump
# https://github.com/joelthelion/autojump
j () {
    cat $HOME/.pwd | sort | uniq | grep -i $@
}


# display current git branch on the prompt
git_branch () {
    if [ -d ".git" ] ; then
        git branch | grep \* | awk '{print "~> on " $2}'
    fi
}


# show distrobution name
distro_name () {
    cat /etc/*release | grep ^NAME= | cut -c6- | sed 's/\"//g'
}


# append pwd to ~/.pwd
adddir () {
    last=`tail -n 1 $HOME/.pwd`
    if [ ! -e $HOME/.pwd ] ; then
        touch $HOME/.pwd
        echo `pwd` >> $HOME/.pwd
    fi

    if [ $last != `pwd` ] ; then
        echo `pwd` >> $HOME/.pwd
    fi
    ret=""
}


# where I've been there
cded () {
    tail $HOME/.pwd
}


# update infomations
update_info () {
    adddir
}

#==============================================================================
#My aliaes

# some more ls aliases
alias ll='ls -AlF'
alias la='ls -A'
alias l='ls -CF'

alias rscp='rsync -avPe ssh'
alias telnet="/usr/bin/luit -encoding big5 /usr/bin/telnet"

#some lazy aliases
alias ta='tmux attach'
alias sr='screen -rd'
alias g='grep'
alias v='vim'
alias vd='vimdiff'
alias s='ssh'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# git aliases
alias gs='git status '
alias ga='git add '
alias gc='git commit'
alias gd='git diff'
alias go='git checkout '
alias gl='git log '
alias gp='git push '
alias gP='git pull '

# google in shell
function google () {
    tmp=`echo -n $@`
    w3m "www.google.com/search?hl=en&q=$tmp";
}

#export -f google

#yahoo dictionary in shell
function dict(){
    tmp=`echo -n $@`
    w3m "tw.dictionary.yahoo.com/dictionary?p=$tmp";
}

#plurk in shell
alias plurk='w3m http://www.plurk.com/m';

#nmap
#alias nmap='sudo nmap'
alias nmapo='sudo nmap -sS -P0 -sV -O -A'
alias nmapp='sudo nmap -sS -P0 -p1-65535 -sV -O'
alias nmapa='sudo nmap -A -T4'
