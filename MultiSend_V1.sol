// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title MultiSend
 * @dev A contract to send different amounts of Ether to multiple recipients in one transaction.
 */
contract MultiSend {

    // Event to log each successful transfer
    event Sent(address indexed to, uint256 amount);

    /**
     * @dev Distributes Ether to multiple addresses.
     * @param recipients Array of addresses to receive Ether.
     * @param amounts Array of values (in wei) to be sent to each recipient.
     */
    function sendEth(address payable[] memory recipients, uint256[] memory amounts) public payable {
        // Step 1: Check if input arrays have the same length
        require(recipients.length == amounts.length, "Arrays length mismatch");
        require(recipients.length > 0, "No recipients provided");

        // Step 2: Calculate total amount required
        uint256 totalRequired = 0;
        for (uint256 i = 0; i < amounts.length; i++) {
            totalRequired += amounts[i];
        }

        // Step 3: Ensure the sender has provided enough Ether
        require(msg.value >= totalRequired, "Insufficient Ether sent");

        // Step 4: Loop through and transfer
        for (uint256 i = 0; i < recipients.length; i++) {
            (bool success, ) = recipients[i].call{value: amounts[i]}("");
            require(success, "Transfer failed");

            // Emit event for tracking
            emit Sent(recipients[i], amounts[i]);
        }

        // Step 5: Refund extra Ether back to the sender (if any)
        uint256 remainingBalance = msg.value - totalRequired;
        if (remainingBalance > 0) {
            payable(msg.sender).transfer(remainingBalance);
        }
    }

    // Function to check the current contract balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
