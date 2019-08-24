pragma solidity 0.5.x;

// SafeMath library
library SafeMath {
    function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
        uint256 c = _a + _b;
        assert(c >= _a);
        return c;
    }

    function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
        assert(_a >= _b);
        return _a - _b;
    }

    function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
        if (_a == 0) {
            return 0;
        }
        uint256 c = _a * _b;
        assert(c / _a == _b);
        return c;
    }

    function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
        return _a / _b;
    }
}

// ContractSpawner library
library ContractSpawner {
    using SafeMath for uint256;

    function create_with_code_of(address _source) internal returns (address _forwarder) {
        bytes27 head = 0x602e600c600039602e6000f3366000600037611000600036600073;  // 27 bytes
        bytes11 tail = 0x5af41558576110006000f3;  // 11 bytes
        bytes20 addr = bytes20(_source);  // 20 bytes

        assembly {
            let cdata := mload(0x40)
            mstore(cdata, head)
            mstore(add(cdata, 27), addr)
            mstore(add(cdata, 47), tail)
            _forwarder := create(0, cdata, 58)
            if eq(eq(extcodesize(_forwarder), 46), 0) {
                revert(0, 0)
            }
        }
    }
}

contract Tester {
    using ContractSpawner for address;

    address public lastAddr;

    function test1(address _source) public returns (address _forwarder) {
        lastAddr = _source.create_with_code_of();
        _forwarder = lastAddr;
    }
}
