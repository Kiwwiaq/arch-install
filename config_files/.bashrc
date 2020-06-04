#
# ~/.bashrc
#

. ~/.bash_aliases
. ~/.bash_functions

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

ssh-agent

