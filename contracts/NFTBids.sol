// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTBids {
    struct Bid {
        uint256 tokenId;
        address bidder;
        uint256 bidAmount;
    }

    mapping(uint256 => Bid) public bids;

    event BidPlaced(uint256 indexed tokenId, address indexed bidder, uint256 bidAmount);
    event BidAccepted(uint256 indexed tokenId, address indexed bidder, uint256 bidAmount);
    event BidReverted(string reason);

    function placeBid(uint256 tokenId) external payable {
        Bid memory existingBid = bids[tokenId];
        if (msg.value <= existingBid.bidAmount) {
            emit BidReverted("New bid must be higher than the existing bid.");
            revert("New bid must be higher than the existing bid.");
        }
        if (existingBid.bidAmount > 0) {
            (bool success, ) = payable(existingBid.bidder).call{value: existingBid.bidAmount}("");
            require(success, "Failed to return previous bid.");
        }
        bids[tokenId] = Bid(tokenId, msg.sender, msg.value);
        emit BidPlaced(tokenId, msg.sender, msg.value);
    }

    function acceptBid(uint256 tokenId, address nftContract) external {
        Bid memory bid = bids[tokenId];
        require(bid.bidAmount > 0, "No valid bid found.");
        IERC721(nftContract).transferFrom(msg.sender, bid.bidder, tokenId);
        (bool success, ) = payable(msg.sender).call{value: bid.bidAmount}("");
        require(success, "Failed to transfer bid amount to the seller.");
        delete bids[tokenId];
        emit BidAccepted(tokenId, bid.bidder, bid.bidAmount);
    }
}


