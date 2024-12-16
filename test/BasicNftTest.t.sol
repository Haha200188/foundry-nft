//SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract BasicNftTest is Test {
    string constant NFT_NAME = "Dogie";
    string constant NFT_SYMBOL = "DOG";
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public constant USER = address(1);
    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testInitializedCorrectly() public view {
        // assert(
        //     keccak256(abi.encodePacked((basicNft.name()))) ==
        //         keccak256(abi.encodePacked(NFT_NAME))
        // );
        assertEq(basicNft.name(), NFT_NAME);
        assertEq(basicNft.symbol(), NFT_SYMBOL);
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);
        assert(basicNft.balanceOf(USER) == 1);
    }

    function testTokenURIIsCorrect() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);
        assertEq(basicNft.tokenURI(0), PUG_URI);
    }

    function testTokenCounterIsCorrect() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);
        assertEq(basicNft.getTokenCounter(), 1);
    }
}
