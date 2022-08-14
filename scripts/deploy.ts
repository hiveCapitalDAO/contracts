import { ethers } from 'hardhat'

async function main() {
  const HiveToken = await ethers.getContractFactory('HiveToken')
  const hiveToken = await HiveToken.deploy()

  await hiveToken.deployed()

  console.log('Deployed Token at: ', hiveToken.address)

  const ICO = await ethers.getContractFactory('ICO')
  const ico = await ICO.deploy(7, hiveToken.address)

  console.log('Deployed ICO at address ', ico.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
