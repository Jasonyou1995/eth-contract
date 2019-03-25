// Author:      Jason You
// Modified:    March 22 2019
//
// Taks 2.1:    Print all tx made to this contract.
//
// Note:        All the solution source codes are stored in the ./helper.js script

/**********************************************************/
/************ Modules And My Helper Functions *************/
/**********************************************************/

/* Setting up the web3.js so it talks to our local Geth Rinkeby client */
var Web3    = require('web3');
var web3    = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));    // geth --rinkeby
var helper  = require('./helper.js');

console.log("This script is based on web3.version: 1.0.0-beta.50\n" +
            "Current web3.version: " + web3.version);

/**********************************************************/
/**************** Validating User Inputs ******************/
/**********************************************************/

const args = process.argv.slice(2);

if (args.length != 1) {
    throw new Error("Require exactly one argument. Usage: node 2-you18-1 <contractAddress>");
}

var contractAddress = args[0];  // get the contract address from user input

if (!helper.isAddress(contractAddress)) {
    throw new Error("You must give a legitimate Ethereum address.")
}

/**********************************************************/
/******* Printing All Transactions To This Address ********/
/**********************************************************/

var DEBUG = true;   // recommand, cause Client is easy to crush with large query

// get the current block number
web3.eth.getBlockNumber()
.then(currentBlock => {
    if (DEBUG) {
        // TEST with less time (DEBUG)
        var startBlock  = 4072000;
        var endBlock    = 4072200;      
    } else {
        var startBlock  = 4071614;      // Our first contract deployed block
        // [Vulnerability: searching to currentBlock can cause DoS for DAPP easily.]
        // var endBlock = currentBlock;
        var endBlock    = currentBlock;      // Client can crash even with 4074000...
    }
    console.log("***********************************************************************\n" +
                "             Printing The Tx Sent To " + contractAddress +            "\n" +
                "***********************************************************************\n")
    // print out all the transactions send to our contract address
    helper.getTxToByAccount(web3, contractAddress, startBlock, endBlock);
    
}).catch(console.log);
