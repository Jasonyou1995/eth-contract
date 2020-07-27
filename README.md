# Ethereum ERC223 Smart Contract Development


## Introduction

This project demonstrates a fully functioning ERC223 token deployed on the Rinkeby test network. You can use Remix web compiler to compile and deploy, or you can setup your own local environment with **Truffle suit** to test the behavior of this smart contract.

I listed all the environment dependencies in the next section, and you can easily install all of them with `./init.sh` in this directory.

After that you can run `npm install` to start this project. More details about how to compile and migrate with truffle will be covered in the later sections

**Note:** In the `./src` directory I implemented the upgradable version of this contract with proxy pattern, and several node.js scripts that interact with our deployed smart contract with web3.js.


<!--&nbsp; is for space, &ensp; might works?-->
## Tools and Environments

### Installing tools

* Each time before you start the app in a new bash, please run the `./init.sh` script to *install all the dependencies* and *initialize the dependencies locally*.
* You might need to run: `chmod a+x ./init.sh` first to make this script executable.

### Environment and dependencies

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
* [How to upgrade solidity compiler in Truffle?](https://ethereum.stackexchange.com/questions/17551/how-to-upgrade-solidity-compiler-in-truffle)
	* We just need to re-install the latest version of *solc* in the local Truffle directory.

## Tasks

All the application building and development notes are in the ./`HowToBuild.md` file

### Training Wheels

Our implementation is based on the modified ERC223 interface. For more development reference, please check the [Solidity documentation](https://solidity.readthedocs.io/en/latest/). The functions are:

	function registerMe(string memory myName) public payable returns (bool);
	function isRegistered(string memory name, address addr) public view returns (bool);
	function balanceOf(string memory who) public view returns (uint);
	function transfer(string memory from, string memory to, uint value, bytes memory data) public returns (bool);
	event Transfer(string from, string to, uint value, bytes data);
	
	
**Some design ideas:**
-----

Since ERC223 can be considered as an upgrade of ERC20 token, I first checked the [implmentation of OpenZeppeline for ERC20](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol). Here are the notes:

* Using the `SafeMath.sol` package: here I get it from the OpenZeppelin
* Understanding the function *modifiers* first:
	* `pure` for **functions**: Disallows modification or access of state. (They are view functions with the additional restriction that their value only depends on the function arguments)
		* This means they cannot use SSTORE, SLOAD, cannot send or receive ether, cannot use msg or block and can only call other pure functions.
	* `view` for **functions**: Disallow modification of state. (This modifier replaces the *constent* modifier for function)
		* This means such functions cannot use SSTORE, cannot send or receive ether and can only call other view or pure functions.
	* `payable` for **functions**: Allows them to receive Ether together with a call.
	* `constant` **for state variables**: Disallows assignment (except initialization); it does not occupy storage slot.
		* The keyword constant is invalid on functions
		* The keyword constant on any variable means it cannot be modified (and could be placed into memory or bytecode by the optimiser).
	* `anonymous` **for events**: Does not store event signature.
	* `indexed` **for event parameters**: Stores the parameter as topic.
	* `internal`: enforece that the function can only be called by 1) addresss that this contract instance belongs to, and 2) this specific contract instance of the contract instances that are derived from this contract. (Note: (1) is enfored by EVM)


	
**[Block and Transaction Properties](https://solidity.readthedocs.io/en/develop/units-and-global-variables.html?highlight=msg.value#block-and-transaction-properties)**

* `msg.data (bytes)`: complete calldata
* `msg.gas (uint)`: remaining gas - deprecated in version 0.4.21 and to be replaced by gasleft()
* `msg.sender (address)`: sender of the message (current call)
* `msg.sig (bytes4`): first four bytes of the calldata (i.e. function identifier)
* `msg.value (uint)`: number of wei sent with the message

