import logging
import os
import json
from web3 import (Web3, HTTPProvider)
import time
import threading
from web3.utils.events import get_event_data
from config import ContractAddress

POLL_INTERVAL = 2

LEVEL = logging.INFO
FORMAT = "[%(levelname)s]: %(asctime)-15s %(message)s"
DATEFMT = '%Y-%m-%d %H:%M:%S'
logging.basicConfig(level=LEVEL, format=FORMAT, datefmt=DATEFMT)
logger = logging.getLogger()

abiFile = "../../build/contracts/C.json"
with open(abiFile) as abiDefinition:
    abiJson = json.load(abiDefinition)

w3 = Web3(HTTPProvider("http://localhost:8545"))
dbAddress = w3.toChecksumAddress(ContractAddress)
contract = w3.eth.contract(address=dbAddress, abi=abiJson['abi'])

def get_receipt(txHash):
    return w3.eth.waitForTransactionReceipt(txHash)

def output_event_data(receipt):
    logger.info(receipt[0]['args'])

def log_loop(event_filter, handler):
    while True:
        for event in event_filter.get_new_entries():
            handler(event)
        time.sleep(POLL_INTERVAL)

def c4(event): 
    receipt = get_receipt(event['transactionHash'])
    receipt = contract.events.LogSender().processReceipt(receipt)
    output_event_data(receipt)

def c5(event):
    receipt = get_receipt(event['transactionHash'])
    receipt = contract.events.LogValue().processReceipt(receipt)
    output_event_data(receipt)

if __name__ == '__main__':
    block_filter = contract.events.LogSender.createFilter(fromBlock='latest')
    threading.Thread(target=log_loop, args=(block_filter, c4)).start()

    block_filter = contract.events.LogValue.createFilter(fromBlock='latest')
    threading.Thread(target=log_loop, args=(block_filter, c5)).start()


