/**
 *Submitted for verification at BscScan.com on 2023-03-27
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract FreelanceContract {
    struct Order {
        address payable customer;
        string description;
        string fullDescription;
        string category;
        uint256 price;
        bool completed;
        bool paid;
        address payable assignedExecutor;
        string ipfsHash;
        bool refusedPayment;
    }

    struct Proposal {
        address payable executor;
        uint256 orderId;
        string message;
        bool accepted;
    }

    mapping(uint256 => Order) public orders;
    mapping(uint256 => uint256) public escrowBalances;
    mapping(uint256 => Proposal[]) public orderProposals;
    uint256 public orderIndex;
    address public owner;
    mapping(address => bool) public admins;

    event OrderCreated(address indexed creator, uint256 indexed orderIndex);
    event PersonalOrderCreated(address customer, uint256 orderId, address assignedExecutor);
    event OrderAccepted(uint256 orderId, address executor);
    event OrderCompleted(uint256 orderId);
    event OrderCancelled(uint256 orderId);
    event OrderPaid(uint256 orderId, uint256 amount);
    event OrderEdited(uint256 orderId);
    event IpfsHashSet(uint256 orderId, string ipfsHash);
    event ProposalSubmitted(uint256 orderId, address executor);
    event ProposalAccepted(uint256 orderId, address executor);
    event AdminAdded(address adminAddress);
    event AdminRemoved(address adminAddress);

    constructor() {
        owner = msg.sender;
        admins[owner] = true;
    }

    modifier onlyAdmin() {
        require(admins[msg.sender], "Only admins can perform this action");
        _;
    }

    function addAdmin(address adminAddress) public onlyAdmin {
        admins[adminAddress] = true;
        emit AdminAdded(adminAddress);
    }

    function removeAdmin(address adminAddress) public onlyAdmin {
        require(adminAddress != owner, "Cannot remove contract owner as admin");
        admins[adminAddress] = false;
        emit AdminRemoved(adminAddress);
    }

    uint256 public orderCount;

    function createOrder(
        string memory _description,
        string memory _fullDescription,
        string memory _category,
        uint256 _price,
        address payable _assignedExecutor
    ) public {
        uint256 newOrderIndex = orderCount;
        orders[newOrderIndex] = Order(
            payable(msg.sender),
            _description,
            _fullDescription,
            _category,
            _price,
            false,
            false,
            _assignedExecutor,
            "",
            false
        );
        orderCount++;

        emit OrderCreated(msg.sender, newOrderIndex);

        if (_assignedExecutor != address(0)) {
            emit PersonalOrderCreated(msg.sender, newOrderIndex, _assignedExecutor);
        } else {
            emit OrderCreated(msg.sender, newOrderIndex);
        }
    }

        function submitProposal(uint256 orderId, string memory message) public {
            require(!isUserBanned(msg.sender), "User is banned");
            Order storage order = orders[orderId];
            require(!order.completed, "Order is already completed");
            require(order.assignedExecutor == address(0), "Order is a personal order");

            orderProposals[orderId].push(Proposal(payable(msg.sender), orderId, message, false));
            emit ProposalSubmitted(orderId, msg.sender);
        }

        function acceptProposal(uint256 orderId, uint256 proposalIndex) public {
            Order storage order = orders[orderId];
            require(!order.completed, "Order is already completed");
            require(msg.sender == order.customer, "Only the customer can accept a proposal");
            require(order.assignedExecutor == address(0), "Order is a personal order");
            Proposal storage proposal = orderProposals[orderId][proposalIndex];
            require(!proposal.accepted, "Proposal is already accepted");

            proposal.accepted = true;
            order.assignedExecutor = proposal.executor;
            emit ProposalAccepted(orderId, proposal.executor);
            }
            function getOrderProposals(uint256 orderId) public view returns (Proposal[] memory) {
        return orderProposals[orderId];
    }

    function completeOrder(uint256 orderId) public {
        Order storage order = orders[orderId];
        require(order.assignedExecutor != address(0), "Order is not accepted");
        require(msg.sender == order.assignedExecutor, "Only the assigned executor can complete the order");
        require(!order.completed, "Order is already completed");

        order.completed = true;
        order.paid = true;
        emit OrderCompleted(orderId);

        uint256 escrowAmount = escrowBalances[orderId];
        require(escrowAmount > 0, "No funds in escrow");
        order.assignedExecutor.transfer(escrowAmount);
        escrowBalances[orderId] = 0;
    }

    function cancelOrder(uint256 orderId) public {
        Order storage order = orders[orderId];
        require(!order.completed, "Order is completed");
        require(!order.paid, "Order has already been paid for and cannot be cancelled");
        require(msg.sender == order.customer, "Only the customer can cancel the order");

        order.completed = true;
        emit OrderCancelled(orderId);
    }

    function payOrder(uint256 orderId) public payable {
        Order storage order = orders[orderId];
        require(order.assignedExecutor != address(0), "Order is not accepted");
        require(!order.completed, "Order is already completed");
        require(msg.sender == order.customer, "Only the customer can pay for the order");
        require(msg.value >= order.price, "Insufficient payment amount");

        escrowBalances[orderId] = msg.value;
        order.paid = true;
        emit OrderPaid(orderId, msg.value);
    }

    function editOrder(uint256 orderId, string memory fullDescription) public {
        Order storage order = orders[orderId];
        require(order.assignedExecutor == address(0), "Order is already accepted");
        require(msg.sender == order.customer, "Only customer can edit order");

        order.fullDescription = fullDescription;
        emit OrderEdited(orderId);
    }

    function setIpfsHash(uint256 orderId, string memory ipfsHash) public {
        require(msg.sender == orders[orderId].customer, "Only the order customer can set the IPFS hash");

        orders[orderId].ipfsHash = ipfsHash;
        emit IpfsHashSet(orderId, ipfsHash);
    }

    function balanceOf(address user) public view returns (uint256) {
        return address(user).balance;
    }

    function withdraw(uint256 amount) public {
        require(amount <= address(this).balance, "Insufficient contract balance");
        require(msg.sender == owner, "Only contract owner can withdraw funds");

        payable(msg.sender).transfer(amount);
    }

    struct Dispute {
        uint256 orderId;
        address customer;
        address executor;
        string reason;
        bool resolved;
        address winner;
    }

    event DisputeCreated(uint256 disputeId, uint256 orderId, address customer, address executor);
    event DisputeResolved(uint256 disputeId, address winner);

    mapping(uint256 => Dispute) public disputes;
    uint256 public disputeIndex;

    function createDispute(uint256 orderId, string memory reason) public {
        Order storage order = orders[orderId];
        require(msg.sender == order.customer || msg.sender == order.assignedExecutor, "Only customer or executor can create a dispute");

        disputeIndex++;
        disputes[disputeIndex] = Dispute(orderId, order.customer, order.assignedExecutor, reason, false, address(0));

        emit DisputeCreated(disputeIndex, orderId, order.customer, order.assignedExecutor);
        }

        function resolveDispute(uint256 disputeId, address winner, bool banLoser) public onlyAdmin {
        Dispute storage dispute = disputes[disputeId];
        require(!dispute.resolved, "Dispute is already resolved");
        dispute.resolved = true;
        dispute.winner = winner;
        Order storage order = orders[dispute.orderId];
    if (winner == order.customer) {
        order.completed = true;
        payable(order.customer).transfer(escrowBalances[dispute.orderId]);
    } else if (winner == order.assignedExecutor) {
        order.completed = true;
        escrowBalances[dispute.orderId] = 0; // �ӧ�٧ӧ�ѧ�ѧ֧� �է֧ߧ�ԧ� �٧ѧܧѧ٧�ڧܧ�
    }

    emit DisputeResolved(disputeId, winner);

    if (banLoser) {
        address loser = winner == order.customer ? order.assignedExecutor : order.customer;
        manageUserWarnings(loser, true, false);
    }
    }

    struct User {
        address userAddress;
        bool isBanned;
        uint256 warnings;
    }

    mapping(address => User) public users;

    event UserBanned(address userAddress);
    event UserWarningsIncreased(address userAddress, uint256 newWarnings);
    event UserWarningsDecreased(address userAddress, uint256 newWarnings);

    function manageUserWarnings(address userAddress, bool increase, bool banUser) public onlyAdmin {
        User storage user = users[userAddress];
        if (user.userAddress == address(0)) {
        user.userAddress = userAddress;
        }
        if (increase) {
        user.warnings++;
        emit UserWarningsIncreased(userAddress, user.warnings);
        } else {
        user.warnings = user.warnings > 0 ? user.warnings - 1 : 0;
        emit UserWarningsDecreased(userAddress, user.warnings);
        }
        if (banUser) {
            user.isBanned = true;
            emit UserBanned(userAddress);
        }
    }

    function isUserBanned(address userAddress) public view returns (bool) {
    return users[userAddress].isBanned;
    }

    function rejectDispute(uint256 disputeId) public {
        Dispute storage dispute = disputes[disputeId];
        require(msg.sender == dispute.executor, "Only the assigned executor can reject a dispute");
        require(!dispute.resolved, "Dispute is already resolved");
        require(escrowBalances[dispute.orderId] > 0, "No funds in escrow");
        dispute.resolved = true;
        orderIndex++;
        orders[orderIndex] = Order(
            payable(dispute.customer),
            "Dispute rejected and order cancelled",
            "",
            "",
            0,
            true,
            false,
            payable(dispute.executor),
            "",
            false
        );
        emit OrderCancelled(orderIndex);
        payable(dispute.customer).transfer(escrowBalances[dispute.orderId]);
        escrowBalances[dispute.orderId] = 0;
    }

    event ExecutorRefusedPayment(uint256 orderId);
    function executorRefusePayment(uint256 orderId) public {
        Order storage order = orders[orderId];
        require(order.assignedExecutor != address(0), "Order is not accepted");
        require(msg.sender == order.assignedExecutor, "Only the assigned executor can refuse the payment");
        require(order.paid, "Order has not been paid yet");

        uint256 escrowAmount = escrowBalances[orderId];
        require(escrowAmount > 0, "No funds in escrow");

        order.completed = true;
        order.refusedPayment = true;
        emit ExecutorRefusedPayment(orderId);
    }

    function refundToCustomer(uint256 orderId) public {
        Order storage order = orders[orderId];
        require(order.refusedPayment, "Executor has not refused payment");
        require(msg.sender == order.customer, "Only the customer can request a refund");

        uint256 escrowAmount = escrowBalances[orderId];
        require(escrowAmount > 0, "No funds in escrow");

        payable(order.customer).transfer(escrowAmount);
        escrowBalances[orderId] = 0;
    }

}