#!/bin/bash


# Author: Jason You All Rights Reseved

# TODO: Check if the packages are installed, if so just update

# return 1 if function not installed
func_exist() {
	if [[ $# -ne 1 ]]; then
		echo "Error: only accept one argument"
		return 1
	fi

	type ${1} >/dev/null 2>&1;
	
	if [[ $? -ne 0 ]]; then
		return 1
	fi

	return 0
}

# This script helps you to install everything needed to build smart contract
# This script is for MacOS ONLY.

echo
echo "Starting to check and install dependencies..."
echo

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
func_exist ganache-cli
if [[ $? -ne 0 ]]; then
	npm install ganache-cli@beta
fi

echo
echo "...All installation finished!"
echo

# Build alias
source SetAlias.sh
if [[ $? -ne 0 ]]; then
	echo "Somthing went wrong in setting alias, please check './SetAlias.sh' for path"
	echo "Maybe you didn't install truffle and ganache-cli in local with npm."
fi


