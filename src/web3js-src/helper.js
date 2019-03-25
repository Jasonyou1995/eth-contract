// Author:      Jason You
// Modified:    March 22 2019
//
// This script stores all helper functions to the demo scripts



module.exports = {

  /********************************************
   ***************** Demo 1 *******************
   ********************************************/


  /**
   * @dev:        print out all the transactions send to our contract address.
   * @param we3:  the module used to connect to web3.js API.
   * @account:    the address we used to search for incoming transactions.
   * @startBlock: the starting block of search.
   * @endBlock:   the ending block of search.
   */
  getTxToByAccount: function(web3, account, startBlock, endBlock) {
    // check all validities
    if (web3 == null) {
      throw new Error("web3 is not defined, check your module setup.")
    } else if (!this.isAddress(account)) {
      throw new Error("Got illegal address format.")
    } else if (startBlock > endBlock) {
      throw new Error("Start block must be smaller than or equals to the end block.")
    }

    // print out arguments passed by client
    console.log("Account: \t" + account + "\n" +
                "Start Block: \t" + startBlock + "\n" +
                "End Block: \t" + endBlock);

    // search in each block for the tx that send to our account/address
    for (var i = startBlock; i < endBlock; i++) {
      if (i % 1000 == 0) {
        // update the searching block index
        console.log("[+] Searching block " + i + "...");
      }

      // get the i-th block and let it return the full transaction block
      web3.eth.getBlock(i, true).then((block) => {
        if (block != null && block.transactions.length != 0) {
          // only deal with non-null blocks
          var txs = block.transactions;
          txs.forEach((tx) => {
            // get the address each tx sending to
            var to = tx.to;
            if (to != null && account.toUpperCase() == to.toUpperCase()) {
              // FOUND ONE VALID Tx! Print Details.
              console.log(
                      "\n------------------------------------------------------------------------\n" +
                      "[txHash]: \t\t" + tx.hash + "\n" +
                      "blockHash: \t\t" + tx.blockHash + "\n" +
                      "blockNumber:\t\t" + tx.bolockNumber + "\n" +
                      "from: \t\t\t" + tx.from + "\n" +
                      "to: \t\t\t" + tx.to + "\n" +
                      "transactionIndex:\t" + tx.transactionIndex + "\n" +
                      "gas:\t\t\t" + tx.gas + "\n" +
                      "gasPrice:\t\t" + tx.gasPrice + "\n" +
                      "nonce:\t\t\t" + tx.nonce + "\n" +
                      "value:\t\t\t" + tx.value +
                      "\n------------------------------------------------------------------------\n"
              )
            }
          });
        }
      }).catch(console.log);
    }
  },


  /********************************************
   ***************** Demo 2 *******************
   ********************************************/


  /**
   * @dev:        Find all the instance of the deployed contract based on our ERC223
   *              token smart contract with solc version 5.6.0
   * @param we3:  the module used to connect to web3.js API.
   * @address:    the address that we deployed our original contract instance.
   * @startBlock: the starting block of search.
   * @endBlock:   the ending block of search.
   */
  getContractInstance: function (web3, myTxHash, startBlock, endBlock) {
    // check all validities
    if (web3 == null) {
      throw new Error("web3 is not defined, check your module setup.")
    } else if (startBlock > endBlock) {
      throw new Error("Start block must be smaller than or equals to the end block.")
    }

    // print out arguments passed by client
    console.log("myTxHash: \t" + myTxHash + "\n" +
                "Start Block: \t" + startBlock + "\n" +
                "End Block: \t" + endBlock);

    // first get the bytecode from the original contract instance
    web3.eth.getTransaction(myTxHash).then(myTx => {
      for (var i = startBlock; i <= endBlock; i++) {
        // ?? get each block (or just contract) code
        if (i % 1000 == 0) {
          // update the searching block index
          console.log("[+] Searching block " + i + "...");
        }
        // get the i-th block and let it return the full transaction block
        web3.eth.getBlock(i, true).then((block) => {
          if (block != null && block.transactions.length != 0) {
            // only deal with non-null blocks
            var txs = block.transactions;
            txs.forEach((tx) => {
              if (tx.to == null)  {
                // Contract creation will have 'to' == null
                // get the bytecode deployed in this address
                if (tx.input == myTx.input) {
                  // FOUND AN INSTANCE OF OUR CONTRACT!
                  // get the contract address through tx receipt
                  web3.eth.getTransactionReceipt(tx.hash).then((receipt) => {
                    console.log(
                      "\n------------------------------------------------------------------------\n" +
                      "[Contract Address]: \t" + receipt.contractAddress + "\n" +
                      "txHash: \t\t" + tx.hash + "\n" +
                      "------------------------------------------------------------------------\n")
                  }).catch(console.log);
                }
              }
            });
          }
        }).catch(console.log);
      }
    }).catch(console.log);
  },


  /********************************************
   ***************** Demo 3 *******************
   ********************************************/

  estimateGas: function(web3, contract) {

    /************ Print Table Header **************/
    console.log("   Function \t\tCosts\n" +
                "------------------------------");

    /************** registerMe *******************/
    // contract.methods.registerMe("Jason").estimateGas({
    //   gas: 5000000,
    //   from: "0x5401844eee6f03dd797c99e26af7238200803ddb"
    // }).then((gasAmount) => {
    //   console.log("isRegistered \t\t" + gasAmount);
    // }).catch(console.log);


    /************** isRegistered *****************/
    contract.methods.isRegistered("Jason", "0x5401844eee6f03dd797c99e26af7238200803ddb").estimateGas({
      gas: 5000000,
      from: "0x5401844eee6f03dd797c99e26af7238200803ddb"
    }).then((gasAmount) => {
      console.log("isRegistered \t\t" + gasAmount);
    }).catch(console.log);

    /**************** balanceOf *****************/
    contract.methods.balanceOf("Jason").estimateGas({
      gas: 5000000,
      from: "0x5401844eee6f03dd797c99e26af7238200803ddb"
    }).then((gasAmount) => {
      console.log("balanceOf \t\t" + gasAmount);
    }).catch(console.log);


    /************* transfer 1 (with data) *************/
    // contract.methods.transfer(
    //   "0x5401844eee6f03dd797c99e26af7238200803ddb",
    //   "0x48e97a8ad5644d898df2b9555d15298c81046917",
    //   "10"    // 10 ERC223 tokens, not Ether nor Wei
    // ).estimateGas({
    //   gas: 5000000,
    //   from: "0x5401844eee6f03dd797c99e26af7238200803ddb"
    // }).then((gasAmount) => {
    //   console.log("balanceOf \t\t" + gasAmount);
    // }).catch(console.log);

    /************* transfer 2 (w.o. data) **************/
    // contract.methods.transfer(
    //     "0x5401844eee6f03dd797c99e26af7238200803ddb",
    //     "0x48e97a8ad5644d898df2b9555d15298c81046917",
    //     "10",    // 10 ERC223 tokens, not Ether nor Wei
    //     web3.utils.hexToBytes('0x1234567890abcdef')
    //   ).estimateGas({
    //     gas: 5000000,
    //     from: "0x5401844eee6f03dd797c99e26af7238200803ddb"
    //   }).then((gasAmount) => {
    //     console.log("balanceOf \t\t" + gasAmount);
    //   }).catch(console.log);
    },


  /********************************************
   *********** Helper Functions ***************
   ********************************************/

  // Check if given address is a legal ETH address, which depends on the
  // 'isChecksumMatch()' function below.
  isAddress: function(address) {
    // Address can start with 0x, and must be 40 characters long and
    // contains only digits and letters from a to f or A to F.
    minRegexFormat = /^(0x)?[0-9a-fA-F]{40}$/i;
    allLowerFormat = /^(0x)?[0-9a-f]{40}$/i;
    allUpperFormat = /^(0x)?[0-9A-F]{40}$/i;

    if (!minRegexFormat.test(address)) { 
      return false;
    } else if (allUpperFormat.test(address) ||
               allLowerFormat.test(address)) {
      return true;
    } else {
      return isChecksumMatch(address);
    }
  },
  // Check the casemap checksum of Ethereum address
  isChecksumMatch: function(address) {
    address = address.replace('0x', '');
    var addressHash = web3.sha3(address.toLowerCase());
    for (var i = 0; i < 40; i++) {
      if (parseInt(addressHash[i], 16) > 7 && address[i].toUpperCase() !== address[i]) {
        // This char should be uppercase if parsed hexadecimal integer is greater than 7.
        return false;
      } else if (parseInt(addressHash[i], 16) <= 7 && address[i].toLowerCase() !== address[i]) {
        // This char should be lowercase if parsed hexadecimal integer is less than 7.
        return false;
      }
    }
    return true;
  },
  checkAllBalances: function() {
      var i = 0;
      web3.eth.accounts.forEach( function(e) {
          console.log(" web3.eth.accounts[" + i + "]:" + e + " \tbalance: " + web3.fromWei(web3.eth.getBalance(e), "ether") + " ether")
      });
  }
};
