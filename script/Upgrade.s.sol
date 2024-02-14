// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {ImplementationV2} from "../src/ImplementationV2.sol";
import {ImplementationV1} from "../src/ImplementationV1.sol";

contract Upgrade is Script {
    function run() external returns (address) {
        address mostRecentlyDeployedProxy = DevOpsTools
            .get_most_recent_deployment("ERC1967Proxy", block.chainid);

        vm.startBroadcast();
        ImplementationV2 newImplementation = new ImplementationV2();
        vm.stopBroadcast();
        address proxy = upgrade(
            mostRecentlyDeployedProxy,
            address(newImplementation)
        );
        return proxy;
    }

    function upgrade(
        address proxyAddress,
        address newImplementation
    ) public returns (address) {
        vm.startBroadcast();
        ImplementationV1 proxy = ImplementationV1(proxyAddress);
        proxy.upgradeTo(address(newImplementation));
        vm.stopBroadcast();
        return address(proxy);
    }
}
