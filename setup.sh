#! /bin/bash

my_bashrc='source $HOME/.bashrc.d/my_bashrc'
PS1_colors='source $HOME/.bashrc.d/PS1_colors'
sort_history='source $HOME/.bashrc.d/sort_history'

if ! [[ $(grep "$my_bashrc" ~/.bashrc) ]]; then
    echo -e "\n$my_bashrc" >> ~/.bashrc
    echo -e "\033[01;32m"\'$(grep "$my_bashrc" ~/.bashrc)\' added to ~/.bashrc "\033[0m"
else
    echo -e "\033[00;33m'$my_bashrc' is already set in ~/.bashrc  \033[0m"
fi

if ! [[ $(grep "$PS1_colors" ~/.bashrc) ]]; then
    echo -e "\n$PS1_colors" >> ~/.bashrc
    echo -e "\033[01;32m"\'$(grep "$PS1_colors" ~/.bashrc)\' added to ~/.bashrc "\033[0m"
else
    echo -e "\033[00;33m'$PS1_colors' is already set in ~/.bashrc \033[0m"
fi

if ! [[ $(grep "$sort_history" ~/.bashrc) ]]; then
    echo -e "\n$sort_history" >> ~/.bashrc
    echo -e "\033[01;32m"\'$(grep "$sort_history" ~/.bashrc)\' added to ~/.bashrc "\033[0m"
else
    echo -e "\033[00;33m'$sort_history' is already set in ~/.bashrc  \033[0m"
fi

if ! [[ -f ~/.vimrc ]]; then
    ln -s ~/.bashrc.d/.vimrc ~/.vimrc
    echo -e "\033[01;32mCreated link: $(ls -l ~/.vimrc | cut -d ' ' -f 9-11) \033[0m"
else
    echo -e "\033[01;31m'~/.vimrc' file already exists \033[0m"
fi
