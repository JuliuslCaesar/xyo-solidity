# XY Oracle Network Smart Contract API

Library toolkit for developing dApps connected to the XY Oracle Network. Users can subscribe to webhooks for event listeners from the XY contract using https://ethercast.io/.

## Requirements

Installing Ganache as a local, Ethereum blockchain node:

* Make sure you have Node.js installed, then run `npm install -g ganache-cli`
* Then, run `ganache-cli`. It will start a local Ethereum simulation on port 8545.

Now that you have Ganache, you can clone the xyo-solidity repo and deploy the XY
core smart contract to the local node as follows:

* Install truffle with `npm i truffle -g`
* Clone the xyo-solidity repo `git clone https://github.com/XYOracleNetwork/xyo-solidity`
* While ganache is running, compile and deploy the contract: `truffle compile && truffle migrate`
* You should see the following in your command line:

![Truffle Migrate](https://i.imgur.com/zfa7YjL.png)

You can also run the simple unit tests over the XY.sol file with `truffle test`

## Project Structure

All of the Ethereum smart contracts used are under `contracts/`, and the compiled JSON artifacts are under `dist/contracts/`. 

Unit tests can be found at `test/`, and example smart contracts that communicate with the XY contract are under `examples/`.

The migration scripts are under `migrations/`.

The gulp files are under `gulp/`.

## Milestones

### Done
* Basic interface for sending location queries and receiving answers
* Multiple types of location query

### Planned
* Verify answers provided by Diviners

## Authors

See the list of [contributors](https://github.com/XYOracleNetwork/xyo-solidity/contributors) who participated in this project.

## License

TODO
