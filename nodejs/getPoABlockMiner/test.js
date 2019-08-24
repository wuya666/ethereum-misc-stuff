const Web3 = require("web3");
const poaBlkMiner = require("./poablkminer");

const poaProvider = new Web3.providers.HttpProvider("https://rinkeby.infura.io/v3/02fa0134f6314afaadcc08fdbccd7ea1");
const blkNum = 666;  /* https://rinkeby.etherscan.io/block/666 */

(async () => {
  try {
    let blkMiner = await poaBlkMiner(poaProvider, blkNum);
    console.log(blkMiner);
  } catch(err) {
    console.error(err);
  }
})();
