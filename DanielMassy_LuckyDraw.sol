pragma solidity >=0.5.0 <0.6.0;

contract LuckyDraw{
    struct participant {
        address addr;
        uint amount;
    }
    mapping(address => participant) participantInfo;
    participant[] participants;
    uint InitialRecvAmount = 200000000000000000;
    uint  internal totalAmount = 0;
    event FundReceived(address from, uint value);
    event Winner(address winner, uint value, uint8 index);

    //This modifer check that the minimum amount must be deposted to contract.
    modifier isSufficientAmount(){
        require(msg.value == InitialRecvAmount, "please provide sufficient funds 200000000000000000 wei");
        _;
    }

    //Constructor used to initizlize the contract with adding the deployer information.
    constructor () public payable isSufficientAmount  {
        uint val = msg.value;
        participant memory ptc;
        ptc.amount = val;
        ptc.addr = msg.sender;
        totalAmount += val;
        participants.push(ptc);
        emit FundReceived(msg.sender, msg.value);
    }

    

    /* Recives the required Amount of funds from the user
    */
    function InitialPaymentReceiver()  payable public  returns(bool ) {
        uint val = msg.value;
        participant memory ptc;
        if (!(CheckUserExist(msg.sender))) {
            ptc.amount = val;
            ptc.addr = msg.sender;
            totalAmount += val;
            participants.push(ptc);
            emit FundReceived(msg.sender, msg.value);

        } else {
            revert("Sorry,You already participated can't participate twice");
        }
    }


    /*  function return true if the user is present otherwise return false
    */
    function CheckUserExist(address uaddr) public view  returns(bool res)  {
        res = false;
        for (uint i = 0; i < participants.length; i++) {
            if (uaddr == participants[i].addr) {
                res = true;
            }
        }
        return res;
    }

    function PayMoney()  payable  public {
        // for(uint i=0;i<Winner.length;i++){
        uint8 WinnngIndex = random();
        address receiver = participants[WinnngIndex].addr;
        uint256 WinningAmount = address(this).balance;
        address(uint160(receiver)).transfer(WinningAmount);
       emit Winner(receiver, WinningAmount, WinnngIndex)
    ;}

    function getParticipant(address ADD) public view   returns(address, uint256)   {
        for (uint i = 0; i < participants.length; i++) {
            if (participants[i].addr == ADD)
                return (participants[i].addr, participants[i].amount);

        }
    }

    function random() internal view returns(uint8) {
         return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % participants.length );
    }

}
