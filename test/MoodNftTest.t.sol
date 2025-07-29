// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {DeployMoodNft} from "../script/DeployMoodNft.s.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNftTest is Test {
    MoodNft public moodNft;
    DeployMoodNft public deployMoodNft;
    address public USER;

    function setUp() external {
        deployMoodNft = new DeployMoodNft();
        moodNft = deployMoodNft.run();
        USER = makeAddr("user");
    }

    function testTokenMintedCorrectly() public {
        string memory expectedOutput = string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            moodNft.name(),
                            '", description: "An NFT that reflects the owners mood.", attributes: [{"trait_type": "moodiness", "value": 100}],',
                            '"image": "',
                            moodNft.gethHappySvgImageUri(),
                            '"}'
                        )
                    )
                )
            )
        );

        vm.startPrank(USER);
        moodNft.mintNft(MoodNft.Mood.HAPPY);
        string memory tokenUriString = moodNft.tokenURI(0);
        vm.stopPrank();

        assertEq(keccak256(abi.encodePacked(tokenUriString)), keccak256(abi.encodePacked(expectedOutput)));
    }

    function testFlippingMoodNFT() public {
        vm.startPrank(USER);
        moodNft.mintNft(MoodNft.Mood.HAPPY);
        moodNft.flipMood(0);
        vm.stopPrank();

        assertEq(uint8(moodNft.getTokenMood(0)), uint8(MoodNft.Mood.SAD));
    }
}
