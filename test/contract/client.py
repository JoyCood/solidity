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

abiFile = "../../build/contracts/Transaction.json"
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

logger.info(account)

def send_ether_to_contract():
    transaction = {
        'from': account,        
        'to': dbAddress,
        'data': 'a',
        'gas': 999999,
        'value': Web3.toWei(1, 'ether')
    }
    txHash = w3.eth.sendTransaction(transaction)
    result = w3.eth.waitForTransactionReceipt(txHash)
    print(result)

def call_other_contract():
    transaction = {
        'from': account,
        'gas': 999999,
        'value': 1000000000, #发送1000000000个代币给合约
        #'data': 这个参数表示编译过后的合约代码或将被调用合约函数与参数(函数与参数都是签名生成的hash值) 
    }
    txHash = contract.functions.setValueToHelloContract(99).transact(transaction)
    result = w3.eth.waitForTransactionReceipt(txHash)
    print(result)

def call_not_exists_function():
    txHash = contract.functions.foo().transact({
            'from': account,
            'gas': 999999
    })
    result = w3.eth.waitForTransactionReceipt(txHash)
    print(result)

#调用其它合约取值
def get_value_from_other_contract():
    transaction = {
        'from': account,
        'gas': 999999
    }
    txHash = contract.functions.getValueFromHelloContract().transact(transaction)
    result = w3.eth.waitForTransactionReceipt(txHash)
    print(result)

#本地调用，不广播，读取本地的值,不会消耗gas
#如果只想读取数据，使用call来节省时间、gas
def make_call():
    result = contract.functions.getValueFromHelloContract().call()
    print(result)

def get_sender_from_other_contract():
    transaction = {
        'from': account,
        'gas': 999999
    }
    txHash = contract.functions.getSenderFromHelloContract().transact(transaction)
    result = w3.eth.waitForTransactionReceipt(txHash)
    print(result)

def send_ether_to_other_contract():
    transaction = {
        'from': account,         
        'gas': 999999
    }
    txHash = contract.functions.sendEtherToHelloContract().transact(transaction)
    result = w3.eth.waitForTransactionReceipt(txHash)
    print(result)

def call_other_contract_without_abi():
    transaction = {
        'from': account,
        'gas': 999999
    }
    txHash = contract.functions.getValueFromHelloContractWithoutABI().transact(transaction)
    result = w3.eth.waitForTransactionReceipt(txHash)
    print(result)

if __name__ == '__main__':
    #print()
    #send_ether_to_contract()
    #print()
    #call_not_exists_function()
    #call_other_contract()
    #print()
    #get_value_from_other_contract()
    #print()
    #get_sender_from_other_contract()
    #print()
    #make_call()
    #print()
    #send_ether_to_other_contract()
    print()
    call_other_contract_without_abi()
