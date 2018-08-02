import os, json
from web3 import Web3, HTTPProvider
import time
import threading
from web3.utils.events import get_event_data
from config import ContractAddress

abiFile = "../../build/contracts/Basic.json"
with open(abiFile, 'r') as abiDefinition:
    abiJson = json.load(abiDefinition)

w3 = Web3(HTTPProvider('http://localhost:8545'))
dbAddress = w3.toChecksumAddress(ContractAddress)
contract = w3.eth.contract(address=dbAddress, abi=abiJson['abi'])

def get_receipt(txHash):
    return w3.eth.waitForTransactionReceipt(txHash)

def output_event_data(receipt):
    print(receipt[0]['args'])

def t22_event(event):
    receipt = get_receipt(event['transactionHash'])
    receipt = contract.events.T22_Logger().processReceipt(receipt)
    output_event_data(receipt)

def fallback_event(event):
    receipt = get_receipt(event['transactionHash'])
    receipt = contract.events.Fallback_Logger().processReceipt(receipt)
    output_event_data(receipt)

def sender_event(event):
    receipt = get_receipt(event['transactionHash'])
    receipt = contract.events.Sender_Logger().processReceipt(receipt)
    output_event_data(receipt)

def log_loop(event_filter, poll_interval, handler):
    while True:
        for event in event_filter.get_new_entries():
            handler(event)
        time.sleep(poll_interval)

block_filter = contract.events.T22_Logger.createFilter(fromBlock='latest')
threading.Thread(target=log_loop, args=(block_filter, 2, t22_event)).start()

block_filter = contract.events.Fallback_Logger.createFilter(fromBlock='latest')
threading.Thread(target=log_loop, args=(block_filter, 2, fallback_event)).start()

block_filter = contract.events.Sender_Logger.createFilter(fromBlock='latest')
threading.Thread(target=log_loop, args=(block_filter, 2, sender_event)).start()
