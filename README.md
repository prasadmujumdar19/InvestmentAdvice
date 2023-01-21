# InvestmentAdvice
First solidity project

-- Information below is rough sketch of what functionality I am intending to achieve..

-- It's not up-to-date with code if you are seeing this line.. I just wrote these notes, started working on code and then discoverd things as I went along
-- Also, there were some learnings such as re-entrancy that I incorportated as I went along
-- Haven't got a chance yet to review and revise below notes

Investor 
- Got $100 and wants to make $10 in a period of 1 month
- Floats an open request to pay 1 ETH on getting a good recommendation of a stock that helps him/her to make expected bucks in a specified period
- Receives requests from many advisors
- Gets to choose single advisor based off available history on blockchain for this advisor
:: Address

Advisor
- Got an experience and happy to make recommendations to Investors
- Keep watching the space for Investors floating their requests
:: Address

Investment Advice Request
- Advisors can make 1 ETH off good recommendation
- But, these advisors need to have skin-in-the-game, so they need to stake 1 ETH too
- If recommendation turns out good, advisors get their own 1 ETH back + 1 ETH that was staked by Investor for getting good stock-tip
- 1 ETH from an Investor and an Advisor is kept in an Escrow and released automatically when investor makes required money
:: InvestmentAdvice
    Initialise (constructor): Address, InvestmentAmount, ExpectedReturnInPercentage, TimeDuration
    AcceptRecommendation : Pick 1 advisor out of many
    ReportSuccessfulRecommendation (PercentageReturn) : Release ETH's in Escrow to Advisor, 50% if 50-80% on target, 1 ETH in full if >80% on-target
    ReportUnSuccessfulRecommendation  : Release ETH's either back to investor (if <50% on target)

:: Advisors call with (MakeRecommendation): Address, StockPick