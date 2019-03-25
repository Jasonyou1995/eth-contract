#!/bin/bash


brew update
brew upgrade go
brew upgrade ethereum

# Add writing permission
chmod -R a+w ./node_modules

# update other npm packages
npm install truffle@latest
npm install web3

# update the solc of truffle
cd ./node_modules/truffle
npm install solc@latest
