// Author:          Jason You All Rights Reserved
// Last modified:   March 22 2019
//
// This contract serves as a proxy contract.

pragma solidity ^0.4.24;    // notice the compiler version is crucial for proxy

import "./ERC223Interface.sol";
import "./SafeMath.sol";
import "./ERC223ReceivingContract.sol";     // fallbackFunction receiving contract
import "./ERC223-storage.sol";

/**
 * @title Implementation of ERC223 token.
 */

/**
 * @dev    This contract implements the ERC223 token, and requires the token
 *         handling contracts to include tokenFallback function. We emit
 *         each Transfer event after successly making a transfer.
 * 
 *         Notice that this contract does not provide any reclaim functions
 *         for Ether, thus for market stable reason, any Ether sent to this
 *         contract in exchange for the ERC223 token will be burned.
 */
contract ERC223 is ERC223Interface, State {

    using SafeMath for uint;            // so that uint256 can use SafeMath functions
    
    address private logicContract;      // the address of current logic contract
    
    /**
     * @dev     Constructor for the ERC223 token.
     *          All the totalSupply, remainingSupply, price are hard coded.
     *          totalSupply:    Total supply is 21,000,000, with the initiator to be the contract owner
     *          owner:          Contract owner is the caller.
     *          price:          One Ether (or 1e18 Wei) worth 100 our ERC223 token
     *                          Thus one of our token worth 1e16 Wei
     */
    constructor() public {
        totalSupply     = 21000000;
        remainingSupply = 21000000;
        owner           = msg.sender;
        price           = 1e16;           // 1 ERC223 = 1e16 Wei (or 0.01 Ether)
    }
    
    /**
     * @dev  Call this function to update the logic contract
     * @param _newLogicContract address of new logic contract
     */
    function changeLogic(address _newLogicContract) public {
        require(msg.sender == owner);
        logicContract = _newLogicContract;
    }

    
    /***********************************/
    /**** Proxy Functions of ERC223 ****/
    /***********************************/
    
    /**
     * @dev    Register the sender address with the given name mapping to address.
     * @param  myName The name that we want the message sender address bind to.
     * @return ture if the binding is successful.
     */
    function registerMe(string memory myName) public payable returns (bool) {
        require(logicContract.delegatecall(bytes4(keccak256("registerMe(string)")), myName));
        return true;
    }

    /**
     * @dev This tranfer function is for backward compatibility with ERC20 standard.
     * @param from The address that sends the funds.
     * @param to The address that receives the funds.
     * @param value The amount been transfered.
     */
    function transfer(string memory from, string memory to, uint value) public returns (bool) {
        require(logicContract.delegatecall(bytes4(keccak256("transfer(string, string, uint)")), from, to, value));
        return true;
    }

    /**
     * @dev This is the main transfer function for ERC223 standard.
     * @param from The address that sends the funds.
     * @param to The address that receives the funds.
     * @param value The amount been transfered.
     * @param data The metadata been sent along with the transaction.
     */
    function transfer(string memory from, string memory to, uint value, bytes memory data) public returns (bool) {
        require(logicContract.delegatecall(bytes4(keccak256("transfer(string, string, uint, bytes)")), from, to, value, data));
        return true;
    }
    
    /***********************************/
    /**** View Functions of ERC223 *****/
    /***********************************/
    
    /*  This kind of function is not necessray to proxy,
     *  cause returning value is not easy, and not under much change
     */
    
    /**
     * @dev     Check if the name and address pair is registered.
     * @param   name The name bind to the address.
     * @param   addr The address relate to the name.
     * @return  true if the name address pair exists.
     */
    function isRegistered(string memory name, address addr) public view returns (bool){
        require(addr != address(0), "Address cannot be empty");        // address must be valid
        return (_identities[name] == addr);
    }
    
    /**
     * @dev     Query the balance of the person.
     * @param   who The person that account balance will be checked.
     * @return  The balance of the address relates to the person.
     */
    function balanceOf(string memory who) public view returns (uint) {
        return _balances[who];
    }
}

