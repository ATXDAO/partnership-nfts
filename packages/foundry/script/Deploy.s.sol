//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/ATXDAOPartnershipNft.sol";
import "./DeployHelpers.s.sol";

contract DeployScript is ScaffoldETHDeploy {
    error InvalidPrivateKey(string);

    address admin = 0x62286D694F89a1B12c0214bfcD567bb6c2951491;

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

        ATXDAOPartnershipNft yourContract = new ATXDAOPartnershipNft(
            admins,
            "ipfs://bafkreide5gtpol2fzt75qt5rpds5vdmv24qnf43frionfhesfqqb2en66a"
        );

        console.logString(
            string.concat(
                "YourContract deployed at: ",
                vm.toString(address(yourContract))
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
