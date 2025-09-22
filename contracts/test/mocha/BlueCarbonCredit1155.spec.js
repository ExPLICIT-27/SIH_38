import { expect } from 'chai';
import { network } from 'hardhat';

const { ethers } = await network.connect();

describe('BlueCarbonCredit1155', function () {
  it('mints and retires balances correctly', async function () {
    const [deployer, user] = await ethers.getSigners();
    const Factory = await ethers.getContractFactory('BlueCarbonCredit1155');
    const c = await Factory.deploy();
    await c.waitForDeployment();

    const MINTER_ROLE = ethers.keccak256(ethers.toUtf8Bytes('MINTER_ROLE'));
    await c.grantRole(MINTER_ROLE, deployer.address);

    await c.mint(user.address, 1, 100n, '0x');
    expect(await c.balanceOf(user.address, 1)).to.equal(100n);

    await c.connect(user).retire(1, 40n, 'demo');
    expect(await c.balanceOf(user.address, 1)).to.equal(60n);
  });
});


