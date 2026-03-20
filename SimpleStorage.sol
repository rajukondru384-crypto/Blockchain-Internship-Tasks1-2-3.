// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    int256 public storedValue;

    // Number ni 1 penchutundi
    function increment() public {
        storedValue += 1;
    }

    // Number ni 1 thaggisthundi
    function decrement() public {
        storedValue -= 1;
    }

    // Value entha undo chudadaniki
    function getValue() public view returns (int256) {
        return storedValue;
    }
}
