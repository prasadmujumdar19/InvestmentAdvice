// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InvestmentAdvice {

    enum InvestmentAdviceContractStatus{ Open, InService, Recommended, Closed }
    uint256 public NativeBalance = address(this).balance;

    //  Investor : Address, InvestmentAmount, ExpectedReturnInPercentage, TimeDuration
    struct Investor {
        address InvestorAddress;
        uint256 InvestorStake;
        uint256 InvestmentAmount;
        uint256 TimeDuration;
        uint256 ExpectedReturnInPercentage;
        uint16 RecommendationsCounter;
        InvestmentAdviceContractStatus status;
    } 
    
    Investor public _Investor;

    // Advisor information
    struct Advisor {
        address AdvisorAddress;
        uint256 AdvisorStake;
        string StockRecommendation;
        bool AcceptedStatus;
    }

    //Advisor[] public InvestorAdvisorsMapping;
    mapping(uint16 => Advisor) public InvestorAdvisorsMapping;

    event NewAdviceRequested(
        Investor _Investor
    );

    constructor (uint256 _investmentAmount, uint256 _duration, uint256 _expectation) payable {
            require(msg.value >=1, "Investor requesting advice needs to stake at least 1 ether");

            address _investorAddress = msg.sender;
            uint256 _investorStake = msg.value;
            uint16 _recommendationCounter = 0;
            _Investor = Investor(_investorAddress, _investorStake, _investmentAmount, _duration, _expectation, _recommendationCounter, InvestmentAdviceContractStatus.Open);
            emit NewAdviceRequested(_Investor);
        }
 
    function makeRecommendation(string calldata _stockRecommendation) public payable{
        // Need to execute this function only if contract is inService status, otherwise go back
        require(_Investor.status != InvestmentAdviceContractStatus.Recommended, "Investment advice already received" );
        
        // Store the advisor's information    
        address _advisorAddress = msg.sender;
        uint256 _advisorStake = msg.value;

        require(_advisorStake >= 1, "Advisors giving advice need to stake at least 1 ether");
        Advisor memory _Advisor;
        _Advisor = Advisor(_advisorAddress, _advisorStake, _stockRecommendation, false);
        InvestorAdvisorsMapping[_Investor.RecommendationsCounter] = _Advisor;
        if (_Investor.RecommendationsCounter == 0){
            _Investor.status = InvestmentAdviceContractStatus.InService;
        }
        _Investor.RecommendationsCounter++;
        
    }

    function recommendationAccepted(uint16 _advisorIndex) public {
        // Need to execute this function only if contract is inService status, otherwise go back
        require(_Investor.status == InvestmentAdviceContractStatus.InService, "Investment advice already received" );
        // step through all available recommendations
        for (uint16 i = 0; i <= _Investor.RecommendationsCounter; i++){
            // for the advisor that has been picked by investor
            if(i== _advisorIndex){
                InvestorAdvisorsMapping[_advisorIndex].AcceptedStatus = true; // mark the accepted status
                _Investor.status = InvestmentAdviceContractStatus.Recommended; // change the contract status to recommended
            }
            // for rest of the advisors.. we need to return the money
            else{
                /* Modify state variable first to avoid re-entrancy */
                // step a - store advisor stake in temp variable
                uint256 _vAdvisorStake = InvestorAdvisorsMapping[i].AdvisorStake;
                // step b - change advisor stake state variable to zero
                InvestorAdvisorsMapping[i].AdvisorStake = 0;
                // step c - try sending back advisor stake, if doesn't work revert the stake value
                if(!payable(InvestorAdvisorsMapping[i].AdvisorAddress).send(InvestorAdvisorsMapping[i].AdvisorStake)){
                    InvestorAdvisorsMapping[i].AdvisorStake = _vAdvisorStake;
                }
            }
        }

        // ensuring that this function is called only


/*        InvestorAdvisorsMapping[_advisorIndex].AcceptedStatus = true;
        _Investor.status = InvestmentAdviceContractStatus.Recommended;
        for (uint16 i = 0; i <= _Investor.RecommendationsCounter; i++){
            if(!(i == _advisorIndex)){

                // step a - store advisor stake in temp variable
                uint256 _vAdvisorStake = InvestorAdvisorsMapping[i].AdvisorStake;
                // step b - change advisor stake state variable to zero
                InvestorAdvisorsMapping[i].AdvisorStake = 0;
                // step c - try sending back advisor stake, if doesn't work revert the stake value
                if(!payable(InvestorAdvisorsMapping[i].AdvisorAddress).send(InvestorAdvisorsMapping[i].AdvisorStake)){
                    InvestorAdvisorsMapping[i].AdvisorStake = _vAdvisorStake;
                }
            }
        }
  */      
    }
    
}