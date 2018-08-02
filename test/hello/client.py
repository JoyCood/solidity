import logging
import os
import json
import time

from web3 import (
    IPCProvider,
    Web3,
)
from web3.middleware import (
    geth_poa_middleware,        
)
from hello_config import (
    ContractAddress,
    IPC_PATH,
)

LEVEL = logging.INFO
FORMAT = "[%(levelname)s]: %(asctime)-15s %(message)s"
DATEFMT = '%Y-%m-%d %H:%M:%S'
logging.basicConfig(level=LEVEL, format=FORMAT, datefmt=DATEFMT)
logger = logging.getLogger()

abiFile = "../../build/contracts/Hello.json"
with open(abiFile, 'r') as abiDefinition:
    abiJson = json.load(abiDefinition)

w3 = Web3(IPCProvider(IPC_PATH))
w3.middleware_stack.inject(geth_poa_middleware, layer=0)

dbAddress = w3.toChecksumAddress(ContractAddress)
contract = w3.eth.contract(
    address=dbAddress,
    abi=abiJson['abi']
)
account = w3.eth.accounts[0]

def get_value():
    transaction = {
        'from': account,
        'gas': 999999
    }
    txHash = contract.functions.t22().transact(transaction)
    result = w3.eth.waitForTransactionReceipt(txHash)
    print(result)

if __name__ == '__main__':
    get_value()
