//SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";

/**
 An example of nft data:

 {
  "name": "CryptoKitty #123",
  "description": "A unique digital cat.",
  "image": "https://example.com/cryptokitty/123.png",
  "attributes": [
    { "trait_type": "Color", "value": "Blue" },
    { "trait_type": "Fur", "value": "Fluffy" }
  ]
}

 */

contract MoodNft is ERC721 {
    // error
    error MoodNft_CantFlipMoodIfNotOwner();

    enum NFTState {
        HAPPY,
        SAD
    }
    uint256 private s_tokenCounter;
    string private s_happySvg;
    string private s_sadSvg;
    mapping(uint256 => NFTState) private s_tokenIdToState;

    // event
    event CreatNFT(uint256 indexed tokenId);

    constructor(
        string memory happyImageUri,
        string memory sadImageUri
    ) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_happySvg = happyImageUri;
        s_sadSvg = sadImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToState[s_tokenCounter] = NFTState.HAPPY; // default HAPPY
        emit CreatNFT(s_tokenCounter);
        s_tokenCounter += 1;
    }

    function flipMood(uint256 tokenId) public {
        if (
            getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender
        ) {
            revert MoodNft_CantFlipMoodIfNotOwner();
        }

        if (s_tokenIdToState[tokenId] == NFTState.HAPPY) {
            s_tokenIdToState[tokenId] = NFTState.SAD;
        } else {
            s_tokenIdToState[tokenId] = NFTState.HAPPY;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imgUri;
        if (s_tokenIdToState[tokenId] == NFTState.HAPPY) {
            imgUri = s_happySvg;
        } else if (s_tokenIdToState[tokenId] == NFTState.SAD) {
            imgUri = s_sadSvg;
        }
        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes( // bytes casting actually unnecessary as 'abi.encodePacked()' returns a bytes
                            abi.encodePacked(
                                '{"name":"',
                                name(),
                                '","description":"An NFT that reflects the mood of the owner, 100% on Chain!","image":"',
                                imgUri,
                                '","attributes":[{"trait_type":"mood","value":"100"}]}'
                            )
                        )
                    )
                )
            );
    }

    function getHappySVG() public view returns (string memory) {
        return s_happySvg;
    }

    function getSadSVG() public view returns (string memory) {
        return s_sadSvg;
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

    function getStateOfTokenId(uint256 tokenId) public view returns (NFTState) {
        return s_tokenIdToState[tokenId];
    }
}
