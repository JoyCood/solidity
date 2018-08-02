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

abiFile = "../../build/contracts/TokenERC20.json"
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
target = w3.eth.accounts[1]
target2 = w3.eth.accounts[2]
logger.info(account)

def output_transact_result(txHash):
    result = w3.eth.waitForTransactionReceipt(txHash)
    logger.info(result)

def transfer(target, value):
    transaction = {
        'from': account,        
        'gas': 999999,
    }
    txHash = contract.functions.transfer(target, value).transact(transaction)
    #output_transact_result(txHash)

def send_eth(target, value): 
    transaction = {
        'from': account,
        'to': target,
        'gas': 999999,
        'value': w3.toWei(value, 'ether')
    }
    txHash = w3.eth.sendTransaction(transaction)
    #output_transact_result(txHash)

def balanceOf(target=target):
    result = contract.functions.balanceOf(target).call()
    logger.info('account: {}, balance: {}'.format(
        target,
        result
    ))

def approve(target, value):
    transaction = {
        'from': account,        
        'gas': 999999,
    }
    txHash = contract.functions.approve(target, value).transact(transaction)
    #output_transact_result(txHash)

def transferFrom(_from, to, value): 
    transaction = {
        'from': account,
        'gas': 999999,
    }
    txHash = contract.functions.transferFrom(_from, to, value).transact(transaction)
    #output_transact_result(txHash)

def allowance(_from, spender): #代理帐号授权余额
    result = contract.functions.allowance(_from, spender).call()
    logger.info(result)

if __name__ == '__main__':
    transfer(target, 100)  #account转100个代币给target
    balanceOf(target) #查询target帐户代币余额 
    balanceOf(account) #查询account帐户余额
    approve(target, 1000) #给target帐户授权代理转帐,额度为1000
    transferFrom(account, target, 100) #从account用户中转100个代币给target用户
    balanceOf(target) #查询target帐户余额
    allowance(account, target) #查询代理帐号授权余额
