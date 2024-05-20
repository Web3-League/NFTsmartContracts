// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract NFTWithRoyalties is ReentrancyGuard {
    struct RoyaltyInfo {
        address creator;
        uint256 royalty;
    }

    mapping(address => mapping(uint256 => RoyaltyInfo)) private _royalties;

    event RoyaltySet(address indexed nftContract, uint256 indexed tokenId, address indexed creator, uint256 royalty);
    event NFTTransferredWithRoyalty(address indexed nftContract, uint256 indexed tokenId, address indexed from, address to, uint256 salePrice, uint256 royaltyAmount);

    function setRoyalty(address nftContract, uint256 tokenId, address creator, uint256 royalty) external {
        require(royalty <= 100, "Royalty percentage cannot be more than 100");
        require(IERC721(nftContract).ownerOf(tokenId) == msg.sender, "Only the owner can set the royalty");

        _royalties[nftContract][tokenId] = RoyaltyInfo(creator, royalty);
        emit RoyaltySet(nftContract, tokenId, creator, royalty);
    }

    function getRoyaltyInfo(address nftContract, uint256 tokenId) external view returns (address, uint256) {
        RoyaltyInfo memory royaltyInfo = _royalties[nftContract][tokenId];
        return (royaltyInfo.creator, royaltyInfo.royalty);
    }

    function transferWithRoyalty(address nftContract, uint256 tokenId, address from, address to) external payable nonReentrant {
        RoyaltyInfo memory royaltyInfo = _royalties[nftContract][tokenId];
        uint256 royaltyAmount = (msg.value * royaltyInfo.royalty) / 100;

        require(royaltyInfo.creator != address(0), "Royalty info not set for this token");

        payable(royaltyInfo.creator).transfer(royaltyAmount);
        payable(from).transfer(msg.value - royaltyAmount);

        IERC721(nftContract).safeTransferFrom(from, to, tokenId);

        emit NFTTransferredWithRoyalty(nftContract, tokenId, from, to, msg.value, royaltyAmount);
    }
}



