pragma solidity ^0.4.15;

contract Example {
    function multiplySeven(uint256 a) constant returns (uint256) {
        return 7 * a;
    }

    function getOne() constant returns (uint8) {
        return 1;
    }

    function hashBytes(bytes32 a) constant returns (bytes32) {
        return keccak256(a);
    }
}
