const { ethers } = require('hardhat');

const hre = require('hardhat');

async function main() {
  const signers = await ethers.getSigners();
  const deployer = signers[0];
  const contractName = 'CineTicket';
  const name = "CineTicket";
  const symbol = "CineTicket"
  const ERC1155 = await ethers.getContractFactory(contractName);
  const constructorArguments = [name, symbol];

  console.log(`1./ Deploy contract ${contractName}`);

  const contractERC1155 = await ERC1155.deploy(...constructorArguments);

  await contractERC1155.waitForDeployment();
  console.log('Deploy completed!');
  console.log('Address Deployer:...', deployer.address);
  console.log('Contract ERC1155:...', contractERC1155.target);

  if (hre.network.name == 'localhost' || hre.network.name == 'hardhat') return;

  console.log(`2./ Verify contract ${contractName}`);
  console.log('\n Waiting for 5 block confirmations\n');
  await contractERC1155.deploymentTransaction().wait(5);

  console.log('\nStart Verify\n');
  await hre.run('verify:verify', {
    address: contractERC1155.target,
    constructorArguments: constructorArguments,
    contract: 'contracts/CineTicket.sol:CineTicket',
  });
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
