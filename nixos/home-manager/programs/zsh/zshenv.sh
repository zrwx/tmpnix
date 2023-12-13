# tput cup "${LINES}" # reduce visual delay by doing this first # TODO: this does not work with ranger because it ends up in stdin
path_add() {
  export PATH="${1}:${PATH}"
}
export SSH_HOME="${HOME}/.ssh"
export LOCAL="${HOME}/.local"
export LOCAL_BIN="${LOCAL}/bin"
export LOCAL_TMP="/u/tmp"
export LOCAL_INC="${LOCAL}/include"
# export LOCAL_PATH="$(du "${LOCAL_BIN}" | cut -f2 | tr '\n' ':' | sed 's/:*$//')" # TODO: recursively add home bin to path using home-manager
# export PYTHONPATH="${LOCAL_INC}/python"
# export CARGO_BIN="${HOME}/.local/share/cargo/bin"

# path_add "${LOCAL_PATH}"
# path_add "${HOME}/gems/bin"
# path_add "${CARGO_BIN}"
# path_add "${HOME}/.gem/ruby/3.0.0/bin"
# path_add "${HOME}/.gem/ruby/2.7.0/bin"
# path_add "${GEM_HOME}/bin"
# path_add "${HOME}/.local/bin/finding"
# path_add "${PNPM_HOME}"
# path_add "${HOME}/.bin"

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
# export XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority"
export XINITRC="${XDG_CONFIG_HOME}/x11/xinitrc"
export XRESOURCES="${XDG_CONFIG_HOME}/x11/Xresources"
export WINIT_X11_SCALE_FACTOR=3

# export TERMINAL="kitty"
# export TERMCMD=kitty
export EDITOR="nvim"
export VISUAL="$EDITOR"
export FILE="ranger"
# export BROWSER="firefox"
# export READER="zathura"
# export SHELL="/bin/zsh"
# export PAGER="nvim -R"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export SHENV="$ZDOTDIR/.zshenv"
export SHRC="$SHENV"
export FILERC="$XDG_CONFIG_HOME/ranger/rc.conf"
export TMUXRC="$XDG_CONFIG_HOME/tmux/tmux.conf"
export ERC="$XDG_CONFIG_HOME/nvim/init.lua"
export TRC="$XDG_CONFIG_HOME/tmux/tmux.conf"
export FRC="$XDG_CONFIG_HOME/ranger/rc.conf"
export WINRC="$HOME/.local/src/dwm/config.h"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
# export JAVA_HOME="/usr/lib/jvm/java-19-openjdk"
export ALSA_CONFIG_PATH="$XDG_CONFIG_HOME/alsa/asoundrc"
export ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible/ansible.cfg"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch-config"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"

export CONFIG="${XDG_CONFIG_HOME}"
export TMP_REPL="${LOCAL_TMP}/tmp_repl"
export LAST_TMP_DIR="${LAST_TMP_DIR:-}"
export DATA="/u"
export INBOX="${DATA}/inbox"
export WIKI="${INBOX}/00_wiki"
export WIKI1="$WIKI/wiki1"
export WIKI2="$WIKI/wiki2"
export WIKI3="$WIKI/wiki3"
export WIKI4="$WIKI/wiki3"
export LESSHISTFILE="-"
# export GNUPGHOME="${CONFIG}/gnupg" # TODO: maybe adapt
# export GPG_HOME="${GNUPGHOME}" # TODO: maybe adapt
# export SSH_HOME="${HOME}/.ssh" # TODO: maybe adapt
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export TRASH="$HOME/.trash"

export FZF_DEFAULT_COMMAND="sudo find $HOME -type f"
export FZF_DEFAULT_OPTS="--layout=reverse --height=6"
export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"
export QT_QPA_PLATFORMTHEME="gtk3"
export QT_SCALE_FACTOR=2
export GDK_SCALE=1
export MOZ_USE_XINPUT2=1 # Mozilla smooth scrolling/touchpads.
export KEYTIMEOUT=1
export _JAVA_AWT_WM_NONREPARENTING=1 # android-studio grey window
# export GTK_USE_PORTAL=1
# export XDG_CURRENT_DESKTOP=

export MANPAGER="nvim -c 'Man!'"
export MANWIDTH='69'

