// Author:      Jason You
// Modified:    March 22 2019
//
// Find gas usage for all functions in you contract.

/**********************************************************/
/************ Modules And My Helper Functions *************/
/**********************************************************/

/* Setting up the web3.js so it talks to our local Geth Rinkeby client */
var Web3    = require('web3');
// var web3    = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));    // geth --rinkeby
var web3    = new Web3("http://localhost:8545");
var helper  = require('./helper.js');

console.log("This script is based on web3.version: 1.0.0-beta.50\n" +
            "Current web3.version: " + web3.version);

/**********************************************************/
/************** Setting Up Contract Instance **************/
/**********************************************************/

/* Create an instance of our ERC223 token contract */
var contractAddress = '0x147a74032017eA0cfD327b9bb564d1988891392c';
var ERC223ABI       = require('./ERC223ABI.json');  // minified ABI
var contract        = web3.eth.Contract(ERC223ABI, contractAddress);    // instance

/**********************************************************/
/**************** Validating User Inputs ******************/
/**********************************************************/

const args = process.argv.slice(2);

if (args.length != 0) { throw new Error("No argument needed. Usage: node 2-you18-2"); }


/**********************************************************/
/******* Estimate Gas Cost For Each Function **************/
/**********************************************************/
    
console.log("***********************************************************************\n" +
            "        Starting To Estimate The Gas Cost For Each Function            \n" +
            "***********************************************************************\n")

helper.estimateGas(web3, contract);

console.log("Infinite gas hided");

/*
    My Rinkeby Test Accounts:
    ["0x5401844eee6f03dd797c99e26af7238200803ddb", "0x48e97a8ad5644d898df2b9555d15298c81046917"]
*/
