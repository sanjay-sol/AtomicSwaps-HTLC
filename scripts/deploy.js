const { ethers } = require("hardhat");

async function main() {
  const network = hre.network.name;
  const [bob, alice] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", bob.address);

  if (network === "sepolia") {
    // Deploy Token A on Sepolia
    const TokenA = await ethers.getContractFactory("Token");
    const tokenA = await TokenA.deploy("Token A", "TKNA");
    await tokenA.deployed();
    console.log("Token A deployed to:", tokenA.address);

    // Deploy HTLC for Bob to Alice on Sepolia
    const HTLC = await ethers.getContractFactory("HTLC");
    const htlcA = await HTLC.deploy(alice.address, tokenA.address, 1);
    await htlcA.deployed();
    console.log("HTLC A deployed to:", htlcA.address);

    // Approve and fund HTLC A
    await tokenA.connect(bob).approve(htlcA.address, 1);
    await htlcA.connect(bob).fund();
    console.log("HTLC A funded");
  } else if (network === "binanceTestnet") {
    // Deploy Token B on Binance Testnet
    const TokenB = await ethers.getContractFactory("Token");
    const tokenB = await TokenB.deploy("Token B", "TKNB");
    await tokenB.deployed();
    console.log("Token B deployed to:", tokenB.address);



    // Deploy HTLC for Alice to Bob on Binance Testnet
    const HTLC = await ethers.getContractFactory("HTLC");
    const htlcB = await HTLC.deploy(bob.address, tokenB.address, 1);
    await htlcB.deployed();
    console.log("HTLC B deployed to:", htlcB.address);

    // Approve and fund HTLC B
    await tokenB.connect(alice).approve(htlcB.address, 1);
    await htlcB.connect(alice).fund();
    console.log("HTLC B funded");
  } else {
    console.log("Unsupported network:", network);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