export PAGER="nvim -c 'Man!'"

HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="${ZDOTDIR}/.zhistory"

# vi mode
export KEYTIMEOUT=1

setopt append_history
setopt hist_save_by_copy
setopt share_history # includes incappendhistory incappendhistory_time extendedhistory
setopt autocd
setopt histignorespace

# autoload -U colors && colors	# Load colors
PS1=">"
PS1='❯'
PS1='$'
# PS1='💥 '
PS1="%B${PS1}%b"
PS1="%F{5}${PS1}%f"

# if [[ -n "$RANGER_LEVEL" ]]; then PS1="[ranger:$RANGER_LEVEL] $PS1"; fi
# stty stop undef

# if interactive shell, stop ctrl-s and ctrl-q
if [[ "$-" == *i* ]]; then
  stty -ixon
  stty -ixoff
fi

# Remove the default of run-help being aliased to man
unalias run-help &>/dev/null
# Use zsh's run-help, which will display information for zsh builtins.
autoload run-help

# Edit line in vim with ctrl-e:
autoload edit-command-line
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh &>/dev/null

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hidden files.

# widgets
# Change cursor shape for different vi modes.
zle-line-init() {
  zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
  echo -ne "\e[5 q"
}

zle-keymap-select() {
  if [[ "${KEYMAP}" == vicmd || $1 = 'block' ]]; then
    escape_code='\e[1 q'
  elif [[ "${KEYMAP}" == main || "${KEYMAP}" == viins \
    || "${KEYMAP}" == '' || "$1" == 'beam' ]]; then
    escape_code='\e[5 q'
  fi
  echo -ne "$escape_code"
}

# echo -ne '\e[5 q' # Use beam shape cursor on startup.
# preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

clear_bottom() {
  clear
  tput cup "${LINES}"
  print -nP ${PS1}
}

zle -N edit-command-line
zle -N zle-line-init
zle -N zle-keymap-select
zle -N clear_bottom

bindkey '^e' edit-command-line
bindkey -s '^f' 'f\n'
# bindkey -s '^j' 'j\n'
bindkey -s '^h' 'h\n'
bindkey -s '^r' 'run\n'
bindkey -s '^o' 'open\n'
bindkey -M menuselect 'h' vi-backward-char # Use vim keys in tab complete menu:
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char
bindkey '^[[P' delete-char
bindkey  "^[[3~"  delete-char
bindkey '^L' clear_bottom

yt() {
  (cd "${INBOX}" && yt-dlp "$@")
}

yta() {
  yt --extract-audio "$@"
}

alias sdn="sudo shutdown now"
alias srn="sudo reboot now"
alias dt="date +%Y-%m-%d\ %H:%M"
alias dts="date +%Y-%m-%d\ %H:%M:%S"
alias dtu="date +%Y-%m-%d_%H-%M-%S"
alias py='python -iqc "from std import *"'
# alias lock="i3lock -i ~/.local/share/bg.png"
alias z='systemctl suspend'
# alias zz="systemctl suspend && slock"
alias day='redshift -PO 6500 1> /dev/null; light 100'
alias night='redshift -PO 3000 1> /dev/null; light 15'
alias bat="cat /sys/class/power_supply/BAT?/capacity"

# make builtins safer and better
alias rm='echo "this is probably not what you want."; false'
# the rest are too dangerous. We don't want cp to misbehave
# alias mv='mv -ib'
# alias cp='cp -n'
# alias mkdir='mkdir -p'

alias e="$EDITOR"
alias ls='ls -ah1'
alias bt=bluetoothctl
alias t='(tmux a &>/dev/null) || tmux'
alias cal='cal -mw'
alias r='run'
# alias o='open'

o() {
  detach rifle "$@"
}

mcd() {
  mkdir -p "$1"
  cd "$1"
  pwd
}

rcd() {
  local tmpdir='/tmp/tmp_ranger'
  mkdir -p "${tmpdir}"
  local tmpfile="$(mktemp "${tmpdir}/tmp_ranger_XXXXX")"

  ranger --choosedir="${tmpfile}" "$@"

  if [[ -f "${tmpfile}" ]]; then
    cd "$(cat "${tmpfile}")" &>/dev/null
    \rm -f "${tmpfile}" &>/dev/null
  fi
}

