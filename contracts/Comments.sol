// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Comments {
    struct Comment {
        uint256 id;
        address commenter;
        string text;
        uint256 timestamp;
    }

    uint256 public nextCommentId;
    mapping(uint256 => Comment) public comments;

    function addComment(string calldata text) external {
        comments[nextCommentId] = Comment(nextCommentId, msg.sender, text, block.timestamp);
        nextCommentId++;
    }
}
