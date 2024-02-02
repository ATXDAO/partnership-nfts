//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "forge-std/console.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract ATXDAOPartnershipNft is ERC721URIStorage, AccessControl {
    constructor(address[] memory admins) ERC721("ADNDN", "ATX") {
        for (uint256 i = 0; i < admins.length; i++) {
            _grantRole(DEFAULT_ADMIN_ROLE, admins[i]);
        }
    }

    uint256 mintCount;

    function mint(address target) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _mint(target, mintCount);
        mintCount++;
    }

    error ATXDAOPartnershipNft__NotValidOperator();

    function setTokenURI(uint256 tokenId, string memory tokenUri) external {
        if (msg.sender != ownerOf(tokenId)) {
            if (!hasRole(DEFAULT_ADMIN_ROLE, msg.sender)) {
                revert ATXDAOPartnershipNft__NotValidOperator();
            }
        }

        _setTokenURI(tokenId, tokenUri);
    }

    function returnToDao(
        uint256 tokenId
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        transferFrom(ownerOf(tokenId), msg.sender, tokenId);
    }

    function _checkAuthorized(
        address owner,
        address spender,
        uint256 tokenId
    ) internal view override {
        if (!hasRole(DEFAULT_ADMIN_ROLE, spender)) {
            if (!_isAuthorized(owner, spender, tokenId)) {
                if (owner == address(0)) {
                    revert ERC721NonexistentToken(tokenId);
                } else {
                    revert ERC721InsufficientApproval(spender, tokenId);
                }
            }
        }
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721URIStorage, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