scr() {
  case "$1" in
    onh) xrandr --output eDP1 --auto --output DP1 --off --output HDMI1 --off;;
    offh) xrandr --output eDP1 --off --output DP1 --auto --output HDMI1 --auto ;;
    on) xrandr --output eDP1 --auto --output DP1 --off --output HDMI1 --off;;
    off) xrandr --output eDP1 --off --output DP1 --auto --output HDMI1 --auto ;;
    red) redshift -PO 1900;;
    night) redshift -PO 1900 &&  xbacklight -set 10;;
    day) redshift -PO 6500 &&  xbacklight -set 100;;
    blue) redshift -PO 6500;;
    both) xrandr --output eDP1 --auto --output HDMI1 --auto --above eDP1;;
    mirror) xrandr --output eDP1 --auto --output HDMI1 --above eDP1;;
    ond) xrandr --output eDP1 --off --output DP1-1 --auto;;
    offd) xrandr --output eDP1 --auto --output DP1-1 --off;;
  esac
}

h() {
  local datetime_pattern='\d\d\d\d\-\d\d\-\d\d \d\d:\d\d'
  local id_pattern='\s*\d+'
  local pattern="^(${id_pattern})\s+(${datetime_pattern})\s+(.*)$"
  local replacement='[\2]: \3'
  local regex="s/${pattern}/${replacement}/g"
  local cmd="$(
    fc -i -r -l 1 \
      | perl -pe "${regex}" \
      | fzf --height='40%' --nth=2.. --delimiter=': ' --tiebreak=index \
      | perl -pe 's/\[.*\]:\s*(.*)/\1/' \
      | perl -pe 's/\\/\\\\/g'
  )"
  print -z "${cmd}"
}

ff() {
  if [[ -e "${1:-}" && ! -d "${1}" ]]; then
    local file="$(realpath "${1}")"
    local dir="$(dirname "${file}")"
    cd "${dir}"
    rcd --selectfile "${file}"
  else
		cd "${1}"
    rcd
  fi
}

f() {
  local target=''
	case "$1" in
		"r") detach "$(ffx)"; return ;;
		"g") target="$(gfffd)" ;;
		"h") target="$(fffd)" ;;
		"l") target="$(lfffd)" ;;
		*) target="$(lfffd)" ;;
	esac

	if [[ -n "${target}" ]]; then
    ff "${target}"
  fi
}

j() {
  ff "$(fffd)"
}

light() {
  if [[ "$1" -ge 1 ]]; then 
    brightnessctl set "${1}%" &>/dev/null
  fi
}

vol() {
  if [[ -n "$1" ]]; then
    pamixer --set-volume "$1"
  fi
  pamixer --get-volume-human
}

# conversion command
# gs \\n -o output.pdf \\n -sDEVICE=pdfwrite \\n -sPAPERSIZE=a4 \\n -dFIXEDMEDIA \\n -dPDFFitPage \\n -dCompatibilityLevel=1.4 \\n  bewerbungsmappe_oscar_mohr.pdf
# pdfunite * bewerbungsmappe_oscar_mohr.pdf
# gs \\n -o output.pdf \\n -sDEVICE=pdfwrite \\n -sPAPERSIZE=a4 \\n -dFIXEDMEDIA \\n -dPDFFitPage \\n -dCompatibilityLevel=1.4 \\n  bewerbungsmappe_oscar_mohr.pdf

