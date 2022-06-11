const main = async () => {
  const [owner, randomPerson, randomPerson2] = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });

  await waveContract.deployed();

  let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance));
  console.log("Contract deployed to:", waveContract.address);
  console.log("Contract deployed by:", owner.address);

  let waveTxn = await waveContract.connect(randomPerson2).wave("a message");
  await waveTxn.wait();

  waveTxn = await waveContract.connect(randomPerson).wave("another message");
  await waveTxn.wait();

  waveCount = await waveContract.getTotalWaves();

  /* waveByOnwer = await waveContract.getWavesByAddress(); */
  waveByRandom = await waveContract.connect(randomPerson).getWavesByAddress();
  waveByRandom2 = await waveContract.connect(randomPerson2).getWavesByAddress();
  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance));

  let allWaves = await waveContract.getAllWaves();
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
