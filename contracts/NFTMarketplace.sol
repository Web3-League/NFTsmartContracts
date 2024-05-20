// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract NFTMarketplace is ReentrancyGuard {
    struct Offer {
        uint256 tokenId;
        address seller;
        uint256 price;
        address nftContract;
    }

    Offer[] public offers;

    event OfferCreated(uint256 indexed tokenId, address indexed seller, uint256 price, address indexed nftContract);
    event OfferCancelled(uint256 indexed tokenId, address indexed seller, address indexed nftContract);
    event NFTBought(uint256 indexed tokenId, address indexed buyer, address indexed seller, uint256 price, address nftContract);

    event Log(string message);

    function createOffer(address nftContract, uint256 tokenId, uint256 price) external nonReentrant {
        require(IERC721(nftContract).ownerOf(tokenId) == msg.sender, "Only owner can create offer");
        require(price > 0, "Price must be greater than zero");

        emit Log("Passed owner and price checks");

        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);
        offers.push(Offer(tokenId, msg.sender, price, nftContract));

        emit Log("NFT transferred and offer created");

        emit OfferCreated(tokenId, msg.sender, price, nftContract);
    }

    function cancelOffer(uint256 tokenId, address nftContract) external nonReentrant {
        Offer memory offer;
        uint256 offerIndex;

        // Find the offer
        for (uint256 i = 0; i < offers.length; i++) {
            if (offers[i].tokenId == tokenId && offers[i].nftContract == nftContract) {
                offer = offers[i];
                offerIndex = i;
                break;
            }
        }

        require(offer.seller == msg.sender, "Only seller can cancel offer");

        IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);
        offers[offerIndex] = offers[offers.length - 1];
        offers.pop();

        emit OfferCancelled(tokenId, msg.sender, nftContract);
    }

    function buyNFT(uint256 tokenId, address nftContract) external payable nonReentrant {
        Offer memory offer;
        uint256 offerIndex;

        // Find the offer
        for (uint256 i = 0; i < offers.length; i++) {
            if (offers[i].tokenId == tokenId && offers[i].nftContract == nftContract) {
                offer = offers[i];
                offerIndex = i;
                break;
            }
        }

        require(offer.price > 0, "NFT not for sale");
        require(msg.value == offer.price, "Incorrect price");

        emit Log("Passed sale checks");

        IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);
        payable(offer.seller).transfer(msg.value);
        offers[offerIndex] = offers[offers.length - 1];
        offers.pop();

        emit NFTBought(tokenId, msg.sender, offer.seller, offer.price, nftContract);
    }

    function getOffers() external view returns (Offer[] memory) {
        return offers;
    }

    function getOffer(uint256 tokenId, address nftContract) external view returns (Offer memory) {
        for (uint256 i = 0; i < offers.length; i++) {
            if (offers[i].tokenId == tokenId && offers[i].nftContract == nftContract) {
                return offers[i];
            }
        }
        revert("Offer not found");
    }
}