# usage:
#   lnch o <file>  # opens file
#   lnch r <file>  # runs a fuzzy found file, curr $2 gets discarded
#   lnch <file>    # equal to lnch o <file>
#   lnch           # opens the fuzzy finder
lnch_new() {
  # determine if opener or runner
  # let argc=$#
  local file=""
  if [[ $# -ge 2 ]]; then       # two argument form: open or run
    if [[ "$1" -eq "r" ]]; then   # runner: runs fuzzy found file
      print -rC1 -- "${commands}" | fzf | xargs detach
      return
    elif [[ "$1" -eq "o" ]]; then # opener: determines file as second arg
      rifle "$2"
    fi
  # elif (($# == 1)); then     # opener: determine file
  #   echo '$# == 1'
  #   file="$1"
  # else 
  #   echo '$# != 1'
  #   file="$(find $HOME | fzf)"
  fi
}

md_dt() {
  local timestamp="!($(dt))"
  echo -n $timestamp | xclip -sel clip
  echo -n $timestamp
}

# ytp() {
#   local URL=$(youtube-dl --get-id ytsearch:"$1")
#   # mpv --volume=70 --no-video "https://www.youtube.com/watch?v=$URL"
#   mpv "https://www.youtube.com/watch?v=$URL"
# }

logme() {
  local timestamp="!($(dt))"
  local content="$@"
  local out="$timestamp $content"
  echo -n $out | clip
  echo -n $out
}

mdc(){
  pandoc --pdf-engine=latexmk -V pagestyle=empty -V geometry=top=40mm,bottom=20mm "$1" -o "$1".pdf
}

fclip() {
  if [[ "$#" -lt 1 ]]; then
    echo "fclip: too few arguments"
    return 1;
  fi
  local file="$1"
  local mime="$(file -b --mime-type "$file")"
  xclip -selection clipboard -t "$mime" < "$file"
}

screencast() {
  local target="${INBOX:-$HOME}/screencast-$(date '+%y%m%d-%H%M-%S').mp4"
  local s="$(xdpyinfo | awk '/dimensions/ {print $2;}')"
  ffmpeg \
    -y \
    -f x11grab \
    -framerate 60 \
    -s "$s" \
    -i "$DISPLAY" \
    -f alsa -i default \
    -r 30 \
    -c:v h264 -crf 0 -preset ultrafast -c:a aac \
    "$target"
}

alias dtt='date +%Y%m%dT%H%M%S'

sh_stub() {
  cat \
<<'EOF'
#!/usr/bin/env bash
PS4="\e[34m[$(basename "${0}")"':${FUNCNAME[0]:+${FUNCNAME[0]}():}${LINENO:-}]: \e[0m'
IFS=$'\n\t'
set -euo pipefail
set -x

die() {
  if [[ "$#" -gt 0 ]]; then
    printf '\e[31m%s\e[0m\n' "${@}" >&2
  fi
  exit 1
}

main() {
  :
}

main "$@"
EOF
}

rs_stub() {
  cat \
<<'EOF'
#!/usr/bin/env -S cargo -Zunstable-options -Zscript
//! ```cargo
//! cargo-features = ["edition2024"]
//! package.edition = "2024"
//! [dependencies]
//! ```
#![feature(
  array_chunks,
  associated_type_bounds,
  const_mut_refs,
  const_trait_impl,
  impl_trait_in_assoc_type,
  impl_trait_in_fn_trait_return,
  iter_next_chunk,
  let_chains,
  log_syntax,
  slice_as_chunks,
  trace_macros,
  trait_alias,
  type_alias_impl_trait,
  variant_count,
)]

fn main() {

}
EOF
}

py_stub() {
  cat \
<<'EOF'
from std import *

def main():
  pass

if __name__ == '__main__':
  main()
EOF
}

# creates filename for temporary file in `${tmpdir}` with optional extension
make_tmp_repl() {
  local ext="$1"
  # local tmpdir="${TMP_REPL}"
  # if [[ ! -d "${tmpdir}" ]]; then
  #   mkdir -p "${tmpdir}"
  # fi
  local tmpdir='.'
  local tmpfile="$(mktemp --dry-run "${tmpdir}/tmp_repl_XXXXX")"

  # in case the user provides an extension, go no further
  if [[ "${ext}" != "" ]]; then
    tmpfile+=".${ext}"
  else
    local EXTS=$'py\nmd\ncc\nrs\njs\nc\ncpp\ncpp2\nkt\nscm\nrkt\nmjs\nts\ngo\nlua\nhy\nfnl\nsscm\nswift\nhs'
    local fzf_response="$(echo "${EXTS}" | fzf --info=hidden --print-query)"
    local fzf_input="$(echo "${fzf_response}" | head -n 1)"
    local fzf_match="$(echo "${fzf_response}" | tail -n 1)"

    # if match use fzf_match as extension
    # if no match (one line of query came back), also use fzf_match (== fzf_input in that case)
    # else: the user just pressed enter to get no extension, do nothing
    if [[ "${fzf_input}" != "" ]]; then
      # the user has searched and wants an extension
      tmpfile+=".${fzf_match}"
    fi
  fi
  echo "${tmpfile}"
}

