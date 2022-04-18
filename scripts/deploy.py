
from brownie import FunMe,MockV3Aggregator,network,config
from scripts.helpful_scripts import get_accounts
from scripts.helpful_scripts import deploy_mocks,LOCAL_BLOCKCHAIN_ENVIROMENTS
from web3 import Web3



def deploy_fund_me():
    account= get_accounts()
    #pass the pricefeed contract address to the fundme contract
    #if we are on a persistant network like rinkby, use the associated addresso
    #otherwise , deploy mock
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIROMENTS:
        price_feed_address = config['networks'][network.show_active()]["eth_usd_price_feed"]
    else:
        deploy_mocks()
        price_feed_address = MockV3Aggregator[-1].address
        

    fund_me = FunMe.deploy(price_feed_address,{"from":account},publish_source=config["networks"][network.show_active()].get("verify"))
    print(f"contract deployed tp {fund_me.address}")
    return fund_me

def main():
    deploy_fund_me()