**[Error Handling](https://solidity.readthedocs.io/en/develop/control-structures.html#assert-and-require)**

* The `assert` function should only be used to test for internal errors, and to check invariants.
* The `require` function should be used to ensure valid conditions, such as inputs, or contract state variables are met, or to validate return values from calls to external contracts.
* There are two other ways to trigger exceptions: The `revert` function can be used to flag an error and revert the current call. It is possible to provide a string message containing details about the error that will be passed back to the caller.

*Note that assert-style exceptions consume all gas available to the call, while require-style exceptions will not consume any gas starting from the Metropolis release.*

### Web Front End Development

#### How to deploy contract on Rinkby

1. Geth connection: `geth --rinkeby --rpc --rpcapi="personal,eth,network,web3,net" --ipcpath "~/Library/Ethereum/geth.ipc"`
	2. Notice that before the "fast sync (by default)" totally finish, the last available block number will always be 0.... So just be patient and wait for a few more hours...
	3. [Reference for issues](https://github.com/ethereum/mist/issues/3738#issuecomment-390892738)
2. In another console type: `geth --datadir=$HOME/.rinkeby attach ipc:$HOME/Library/Ethereum/geth.ipc console`
3. Creating a rinkby account: `geth --rinkeby account new`
5. In the geth console
	5. Check the accounts in the geth console: `eth.accounts`
	6. Check the syncing: `eth.syncing`
		7. Note if the output is **false**, that is file, but if it shows an JSON object, then you probably still need to wait the state to up to date.
	7. Unlock you account: `personal.unlockAccount(eth.accounts[0], null, 1200)
8. Set up the Truffle: after everything, remember to **add the rinkeby into network** in the truffle.js configuration file!

		module.exports = {
			networks: {
				rinkeby: {
					host: "localhost",
					port:8545,
					network_id: 4,
					gas: 4700000
				}
			}
		}
9. Migrate to the rinkeby network with truffle: `truffle migrate --reset --compile-all --network rinkeby`
	10. Interface and abstract functions should just be **imported, and not deployed with migration!**
10. Find the contrct address you just deployed: through the *./build/contract/<you-contract-name>.json* in the bottom find the **network** with id 4 and "address".
	11. Then copy and define this address in the geth console: `var contractAddress = "<the-copied-address>"`.
11. Next step is to **find the contract ABI** in the same .json file and then minify it will online tools. Then copy and build a variable for it as well in the geth console you opened. `var ContractABI = <minified-ABI>`
	12. Note: here we must **use JSON object, and not string**!
12. Build a contract variable: `var myContract = web3.eth.contract(contractABI)`
13. Get the instance of the contract: `var myContractInstance = myContract.at(contractAddress)`
14. Call function now: `myContractInstance.function_name(param)`


#### [Using Truffle HD Wallet and INFURA to interact with Ropsten network](https://www.youtube.com/watch?v=H52Z0R1M_n0)

* First modify the `truffle.js` configuration network with Ropsten, and here put your INFURA APIKEY into the provider function.
	* Set the **provide, gasPrice, network_id** fields accordingly. Notice that the network id of Ropsten is 3 (and is 4 for Rinkeby).


			ropsten: {
		      provider: function() {
		        return new HDWalletProvider(
		          process.env.MNEMONIC,
		          `https://ropsten.infura.io/${process.env.INFURA_API_KEY}`
		          )
		      },
		      gasPrice: 25000000000,
		      network_id: 3
		    }
	    
	* Notice that here we use the bash environment variables, which is accomplished with `require('dotenv').config(); `. We also need `const HDWalletProvider = require('truffle-hdwallet-provider');` to set the provider.
	* Here MNEMONIC is 

* `truffle console --network ropsten`
* Notice that all the eth. functions are async, so you should provide some functions like `(err, response) => { console.log(response) }) into the argument field.
* 

#### Difference between Ganache (TestRPC) and GETH (private or testnet)

Ganache is ETH blockchain client simulator that mimic the bahaviors of a testnet or blockchain, and the advantage of this is that development can be very fast and no need to wait the block downloading and states syncing as using testnet.

Geth is a real client that can be used to deploy Dapps on testnet, private network or mainnet. So it is always wise to test your applicaiton on Geth client before publish it.

References:

* [What are the difference between TestRPC and geth?](https://ethereum.stackexchange.com/questions/9347/what-is-the-difference-between-testrpc-and-geth)
* [Test networks](http://ethdocs.org/en/latest/network/test-networks.html#test-networks)

#### Using Node.JS to Interact with the contract






####[Web3.js Tutorial](http://www.dappuniversity.com/articles/web3-js-intro)

* What is Web3.js?
	* Give us a way to build a web site that can talk to a server/API that can interact with smart contracts.
	* You can use it either through your local server that syncing with testnet or mainnet with Geth client, or you can using INFURA API to access remote nodes.
	* `var Web3 = require('web3');`
	* `var url = 'listening 'https://host:port';  // the Ethereum network node that is listening`
	* `var web3 = new Web(url);`
	* 
* What are the information we can get?
	* Interacting with accounts
		* You use the account (address) to represent yourself in the Ethereum blockchain network.
		* All the web3 function call with INFURA service provider will be async, thus you will need to provide a **callback function** as the last argument in each function. For example: `web3.eth.getBalance(address, (err, bal) => { balance = bal // global var };`
		* You can create an account easily with web3: `web3.eth.accounts.create()`, but be really careful about the private key and security issues (not recommanded in this way).
* What are the platforms that can use web3.js?
	* Geth: local client (need to download the huge blockchain and world states)
	* Ganache (TestRPC): simulator of the Ethereum blockchain
		* `var web3 = new Web3('http://localhost:port-ganache-listening-on');`
		* This is useful because the behaviors of Ethereum blockchain networks (such as mainnet, testnet, and private network) are similar, so development and configuration of Dapp can start from Ganache and save a lot of waiting time for syncing and waiting blocks to be mined.
	* INFURA remote node API
