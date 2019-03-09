#!/bin/bash


# Author: Jason You All Rights Reseved

# TODO: Check if the packages are installed, if so just update

# return 1 if function not installed
func_exist() {
	if [[ $# -ne 1 ]]; then
		echo "[-] Error: only accept one argument"
		return 1
	fi

	type "$1" >/dev/null 2>&1;
	
	if [[ $? -ne 0 ]]; then
		return 1
	fi

	return 0
}

# This script helps you to install everything needed to build smart contract
# This script is for MacOS ONLY.

echo
echo "[+] Starting to check and install dependencies..."
echo

# Try to setup all proper aliases first
chmod a+x ./SetAlias.sh
source ./SetAlias.sh 2>&1

# Install homebrew
func_exist brew
if [[ $? -ne 0 ]]; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install Node.js and NPM
func_exist node
if [[ $? -ne 0 ]]; then
	brew install node
fi

# Install Git
func_exist git
if [[ $? -ne 0 ]]; then
	brew install git
fi

# Install Go Binary
func_exist go
if [[ $? -ne 0 ]]; then
	brew install go
	# Export GOPATH 
	export PATH=${HOME}/go/bin:$PATH
fi

# Install geth
func_exist geth
if [[ $? -ne 0 ]]; then
	brew update; brew install ethereum
fi

# Install truffle (Solidity Compiler is 'solc' is also installed)
func_exist truffle
if [[ $? -ne 0 ]]; then
	npm install truffle
fi

# Install ganache-cli (prev. TestRPC)
func_exist ganache
if [[ $? -ne 0 ]]; then
	npm install ganache-cli@beta
fi

echo
echo "[+] ...All installation finished!"
echo


echo
echo "[+] Starting the set asliaes..."
echo
# Build alias
source SetAlias.sh
echo
echo "[+] ...All denpendency setup finished!"
echo


echo
echo 'Below are the dependencies we checked'
echo
echo '--------------------------------------'
echo '|   Installed   |   Invoke Command    |'
echo '--------------------------------------'
echo '--------------------------------------'
echo '|   Homebrew    |   $ brew            |'
echo '--------------------------------------'
echo '|   Node.js     |   $ node            |'
echo '--------------------------------------'
echo '|   NPM         |   $ npm             |'
echo '--------------------------------------'
echo '|   Git         |   $ git             |'
echo '--------------------------------------'
echo '|   Golang      |   $ go              |'
echo '--------------------------------------'
echo '|   Go-Ethereum |   $ geth            |'
echo '--------------------------------------'
echo '|   Truffle     |   $ truffle         |'
echo '--------------------------------------'
echo '|   Ganache-cli |   $ ganache         |'
echo '--------------------------------------'
echo '|   Solc-js     |   $ solcjs          |'
echo '--------------------------------------'
echo

