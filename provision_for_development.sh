#!/usr/bin/env bash

###################################################################################
# Provision Program for Development 0.1                                           #
# This script provisions Common Linux machines with software development programs #
###################################################################################

additional_flags=""

if hash apt 2> /dev/null; then
    pm_prefix="apt install"
    declare -A packages
    packages[development]="build-essential qt5-default qt5-qmake qt5-doc qtcreator git python2.7 python-dev python3 python3-dev cmake"
    packages[editors]="vim vim-gnome eclipse"
    packages[debugging]="gdb valgrind"
    packages[useful]="tmux zsh"
    packages[security]="wireshark nmap zenmap tcpdump"
    packages[virtualization]="virtualbox vagrant kvm qemu qemu-kvm libvirt-daemon-system"
    packages[design]="dia inkscape gimp"
    echo "Updating system..."
    apt update && apt upgrade -y;
fi

if hash dnf 2> /dev/null; then
    pm_prefix="dnf install"
    declare -A packages
    packages[development]="@development-tools qt5-qtbase qconf git qt-creator python3 python3-devel cmake"
    packages[editors]="vim gvim eclipse"
    packages[debugging]="gdb valgrind"
    packages[useful]="tmux zsh"
    packages[security]="wireshark nmap tcpdump"
    packages[virtualization]="@virtualization VirtualBox vagrant qemu"
    packages[design]="dia inkscape gimp"
    echo "Updating system..."
    cd /etc/yum.repos.d/;
    wget http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo;
    dnf upgrade -y;
fi

if hash pacman 2> /dev/null; then
    pm_prefix="pacman -S"
    declare -A packages
    packages[development]="base-devel qt5-base qt5-doc qconf git qtcreator python3 python3-dev cmake"
    packages[editors]="vim g vim eclipse"
    packages[debugging]="gdb valgrind"
    packages[useful]="tmux zsh"
    packages[security]="wireshark nmap zenmap tcpdump"
    packages[virtualization]="virtualbox vagrant qemu libvirt"
    packages[design]="dia inkscape gimp"
    echo "Updating system..."
    pacman -Syu;
fi

if hash eopkg 2> /dev/null; then
    pm_prefix="eopkg install -y"
    additional_flags="-c"
    declare -A packages
    packages[development]="system.devel qt5-base qt-creator git python2.7 python-dev python3 python3-dev cmake"
    packages[editors]="vim gvim" # Eclipse is not available on Solus at the moment, need to find an alternative
    packages[debugging]="gdb valgrind"
    packages[useful]="tmux zsh"
    packages[security]="wireshark nmap tcpdump"
    packages[virtualization]="virtualbox vagrant qemu"
    packages[design]="dia inkscape gimp"
    echo "Updating system..."
    eopkg upgrade -y;
fi

if hash zypper 2> /dev/null; then
    pm_prefix="zypper install"
    declare -A packages
    packages[development]="pattern devel qt5-qtbase qconf git qt-creator python3 python3-dev cmake"
    packages[editors]="vim g vim eclipse"
    packages[debugging]="gdb valgrind"
    packages[useful]="tmux zsh"
    packages[security]="wireshark nmap zenmap tcpdump"
    packages[virtualization]="virtualbox vagrant qemu"
    packages[design]="dia inkscape gimp"
    echo "Updating system..."
    zypper upgrade -y;
fi

if [ -z "$pm_prefix" ]; then
    printf "Your distribution is not supported, sorry.\nSupported distributions include:\nDebian/Redhat systems, Solus, OpenSUSE, and Arch Linux\n"
    exit 1
fi

all_packages=""
for i in ${!packages[@]}
do
    all_packages+="${packages[$i]} "
done

echo $all_packages

packages[all]=$all_packages

# Check for root
if [[ $EUID -ne 0 ]]; then
    echo "You must be root to run this script."
    exit 1
fi

############################
# Installation of packages #
############################
echo "#######################################################"
echo "# Linux Distribution Provisioning Tool for Developers #"
echo "#######################################################"

printf "\n################ Package Installation #################\n\n"

echo "What packages do you want to install?"
echo "[0] - Development: ${packages[development]}"
echo "[1] - Editors: ${packages[editors]}"
echo "[2] - Debugging: ${packages[debugging]}"
echo "[3] - Useful: ${packages[useful]}"
echo "[4] - Security: ${packages[security]}"
echo "[5] - Virtualization: ${packages[virtualization]}"
echo "[6] - Design: ${packages[design]}"
echo "[7] - All packages: ${packages[all]}"

printf "\nEnter a number ->:"
read package_options

install="$pm_prefix $additional_flags "

case $package_options in
    0)
        echo "Installing development packages (${packages[development]})..."
        install+=${packages[development]}
        ;;

    1)
        echo "Installing editors (${packages[editors]})..."
        install+=${packages[editors]}
        ;;

    2)
        echo "Installing debugging tools (${packages[debugging]})..."
        install+=${packages[debugging]}
        ;;

    3)
        echo "Installing useful packages (${packages[useful]})..."
        install+=${packages[useful]}
        ;;

    4)
        echo "Installing useful packages (${packages[security]})..."
        install+=${packages[security]}
        ;;

    5)
        echo "Installing useful packages (${packages[virtualization]})..."
        install+=${packages[virtualization]}
        ;;

    6)
        echo "Installing useful packages (${packages[design]})..."
        install+=${packages[design]}
        ;;

    7)
        echo "Installing all packages (${packages[all]})... "
        install+=${packages[all]}
        ;;

    *)
        echo "Please choose a valid option"
        exit 1
esac

$install;

#################
# Configuration #
#################
printf "\n################ System Configuration #################\n\n"

printf "Do you want to configure Git? Y/n:"
read configure
if [ ${configure,,} = "y" ]; then
    printf "Enter a git UserName:"
    read gitUser
    git config --global user.name = gitUser;

    printf "Enter a git EmailAddress:"
    read gitEmailAddress
    git config --global user.email = gitEmailAddress;
fi

printf "Do you want to a bare-bones Vim config? Y/n:"
read vim_configure
if [ ${vim_configure,,} = "y" ]; then
    echo $'set number\necho\nset\nset shiftwidth=4\nset softtabstop=4\nset ruler\nset undolevels=1000\nsyntax on' > ~/.vimrc;
fi

printf "Do yo want to extend Vim with plugins? Y/n: ";
read vim_configure_plugins

if [ ${vim_configure_plugins,,} = "y" ]; then
    echo "Installing Pathogen...";
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
        curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim;
    echo "execute pathogen#infect()" >> ~/.vimrc;

'
    This seems to take a while. Will need to look into this later

    printf "Do you want to use Intellisense with Vim? Y/n: "
    read intellisense
    if [ ${intellisense,,} = "y" ]; then
        echo "Installing Intellisense for Vim (YouCompleteMe)..."
        git clone https://github.com/Valloric/YouCompleteMe.git;
        mv YouCompleteMe ~/.vim/bundle/;
        cd ~/.vim/bundle/YouCompleteMe/;
        git submodule update --init --recursive;
        python3 install.py --clang-completer;
    fi
'

fi

printf "Do you want to use zsh shell with oh-my-zsh? Y/n:"
read zsh_install

if [ ${zsh_install,,} = "y" ]; then
    echo "Setting default shell to zsh..."
    chsh -s $(which zsh);
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)";
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' ~/.zshrc;
    source ~/.zshrc;

fi
echo "Script finished successfully"