* How to interact with **smart contract** with web3.js?
	* Required arguments: **ABI** and **address**
		* ABI: help the web3 to know the bytecode and what are the functions exists.
		* address: the location of the contract.
	* We can choose to interact with the ERC223 token contract we deployed:

			$ node
			> var Web3 = require('web3')
			> var web3 = new Web3('http://127.0.0.1:8545')  // we use Rinkeby here with geth
			// both the contract address and ABI can be found in the ./build/<contract-name>.json file. With address in the "network" field, and ABI in the "abi" field.
			> var contractAddress = '0x147a74032017eA0cfD327b9bb564d1988891392c'
			> var ERC223ABI = [{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function","signature":"0x18160ddd"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function","signature":"0x8da5cb5b"},{"constant":true,"inputs":[],"name":"remainingSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function","signature":"0xda0239a6"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor","signature":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"from","type":"string"},{"indexed":false,"name":"to","type":"string"},{"indexed":false,"name":"value","type":"uint256"},{"indexed":false,"name":"data","type":"bytes"}],"name":"Transfer","type":"event","signature":"0xe8cca054678291c72a36fdd68416aea936e6b2720caa266fa5070fbae858d191"},{"constant":false,"inputs":[{"name":"myName","type":"string"}],"name":"registerMe","outputs":[{"name":"","type":"bool"}],"payable":true,"stateMutability":"payable","type":"function","signature":"0x218add39"},{"constant":true,"inputs":[{"name":"name","type":"string"},{"name":"addr","type":"address"}],"name":"isRegistered","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function","signature":"0xbd290b81"},{"constant":true,"inputs":[{"name":"who","type":"string"}],"name":"balanceOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function","signature":"0x35ee5f87"},{"constant":false,"inputs":[{"name":"from","type":"string"},{"name":"to","type":"string"},{"name":"value","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function","signature":"0x9b80b050"},{"constant":false,"inputs":[{"name":"from","type":"string"},{"name":"to","type":"string"},{"name":"value","type":"uint256"},{"name":"data","type":"bytes"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function","signature":"0xacbae75e"}]
			> var contract = web3.eth.Contract(ERC223ABI, contractAddress)  // this creates an instance for the contract
			> // to read from a smart contract
			> // TODO: list all the accounts
			> contract.accounts
			
##### More details in the [web3.eth.Contract](https://web3js.readthedocs.io/en/1.0/web3-eth-contract.html)

* We can `.cal()` or `.send()` our contract which will either change the state, or not change the state.
* 

*The Function Calls to the ERC223 token deployed*

**totalSupply:**

`> contract.methods.totalSupply().call({from: '0x5401844eee6f03dd797c99e26af7238200803ddb'}, (err, result) => { console.log(result) })	// notice the address 'from' is not necessary here`

**remainingSupply:**

`> contract.methods.remainingSupply().call({}, (err, result) => { console.log(result) })`

**owner:**

`> contract.methods.owner().call({}, (err, result) => { console.log(result) })`

**function registerMe(string) public payable:**

This is a send() operation to the function, and will modify the state of the blockchain. So we must provide the 'from' address here.

`> contract.methods.registerMe("Jason").send({from: '0x5401844eee6f03dd797c99e26af7238200803ddb'}, (err, result) => { console.log(result) })`

**function isRegistered(string, address) public view:**

Note: you may need to unlock your account in the geth console attached to this specific network (Rinkeby in here).

`> contract.methods.registerMe("Jason").send({from: '0x5401844eee6f03dd797c99e26af7238200803ddb', value: 1e16}).then(console.log)`

**function balanceOf(string) public view returns (uint):**

`> contract.methods.balanceOf("Jason").call({from: '0x5401844eee6f03dd797c99e26af7238200803ddb'}).then(console.log)`

**function transfer(string memory from, string memory to, uint value) public:**

