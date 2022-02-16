pragma solidity ^0.4.24;

import "contracts/Buzz.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Crowdsale is Ownable {

    uint256 public startTime;
    uint256 public endTime;
    uint256 public weiTokenPrice;
    uint256 public weiInvestmentObjective;
    uint256 public investmentReceived;
    uint256 public investmentRefunded;
    mapping (address => uint256) public investmentAmountOf;
    bool public isFinalized;
    bool public isRefundingAllowed;
    address public owner;
    BuzzToken public crowdsaleToken;
    
    event LogInvestment(address indexed investor, uint256 value);
    event LogTokenAssignment(address indexed investor, uint256 numTokens);

    constructor(uint256 _startTime, uint256 _endTime, uint256 _weiTokenPrice, uint256 _etherInvestmentObjective) public {

        require(_startTime >= now);
        require(_endTime >= _startTime);
        require(_weiTokenPrice != 0);
        require(_etherInvestmentObjective != 0);

        startTime = _startTime;
        endTime = _endTime;
        weiTokenPrice = _weiTokenPrice;
        weiInvestmentObjective = _etherInvestmentObjective;

        crowdsaleToken = new BuzzToken();
        isFinalized = false;
        isRefundingAllowed = false;
        owner = msg.sender;
    }

    function invest(address _beneficiary) public payable {
        require(isValidInvestment(msg.value));

        address investor = msg.sender;
        uint256 investment = msg.value;

        investmentAmountOf[investor] += investment;
        investmentReceived[investor] += investment;

        assignTokens(investor, investment);
        emit LogInvestment(investor, investment);

    }

    

    function finalize() onlyOwner public {}

    function refund() public {}

}