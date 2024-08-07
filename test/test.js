// test smart contract

const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("HTLC", function () {
    let HTLC;
    let htlc;
    let Token;
    let token;
    let owner;
    let alice;
    let bob;
    
    const hash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("abcdefgh"));
    
    beforeEach(async function () {
        [owner, alice, bob] = await ethers.getSigners();
    
        Token = await ethers.getContractFactory("Token");
        token = await Token.deploy("Token", "TKN");
        await token.deployed();
    
        HTLC = await ethers.getContractFactory("HTLC");
        htlc = await HTLC.deploy(alice.address, token.address, 1);
        await htlc.deployed();
    
        await token.connect(owner).approve(htlc.address, 1);
        await htlc.connect(owner).fund();
    });
    
    it("should deploy the HTLC contract", async function () {
        expect(htlc.address).to.not.equal(0);
    });
    
    it("should fund the HTLC contract", async function () {
        const balance = await token.balanceOf(htlc.address);
        expect(balance).to.equal(1);
    });
    
    it("should not withdraw with an incorrect secret", async function () {
        const secret = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("incorrect"));
        await expect(htlc.connect(alice).withdraw(secret)).to.be.revertedWith("HTLC: invalid secret");
    });
    
    it("should withdraw with the correct secret", async function () {
        await htlc.connect(alice).withdraw(hash);
        const balance = await token.balanceOf(alice.address);
        expect(balance).to.equal(1);
    });
});
    