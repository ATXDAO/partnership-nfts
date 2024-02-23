// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {ATXDAOPartnershipNft} from "../contracts/ATXDAOPartnershipNft.sol";

contract YourContractTest is Test {
    ATXDAOPartnershipNft public nftCollection;

    address user = makeAddr("User");
    address user2 = makeAddr("User2");
    address admin = makeAddr("Admin");
    address multisig = makeAddr("Multisig");

    function setUp() public {
        console.log("User: ", user);
        console.log("User 2: ", user2);
        console.log("Admin: ", admin);

        address[] memory admins = new address[](1);
        admins[0] = admin;

        nftCollection = new ATXDAOPartnershipNft(
            admins,
            "ipfs://bafkreide5gtpol2fzt75qt5rpds5vdmv24qnf43frionfhesfqqb2en66a"
        );
    }

    function testSetTokenUriAsOwner() public {
        vm.prank(admin);
        nftCollection.mint(user, 0);

        vm.prank(user);
        nftCollection.setTokenURI(
            0,
            "ipfs://bafybeiaz55w6kf7ar2g5vzikfbft2qoexknstfouu524l7q3mliutns2u4/0"
        );

        assertEq(
            nftCollection.tokenURI(0),
            "ipfs://bafybeiaz55w6kf7ar2g5vzikfbft2qoexknstfouu524l7q3mliutns2u4/0"
        );
    }

    function testSetTokenUriAsAdmin() public {
        vm.prank(admin);
        nftCollection.mint(user, 0);

        vm.startPrank(admin);
        nftCollection.setTokenURI(
            0,
            "ipfs://bafybeiaz55w6kf7ar2g5vzikfbft2qoexknstfouu524l7q3mliutns2u4/0"
        );
        vm.stopPrank();

        assertEq(
            nftCollection.tokenURI(0),
            "ipfs://bafybeiaz55w6kf7ar2g5vzikfbft2qoexknstfouu524l7q3mliutns2u4/0"
        );
    }

    function testRevertIfNotOwner() public {
        vm.prank(admin);
        nftCollection.mint(user, 0);

        vm.startPrank(user2);
        vm.expectRevert();
        nftCollection.setTokenURI(
            0,
            "ipfs://bafybeiaz55w6kf7ar2g5vzikfbft2qoexknstfouu524l7q3mliutns2u4/0"
        );
        vm.stopPrank();
    }

    function testReturnToDao() public {
        vm.startPrank(admin);
        nftCollection.mint(user, 0);

        nftCollection.revokeNft(0, multisig);
        vm.stopPrank();

        assertEq(nftCollection.ownerOf(0), multisig);
    }

    function testRevert__ReturnToDao__IfNotAdmin() public {
        vm.startPrank(admin);
        nftCollection.mint(user, 0);
        vm.stopPrank();

        vm.prank(user);
        vm.expectRevert();
        nftCollection.revokeNft(0, multisig);
    }

    function testTransfer() public {
        vm.startPrank(admin);
        nftCollection.mint(user, 0);
        vm.stopPrank();

        vm.prank(user);
        nftCollection.transferFrom(user, user2, 0);
    }
}
