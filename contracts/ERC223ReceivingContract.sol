pragma solidity >=0.4.11;

/**
  * @title  Abstract contract that must be inherited by any other contracts
  *         that want to handle ERC223 tokens.
  */

contract ERC223ReceivingContract {
    /**
      * @dev ERC223 Standard using fallback function to handle incoming token transfers.
      * @param _from address where token is sent from.
      * @param _value Amount of tokens sent from the sender.
      * @param _data Transaction metadata payload.
      */
    function tokenFallback(address _from, uint _value, bytes memory _data) public;
}
