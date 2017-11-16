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

    function arrayTest(bytes32[3] a) returns (bytes32, bytes32, bytes32) {
        return (a[0], a[1], a[2]);
    }

    function arrayTestC(bytes32[3] a, bytes32 b) constant
        returns (bytes32, bytes32, bytes32, bytes32) {

        return (a[0], a[1], a[2], b);

    }

    function dynArrayTestC(bytes32[] a) constant returns (bytes32) {
        return (a[0]);
    }

    function issueCredit( bytes32 ucac, address creditor, address debtor, uint256 amount, bytes32[3] memory sig1, bytes32[3] memory sig2, bytes32 memo) public constant returns (bytes32) {
        return memo;
    }

}
