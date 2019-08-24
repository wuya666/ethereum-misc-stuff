pragma solidity 0.5.x;

library ExistOrNull {
    function readOrNull(address _addr, bytes memory _data) internal view returns (bytes memory _result) {
        bool success;
        bytes memory retData;
        (success, retData) = _addr.staticcall(_data);
        if (success) {
            _result = retData;
        } else {
            _result = abi.encode(0x0);
        }
    }
}

contract Tester {
    using ExistOrNull for address;

    string public lastStringResult;
    uint256 public lastUintResult;

    string public name = "Hello World";
    string public symbol = "HW";
    uint8 public decimals = 18;

    function test1(address _addr, string memory _func) public returns (string memory _result) {
        bytes4 sig = bytes4(keccak256(abi.encodePacked(_func)));
        _result = abi.decode(_addr.readOrNull(abi.encode(sig)), (string));
        lastStringResult = _result;
    }

    function test2(address _addr, string memory _func) public returns (uint256  _result) {
        bytes4 sig = bytes4(keccak256(abi.encodePacked(_func)));
        _result = abi.decode(_addr.readOrNull(abi.encode(sig)), (uint256));
        lastUintResult = _result;
    }

}
