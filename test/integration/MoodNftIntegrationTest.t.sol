//SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract MoodNftIntegrationTest is Test {
    enum NFTState {
        HAPPY,
        SAD
    }
    MoodNft public moodNft;
    DeployMoodNft public deployer;
    address USER = makeAddr("user");

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testViewTokenUriIntegration() public {
        vm.prank(USER);
        moodNft.mintNft();
        console.log(moodNft.tokenURI(0));
    }

    function testFlipMood() public {
        vm.prank(USER);
        moodNft.mintNft();
        vm.prank(USER);
        moodNft.flipMood(0);
        assert(uint(moodNft.getStateOfTokenId(0)) == uint(NFTState.SAD));
    }
}
