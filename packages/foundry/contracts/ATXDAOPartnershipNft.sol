//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "forge-std/console.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

abstract contract ATXDAOPartnershipNft is ERC721URIStorage, AccessControl {
    error ATXDAOPartnershipNft__NotValidOperator();

    string mintUri;
    uint256 mintCount;

    bool s_isTradeable;

    constructor(
        address[] memory admins,
        string memory newMintUri,
        bool isTradeable,
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) {
        for (uint256 i = 0; i < admins.length; i++) {
            _grantRole(DEFAULT_ADMIN_ROLE, admins[i]);
        }

        mintUri = newMintUri;
        s_isTradeable = isTradeable;
    }

    function _checkAuthorized(
        address owner,
        address spender,
        uint256 tokenId
    ) internal view override {
        if (!hasRole(DEFAULT_ADMIN_ROLE, spender)) {
            if (s_isTradeable) super._checkAuthorized(owner, spender, tokenId);
        }
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721URIStorage, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function mint(address target) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _mint(target, mintCount);
        _setTokenURI(mintCount, mintUri);
        mintCount++;
    }

    function setTokenURI(uint256 tokenId, string memory tokenUri) external {
        if (msg.sender != ownerOf(tokenId)) {
            if (!hasRole(DEFAULT_ADMIN_ROLE, msg.sender)) {
                revert ATXDAOPartnershipNft__NotValidOperator();
            }
        }

        _setTokenURI(tokenId, tokenUri);
    }

    function revokeNft(
        uint256 tokenId,
        address receiver
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        transferFrom(ownerOf(tokenId), receiver, tokenId);
    }

    function setMintUri(
        string memory newMintUri
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        mintUri = newMintUri;
    }

    function getMintUri() external view returns (string memory) {
        return mintUri;
    }

    function getMintCount() external view returns (uint256) {
        return mintCount;
    }

    function burn(uint256 tokenId) external {
        if (msg.sender != ownerOf(tokenId)) {
            if (!hasRole(DEFAULT_ADMIN_ROLE, msg.sender)) {
                revert ATXDAOPartnershipNft__NotValidOperator();
            }
        }

        _burn(tokenId);
    }
}
