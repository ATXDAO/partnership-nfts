//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "forge-std/console.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import "./ATXDAOPartnershipNft.sol";

contract SixthStreetPartnershipNft is ATXDAOPartnershipNft {
    constructor(
        address[] memory admins,
        string memory newMintUri
    )
        ATXDAOPartnershipNft(
            admins,
            newMintUri,
            "ATX DAO Partnership NFT - Sixth",
            "ATXPS"
        )
    {}
}
