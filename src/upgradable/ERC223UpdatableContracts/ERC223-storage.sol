// Author:          Jason You All Rights Reserved
// Last modified:   March 22 2019
//
// This contract serves as a storage contract.

pragma solidity ^0.4.24;    // notice the compiler version is crucial for proxy

/**
 * Storage contract for all the global variables.
 */
contract State {
    /***********************************/
    /***** Glocal Storage Variables ****/
    /***********************************/
    uint public totalSupply;        // total number of tokens
    uint public remainingSupply;    // remaining supplies
    address public owner;           // owner of this contract
    uint public price;              // (n Wei / ERC223_token)
    
    // Notice we switch these from 'private' to 'internal' for state inheritence
    mapping (string => uint) internal _balances;          // storing all the balances by names
    mapping (string => address) internal _identities;     // storing (name => address)
}