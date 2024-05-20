// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTWithRoyalties is ERC721 {
    mapping(uint256 => address) private _creators;
    mapping(uint256 => uint256) private _royalties;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    function mint(address to, uint256 tokenId, uint256 royalty) external {
        _mint(to, tokenId);
        _creators[tokenId] = msg.sender;
        _royalties[tokenId] = royalty;
    }

    function transferWithRoyalty(address from, address to, uint256 tokenId) external payable {
        uint256 royaltyAmount = (msg.value * _royalties[tokenId]) / 100;
        payable(_creators[tokenId]).transfer(royaltyAmount);
        payable(from).transfer(msg.value - royaltyAmount);
        safeTransferFrom(from, to, tokenId);
    }
}
