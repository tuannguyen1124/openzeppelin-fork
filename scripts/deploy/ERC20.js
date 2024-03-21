const { ethers } = require('hardhat');

const hre = require('hardhat');

async function main() {
  const signers = await ethers.getSigners();
  const deployer = signers[0];
  const contractName = 'CineCoin';
  const ERC20 = await ethers.getContractFactory(contractName);


  console.log(`1./ Deploy contract ${contractName}`);

  const contractERC20 = await ERC20.deploy();

  await contractERC20.waitForDeployment();
  console.log('Deploy completed!');
  console.log('Address Deployer:...', deployer.address);
  console.log('Contract ERC20:...', contractERC20.target);

  if (hre.network.name == 'localhost' || hre.network.name == 'hardhat') return;

  console.log(`2./ Verify contract ${contractName}`);
  console.log('\n Waiting for 5 block confirmations\n');
  await contractERC20.deploymentTransaction().wait(5);

  console.log('\nStart Verify\n');
  await hre.run('verify:verify', {
    address: contractERC20.target,
    constructorArguments: [],
    contract: 'contracts/CineCoin.sol:CineCoin',
  });
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
