//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IERC20 {
     function transfer(address to, uint256 value) external returns (bool);
     function transferFrom(address from, address to, uint256 value) external returns (bool);
     // function allowance(address owner, address spender) external view returns (uint256);
}


contract HTLC {

    mapping(bytes32 => LockContract) public contracts;

    uint256 public constant INVALID = 0;
    uint256 public constant ACTIVE = 1; 
    uint256 public constant REFUNDED = 2; 
    uint256 public constant WITHDRAWN = 3;
    uint256 public constant EXPIRED = 4; 

    struct LockContract {
        uint256 inputAmount;
        uint256 outputAmount;
        uint256 expiration;
        uint256 status;
        bytes32 hashLock;
        address payable sender;
        address payable receiver;
        string outputNetwork;
        string outputAddress;
    }
    uint public startTime;
    uint public lockTime = 10000 seconds;
    string public secret; // abcdefgh
    bytes32 public hash =  0x48624fa43c68d5c552855a4e2919e74645f683f5384f72b5b051b71ea41d4f2d;
    address public recipient;
    address public owner;
    uint public amount;
    IERC20 public token;

    constructor(address _recipient, address _token, uint _amount) {
        recipient = _recipient;
        owner = msg.sender;
        amount = _amount;
        token = IERC20(_token);
    }

    function fund() external {
        startTime = block.timestamp;
        token.transferFrom(msg.sender, address(this), amount);
    }

    function withdraw(string memory _secret) external  {
        require(keccak256(abi.encodePacked(_secret)) == hash, "wrong secret");
        secret = _secret;
        token.transfer(recipient, amount);
    }

    function refund() external {
        require(block.timestamp > startTime + lockTime, "too early");
        token.transfer(owner, amount);
    }


 }