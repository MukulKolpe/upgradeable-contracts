// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {Deploy} from "../script/Deploy.s.sol";
import {Upgrade} from "../script/Upgrade.s.sol";
import {ImplementationV1} from "../src/ImplementationV1.sol";
import {ImplementationV2} from "../src/ImplementationV2.sol";

contract DeployAndUpgrade is Test {
    Deploy public deployer;
    Upgrade public upgrader;
    address public OWNER = makeAddr("owner");

    address public proxy;

    function setUp() public {
        deployer = new Deploy();
        upgrader = new Upgrade();
        proxy = deployer.run();
    }

    function testProxyStartsAsImplementationV1() public {
        vm.expectRevert();
        ImplementationV2(proxy).setNumber(10);
    }

    function testUpgrade() public {
        ImplementationV2 implementationV2 = new ImplementationV2();

        upgrader.upgrade(proxy, address(implementationV2));

        uint256 expectedValue = 2;
        assertEq(expectedValue, ImplementationV2(proxy).version());

        ImplementationV2(proxy).setNumber(10);
        assertEq(10, ImplementationV2(proxy).getNumber());
    }
}
