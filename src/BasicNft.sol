// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToUri;

    constructor() ERC721("BasicNFT", "BNFT") {
        s_tokenCounter = 0;
    }

    function tokenURI(
        uint256 _tokenId
    ) public view override returns (string memory) {
        return s_tokenIdToUri[_tokenId];
    }

    function mintNft(string memory _tokenUri) public {
        s_tokenIdToUri[s_tokenCounter] = _tokenUri;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

}