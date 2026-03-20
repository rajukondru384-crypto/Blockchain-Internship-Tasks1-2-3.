// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PollingSystem {
    
    struct Poll {
        string title;
        string[] options;
        uint256 endTime;
        bool exists;
        mapping(uint256 => uint256) voteCount; // mapping option index to number of votes
        mapping(address => bool) hasVoted;    // tracks if an address has voted in this poll
    }

    uint256 public pollCount;
    mapping(uint256 => Poll) private polls;

    // Event to log when a poll is created
    event PollCreated(uint256 pollId, string title, uint256 endTime);
    // Event to log when a vote is cast
    event VoteCast(uint256 pollId, address voter, uint256 optionIndex);

    /**
     * @dev Create a new poll. 
     * @param _title The question/title of the poll.
     * @param _options An array of strings representing the choices.
     * @param _durationInMinutes How long the poll should stay active from now.
     */
    function createPoll(
        string memory _title, 
        string[] memory _options, 
        uint256 _durationInMinutes
    ) public {
        require(_options.length >= 2, "At least two options required.");
        
        pollCount++;
        Poll storage newPoll = polls[pollCount];
        newPoll.title = _title;
        newPoll.options = _options;
        newPoll.endTime = block.timestamp + (_durationInMinutes * 1 minutes);
        newPoll.exists = true;

        emit PollCreated(pollCount, _title, newPoll.endTime);
    }

    /**
     * @dev Vote for a specific option in a poll.
     */
    function vote(uint256 _pollId, uint256 _optionIndex) public {
        Poll storage poll = polls[_pollId];

        require(poll.exists, "Poll does not exist.");
        require(block.timestamp < poll.endTime, "The poll has ended.");
        require(!poll.hasVoted[msg.sender], "You have already voted in this poll.");
        require(_optionIndex < poll.options.length, "Invalid option selected.");

        poll.hasVoted[msg.sender] = true;
        poll.voteCount[_optionIndex]++;

        emit VoteCast(_pollId, msg.sender, _optionIndex);
    }

    /**
     * @dev Returns the winning option after the poll ends.
     */
    function getWinner(uint256 _pollId) public view returns (string memory winningOption) {
        Poll storage poll = polls[_pollId];

        require(poll.exists, "Poll does not exist.");
        require(block.timestamp >= poll.endTime, "Poll is still ongoing.");

        uint256 highestVotes = 0;
        uint256 winningIndex = 0;

        for (uint256 i = 0; i < poll.options.length; i++) {
            if (poll.voteCount[i] > highestVotes) {
                highestVotes = poll.voteCount[i];
                winningIndex = i;
            }
        }

        winningOption = poll.options[winningIndex];
    }

    /**
     * @dev Helper function to get poll details (Remix visibility).
     */
    function getPollDetails(uint256 _pollId) public view returns (string memory title, string[] memory options, uint256 endTime) {
        Poll storage poll = polls[_pollId];
        return (poll.title, poll.options, poll.endTime);
    }
}
