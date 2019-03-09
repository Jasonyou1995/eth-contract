# Ethereum Smart Contract Development

## Introduction

<!--&nbsp; is for space, &ensp; might works?-->
## Tools and Environments

### Installing tools

* Before you start, please run the `./InstallDependencies.sh` script. You might need to run: `chmod a+x ./InstallDependencies.sh` first

### Environments

* Golang = go version go1.11.4 darwin/amd64
* geth (go-ethereum) = 1.8.22-stable
* npm &nbsp;= v6.9.0
* node = v11.10.1
* Truffle = v5.0.7
* Solidity = v0.5.0
* Ganache-cli (prev. TestRPC) = v6.3.0-beta.0 (ganache-core: 2.4.0-beta.0)

### Version Check

	$ geth version
	Geth
	Version: 1.8.22-stable
	Architecture: amd64
	Protocol Versions: [63 62]
	Network Id: 1
	Go Version: go1.11.5
	...

	$ truffle version
	Truffle v5.0.7 (core: 5.0.7)
	Solidity v0.5.0 (solc-js)
	Node v11.10.1

	$ ganache-cli --version
	Ganache CLI v6.3.0-beta.0 (ganache-core: 2.4.0-beta.0)

		
### Notes for dependencies:

1. Sometimes **Solidity compiler** is aliased as `solcjs`;
2. It is recommended that **node packages be installed locally**:
	3. First initialize a directory by `$ npm init`
	4. Then run `$ npm install tructtle` to install truffle locally
	3. Add the alias of truffle by `$ alias truffle=’node_modules/truffle/build/cli.bundled.js’`
	4. Check the installation: `$ truffle --version`
5. There are two reasons **why the beta version of ganache-cli is used**. The first reason is because of the support for web sockets. The second reason is that it supports web with versions (≥ 1.0.0).
6. Updating go-ethereum:
	7. MacOS: (in installed with brew)
		8. `$ brew update; brew upgrade ethereum`
	8. Linux:
		9. `$ sudo apt-get update && sudo apt-get upgrade`
	9. [Or find other references...](https://www.reddit.com/r/ethereum/comments/3fwyto/how_to_update_geth/)

Update/Install guides:

* [Update Node.js](https://solarianprogrammer.com/2016/04/29/how-to-upgrade-nodejs-mac-os-x/), or you can check the [StackOverflow answer](https://stackoverflow.com/questions/34810526/how-to-properly-upgrade-node-using-nvm)
* [Install Truffle](https://truffleframework.com/docs/truffle/getting-started/installation)

## Getting started with Contract Development

## Tasks

## Deliverables


## Resources

[Truffle Framework](https://truffleframework.com/)

[Truffle suite ganache-cli](https://github.com/trufflesuite/ganache-cli)

[Go ETH](https://github.com/ethereum/go-ethereum)

[Solidity](https://github.com/ethereum/solidity)

[Solidity Documentation](https://solidity.readthedocs.io/en/latest/index.html)

[Node.js](https://nodejs.org/en/)

[NPM JS](https://www.npmjs.com/)

bhat24@purdue.edu

Piazza Resources

[Zeppelinos](https://github.com/zeppelinos/zos)