Warn: here we are burning the tokens by transfering them to an address that is very unlikely to fund its private key. (0x followed with 42 0's)

`> contract.methods.transfer("0x5401844eee6f03dd797c99e26af7238200803ddb", "0x0000000000000000000000000000000000000000", 1).send({from: "0x5401844eee6f03dd797c99e26af7238200803ddb"}).then(console.log)`



**function transfer(string memory from, string memory to, uint value, bytes memory data) public:**




**Dependencies**

First we will need to interact with our smart contract with NodeJS on the rinkeby test network with web3js 1.0.

First step is to initiate the folder, which we already did: run `npm init` in the folder that want to store all the source codes.

Using the following code to install some dependencies:

	npm install web3 --save
	npm install express --save
	npm install ethereumjs-tx --save
	
*Note: Running the* `./init` *bash script will install all of these dependencies for you locally.*
	
**INFURA**

You will need to register on [INFURA](https://infura.io/) and get the API key for Rinkeby for this part to work.

**Start Coding**

* We use web3.js module to interact with ethereum.
* Express.js is used to create a router.
* The ethereumjs-tx is used for creating transactions.


Reference: [Ethereum Tutorial: Sending Transaction via NodeJS Backend](https://medium.com/coinmonks/ethereum-tutorial-sending-transaction-via-nodejs-backend-7b623b885707)

### Gas fee optimization

* Assert can be costly, and contract should eliminate all unnecessary computation
* 


### The security check

* Tools:
	* [truffle-security](https://github.com/ConsenSys/truffle-security)
	* [Sūrya, The Sun God: A Solidity Inspector](https://github.com/ConsenSys/surya)
	* [EVM Lab Utilities](https://github.com/ethereum/evmlab)
	* [Ethereum Graph Debugger](https://github.com/fergarrui/ethereum-graph-debugger)
	* [Securify](https://securify.chainsecurity.com/)
	* [solidity-coverage](https://github.com/sc-forks/solidity-coverage)
* Methodologies
	* 


### FAQ
1. [Where is the IPC file, and how to produce it?](https://ethereum.stackexchange.com/questions/1492/when-is-the-geth-ipc-file-produced)
2. How to update the local ETH Rinkeby testnet?
3. `geth --rinkeby --rpc --rpcapi="personal,eth,network,web3,net" --ipcpath "~/Library/Ethereum/geth.ipc"`
	4. [tutorial for geth...](https://hackernoon.com/hands-on-creating-your-own-local-private-geth-node-beginner-friendly-3d45902cc612): `geth` is the CLI for running a full ethereum node implementation in Go. You can use geth to mine real Ether if you are on mainnet, transfer funds between addresses, create smart contracts, make transactions, explore the chain information, use Web3.JS etc. To learn more, please visit the [Github Wiki for Go-ethereum](https://github.com/ethereum/go-ethereum/wiki/geth).
	4. [Geth JavaScript console](https://github.com/ethereum/go-ethereum/wiki/JavaScript-Console)
		5. 	Geth has support to load custom JavaScript files into the console through the --preload argument. This can be used to load often used functions, setup web3 contract objects, or ...
		6.  `geth --preload "/my/scripts/folder/utils.js,/my/scripts/folder/contracts.js" console`
	7. JSON-RPC
		8. [Definition of JSON-RPC](https://www.jsonrpc.org/specification)
		9. [Geth JSON RPC API Wiki](https://github.com/ethereum/wiki/wiki/JSON-RPC)

Default JSON-RPC endpoints:

* C++: http://localhost:8545
* Go: http://localhost:8545
* Py: http://localhost:4000
* Parity: http://localhost:8545

Notes on [port numbers for Ethereum client](https://ethereum.stackexchange.com/questions/809/which-tcp-and-udp-ports-are-required-to-run-an-ethereum-client):

> Ethereum clients use a listener (TCP) port and a discovery (UDP) port, both on 30303 by default.

> If you need to run JSON-RPC, you'll also need TCP port 8545. Note that JSON-RPC port should not be opened to the outside world, because from there you can do admin operations.

> All client's ports can be customized from the default.
> 
> [Actively block inbound JSON-RPC (8545)](https://etherscan.io/address/0x957cd4ff9b3894fc78b5134a8dc72b032ffbc464#comments)
> 

**Go**

You can start the HTTP JSON-RPC with the `--rpc` flag

`geth --rpc`

change the default port (8545) and listing address (localhost) with:

`geth --rpc --rpcaddr <ip> --rpcport <portnumber>`

If accessing the RPC from a browser, CORS will need to be enabled with the appropriate domain set. Otherwise, JavaScript calls are limit by the same-origin policy and requests will fail:

`geth --rpc --rpccorsdomain "http://localhost:3000"`

The JSON RPC can also be started from the geth console using the `admin.startRPC(addr, port)` command.

Curl example (using the default port for JSON-RPC):

First run geth: `geth --rpc` or `geth --rpc --rpcaddr <ip> --rpcport <portnumber>`

Then run commends in the JSON-RPC API for Ethereum clients:

`curl -X POST -H "Content-Type:application/json" --data '{"jsonrpc":"2.0","method":"<methodname>","params":["param1", "param2", ...],"id":64}' http://localhost:8545`

SHA3 example with JSON-RPC:

`curl -X POST -H "Content-Type:application/json" --data '{"jsonrpc":"2.0","method":"web3_sha3","params":["0x68656c6c6f20776f726c64"],"id":64}' http://localhost:8545`




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