tmp_interpret() {
  # normally we want to insert in the end, after the last newline
  pos(){
    local stub="$1"
    newlines="$(echo -n "${stub}"| wc -l | cut -d' ' -f 1)"
    echo -n "$(( newlines + 1 ))"
  }

  # brace delimited main: adjust up by one (redundant adds not considered harmful here)
  braced_pos() {
    local stub="$1"
    echo -n "$(( "$(pos "${stub}")" - 1 ))"
  }

  # two space indentation supremacy
  local INDENT='  '

  # available from C23 and C++17
  local MAIN_PARAM='[[maybe_unused]] int argc, [[maybe_unused]] char** argv'

  local C_STUB="$(cat \
<<EOF
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

int main(${MAIN_PARAM}) {
${INDENT}
}
EOF
)"

  local CPP_STUB="\
#include <all.hpp>

auto main(${MAIN_PARAM}) -> int {
${INDENT}
}"

  local RS_STUB="\
fn main() {
${INDENT}
}"

  local PY_STUB=$'from std import *\n\n'

  local SH_STUB="$(sh_stub)"

  # line number in which to insert cursor
  local C_POS="$(braced_pos "${C_STUB}")"
  local CPP_POS="$(braced_pos "${CPP_STUB}")"
  local RS_POS="$(braced_pos "${RS_STUB}")"
  local PY_POS="$(pos "${PY_STUB}")"

  local ext="$1"
  local file="$(make_tmp_repl "${ext}")"

  insert_stub_and_open() {
    local stub="$1"
    local pos="$2"

    if [[ -n "${stub}" ]]; then
      printf '%s\n' "${stub}" >> "${file}"
    fi

    nvim -c ":${pos:-1}" -c 'startinsert!' "${file}"
  }

  case "${file}" in
    *\.c) insert_stub_and_open "${C_STUB}" "${C_POS}";;
    *\.cpp|*\.cc) insert_stub_and_open "${CPP_STUB}" "${CPP_POS}";;
    *\.rs) insert_stub_and_open "${RS_STUB}" "${RS_POS}";;
    *\.py) insert_stub_and_open "${PY_STUB}" "${PY_POS}";;
    *) insert_stub_and_open ;;
  esac
  echo "${file}"
}

# bindkey -s '^t' 'tmp_interpret\n'
bindkey -s '^t' 'in_tmpdir\n'
bindkey -s '^r' 'tmp_interpret\n'
# bindkey -s '^T' 'in_tmpdir\n' # this has a strange effect!
# bindkey -s '^p' 'tmp_interpret py\n'
bindkey -s '^p' 'py\n'
bindkey -s '^/' 'f\n'
bindkey -s '^S' ' clear;scc;clear\n'
bindkey -s '^s' ' clear;silent_gpt;clear\n'

CC_CPP() {
  # local cwd="$(pwd)"
  # local file="$(realpath "$1")"
  # cd "$(dirname "$file")" || return 1

  echo -n "${CPP_CMD}"
}

local C_FLAGS=(-g -Wall -Wextra -Wpedantic)
local CPP_INC=(-"I${LOCAL_INC}/all" "-I${LOCAL_INC}/std")
export CPP_CMD=(g++ --std=c++2b $C_FLAGS $CPP_INC)

CC_CPP2() {
  local CPP2_CMD="cppfront -c"
  ($CPP2_CMD "$1" -o "$1.cpp" > /dev/null) \
    && ($CPP_CMD "$1.cpp" -o "$1.cpp.elf" > /dev/null) \
    && echo "$1.cpp.elf"
}

alias proj="${DATA}/data/projekte"
alias inbox="${INBOX}"

in_tmpdir() {
  local datetime="$(date '+%Y-%m-%d_%H-%M-%S')"
  local tmpdir="${LOCAL_TMP}/tmpd_${datetime}_XXX"
  local tmpdir="$(mktemp --directory "${tmpdir}")"
  cd "${tmpdir}"
  pwd
}

emoji() {
  local emojis="${XDG_DATA_HOME}/larbs/emoji"
  local emoji="$(cut -f '1' -d ';' "${emojis}"  | fzf | sed "s/ .*//")"

  if [[ "${emoji}" != "" ]]; then
    echo -n "${emoji}" | xclip -selection clipboard
  fi
}

