// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {ImplementationV1} from "../src/ImplementationV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract Deploy is Script {
    function run() external returns (address) {
        address proxy = deploy();
        return proxy;
    }
    function deploy() public returns (address) {
        vm.startBroadcast();
        ImplementationV1 implementationv1 = new ImplementationV1();
        ERC1967Proxy proxy = new ERC1967Proxy(address(implementationv1), "");
        ImplementationV1(address(proxy)).initialize();
        vm.stopBroadcast();
        return address(proxy);
    }
}
