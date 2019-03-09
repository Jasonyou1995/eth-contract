#!/bin/bash

# Expand aliases defined in the shell ~/.bashrc
# This  command must be included, otherwise aslias won't works
# Reason:
#  Your ~/.bashrc is only used by interactive shells, and not non-interactive shell.
#  A non-interactive shell. A non-interactive shell is a shell that can not interact
#  with the user. It's most often run from a script or similar. This means that .bashrc
#  and .profile are not executed. It is important to note that this often influences your
#  PATH variable.
# References:
#   https://bash.cyberciti.biz/guide/Shopt,
#   https://stackoverflow.com/questions/44382433/why-bash-alias-doesnt-work-in-scripts
shopt -s expand_aliases

# This script set all the useful environemnt variables.
# Please run this everything before you start this program.

# Set aliases (must export!)
export alias truffle='./node_modules/truffle/build/cli.bundled.js'

alias ganache='./node_modules/ganache-cli/cli.js'

alias solcjs='./node_modules/truffle/node_modules/solc/solcjs'

# Check versions
truffle version
ganache --version
