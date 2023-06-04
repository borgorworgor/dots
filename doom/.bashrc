#
# /etc/skel/.bashrc
#

# If not running interactively, don't do anything
if [[ $- != *i* ]] ; then
	return
fi

# History
HISTCONTROL=ignoredups
HISTSIZE=1000
HISTFILESIZE=1000

export PS1="\[\e[1;32m\]\d \[\e[1;35m\]@ \[\e[1;34m\]\t \[\e[1;35m\]| \[\e[1;32m\]\w \[\e[1;35m\]λ \[\e[0m\]"
export PATH=$"$HOME/.config/emacs/bin:$PATH"
export PATH=$"$HOME/.local/bin:$PATH"
export MOZ_ENABLE_WAYLAND=1
export MOZ_DRM_DEVICE=card0
export LIBVA_DRIVER_NAME=iHD
export VDPAU_DRIVER=va_gl
export EDITOR=nvim

# Prepend "cd"
shopt -s autocd

# History Completion
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Help Ability
run-help() { help "$READLINE_LINE" 2>/dev/null || man "$READLINE_LINE"; }
bind -m vi-insert -x '"\eh": run-help'
bind -m emacs -x     '"\eh": run-help'

# Aliases
alias shutdown='doas shutdown -hP now'
alias restart='doas shutdown -r now'
alias ls='ls --color=auto'
alias encrypt='gpg -er "arlo h"'
alias decrypt='gpg -d'
alias yt='ytfzf -t'
alias monitor-on='xrandr --output HDMI-1 --mode 3440x1440 --left-of eDP-1 && pkill picom'
alias monitor-off='xrandr --output HDMI-1 --off && picom --experimental-backends &'

# Something I kinda forgot
set -o noclobber

# Blesh
[[ $- == *i* ]] && . /usr/share/blesh/ble.sh
[[ ${BLE_VERSION-} ]] && ble-attach

# Tlmgr fix stuff
alias tlmgr='/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode'
