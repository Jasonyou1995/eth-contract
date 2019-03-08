#!/bin/bash

# This script set all the useful environemnt variables.
# Please run this everything before you start this program.

echo
echo "Starting the set asliaes..."
echo

# Set aliases
alias truffle='node_modules/truffle/build/cli.bundled.js'
alias ganache-cli='node_modules/ganache-cli/cli.js'
alias solc='./node_modules/truffle/node_modules/solc/solcjs'

# Check versions
truffle version
ganache-cli --version

echo
echo "...All denpendency setup finished!"
echo

