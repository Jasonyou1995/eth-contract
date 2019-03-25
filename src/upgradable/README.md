# Test 3: Upgradable Contract aka The Proxy Pattern

## Strategies

* Download zos-lib
* Set the contract to inheriate Migratable
* No constructor, but just initializor
* Create a contract, but use delegate contract

1. To create a basic upgradable smart contract system, we will need three basic contracts. They are:
	2. Storage contract
	3. Proxy contract
	4. Logic contact
5. Keeping track of the logic contract, and using the proxy contract to redirect aclls to the latest contract that has the upgraded code.
6. Using the logic contract to write the upgradable piece of code and the storage contrage to keeping track of all the contract states
7. **The proxy uses the latest code from the logic contract to update the state of the storage contract.**
8. `delegatecall` allows one contract to execute code from another contract while keeping the context of the caller, including its storage. 
9. Check for the destination contract’s existence prior to calling delegatecall. 


## How to deploy and update

1. Deploy the **proxy** and **logic** contract separately (storage is just an abstract contract, so is handled by the proxy contract).
2. Using  the `changeLogic` function call in the **proxy** contract to update the `logicContract` whenever we want to update. (note that we need to call this function to make proxy contract usable)

## Environment Setup

First we will need to separate the ERC223.sol into three contracts:

* ERC223-storage.sol
	* All the global variables will be in this contract
* ERC223-proxy.sol
	* We will have multiple delegate calls here
* ERC223-logic-i.sol    // this is the i-th logic contract we deployed
	* All the functions will be in here


## Deployment to Rinkeby

* ERC223-proxy: 0x01a68225989a33ca1aa8d4d4558e454102620537
                0x74c8c2d5644f8be7b51c69624237757ef580d0b1
* ERC223-logic-1: 0x7610f02a541901f6cb44d411c4dd1c3bfb0660ff
                0xa30e5fe207f6da238ca45a886708108eea674fb2  
