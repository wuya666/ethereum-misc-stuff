const Web3 = require("web3");
const eju = require("ethereumjs-util");

module.exports = async (poaProvider, blkNum) => {
  try {
    let web3 = new Web3(poaProvider);
    let blk = await web3.eth.getBlock(blkNum);
    let header = [
      eju.toBuffer(blk.parentHash),
      eju.toBuffer(blk.sha3Uncles),
      eju.toBuffer(blk.miner),
      eju.toBuffer(blk.stateRoot),
      eju.toBuffer(blk.transactionsRoot),
      eju.toBuffer(blk.receiptsRoot),
      eju.toBuffer(blk.logsBloom),
      parseInt(blk.difficulty),
      parseInt(blk.number),
      parseInt(blk.gasLimit),
      parseInt(blk.gasUsed),
      parseInt(blk.timestamp),
      eju.toBuffer(blk.extraData.slice(0, blk.extraData.length - 130)),
      eju.toBuffer(blk.mixHash),
      eju.toBuffer(blk.nonce)
    ];

    let msg = eju.rlp.encode(header);
    let msghash = eju.keccak256(msg)
    let sig = blk.extraData.slice(-130);
    let r = "0x" + sig.slice(0, 64);
    let s = '0x' + sig.slice(64, 128);
    let v = '0x' + sig.slice(128, 130);
    v = parseInt(v) + 27;
    let pub = eju.ecrecover(msghash, v, r, s);
    let blkMiner = eju.pubToAddress(pub);
    return eju.bufferToHex(blkMiner);
  } catch(err) {
    throw err;
  }
}
