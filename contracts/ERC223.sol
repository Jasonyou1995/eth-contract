// Author:          Jason You All Rights Reserved
// Last modified:   March 18 2019

pragma solidity >=0.4.11;

import "./ERC223Interface.sol";
import "./SafeMath.sol";
import "./ERC223ReceivingContract.sol";     // fallbackFunction receiving contract


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
contract ERC223 is ERC223Interface {

    using SafeMath for uint;     // so that uint256 can use SafeMath functions

    /***********************************/
    /***** Glocal Storage Variables ****/
    /***********************************/

    uint public totalSupply;        // total number of tokens
    uint public remainingSupply;    // remaining supplies
    address public owner;           // owner of this contract
    uint price;                     // (n Wei / ERC223_token)
    
    mapping (string => uint) private _balances;          // storing all the balances by names
    mapping (string => address) private _identities;     // storing (name => address)
     
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
     

    /***********************************/
    /******* Functions of ERC223 *******/
    /***********************************/
    
    /**
     * @dev    Register the sender address with the given name mapping to address.
     * @param  myName The name that we want the message sender address bind to.
     * @return ture if the binding is successful.
     */
    function registerMe(string memory myName) public payable returns (bool) {
        require(bytes(myName).length != 0, "Name cannot be empty.");     // must change to bytes to get length
        
        // payable must get payment
        require(msg.value != 0, "Payment cannot be zero.");
        
        // check if the supply is sufficient
        require(remainingSupply > (msg.value.div(price)), "Insufficient total token supply.");
        
        // Register the applier
        _identities[myName] = msg.sender;
        
        // Decrease the total supply of our token
        remainingSupply = remainingSupply.sub(msg.value.div(price));
        
        // TODO: check that the unit for division of Ether and ERC223 token are right!
        
        // Token is assigned to user with the amount paid divided by the fixed price
        _balances[myName] = _balances[myName].add(msg.value.div(price));
        
        return true;
    }

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

    /**
     * @dev This tranfer function is for backward compatibility with ERC20 standard.
     * @param from The address that sends the funds.
     * @param to The address that receives the funds.
     * @param value The amount been transfered.
     */
    function transfer(string memory from, string memory to, uint value) public returns (bool) {
        _transfer(from, to, value);
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
        _transfer(from, to, value, data);
        return true;
    }
    
    /***********************************/
    /**** Internal Helper Functions ****/
    /***********************************/
    
    /**
     * @dev This is the helper function for transfering without data.
     * @param from The address that sends the funds.
     * @param to The address that receives the funds.
     * @param value The amount been transfered.
     */
    function _transfer(string memory from, string memory to, uint value) internal {
        // Check the validity of the from and to addresses
        require(_identities[from] != address(0), "From address is empty.");
        require(_identities[to] != address(0), "To address is empty.");
        
        // If the funds are sent to a contract address, then this contract must
        // already implements the tokenFallback function as defined in the
        // abstract contract ERC223ReceivingContract.
        if (_isContract(_identities[to])) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_identities[to]);
            receiver.tokenFallback(_identities[from], value, "");
        }
        
        // Transfering the fund
        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);

        // Publish the successful tranfering event        
        emit Transfer(from, to, value, "");
    }
    
    /**
     * @dev This is the helper function for transfering with data.
     * @param from The address that sends the funds.
     * @param to The address that receives the funds.
     * @param value The amount been transfered.
     * @param data The metadata been sent along with the transaction.
     */
    function _transfer(string memory from, string memory to, uint value, bytes memory data) internal {
        // Check the validity of the from and to addresses
        require(_identities[from] != address(0), "From address is empty.");
        require(_identities[to] != address(0), "To address is empty.");
        
        // If the funds are sent to a contract address, then this contract must
        // already implements the tokenFallback function as defined in the
        // abstract contract ERC223ReceivingContract.
        if (_isContract(_identities[to])) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_identities[to]);
            receiver.tokenFallback(_identities[from], value, data);
        }
        
        // Transfering the fund
        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);

        // Publish the successful tranfering event        
        emit Transfer(from, to, value, data);
    }
    
    /**
     * @dev Check if an address is a contract.
     * @param _addr The address to test for.
     * @return true if this is a contract address, false otherwise.
     */
    function _isContract(address _addr) private view returns (bool) {
        /*
        This function must be private, not each internal. Otherwise attacker can inheriate This
        function and calling this function from a contract constructor and trick this test.
        
        private:
            Private functions and state variables are only visible for the contract they are defined in
            and not in derived contracts.
        Note:
            Everything that is inside a contract is visible to all observers external to the blockchain. 
            Making something private only prevents other contracts from accessing and modifying the 
            information, but it will still be visible to the whole world outside of the blockchain.
        */
        
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }
}

