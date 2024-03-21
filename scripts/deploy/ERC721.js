const { ethers } = require('hardhat');

const hre = require('hardhat');

async function main() {
  const signers = await ethers.getSigners();
  const deployer = signers[0];
  const contractName = 'CineID';
  const ERC721 = await ethers.getContractFactory(contractName);


  console.log(`1./ Deploy contract ${contractName}`);

  const contractERC721 = await ERC721.deploy();

  await contractERC721.waitForDeployment();
  console.log('Deploy completed!');
  console.log('Address Deployer:...', deployer.address);
  console.log('Contract ERC721:...', contractERC721.target);

  if (hre.network.name == 'localhost' || hre.network.name == 'hardhat') return;

  console.log(`2./ Verify contract ${contractName}`);
  console.log('\n Waiting for 5 block confirmations\n');
  await contractERC721.deploymentTransaction().wait(5);

  console.log('\nStart Verify\n');
  await hre.run('verify:verify', {
    address: contractERC721.target,
    constructorArguments: [],
    contract: 'contracts/CineID.sol:CineID',
  });
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
