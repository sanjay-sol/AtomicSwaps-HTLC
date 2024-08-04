// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract HashTimeLock {

    //                         / - WITHDRAWN
    // UNINITIALIZED - ACTIVE |
    //                         \ - EXPIRED - REFUNDED

    // Mapping to store details of each lock contract by their ID
    mapping(bytes32 => LockContract) public contracts;

    // Constants representing different states of the contract
    uint256 public constant UNINITIALIZED = 0;
    uint256 public constant ACTIVE = 1;
    uint256 public constant REFUNDED = 2;
    uint256 public constant WITHDRAWN = 3;
    uint256 public constant EXPIRED = 4;

    // Structure to hold the details of a lock contract
    struct LockContract {
        uint256 inputAmount; // Amount of tokens locked in the contract
        uint256 outputAmount; // Amount of tokens to be released
        uint256 expiration; // Expiry time of the contract
        uint256 status; // Current status of the contract
        bytes32 hashLock; // Hash lock for security
        address payable sender; // Address of the sender
        address payable receiver; // Address of the receiver
        string outputNetwork; // Network for output tokens
        string outputAddress; // Address for output tokens
    }

    // Events to log contract activities
    event Withdraw(
        bytes32 indexed id,
        bytes32 secret,
        bytes32 hashLock,
        address indexed sender,
        address indexed receiver
    );

    event Refund(
        bytes32 indexed id,
        bytes32 hashLock,
        address indexed sender,
        address indexed receiver
    );

    event NewContract(
        uint256 inputAmount,
        uint256 outputAmount,
        uint256 expiration,
        bytes32 indexed id,
        bytes32 hashLock,
        address indexed sender,
        address indexed receiver,
        string outputNetwork,
        string outputAddress
    );

    // Function to create a new lock contract
    function newContract(
        uint256 outputAmount,
        uint256 expiration,
        bytes32 hashLock,
        address payable receiver,
        string calldata outputNetwork,
        string calldata outputAddress
    ) external payable {
        address payable sender = payable(msg.sender);
        uint256 inputAmount = msg.value;

        require(expiration > block.timestamp, 'Expiration time must be in the future');
        require(inputAmount > 0, 'Amount must be greater than zero');

        bytes32 id = sha256(
            abi.encodePacked(sender, receiver, inputAmount, hashLock, expiration)
        );

        require(contracts[id].status == UNINITIALIZED, "Contract already exists");

        contracts[id] = LockContract(
            inputAmount,
            outputAmount,
            expiration,
            ACTIVE,
            hashLock,
            sender,
            receiver,
            outputNetwork,
            outputAddress
        );

        emit NewContract(
            inputAmount,
            outputAmount,
            expiration,
            id,
            hashLock,
            sender,
            receiver,
            outputNetwork,
            outputAddress
        );
    }

    // Function to withdraw from a lock contract
    function withdraw(bytes32 id, bytes32 secret) external {
        LockContract storage c = contracts[id];

        require(c.status == ACTIVE, "Contract is not active");
        require(c.expiration > block.timestamp, "Contract has expired");
        require(c.hashLock == sha256(abi.encodePacked(secret)), "Invalid secret");

        c.status = WITHDRAWN;
        c.receiver.transfer(c.inputAmount);

        emit Withdraw(id, secret, c.hashLock, c.sender, c.receiver);
    }

    // Function to refund a lock contract
    function refund(bytes32 id) external {
        LockContract storage c = contracts[id];

        require(c.status == ACTIVE, "Contract is not active");
        require(c.expiration <= block.timestamp, "Contract has not expired yet");

        c.status = REFUNDED;
        c.sender.transfer(c.inputAmount);

        emit Refund(id, c.hashLock, c.sender, c.receiver);
    }

    // Function to get the status of multiple lock contracts
    function getStatus(bytes32[] memory ids) external view returns (uint256[] memory) {
        uint256[] memory result = new uint256[](ids.length);

        for (uint256 i = 0; i < ids.length; i++) {
            result[i] = getSingleStatus(ids[i]);
        }

        return result;
    }

    // Function to get the status of a single lock contract
    function getSingleStatus(bytes32 id) public view returns (uint256 status) {
        LockContract memory lc = contracts[id];

        if (lc.status == ACTIVE && lc.expiration < block.timestamp) {
            status = EXPIRED;
        } else {
            status = lc.status;
        }
    }
}
