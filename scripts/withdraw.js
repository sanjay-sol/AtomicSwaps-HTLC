const { ethers } = require("hardhat");

async function main() {
  const [bob, alice] = await ethers.getSigners();

  const htlcAddress = "0x529bFec7b0c0769902A5e8C74A0bFA480d976D0C";
  const balance = await token.balanceOf(htlcAddress);
  console.log("HTLC contract balance:", balance.toString());

  const HTLC = await ethers.getContractFactory("HTLC");
  const htlc = await HTLC.attach(htlcAddress);

  const secret = "abcdefgh";
  const hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(secret));

  console.log("Hash of the provided secret:", hash);

  const contractHash = await htlc.hash();
  console.log("Hash stored in contract:", contractHash);

    const timeout = await htlc.timeout();
    console.log("Timeout:", timeout.toString());

    

  if (hash !== contractHash) {
    console.error("Provided secret does not match the stored hash.");
    return;
  }

  try {
    const tx = await htlc.connect(alice).withdraw(secret, {
      gasLimit: 3000000, 
    });
    await tx.wait();
    console.log("Withdrawal successful");
  } catch (error) {
    console.error("Withdrawal failed:", error);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
