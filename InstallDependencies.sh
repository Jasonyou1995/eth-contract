#!/bin/bash


# Author: Jason You All Rights Reseved

# TODO: Check if the packages are installed, if so just update

# This script helps you to install everything needed to build smart contract
# This script is for MacOS ONLY.

# Install homebrew
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install Node.js and NPM
brew install node

# Install Git
brew install git

# Install Go Binary
brew install go
# Export GOPATH 
export PATH=${HOME}/go/bin:$PATH

# Install geth
brew update; brew install ethereum

# Install truffle (Solidity Compiler is 'solc' is also installed)
npm install truffle

# Install ganache-cli (prev. TestRPC)
npm install ganache-cli@beta

# Build alias
sourse ./SetAlias.sh

