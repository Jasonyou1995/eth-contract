pragma solidity >=0.4.11;

contract ERC223Interface {

    uint public totalSupply;
    uint public remainingSupply;

    address public owner; 
    
    function registerMe(string memory myName) public payable 
        returns (bool);

    function isRegistered(string memory name, address addr) 
        public view returns (bool);

    function balanceOf(string memory who) public view 
        returns (uint);

    function transfer(string memory from, string memory to, 
        uint value) public returns (bool);

    function transfer(string memory from, string memory to, 
        uint value, bytes memory data) public returns (bool);

    event Transfer(string from, string to, uint value, 
                   bytes data);
}

