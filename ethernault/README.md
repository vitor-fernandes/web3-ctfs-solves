# ethernault-ctf-solves
This repository contains some codes wrote in Foundry Framework to solve the challenges of Ethernault CTF

Before starting to run the tests, it's necessary to install the dependencies:
```
    git clone https://github.com/vitor-fernandes/ethernault-ctf-solves
    cd ethernault-ctf-solves
    forge install --no-commit
```

To run a specific challenge, execute the following command:

```
    forge test --match-path test/CONTRACT.t.sol -vvv
```

