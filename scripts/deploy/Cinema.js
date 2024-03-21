const { ethers } = require('hardhat');
const hre = require('hardhat');

async function main() {
  const signers = await ethers.getSigners();
  const deployer = signers[0];
  const contractName = 'Cinema';
  const ExchangeNFT = await ethers.getContractFactory(contractName);
  const ERC20Address = process.env.ERC20_ADDRESS;
  const ERC721Address = process.env.ERC721_ADDRESS;
  const ERC1155Address = process.env.ERC1155_ADDRESS;
  const priceTicket = 10;

  console.log(`1./ Deploy contract ${contractName}`);
  const constructorArguments = [ERC20Address, ERC721Address, ERC1155Address, priceTicket];

  const contractExchangeNFT = await ExchangeNFT.deploy(...constructorArguments);

  await contractExchangeNFT.waitForDeployment();
  console.log("Deploy completed!");
  console.log("Address Deployer:...", deployer.address);
  console.log("Contract ExchangeNFT:...", contractExchangeNFT.target);

  if (hre.network.name == "localhost" || hre.network.name == "hardhat") return;

  console.log(`2./ Verify contract ${contractName}`);
  console.log("\n Waiting for 5 block confirmations\n");
  await contractExchangeNFT.deploymentTransaction().wait(5);

  console.log("\nStart Verify\n");
  await hre.run("verify:verify", {
    address: contractExchangeNFT.target,
    constructorArguments: constructorArguments,
    contract: "contracts/Cinema.sol:Cinema",
  });
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