_launch() {
  nohup $1 2>&1 >/dev/null & disown; exit
}

timer() {
  local pycmd='print(__import__("sys").stdin.readlines()[-1].split()[-2])'
  (time python -c "input()" &>/dev/null) 2>&1 | python -c "${pycmd}"
}

start_x_server() {
  local datetime="$(date +%Y-%m-%d_%H-%M-%S)"
  local logfile="${HOME}/.local/share/xorg/xorg_${datetime}.log"
  local xinitrc="$(cat \
<<EOF
dbus-update-activation-environment --all --systemd
xrdb "${XRESOURCES}"
setbackground.sh
remaps &
picom &
flashfocus &
dunst &
unclutter --timeout 1 --jitter 1 --ignore-scrolling --hide-on-touch --start-hidden &
syncthing --no-browser &
xss-lock --transfer-sleep-lock -- i3lock.sh &
xset s on; xset s 300 # Trigger screensaver after 5 minutes of inactivity
mullvad connect --wait &
udiskie &
dwm
EOF
  )"
  startx -keeptty <(printf '%s\n' "${xinitrc}") &>>"${logfile}"
  # cat <(printf '%s\n' "${xinitrc}") #&>>"${logfile}"
  # startx <(cat "${XINITRC}") &>>"${logfile}"

}

if [[ "${DISPLAY:-}" == '' && "${XDG_VTNR}" == '1' ]]; then
  start_x_server
fi

DIRSTACKSIZE=25
setopt autopushd pushdminus pushdsilent # pushdtohome

alias dh='dirs -v'

blt() {
  if [[ "$1" == "d" ]]; then
    bluetoothctl disconnect
  else
    device="$(bluetoothctl devices | fzf | cut -d ' ' -f 2)"
    [[ -n "$device" ]] && bluetoothctl connect "$device"
  fi
}

alias pkg='yay -S --needed'
alias update='yay -Syu --needed --noconfirm'

preexec() {
  tput cup "${LINES}"
  echo -ne '\e[5 q' # Use beam shape cursor for each new prompt.
}

precmd() {
  tput cup "${LINES}"
}

alias exa='eza'
alias ls='exa -ahlg -b --time-style=long-iso --color=never'

# export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:="/run/user/${UID}"}/gcr/ssh"
export SSH_KEY_GH_EXPRPAPI="${SSH_HOME}/key_gh_exprpapi"
export SSH_KEY_GH_OSCARSYNTAX="${SSH_HOME}/key_gh_oscarsyntax"
export SSH_KEY_GH_ZRWX="${SSH_HOME}/key_gh_zrwx"
export EMAIL_GH_EXPRPAPI='121869314+exprpapi@users.noreply.github.com'
export EMAIL_GH_OSCARSYNTAX='121956330+oscarsyntax@users.noreply.github.com'
export EMAIL_GH_ZRWX='143856164+zrwx@users.noreply.github.com'

get_git_name() {
  local names=('exprpapi' 'oscarsyntax' 'zrwx')
  local name="$(printf '%s\n' "${names[@]}" | fzf)"
  printf '%s\n' "${name}"
}

get_git_email() {
  local name="${1:-$(get_git_name)}"
  local name_upper="$(printf '%s\n' "${name}" | tr '[:lower:]' '[:upper:]')"
  local email="EMAIL_GH_${name_upper}"
  local email="${(P)email}"
  printf '%s\n' "${email}"
}

get_git_signingkey() {
  local name="${1:-$(get_git_name)}"
  local name_upper="$(echo "${name}" | tr '[:lower:]' '[:upper:]')"
  local signingkey="SSH_KEY_GH_${name_upper}"
  local signingkey="${(P)signingkey}.pub"
  printf '%s\n' "${signingkey}"
}

git_as() {
  (
    set -euo pipefail
    local name="${1:-$(get_git_name)}"
    git config --local user.name "${name}"
    git config --local user.email "$(get_git_email "${name}")"
    git config --local user.signingkey "$(get_git_signingkey "${name}")"
    # set_remote() {
    #   local url_pre="$(git remote get-url origin)"
    #   local python_cmd='import sys;print("/".join(sys.stdin.readlines()[0].split("/")[-2:]))'
    #   local repo="$(python -c "${python_cmd}" <<<"${url_pre}")"
    #   local url="https://${name}@github.com/${repo}"
    #   git remote set-url origin "${url}"
    # }
    # if git remote get-url origin &>/dev/null; then set_remote fi
  )
}

