// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    // 1. Declare an integer variable to store a value
    int256 public value;

    // 2. Function to increase value by 1
    function increment() public {
        value += 1;
    }

    // 3. Function to decrease value by 1
    function decrement() public {
        value -= 1;
    }

    // 4. Function to read the value (Explicitly, though 'public' does this)
    function getValue() public view returns (int256) {
        return value;
    }
}
