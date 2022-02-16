const { expect } = require("chai");
const { ethers, artifacts } = require("hardhat");
const hre = require("hardhat");

describe("Swap token to token", function(){
  let token;
  let hardhat;
  let ad2;
  let t1;
  let t2;
  let ad1;
  let owner;
  //const accountToInpersonate = "0x6F6C07d80D0D433ca389D336e6D1feBEA2489264"
  // beforeEach(function (done) {
  //   this.timeout(10000) //for timeout
  //   done();
  // abi, address
  // ethers.Contract(abi, address);
  beforeEach(async () => {
    token = await ethers.getContractFactory("Uswap");
    await hre.network.provider.request({
      method: "hardhat_impersonateAccount",
      params: ["0x26a78D5b6d7a7acEEDD1e6eE3229b372A624d8b7"],
    });
    [owner, _] = await ethers.getSigners("0x26a78D5b6d7a7acEEDD1e6eE3229b372A624d8b7");
    hardhat = await token.deploy();
    await hardhat.deployed();
  });
  
  it("SwapTtoT", async () => {
    const DAI = "0x6b175474e89094c44da98b954eedeac495271d0f";
    const AAVE = "0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9";
    const ad_to = owner.address;
    const tokenArtifacts = await artifacts.readArtifact("IERC20");
    const tokenx = new ethers.Contract(DAI,tokenArtifacts.abi);
    await tokenx.connect(owner).approve(hardhat.address,ethers.utils.parseUnits("2", 18) );
     await hardhat.connect(owner).swapTtoT(DAI,AAVE,ethers.utils.parseUnits("2", 18),0,ad_to);
     // expect(await getAmountOutMin(DAI,AAVE,ethers.utils.parseUnits("2", 18))).to.eq(0);
     });

    it("SwapTtoE", async () => {
       const DAI = "0x6b175474e89094c44da98b954eedeac495271d0f";
       const ETH = "0x7d812B62Dc15e6F4073ebA8a2bA8Db19c4E40704";
    const ad_to = owner.address;
    const tokenArtifacts = await artifacts.readArtifact("IERC20");//DAI instance
    const tokenx = new ethers.Contract(DAI,tokenArtifacts.abi);
    await tokenx.connect(owner).approve(hardhat.address,ethers.utils.parseUnits("2", 18) );
     await hardhat.connect(owner).swapTtoE(DAI,ethers.utils.parseUnits("2", 18),0,ad_to);
     })

    it("SwapEtoT", async () => {
      const ETH = "0x7d812B62Dc15e6F4073ebA8a2bA8Db19c4E40704";
      const DAI = "0x6b175474e89094c44da98b954eedeac495271d0f";
   const ad_to = owner.address;
  
   await hardhat.connect(owner).swapEtoT(ethers.utils.parseEther("5", 18),DAI,0,ad_to, {value: ethers.utils.parseEther("5", 18)});
    const tokenArtifacts = await artifacts.readArtifact("IERC20");
   const tokenx = new ethers.Contract(DAI,tokenArtifacts.abi);
   await tokenx.connect(owner).approve(hardhat.address,0) ;
    })
});