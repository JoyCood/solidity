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
from config import (
    ContractAddress,
    IPC_PATH,
)

LEVEL = logging.INFO
FORMAT = "[%(levelname)s]: %(asctime)-15s %(message)s"
DATEFMT = '%Y-%m-%d %H:%M:%S'
logging.basicConfig(level=LEVEL, format=FORMAT, datefmt=DATEFMT)
logger = logging.getLogger()

abiFile = "../../build/contracts/Inherit_A.json"
with open(abiFile, 'r') as abiDefinition:
    abiJson = json.load(abiDefinition)

w3 = Web3(IPCProvider(IPC_PATH))
w3.middleware_stack.inject(geth_poa_middleware, layer=0)

contractAddress = w3.toChecksumAddress(ContractAddress)
contract = w3.eth.contract(
    address = contractAddress,
    abi = abiJson['abi']
)
w3.eth.defaultAccount = w3.eth.accounts[0]

def b1():
    transaction = {
        'gas': 999999        
    }
    result = contract.functions.b1().call()
    logger.info(result)

def b1_1():
    result = contract.functions.b1(2).call()
    logger.info(result)

def a1():
    result = contract.functions.a1().call()
    logger.info(result)

def a2():
    result = contract.functions.a2().call()
    logger.info(result)

def c2():
    result = contract.functions.c2().call()
    logger.info(result)

if __name__ == '__main__':
    b1()
    b1_1()
    a1()
    a2()
    c2()
