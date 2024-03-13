#! /bin/bash

PS1_colors_file="$(dirname $0)/PS1_colors"

source $PS1_colors_file

u=$(whoami)
h=$(hostname)
w=$(pwd)

RESET="\033[0m"
MIDDLE_DOT="\033[38;5;${GREY_DARK}m·${RESET}"

check_colors () {
    COLOR_1="\033[38;5;${TEXT_COLOR_1};48;5;${BACKGROUND_COLOR_1}m"
    COLOR_2="\033[38;5;${TEXT_COLOR_2};48;5;${BACKGROUND_COLOR_2}m"
    printf "${COLOR_1}${LEADING_SPACE}$u@$h${TRAILING_SPACE}${RESET}:${COLOR_2}$w${RESET}\$${MIDDLE_DOT}$1 \n"
}


check_colors "Current config"

# The COLOR_NAMES value is declared in the PS1_colors_file

TEXT_COLOR_2=$DEFAULT_TEXT_COLOR_2
BACKGROUND_COLOR_2=$DEFAULT_BACKGROUND_COLOR_2

###########################################
###  TEXT
###########################################
LEADING_SPACE=""
TRAILING_SPACE=""

for background in BLACK WHITE
do
    for text_color in ${COLOR_NAMES[@]}
    do
        BACKGROUND_COLOR_1=${!background}
        TEXT_COLOR_1=${!text_color}

        if [[ $BACKGROUND_COLOR_1 != $TEXT_COLOR_1 ]]; then
            check_colors "$text_color"
        fi
    done
done


###########################################
###  BACKGROUND
###########################################
LEADING_SPACE=" "
TRAILING_SPACE=" "

for background in ${COLOR_NAMES[@]}
do
    for text_color in BLACK WHITE
    do
        BACKGROUND_COLOR_1=${!background}
        TEXT_COLOR_1=${!text_color}

        if [[ $BACKGROUND_COLOR_1 != $TEXT_COLOR_1 ]]; then
            check_colors "$background"
        fi
    done
done
