// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract HelloWorld{
    string public myString="hello world";
    bool public b=true;
    uint public u=123; // uint = uint256  0 to 2**256-1
                       //        uint8    0 to 2**8-1
                       //        uint16   0 to 2**16-1
    int public i=-123; // int = int256 -2**255-1 to 2**255-1
                       //       int128 -2**127-1 to 2**127-1
    int public minInt=type(int).min;
    int public maxInt=type(int).max;
    address public addr = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;
    bytes1 a = 0xb5;
    bool public defaultBoo; // false
    uint public defaultUint; // 0
    int public defaultInt; // 0
    address public defaultAddr; // 0x0000000000000000000000000000000000000000

    function foo() external {
        uint notStateVariable = 456;
    }

    function globalVariables() external view returns (address,uint,uint){ //view functions can read local and state variables
        address sender = msg.sender;
        uint timestamp = block.timestamp;
        uint blockNum = block.number;
        return(sender,timestamp,blockNum);
    }

    enum Status{
        None,
        Pending,
        Shipped,
        Completed,
        Rejected,
        Cancelled
    }
    Status public status;
    struct Order{
        address buyer;
        Status status;
    }
    Order[] public orders;
    function get() view returns(Status){
        return status;
    }
    function set(Status _status) external{
        status=_status;
    }
    function ship() external{
        status=Status.Shipped;
    }
}