pragma solidity ^0.4.15;

contract Example {
    function multiplySeven(uint256 a) returns (uint256) {
        return 7 * a;
    }

    function getOne() returns (uint8) {
        return 1;
    }

    function hashBytes(bytes32 a) returns (bytes32) {
        return keccak256(a);
    }
}
