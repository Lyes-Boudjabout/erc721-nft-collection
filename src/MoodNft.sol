// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    /* constants */
    string public constant NAME = "DynamicNFT";
    string public constant SYMBOL = "DNFT";

    /* errors */
    error MoodNft__NotOwnerOfTheNFT();

    /* events */
    event MoodFlipped(uint256 indexed tokenId);
    event MintedMoodNFT(uint256 indexed tokenId);

    /* storage variables */
    string private s_happySvgImageUri;
    string private s_sadSvgImageUri;
    uint256 private s_tokenCounter;
    mapping(uint256 => Mood) private s_tokenIdToMood;

    /* enumerations */
    enum Mood {
        HAPPY,
        SAD
    }

    /* constructor */
    constructor(string memory happySvgImageUri, string memory sadSvgImageUri) ERC721(NAME, SYMBOL) {
        s_happySvgImageUri = happySvgImageUri;
        s_sadSvgImageUri = sadSvgImageUri;
        s_tokenCounter = 0;
    }

    /**
     * Functions ***********
     */
    function mintNft(Mood mood) public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = mood;
        emit MintedMoodNFT(s_tokenCounter);
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        if (ownerOf(tokenId) != msg.sender) {
            revert MoodNft__NotOwnerOfTheNFT();
        }
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
        emit MoodFlipped(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageUri;

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageUri = s_happySvgImageUri;
        } else {
            imageUri = s_sadSvgImageUri;
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            '", description: "An NFT that reflects the owners mood.", attributes: [{"trait_type": "moodiness", "value": 100}],',
                            '"image": "',
                            imageUri,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    /**
     * Getter Functions ***********
     */
    function getTokenMood(uint256 tokenId) public view returns (Mood) {
        return s_tokenIdToMood[tokenId];
    }

    function gethHappySvgImageUri() public view returns (string memory) {
        return s_happySvgImageUri;
    }

    function gethSadSvgImageUri() public view returns (string memory) {
        return s_sadSvgImageUri;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }
}
