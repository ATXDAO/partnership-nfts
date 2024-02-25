//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/RaineyStreetPartnershipNft.sol";
import "../contracts/SixthStreetPartnershipNft.sol";

// import "../contracts/ATXDAOPartnershipNft.sol";
import "./DeployHelpers.s.sol";

contract DeployScript is ScaffoldETHDeploy {
    error InvalidPrivateKey(string);

    address admin = 0x3bEc6a181d6Ef7239F699DAf2fAa5FE3A5f01Edf;

    function run() external {
        uint256 deployerPrivateKey = setupLocalhostEnv();
        if (deployerPrivateKey == 0) {
            revert InvalidPrivateKey(
                "You don't have a deployer account. Make sure you have set DEPLOYER_PRIVATE_KEY in .env or use `yarn generate` to generate a new random account"
            );
        }

        vm.startBroadcast(deployerPrivateKey);

        address[] memory admins = new address[](1);
        admins[0] = admin;

        RaineyStreetPartnershipNft yourContract1 = new RaineyStreetPartnershipNft(
                admins,
                "ipfs://bafkreide5gtpol2fzt75qt5rpds5vdmv24qnf43frionfhesfqqb2en66a"
            );

        SixthStreetPartnershipNft yourContract2 = new SixthStreetPartnershipNft(
            admins,
            "ipfs://bafkreide5gtpol2fzt75qt5rpds5vdmv24qnf43frionfhesfqqb2en66a"
        );

        console.logString(
            string.concat(
                "YourContract deployed at: ",
                vm.toString(address(yourContract1))
            )
        );

        console.logString(
            string.concat(
                "YourContract deployed at: ",
                vm.toString(address(yourContract2))
            )
        );
        vm.stopBroadcast();

        /**
         * This function generates the file containing the contracts Abi definitions.
         * These definitions are used to derive the types needed in the custom scaffold-eth hooks, for example.
         * This function should be called last.
         */
        exportDeployments();
    }

    function test() public {}
}
