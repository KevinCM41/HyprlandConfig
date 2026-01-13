#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

eval "$(starship init bash)"

export GTK_THEME=catppuccin-mocha-mauve-standard+default
export GTK_ICON_THEME=Papirus-Dark

export XDG_DATA_DIRS=/usr/share:/usr/local/share:/var/lib/flatpak/exports/share
