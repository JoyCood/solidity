/*
 * NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a 
 * function when declaring them. Failure to do so will cause commands to hang. ex:
 * ```
 * mainnet: {
 *     provider: function() { 
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>') 
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */
//var Web3 = require("web3")
module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
    solc: {
	    optimizer: {
		  enabled: true,
		  runs: 200
		}
	},
	networks: {
	    development: {
			host: "127.0.0.1",
			port: 8545,
		 	network_id: "2018",
			gas: 4000000,//999999,
			gasPrice: 99999999,
			from: "0x14CD5c014C56cd8464f871b0955Aa3B23EB78B5a"
		}
	}
	
};
