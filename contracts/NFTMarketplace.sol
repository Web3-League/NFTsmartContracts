// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract NFTMarketplace is ReentrancyGuard {
    struct Offer {
        uint256 tokenId;
        address seller;
        uint256 price;
    }

    mapping(uint256 => Offer) public offers;
    IERC721 public nftContract;

    event OfferCreated(uint256 indexed tokenId, address indexed seller, uint256 price);
    event OfferCancelled(uint256 indexed tokenId, address indexed seller);
    event NFTBought(uint256 indexed tokenId, address indexed buyer, address indexed seller, uint256 price);

    constructor(address _nftContract) {
        require(_nftContract != address(0), "Invalid NFT contract address");
        nftContract = IERC721(_nftContract);
    }

    function createOffer(uint256 tokenId, uint256 price) external nonReentrant {
        require(nftContract.ownerOf(tokenId) == msg.sender, "Only owner can create offer");
        require(price > 0, "Price must be greater than zero");

        nftContract.transferFrom(msg.sender, address(this), tokenId);
        offers[tokenId] = Offer(tokenId, msg.sender, price);

        emit OfferCreated(tokenId, msg.sender, price);
    }

    function cancelOffer(uint256 tokenId) external nonReentrant {
        Offer memory offer = offers[tokenId];
        require(offer.seller == msg.sender, "Only seller can cancel offer");

        nftContract.transferFrom(address(this), msg.sender, tokenId);
        delete offers[tokenId];

        emit OfferCancelled(tokenId, msg.sender);
    }

    function buyNFT(uint256 tokenId) external payable nonReentrant {
        Offer memory offer = offers[tokenId];
        require(offer.price > 0, "NFT not for sale");
        require(msg.value == offer.price, "Incorrect price");

        nftContract.transferFrom(address(this), msg.sender, tokenId);
        payable(offer.seller).transfer(msg.value);
        delete offers[tokenId];

        emit NFTBought(tokenId, msg.sender, offer.seller, offer.price);
    }

    function getOffer(uint256 tokenId) external view returns (Offer memory) {
        return offers[tokenId];
    }
}

