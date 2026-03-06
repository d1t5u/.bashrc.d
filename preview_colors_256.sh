#!/bin/bash

for i in {0..255}; do
    # Print color number with background \e[48;5;${i}m
    # %3d — aligns the number width
    # \e[0m — resets color at the end of the line
    printf "\e[48;5;%dm  Color %3d  \e[0m" "$i" "$i"

    # Add a newline every 6 colors for readability
    if [ $((($i + 1) % 6)) == 0 ]; then
        echo
    fi
done

