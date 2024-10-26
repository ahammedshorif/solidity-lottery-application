//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0  <0.9.0;

contract Lottery{
    address public manager;
    address payable[] public participants;

    constructor(){
        manager= msg.sender;
    }

    receive() external payable{
        require(msg.value == 1 ether);
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(msg.sender== manager);
        return address(this).balance;
    }

    function rendom() public view returns(uint){
       return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,participants.length)));
    }

    function selectWinner() public {
        require(msg.sender==manager);
        require(3 <=  participants.length);
        uint r= rendom();
        address payable winner;
        uint index= r % (participants.length);
        winner= participants[index];
        winner.transfer(getBalance());  //transfer balance into winner account

        participants = new address payable[](0); //reset the array
            
    }
}




