// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract EventManager {
    struct Event {
        uint256 id;
        string name;
        string description;
        uint256 date;
    }

    uint256 public nextEventId;
    mapping(uint256 => Event) public events;

    function createEvent(string calldata name, string calldata description, uint256 date) external {
        events[nextEventId] = Event(nextEventId, name, description, date);
        nextEventId++;
    }
}
