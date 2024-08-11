
# HTLC for Atomic Swaps between Sepolia and BNB Networks

This project demonstrates a cross-chain atomic swap using Hash Time-Locked Contracts (HTLC) between the Sepolia Ethereum testnet and the Binance Smart Chain (BNB) testnet. The implementation is done using Solidity, Hardhat for development, and Chai for testing.

## Table of Contents
- [HTLC for Atomic Swaps between Sepolia and BNB Networks](#htlc-for-atomic-swaps-between-sepolia-and-bnb-networks)
  - [Table of Contents](#table-of-contents)
  - [Project Overview](#project-overview)
    - [Key Components:](#key-components)
  - [Architecture Diagrams](#architecture-diagrams)
    - [1. Detailed Process Flow](#1-detailed-process-flow)
    - [2. Simplified Overview](#2-simplified-overview)
  - [How It Works](#how-it-works)
    - [Contract Creation](#contract-creation)
    - [Token Locking](#token-locking)
    - [Token Withdrawal](#token-withdrawal)
    - [Token Refund](#token-refund)
  - [Setup \& Deployment](#setup--deployment)
  - [NOTE:](#note)
  - [Conclusion](#conclusion)

## Project Overview

Atomic swaps are a method of exchanging cryptocurrencies between two different blockchains without requiring a trusted third party. This project implements HTLCs to enable these atomic swaps, ensuring that the swap either completes successfully for both parties or fails for both, without either party being able to cheat the other.

### Key Components:

- **Users**: 
  - **User 1** on the Sepolia Network.
  - **User 2** on the BNB Network.
  - Each user receives the corresponding tokens from the other network after a successful transaction.

- **HTLC Contracts**:
  - **Sepolia HTLC Contract**: Deployed on the Sepolia Ethereum testnet.
  - **BNB HTLC Contract**: Deployed on the Binance Smart Chain testnet.
  - The contracts have several states: `UNINITIALIZED`, `ACTIVE`, `WITHDRAWN`, `REFUNDED`, and `EXPIRED`.

- **Hash Lock & Time Lock**:
  - **Hash Lock**: Ensures that tokens can only be withdrawn with the correct secret (hash).
  - **Time Lock**: Sets a time limit within which the swap must be completed, or the tokens are refunded.

- **Development Tools**:
  - **Hardhat**: Used for developing and deploying the smart contracts.
  - **Chai**: Used for unit testing the contracts to ensure correctness.

## Architecture Diagrams

### 1. Detailed Process Flow
![Screenshot 2024-08-12 at 3 07 19 AM](https://github.com/user-attachments/assets/2f018d49-89fd-4e0c-8bb2-e7bad0e182d3)



This diagram illustrates the detailed process flow of the HTLC-based atomic swap between Sepolia and BNB networks, including the token locking, unlocking, and refund mechanisms.

### 2. Simplified Overview

![Screenshot 2024-08-12 at 3 03 49 AM](https://github.com/user-attachments/assets/282e7cd9-75b7-4cd0-9a22-7de39563b18b)

This diagram provides a simplified overview of the HTLC setup, focusing on the interactions between users, smart contracts, and the development tools.

## How It Works

### Contract Creation

1. **User 1** creates an HTLC contract on the Sepolia network by locking tokens with a hash lock and a time lock.
2. **User 2** creates a corresponding HTLC contract on the BNB network, similarly locking tokens.

### Token Locking

- Tokens are locked in the HTLC contracts on both networks.
- The `hashLock` ensures that tokens can only be withdrawn by providing the correct secret.
- The `timeLock` ensures that if the swap is not completed within the specified time, the tokens are refunded to the original sender.

### Token Withdrawal

- Once the correct secret is provided by User 1 to the Sepolia HTLC, the Sepolia tokens are unlocked and sent to User 2.
- The same secret is then used by User 2 to unlock the BNB tokens, which are sent to User 1.

### Token Refund

- If the swap is not completed within the time lock, both contracts transition to the `REFUNDED` state, and the locked tokens are returned to the original senders.

## Setup & Deployment

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/sanjay-sol/AtomicSwaps-HTLC
   cd AtomicSwaps-HTLC
   ```

2. **Install Dependencies**:
   ```bash
   npm install
   ```

3. **Compile Contracts**:
   ```bash
   npx hardhat compile
   ```

4. **Deploy Contracts**:
   Deploy the HTLC contracts on both Sepolia and BNB testnets.
   ```bash
   npx hardhat run scripts/deploy.js --network sepolia
   npx hardhat run scripts/deploy.js --network binanceTestnet
   ```

5. **Run Tests**:
   ```bash
   npx hardhat test
   ```


## NOTE:

I am working on the project, it is not completed yet.

## Conclusion

This project demonstrates the implementation of atomic swaps using HTLCs, allowing trustless exchanges between two different blockchains. The use of Hardhat and Chai ensures that the contracts are robust and thoroughly tested.