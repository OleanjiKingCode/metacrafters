// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IERC20 {
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);
}

/// @title CrowdFunding
/// @author Oleanji
/// @notice This contract enables crowdfunding using custom ERC20 tokens with refund option if goal not met

contract Crowdfunding {
    /// -----------------------------------------------------------------------
    /// Errors
    /// -----------------------------------------------------------------------

    error Transfer_Failed();
    error Funding_Goal_Reached();
    error No_Funds_To_Refund();
    error Only_ProjectOwner_Can_Withdraw();
    error Funding_Goal_Not_Reached();
    error Refund_Already_Gotten();

    /// -----------------------------------------------------------------------
    /// Variables
    /// -----------------------------------------------------------------------

    IERC20 public token;
    address public projectOwner;
    uint256 public fundingGoal;
    uint256 public totalFundsRaised;

    /// -----------------------------------------------------------------------
    /// Mapping
    /// -----------------------------------------------------------------------
    mapping(address => uint256) public accumulatedFunds;
    mapping(address => bool) public hasClaimedRefund;

    /// -----------------------------------------------------------------------
    /// Constructor
    /// -----------------------------------------------------------------------
    constructor(IERC20 _token, address _projectOwner, uint256 _fundingGoal) {
        token = _token;
        projectOwner = _projectOwner;
        fundingGoal = _fundingGoal;
    }

    /// @notice Pledge amount to a funding goal
    /// @param _amount The amount to add
    function pledgeFunds(uint256 _amount) external {
        bool success = token.transferFrom(msg.sender, address(this), _amount);
        if (!success) revert Transfer_Failed();

        accumulatedFunds[msg.sender] += _amount;
        totalFundsRaised += _amount;
        emit FundingReceived(msg.sender, _amount);
        if (totalFundsRaised >= fundingGoal) {
            emit FundingGoalReached(totalFundsRaised);
        }
    }

    /// @notice Claim Fund back when goal not met

    function claimRefund() external payable {
        if (totalFundsRaised >= fundingGoal) revert Funding_Goal_Reached();

        if (accumulatedFunds[msg.sender] == 0) revert No_Funds_To_Refund();

        if (hasClaimedRefund[msg.sender]) revert Refund_Already_Gotten();

        uint256 amountToRefund = accumulatedFunds[msg.sender];
        hasClaimedRefund[msg.sender] = true;

        bool success = token.transfer(msg.sender, amountToRefund);
        if (!success) revert Transfer_Failed();

        emit RefundSent(msg.sender, amountToRefund);
    }

    /// @notice Withdraw Fund back when goal is met
    function withdrawFunds() external {
        if (msg.sender != projectOwner) revert Only_ProjectOwner_Can_Withdraw();

        if (totalFundsRaised < fundingGoal) revert Funding_Goal_Not_Reached();

        uint256 amountToWithdraw = token.balanceOf(address(this));

        bool success = token.transfer(projectOwner, amountToWithdraw);
        if (!success) revert Transfer_Failed();
    }

    /// -----------------------------------------------------------------------
    /// Events
    /// -----------------------------------------------------------------------
    event FundingReceived(address backer, uint256 amount);
    event FundingGoalReached(uint256 totalFundsRaised);
    event RefundSent(address backer, uint256 amount);
}