get_git_token() {
  local name="${1:-$(get_git_name)}"
  local name_upper="$(echo "${name}" | tr '[:lower:]' '[:upper:]')"
  local token="TOKEN_GH_${name_upper}" 
  local gh_token="$(secret-tool lookup "${token}" token)"
  printf '%s\n' "${gh_token}"
}

set_git_token() {
  if [[ "${#}" != 2 ]]; then
    printf '%s\n' 'invalid argc' >&2
    return 1
  fi
  local name="${1}"
  local key="${2}"
  local name_upper="$(echo "${name}" | tr '[:lower:]' '[:upper:]')"
  local token="TOKEN_GH_${name_upper}" 
  printf '%s' "${key}" | secret-tool store --label="${token}" "${token}" token
}

original_gh="$(which gh)"

gh() {
  GH_TOKEN="$(get_git_token)" "${original_gh}" "$@"
}

gh_clone() {
  (
    set -euo pipefail  
    local name="$(get_git_name)"
    local repo="$1"
    local git_dir="$(echo "${repo}" | cut -d '/' -f '2')"
    local url="https://${name}@github.com/${repo}"
    git clone "${url}"
    cd "${git_dir}"
    git_as "${name}"
  )
}

ncdu() {
  sudo ncdu \
    --extended \
    --disable-delete \
    --show-mtime \
    --show-itemcount \
    --graph-style eigth-block \
    "$@"
}

alias -g VV='|& nvim -'

set -o pipefail

cryfs_decrypt() {
  if [[ ! "$#" == 2 ]]; then
    printf '%s\n' "Error[${0}]: invalid argc" &>/dev/null
    return
  fi
  local encrypted="$1"
  local decrypted="$2"
  cryfs "${encrypted}" "${decrypted}"
}

alias journalctl='journalctl -xeb -o short-iso'

alias prep='perl -ne'

ins() {
  ins_ls() {
    # exa -ahlg -b --time-style=long-iso --color=never
    exa --all --color='always' --oneline --group-directories-first "$@"
  }
  if [[ "$#" -eq 0 ]];then
    ins_ls
  elif [[ -d "${1}" ]]; then
    ins_ls "${1}"
  elif [[ -e "${1}" ]]; then
    \cat "${1}"
  fi
}

alias println='printf "%s\n"'

alias rg='rg --smart-case --hidden --no-ignore --no-ignore-files --one-file-system'

nix-run() {
  local program="${1}"
  nix-shell --packages "${program}" --run "${program}"
}

rsync_cp() {
  if [[ "$#" -lt 2 ]]; then
    printf '%s\n' '[Error in rsync_cp()]: invalid argc' &>>/dev/stderr
    return
  fi
  local opts=(
   --archive
   --hard-links
   --xattrs
   --atimes
   --info=progress2
  )
  local src="${1}"
  local dst="${2}"
  rsync "${opts[@]}" "${src}" "${dst}"
}

silent_gpt() {
  clear
  tput cup "${LINES}"
  local verb="${1:-}"
  local args=()
  if [[ "${verb}" == '' ]]; then
    args+='--code'
  fi
  print -nP "${PROMPT}"
  read -sr user_prompt
  if [[ "${user_prompt}" == '' ]]; then
    return
  fi
  args+="${user_prompt}"
  clear
  ({sgpt "${args[@]}" |& clip} &>>/dev/null &)
  clear
}

scc() {
  silent_gpt 'text'
}

shgpt() {
  sgpt --repl temp --model gpt-4
}

md_preview() {
  local grip="$(which grip)"
  local pass='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'
  "${grip}" --pass "${pass}"
}

alias dookie='killall -I -KILL'

nixpkgs() {
  nix search nixpkgs "${1}" 2>/dev/null \
    | sed -e 's|legacy.*linux\.||' \
    | sed -n -e '/^\* /{N;s/\* \(.*\)\n  \(.*\)/\1: \2/p}' \
    | sort \
    | less
}
