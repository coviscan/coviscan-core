#!/bin/bash

print_status() {
    echo
    echo -e "##  ${bold}${green}$1${normal}"
    echo
}

print_error() {
    echo
    echo -e "##  ${bold}${green}$1${normal}"
    echo
}

print_error() {
    echo
    echo -e "##  ${bold}${red}$1${normal}"
    echo

    exit 1
}

if test -t 1; then # if terminal
    ncolors=$(which tput > /dev/null && tput colors) # supports color
    if test -n "$ncolors" && test $ncolors -ge 8; then
        termcols=$(tput cols)
        bold="$(tput bold)"
        underline="$(tput smul)"
        standout="$(tput smso)"
        normal="$(tput sgr0)"
        black="$(tput setaf 0)"
        red="$(tput setaf 1)"
        green="$(tput setaf 2)"
        yellow="$(tput setaf 3)"
        blue="$(tput setaf 4)"
        magenta="$(tput setaf 5)"
        cyan="$(tput setaf 6)"
        white="$(tput setaf 7)"
    fi
fi

print_bold() {
    title="$1"
    text="$2"

    echo
    echo "${cyan}================================================================================${normal}"
    echo "${cyan}================================================================================${normal}"
    echo
    echo -e "  ${bold}${green}${title}${normal}"
    echo
    echo -en "  ${text}"
    echo
    echo "${cyan}================================================================================${normal}"
    echo "${cyan}================================================================================${normal}"
}