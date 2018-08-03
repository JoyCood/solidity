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

abiFile = "../../build/contracts/C.json"
with open(abiFile, 'r') as abiDefinition:
    abiJson = json.load(abiDefinition)

w3 = Web3(IPCProvider(IPC_PATH))
w3.middleware_stack.inject(geth_poa_middleware, layer=0)

dbAddress = w3.toChecksumAddress(ContractAddress)
contract = w3.eth.contract(
    address = dbAddress,
    abi = abiJson['abi']
)

account = w3.eth.accounts[0]

logger.info("account: {}".format(account))

def output_transaction_result(fun, txHash):
    result = w3.eth.waitForTransactionReceipt(txHash)
    logger.info("{}: status={}".format(
        fun, 
        ('success' if result['status'] else 'false') 
    ))

def c1():
    result = contract.functions.c1().call()
    logger.info("c1: {}".format(result))

def c2():
    txHash = contract.functions.c2().transact({ 
        'from': account,
        'gas': 99999,
    })
    output_transaction_result('c2', txHash)
    
def c3():
    result = contract.functions.c3().call()
    logger.info("c3: {}".format(result))

def c4():
    txHash = contract.functions.c4().transact({
        'from': account    
    })
    output_transaction_result('c4', txHash)

def c5():
    txHash = contract.functions.c5().transact({
        'from': account    
    })
    output_transaction_result('c5', txHash)

def c6():
    txHash = contract.functions.c6().transact({
        'from': account    
    })
    output_transaction_result('c6', txHash)

def c7():
    #result = contract.functions.c7().call()
    #logger.info("c7: result={}".format(result))
    txHash = contract.functions.c7().transact({
        'from': account    
    })
    output_transaction_result('c7', txHash)

if __name__ == '__main__':
    c1()
    c2()
    c3()
    c4()
    c5()
    c6()
    c7()
