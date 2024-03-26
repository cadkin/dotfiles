#!/usr/bin/env bash

# Prompt colors
c_background="48;5;236m"

c_user="32m"
c_host="38;5;51m"
c_dir="95m"
c_branch="38;5;156m"
c_nix="38;5;33m"
c_time="36m"

c_clear="0;$c_background"
c_reset="0m"

function color() {
    echo -n "\033[$1"
}

function colorize() {
    echo -n "$(color $2)$1$(color $c_clear)"
}

function prompt_left() {
    # Standard prompt
    echo -n "$(colorize '\u' $c_user)@$(colorize '\h' $c_host) "
    echo -n "∈ [$(colorize '\w' $c_dir)] "

    # Git branch
    if output=$(git branch 2>/dev/null); then
        branch_name=$(echo -n "$output" | grep \* | colrm 1 2)
        echo -n "⑃ [$(colorize $branch_name $c_branch)] "
    fi

    # Nix environment
    if [ $IN_NIX_SHELL ]; then
        shell_name=$(echo $name | sed "s/.\{4\}$//")
        echo -n "# [$(colorize $shell_name $c_nix)] "
    fi
}

function prompt_right() {
    echo -n "[$(colorize '\t' $c_time)]"
}

function prompt() {
    left=$(prompt_left)
    right=$(prompt_right)

    escapes="${right//[^\033]}"
    compensate=$(( ${#escapes} + 9 ))

    PS1=$(printf "\n$(color $c_background)%$((${COLUMNS} + ${compensate}))s\r%s$(color $c_reset)\n$ " "$right" "$left")
}

PROMPT_COMMAND=prompt

source /run/current-system/sw/share/fzf/key-bindings.bash
source /run/current-system/sw/share/fzf/completion.bash

HISTSIZE=100000
HISTFILESIZE=100000

PATH=$PATH:$HOME/.appimage
PATH=$PATH:$HOME/.scripts

function wineprefix_gen_start_script() {
    if [ -z "$1" ]; then
        echo "usage: wineprefix_gen_start_script <wine_exe> [lang]"
        return
    fi

    lang=${2:-en_US.UTF-8}

cat << EOF > "start-${1//\//_}.sh"
cd "\${0%/*}"
export WINEPREFIX=\$PWD/winesys/
export LANG=$lang
wine "$1"
EOF

    chmod +x "start-${1//\//_}.sh"
}

function wineprefix_pwd() {
    export WINEPREFIX=$PWD/winesys
}

function wineprefix_pwd_dxvk_init() {
    export WINEPREFIX=$PWD/winesys
    winetricks -q dxvk
}

function nix-where() {
    ls -lah $(which $1)
}

alias vim="nvim"
alias weather="curl wttr.in/Knoxville?u"
alias fix_scarlett_tmp="pw-metadata -n settings 0 clock.force-rate 44100"

## >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/cva/.conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/cva/.conda/etc/profile.d/conda.sh" ]; then
        . "/home/cva/.conda/etc/profile.d/conda.sh"
    else
        export PATH="/home/cva/.conda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

