import os, json
from web3 import Web3, HTTPProvider
import time
import threading
from web3.utils.events import get_event_data
from config import ContractAddress

abiFile = "../../build/contracts/Transaction.json"
with open(abiFile, 'r') as abiDefinition:
    abiJson = json.load(abiDefinition)

w3 = Web3(HTTPProvider('http://localhost:8545'))
dbAddress = w3.toChecksumAddress(ContractAddress)
contract = w3.eth.contract(address=dbAddress, abi=abiJson['abi'])

def get_receipt(txHash):
    return w3.eth.waitForTransactionReceipt(txHash)

def output_event_data(receipt):
    print(receipt[0]['args']) 

def sender_logger_event(event):
    receipt = get_receipt(event['transactionHash'])
    receipt = contract.events.SenderLogger().processReceipt(receipt)
    output_event_data(receipt)

def value_logger_event(event):
    receipt = get_receipt(event['transactionHash'])
    receipt = contract.events.ValueLogger().processReceipt(receipt)
    output_event_data(receipt)

def balance_logger_event(event):
    receipt = get_receipt(event['transactionHash'])
    receipt = contract.events.BalanceLogger().processReceipt(receipt)
    output_event_data(receipt)

def hello_value_event(event):
    receipt = get_receipt(event['transactionHash'])
    receipt = contract.events.BasicValueLogger().processReceipt(receipt)
    output_event_data(receipt)

def hello_sender_event(event):
    receipt = get_receipt(event['transactionHash'])
    receipt = contract.events.BasicSenderLogger().processReceipt(receipt)
    output_event_data(receipt)

def log_loop(event_filter, poll_interval, handler):
    while True:
        for event in event_filter.get_new_entries():
            handler(event)
        time.sleep(poll_interval)

block_filter = contract.events.SenderLogger.createFilter(fromBlock='latest')
threading.Thread(target=log_loop, args=(block_filter, 2, sender_logger_event)).start()

block_filter = contract.events.ValueLogger.createFilter(fromBlock='latest')
threading.Thread(target=log_loop, args=(block_filter, 2, value_logger_event)).start()

block_filter = contract.events.BalanceLogger.createFilter(fromBlock='latest')
threading.Thread(target=log_loop, args=(block_filter, 2, balance_logger_event)).start()

block_filter = contract.events.BasicValueLogger.createFilter(fromBlock='latest')
threading.Thread(target=log_loop, args=(block_filter, 2, hello_value_event)).start()

#调用外部合约并返回调用者帐户地址
block_filter = contract.events.BasicSenderLogger.createFilter(fromBlock='latest')
threading.Thread(target=log_loop, args=(block_filter, 2, hello_sender_event)).start()
