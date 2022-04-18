from brownie import FunMe
from scripts.helpful_scripts import get_accounts


def fund():
    fund_me = FunMe[-1]
    account = get_accounts()
    entrence_fee = fund_me.getEnterenceFee()
    print(entrence_fee)
    print(f"current entry fee is {entrence_fee}")
    print("Funding")
    fund_me.fund({"from":account,"value":entrence_fee})

def withdraw():
    fund_me = FunMe[-1]
    account = get_accounts()
    fund_me.withdraw({"from":account})


def main():
    fund()
    withdraw()
