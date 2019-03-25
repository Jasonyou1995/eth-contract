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
echo "[+] Starting to check and install dependencies......"
echo

# Try to setup all proper aliases first
chmod a+x ./SetAlias.sh
source ./SetAlias.sh >/dev/null 2>&1

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
# After installing, run `geth account new` to create an account on your node.
func_exist geth
if [[ $? -ne 0 ]]; then
	brew tap ethereum/ethereum
	brew install ethereum
fi

# Install truffle (Solidity Compiler is 'solcjs' is also installed)
func_exist truffle
if [[ $? -ne 0 ]]; then
	npm install truffle
fi

# Install ganache-cli (prev. TestRPC)
func_exist ganache
if [[ $? -ne 0 ]]; then
	npm install ganache-cli@beta
fi

# check the web3.js
npm view web3 version >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
	npm install web3
fi

# check the express.js
npm view express version >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
	npm install express
fi

# check the ethereumjs-tx
npm view ethereumjs-tx version >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
	npm install ethereumjs-tx
fi

# check the bootstrap
npm view bootstrap version >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
	npm install bootstrap
fi

# First check if the docker is running
docker version >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
	echo "You must install Docker and run it on the local machine"
	return 1
fi


echo
echo '+++ Below are the dependencies we checked +++'
echo
echo '--------------------------------------'
echo '|   INSTALLED   |  COMMAND TO INVOKE  |'
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
echo '|   Web 3       | N/A (import in node)|'
echo '--------------------------------------'
echo '| ethereumjs-tx | N/A (import in node)|'
echo '--------------------------------------'
echo '|  bootstrap    | N/A (used in html)  |'
echo '--------------------------------------'
echo '|	  express     |   $ express         |'
echo '--------------------------------------'
echo '| solc (docker) |   $ solc            |'
echo '--------------------------------------'
echo

# install solc stable with docker
docker run ethereum/solc:stable --version

echo
echo " ......All installation finished!"
echo

# Make sure the files are executable
chmod a+x ./update.sh
chmod a+x ./SetAlias.sh

# Update dependencies
echo
echo "[+] Starting update......"
echo
# source ./update.sh
echo Please run ./update.sh by yourself if needed.
echo
echo " ......All updating finished!"
echo

# Build alias
echo
echo "[+] Setting the asliaes......"
echo
source ./SetAlias.sh
echo
echo " ......Setup finished!"
echo

