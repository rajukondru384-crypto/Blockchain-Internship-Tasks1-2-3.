// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSend {
    event Sent(address indexed to, uint256 amount);

    function sendEth(address payable[] memory recipients, uint256[] memory amounts) public payable {
        require(recipients.length == amounts.length, "Mismatch");
        require(recipients.length > 0, "Empty");

        uint256 total = 0;
        for (uint256 i = 0; i < amounts.length; i++) {
            total += amounts[i];
        }

        require(msg.value >= total, "Low Ether");

        for (uint256 i = 0; i < recipients.length; i++) {
            (bool success, ) = recipients[i].call{value: amounts[i]}("");
            require(success, "Failed");
            emit Sent(recipients[i], amounts[i]);
        }

        if (address(this).balance > 0) {
            payable(msg.sender).transfer(address(this).balance);
        }
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
