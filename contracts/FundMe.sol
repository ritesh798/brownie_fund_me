//"SPDX-License-Identifier: MIT"

pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FunMe{

    using SafeMathChainlink for uint256;

    mapping(address => uint256)  public addressToAmountFunded;
    address[] public funders;
    address public owner;
    AggregatorV3Interface public pricefeed;

    constructor(address _price_feed) public {
        owner = msg.sender;
        pricefeed = AggregatorV3Interface(_price_feed);
    }

    function fund() public payable {
        uint256 minimumUSD = 50*10**18;
        require(getConversionRate(msg.value)>= minimumUSD,"You neddd to spend more Eth");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
        }

    function getVersion() public view returns (uint256){
        
        return pricefeed.version();
    }

    function getPrice() public view returns(uint256){
        
        (,int256 answer,,,)=pricefeed.latestRoundData();
        return uint256(answer*1000000000);
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice =getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount)/100000000000000000;
        return ethAmountInUsd;
    }

    function getEnterenceFee() public view returns (uint256){
        //minimumumUSD
        uint256 minimumUSD = 50* 10**18;
        uint256 price = getPrice();
        uint256 precision = 1* 10**18;
        return (minimumUSD * precision)/price;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function  withdraw() payable onlyOwner public {
        
        msg.sender.transfer(address(this).balance);
        for(uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder]=0;

        }
        funders = new address[](0);
    }


}
 
  