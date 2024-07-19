#!/bin/bash

arg="$1"
ab="1"

if [ "$arg" == "--help" ]; then
    echo "Usage: jpcvm [options]"
    echo "Options:"
    echo "  --help         Show the usage."
    echo "  --version      Show the version."
    echo "  --init         Initialize the VM."
    echo "  --start        Start the VM."
    echo "  --info         Show the information of the VM."
    echo "  --delete       Delete the VM."
    echo "  --uninstall    Uninstall the JPCVM."
    ab="0"
fi

if [ "$arg" = "--version" ] || [ "$arg" = "-v" ]; then
    echo "JPCVM version 0.0.0 Preview by JeelanPro"
    ab="0"
fi

if [ "$arg" = "--init" ]; then
    if [ -d ".JPCVM" ]; then
        echo "The VM is already initialized. Use following options: "
        echo "  Use the --start option to start the VM."
        echo "  Use the --delete option to delete the VM."
    else
        clear
        echo "Initializing the Virtual Machine..."
        mkdir ".JPCVM"
        sleep 1s
        
        echo -n "Name of your Virtual Machine: "
        read -r name
        clear
        
        echo -n "Password of Your VM (You can leave it blank): "
        read -r password
        clear
        
        echo -n "Do you want to enter in the VM (y/n) [Default: n]: "
        read -r answer
        clear
        
        date=$(date "+%Y-%m-%d %H:%M:%S")
        echo "Setting up JPCVM..."
        
        echo -e "$name\n$password\n$date" > ".JPCVM/info.txt"
        
        echo "Creating Virtual Machine..."
        sleep 1s
        mkdir "HardDisk"
        cd "HardDisk"
        wget -O akuh.zip https://media.githubusercontent.com/media/akuhnet/wqemu/master/akuh.zip
        unzip akuh.zip
        unzip root.zip
        tar -xvf root.tar.xz
        rm -rf akuh.zip root.zip root.tar.xz
        clear
        
        if [ "$answer" != "${answer#[Yy]}" ]; then
            echo -n "Please Enter the password of your VM: "
            read -r password1
            clear
            if [ "$password" = "$password1" ]; then
                clear
                echo "--------------------------------------------------------"
                echo "Welcome to JPCVM. Please read the following Info:"
                echo "   Write exit to exit/stop the VM.*"
                echo "   This VM is empty and It has only apt commands.*"
                echo "--------------------------------------------------------"
                ./dist/proot -S . /bin/bash
            else
                echo "The password is incorrect."
                echo "   Please use the --start option to Try again"
            fi
        fi
    fi
    ab="0"
fi

if [ "$arg" = "--start" ]; then
    if [ -d ".JPCVM" ]; then
        passwordA=$(sed -n '2p' ".JPCVM/info.txt")
        name=$(sed -n '1p' ".JPCVM/info.txt")
        echo -n "Please Enter the password of $name VM: "
        read -r password
        if [ "$password" = "$passwordA" ]; then
            clear
            echo "--------------------------------------------------------"
            echo "Welcome to JPCVM. Please read the following Info:"
            echo "   Write exit to exit/stop the VM.*"
            echo "   This VM is empty and It only has apt commands.*"
            echo "--------------------------------------------------------"
            cd "HardDisk"
            ./dist/proot -S . /bin/bash
            cd ..
        else
            echo "The password is incorrect."
        fi
    else
        echo "The VM is not initialized. Use following options: "
        echo "  Use the --init option to initialize the VM."
    fi
    ab="0"
fi

if [ "$arg" = "--info" ]; then
    if [ -d ".JPCVM" ]; then
        name=$(sed -n '1p' ".JPCVM/info.txt")
        date=$(sed -n '3p' ".JPCVM/info.txt")
        echo "JeelanPro Official Virtual Machine: "
        echo "   Name of your Virtual Machine: $name"
        echo "   This Virtual Machine was created on: $date"
    else
        echo "The VM is not initialized. Use following options: "
        echo "  Use the --init option to initialize the VM."
    fi
    ab="0"
fi

if [ "$arg" = "--delete" ] || [ "$arg" = "--del" ]; then
    if [ -d ".JPCVM" ]; then
        echo "Are you sure you want to delete the VM? (y/n): "
        read -r answer
        if [ "$answer" != "${answer#[Yy]}" ]; then
            echo "Please Enter the password of your VM: "
            read -r password
            passwordA=$(sed -n '2p' ".JPCVM/info.txt")
            if [ "$password" = "$passwordA" ]; then
                rm -rf ".JPCVM"
                rm -rf "HardDisk"
                echo "The VM has been deleted."
            else
                echo "The password is incorrect."
            fi
        fi
    else
        echo "The VM is not initialized. Use following options: "
        echo "  Use the --init option to initialize the VM."
    fi
    ab="0"
fi

if [ "$arg" = "--uninstall" ]; then
    echo -n "Are you sure you want to uninstall the JPCVM? (y/n): "
    read -r answer
    if [ "$answer" != "${answer#[Yy]}" ]; then
        rm -rf "/opt/bin/jpcvm.bash"
        sed -i "/jpcvm/d" ~/.bashrc
        sed -i "/jpcvm/d" ~/.bash_profile
        sed -i "/jpcvm/d" ~/.zshrc
        sed -i "/jpcvm/d" ~/.zsh_profile
        sed -i "/jpcvm/d" ~/.config/fish/config.fish
        sed -i "/jpcvm/d" ~/.config/fish/conf.d/jpcvm.fish
				echo ""
				echo ""
				echo ""
        echo "The JPCVM has been uninstalled."
        echo "Thank you for using JPCVM."
        echo "If you have any feedback, please leave feedback on GitHub."
        echo "Please Visit: https://JeelanPro.github.io"
    fi
    ab="0"
fi

if [ "$ab" == "1" ]; then
    echo "missing option"
    echo "Usage: jpcvm [options]"
    echo ""
    echo "Try \`jpcvm --help\` for more information"
fi


#==============================================================================================
