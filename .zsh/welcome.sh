#! /usr/bin/sh

esc="\x1b["
reset="${esc}0m"
bold="${esc}1m"
red="${esc}31m"
green="${esc}32m"
blue="${esc}34m"
magenta="${esc}35m"

host=$(cat "/etc/hostname")

printf "welcome, %b%b%s%b on %b%b%s%b\n" "$bold" "$magenta" "$USER" "$reset" "$bold" "$magenta" "$host" "$reset"

line_title() {
    printf "%b%s%b: " "$blue" "$1" "$reset" 
}

if [ -x "$(command -v yadm)" ]; then
    line_title "Config"
    if [ "$(yadm rev-parse HEAD)" = "$(yadm rev-parse "@{u}")" ]; then
        printf "%b%bup to date%b" "$bold" "$green" "$reset" 
    else
        printf "%b%boutdated%b" "$bold" "$red" "$reset"
    fi

    if [ -z "$(yadm status --porcelain=v1 2>/dev/null)" ]; then
        printf "\n"
    else
        printf " (uncommited changes)\n"
    fi
fi

if [ -x "$(command -v lsb_release)" ]; then
    os="$(lsb_release -sd)"
    os=${os##[\"\']}
    os=${os%%[\"\']}
    line_title "Distro"
    printf "%s%b\n" "$os" "$reset"
fi

if [ -x "$(command -v uptime)" ]; then
    up="$(uptime -p)"
    up=${up#up }
    line_title "Uptime"
    printf "%s%b\n" "$up" "$reset"
fi

printf "\n"
