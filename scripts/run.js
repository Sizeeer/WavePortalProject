const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await waveContract.deployed();
  console.log("Развернут на адресе:", waveContract.address);
  console.log("Развернут адресом:", owner.address);

  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );

  console.log(
    "Initial contract balance",
    hre.ethers.utils.formatEther(contractBalance)
  );

  await waveContract.getTotalWaves();

  let waveTxn = await waveContract.wave("Привет");
  await waveTxn.wait();

  waveTxn = await waveContract.connect(randomPerson).wave("{f[f[f");
  await waveTxn.wait();

  waveTxn = await waveContract.wave("Дублирую");
  await waveTxn.wait();

  await waveContract.getTotalWaves();

  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);

  console.log(
    "Contract balance after 2 wave actions",
    hre.ethers.utils.formatEther(contractBalance)
  );

  const waves = await waveContract.getAllWaves();

  console.log(waves);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (e) {
    console.log(e);
    process.exit(1);
  }
};

runMain();
