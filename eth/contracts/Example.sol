pragma solidity ^0.4.15;

contract Example {

    uint256 public a = 10;

    function setA(uint256 val) {
        a = val;
    }

    function getDoubleA() constant returns (uint256) {
        return a * 2;
    }

}
