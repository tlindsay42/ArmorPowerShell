#!/usr/bin/env bash

# PowerShell Core Linux installation instructions
# https://github.com/PowerShell/PowerShell/blob/master/docs/installation/linux.md

# Let's quit on interrupt of subcommands
trap '
  trap - INT # restore default INT handler
  echo "Interrupted"
  kill -s INT "$$"
' INT

get_url() {
    echo "/config/$1/$2/prod.$3"
    #https://packages.microsoft.com/repos/microsoft-debian-jessie-prod
}

base_url=https://packages.microsoft.com

 # Get OS specific asset ID and package name
case "$OSTYPE" in
    linux*)
        source /etc/os-release
        # Install curl and wget to download package
        case "$ID" in
            centos*)
                distro=rhel
                ext=repo
                repo=/etc/yum.repos.d/microsoft.$ext

                if ! hash curl 2>/dev/null; then
                    echo "curl not found, installing..."
                    sudo yum install -y curl
                fi

                case "$VERSION_ID" in
                    7)
                        version=7
                        ;;
                    *)
                        echo "CentOS $VERSION_ID is not supported!" >&2
                        exit 2
                esac

                # Register the Microsoft RedHat repository
                curl "$base_url/config/$distro/$version/prod.$ext" | sudo tee $repo
                ;;
            debian)
                distro=debian
                ext=list
                repo=/etc/apt/sources.list.d/microsoft.$ext

                if ! hash curl 2>/dev/null; then
                    echo "curl not found, installing..."
                    sudo apt-get install -y curl
                fi

                case "$VERSION_ID" in
                    8)
                        version=jessie
                        ;;
                    9)
                        version=stretch
                        ;;
                    *)
                        echo "Debian $VERSION_ID is not supported!" >&2
                        exit 2
                esac

                # Install system components
                sudo apt-get update
                sudo apt-get install curl apt-transport-https

                # Import the public repository GPG keys
                curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

                # Register the Microsoft Product feed
                sudo sh -c "echo 'deb [arch=amd64] $base_url/repos/microsoft-debian-$version-prod $version main' > $repo"
                ;;
            fedora*)
                distro=rhel
                ext=repo
                repo=/etc/yum.repos.d/microsoft.$ext

                if ! hash curl 2>/dev/null; then
                    echo "curl not found, installing..."
                    sudo dnf install curl
                fi

                case "$VERSION_ID" in
                    25)
                        version=7
                        ;;
                    26)
                        version=7

                        # Update the list of products
                        sudo dnf update

                        # Install a system component
                        sudo dnf install compat-openssl10
                        ;;
                    *)
                        echo "Fedora $VERSION_ID is not supported!" >&2
                        exit 2
                esac

                # Register the Microsoft signature key
                sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

                # Register the Microsoft RedHat repository
                curl "$base_url/config/$distro/$version/prod.$ext" | sudo tee $repo
                ;;
            rhel*)
                distro=rhel
                ext=repo
                repo=/etc/yum.repos.d/microsoft.$ext

                if ! hash curl 2>/dev/null; then
                    echo "curl not found, installing..."
                    sudo yum install -y curl
                fi

                case "$VERSION_ID" in
                    7)
                        version=7
                        ;;
                    *)
                        echo "Red Hat $VERSION_ID is not supported!" >&2
                        exit 2
                esac

                # Register the Microsoft RedHat repository
                curl $(get_url "$distro" "$version" "$ext") | sudo tee $repo
                ;;
            opensuse)
                distro=rhel
                ext=repo
                repo=/etc/zypp/repos.d/microsoft.$ext

                if ! hash curl 2>/dev/null; then
                    echo "curl not found, installing..."
                    sudo zypper install -y curl
                fi

                case "$VERSION_ID" in
                    42.2)
                        version=7
                        ;;
                    *)
                        echo "OpenSUSE $VERSION_ID is not supported!" >&2
                        exit 2
                esac

                # Register the Microsoft signature key
                sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

                # Add the Microsoft Product feed
                curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee $repo
                ;;
            ubuntu)
                distro=ubuntu
                ext=list
                repo=/etc/apt/sources.list.d/microsoft.$ext

                if ! hash curl 2>/dev/null; then
                    echo "curl not found, installing..."
                    sudo apt-get install -y curl
                fi

                case "$VERSION_ID" in
                    14.04)
                    16.04)
                    17.04)
                        version=$VERSION_ID
                        ;;
                    *)
                        echo "Ubuntu $VERSION_ID is not supported!" >&2
                        exit 2
                esac

                # Import the public repository GPG keys
                curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

                curl "$base_url/config/$distro/$version/prod.$ext" | sudo tee $repo
                ;;
            *)
                echo "$NAME is not supported!" >&2
                exit 2
        esac
        ;;
    darwin*)
        if hash brew 2>/dev/null; then
            brew update

            brew tap caskroom/cask
        else
            echo "ERROR: Homebrew is not installed! Aborting..." >&2
            exit 1
        fi
        ;;
    *)
        echo "$OSTYPE is not supported!" >&2
        exit 2
        ;;
esac

if [[ ! -r "$repo" ]]; then
    echo "ERROR: Failed to set $repo! Aborting..." >&2
    exit 3
fi

# Installs PowerShell package
case "$OSTYPE" in
    linux*)
        source /etc/os-release
        # Install dependencies
        echo "Installing PowerShell with sudo..."
        case "$ID" in
            centos)
            rhel)
                # yum automatically resolves dependencies for local packages
                sudo yum install -y powershell
                ;;
            fedora)
                # Update the list of products
                sudo dnf update

                # Install PowerShell
                sudo dnf install -y powershell
            opensuse)
                # Update the list of products
                sudo zypper update

                # Install PowerShell
                sudo zypper install powershell
                ;;
            debian)
            ubuntu)
                # Update the list of products
                sudo apt-get update

                # Install PowerShell
                sudo apt-get install -y powershell
                ;;
            *)
                echo "$NAME is not supported!" >&2
                exit 2
        esac
        ;;
    darwin*)
        brew cask install powershell
        ;;
    *)
        echo "$OSTYPE is not supported!" >&2
        exit 2
esac

powershell -noprofile -c '"Congratulations! PowerShell is installed at $PSHOME"'
success=$?

if [[ "$success" != 0 ]]; then
    echo "ERROR: PowerShell failed to install!" >&2
    exit "$success"
fi
