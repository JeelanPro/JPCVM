#!/bin/bash

checkAndInstall() {
    if ! command -v $1 &>/dev/null; then
        echo "The command '$1' is not installed."
        if command -v apt-get &>/dev/null; then
            echo "Please install '$1' by running the following command:"
            echo "sudo apt-get install $1"
        elif command -v yum &>/dev/null; then
            echo "Please install '$1' by running the following command:"
            echo "sudo yum install $1"
        elif command -v dnf &>/dev/null; then
            echo "Please install '$1' by running the following command:"
            echo "sudo dnf install $1"
        elif command -v pacman &>/dev/null; then
            echo "Please install '$1' by running the following command:"
            echo "sudo pacman -S $1"
        else
            echo "Please install '$1' using your package manager."
        fi
        exit 1
    fi
}

echo "Verifying Dependencies"
sleep 1s
checkAndInstall wget
checkAndInstall unzip
checkAndInstall mkdir
checkAndInstall curl
checkAndInstall chmod

echo -n "Are you sure you want to install this JPCVM program? (y/n): "
read -r answer
if [ "$answer" != "${answer#[Yy]}" ]; then
    echo -n "Please enter directory of your JPCVM installation [default: /opt/bin/]: "
    read -r jpcvm_dir
    if [ -z "$jpcvm_dir" ]; then
        jpcvm_dir="/opt/bin/"
    fi
    curl -o "main.bash" -OL "$jpcvm_dir/jpcvm.bash"
    chmod +x "$jpcvm_dir/jpcvm.bash"
    echo "adding to the command..."
    location1=$(realpath "$jpcvm_dir/jpcvm.bash")
    if [ -f ~/.bashrc ]; then
        echo "alias jpcvm='$location1'" >>~/.bashrc
        echo "jpcvmLoc=\"$location1\"" >>~/.bashrc
    elif [ -f ~/.bash_profile ]; then
        echo "alias jpcvm='$location1'" >>~/.bash_profile
        echo "jpcvmLoc=\"$location1\"" >>~/.bash_profile
    elif [ -f ~/.zshrc ]; then
        echo "alias jpcvm='$location1'" >>~/.zshrc
        echo "jpcvmLoc=\"$location1\"" >>~/.zshrc
    elif [ -f ~/.zsh_profile ]; then
        echo "alias jpcvm='$location1'" >>~/.zsh_profile
        echo "jpcvmLoc=\"$location1\"" >>~/.zsh_profile
    elif [ -f ~/.config/fish/config.fish ]; then
        echo "alias jpcvm='$location1'" >>~/.config/fish/config.fish
        echo "jpcvmLoc=\"$location1\"" >>~/.config/fish/config.fish
    else
        echo "Error: Code: E1B0. Please contact us."
        exit 1
    fi
    echo "Sourcing the files"
    if [ -f ~/.bashrc ]; then
        source ~/.bashrc
    elif [ -f ~/.bash_profile ]; then
        source ~/.bash_profile
    elif [ -f ~/.zshrc ]; then
        source ~/.zshrc
    elif [ -f ~/.zsh_profile ]; then
        source ~/.zsh_profile
    elif [ -f ~/.config/fish/config.fish ]; then
        source ~/.config/fish/config.fish
    else
        echo "Error: Code: E1B1. Please contact us."
        exit 1
    fi
    echo ""
    sleep 1s
    echo "Done!"
    echo ""
    echo "--------------------------------------------------------------"
    echo "by JeelanPro, jpcvm 0.0.0 preview has been installed."
    echo "--------------------------------------------------------------"
fi
