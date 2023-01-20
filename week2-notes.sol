// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Constructor{
    //Counstructors are special functions that are only called once when the contract is deployed
    //mainly used to initialized state variables
    //defining some state variables here
    address public owner;
    uint public x;

    constructor (uint _x){
        //msg.sender is the account that deployes the contract
        owner=msg.sender; 
        x=_x;
    }

}

contract Constants{
    //Constants
    //Main benefit to declare a variable constant is you can save gas
    //gas fo MY_ADDR is 127909
    address public constant MY_ADDRESS = 0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;
    uint public constant MY_UINT = 123;

    //You can check the gas value difference by checking Var contract under MY_ADDRESS var
}

contract Var{
    //gas for MY_ADDR is 149779 
     address public MY_ADDRESS = 0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;
}

contract Immutable{
    //lets say i have a state var i want to initialize when the contract is deployed and not to change afterwards
    //kind of like a constant but i want to initialize when the contract is deployed
    //you save some gas this way
    //you won't be able to change it  after deployment
    address public immutable owner =msg.sender;
    //constructor example here
    address public owner2 ;
    constructor(){
        owner2=msg.sender;
    }
}

contract Elif{
    function ternary (uint _x) external pure returns(uint){
        //if(x<10){return 1;}
        //return 2;
        return _x<10 ? 1 : 2;
    }
}

contract Mapping{
    //it is different fom array in ex. 1. one you look 3 times 2. one you look only once
    //1. ["alice","bob","charlie"]
    //2. {"alice":true, "bob":true, "charlie":true}
    //here every address has a uint value 
    mapping (address=>uint) public balances;
    //nested mapping 
    mapping (address=>mapping(address=>bool))public isFriend;

    //get,set and delete in a mapping
    function examples()external{
        balances[msg.sender]=123;
        uint  bal =balances[msg.sender];
        uint  bal2 =balances[address(1)];//because uint null value is 0 bal2=0 here

        balances[msg.sender]+=456; //123+456=579

        delete balances[msg.sender];

        isFriend[msg.sender][address(this)]=true;
    }
}

contract IterableMapping{
    mapping (address=>uint) public balances;
    mapping (address=>bool) public inserted;
    address[] public keys;

    //this function gives us the size of the mapping and iterate 
    function set(address _key, uint _val) external{
        balances[_key]=_val;

        if(!inserted[_key]){
            inserted[_key]=true;
            keys.push(_key);
        }
    }

    function getSize() external view returns(uint){
        return keys.length;
    }

    function get(uint _i) external view returns(uint){
        return balances[keys[_i]];
    }
}

contract Structs{
    struct Car{
        string model;
        uint year;
        address owner;
    }

    Car public car;
    Car[] public cars;
    mapping(address=> Car[]) public carsByOwner;

    function examples() external {
         // memory = only exist only while this function is called
         //3 ways to initialize a struct
         Car memory toyota= Car("Toyota",1990,msg.sender);
         Car memory lambo= Car({model:"Lamborghini",year:1980, owner:msg.sender}); 
         Car memory tesla;
         tesla.model="Tesla";
         tesla.year=2010;
         tesla.owner=msg.sender;

         //after executing function we ant to access so we add them to array
         cars.push(toyota);
         cars.push(lambo);
         cars.push(tesla);

         cars.push(Car("Ferrari",2020,msg.sender));

         //storage allows you to update vars and change will be saved
         Car storage _car=cars[0];
         _car.year=1999;
         delete _car.owner;

         delete cars[1]; //whatever stored here will be reset to it's default value
    }

}

contract Modifier{
    //Function modifier - reuse code before and/or after function 
    
    bool public paused;
    uint public count;

    function setPause (bool _paused) external{
        paused=_paused;
    }
    
    modifier whenNotPaused(){
        require (!paused,"paused");
        _; //call the actual function that this modifier actually wraps
    }
    
    function inc() external{
        //require the function to be operate if only the contract is not paused 
        require (!paused,"paused");
        count+=1;
    }

    //or you can do it like this using modifiers
    function dec() external whenNotPaused{
        count-=1;
    }
    
    //modifiers can take input
    modifier cap(uint _x){
        require(_x<100, "x>=100");
        _;//calling the main function it is attached to
    }

    function incBy(uint _x) external whenNotPaused cap(_x){
        count+= _x; 
    }

    //sandwich modifier 
    modifier sandwich(){
        count+=10;//first here
        _;//goes to main function and executes that
        count*=2;//comes here to execute here
    }

    function foo() external sandwich{
        count+=1;
    }
}

contract Event{
    //events allow write data on the blockchain 
    //these data then can be retrieve by smartcontracts
    //main purpose is logging 
    event Log(string message, uint val);
    event IndexedLog(address indexed sender, uint val);

    //transactional function
    function example() external{
        emit Log("foo",123);
        emit IndexedLog(msg.sender, 789);
    }
    //up to 3 parameters can be indexed
    event Message2(address indexed _from , address indexed _to, string message);
    function sendMessage(address _to, string calldata message) external{
        emit Message2(msg.sender,_to, message);
    }
}

contract Errors{
    //3 ways to throw an error require, revert, assert
    //gas will be refunded and state updates are reverted
    //custom error - saves gas

    //require mostly used for validate inputs and for access control
    //require(condition, string)

    function testRequire(uint _i) public pure{
        require (_i<=10, "i>10");
        //MORE CODE HERE
    }

    function testRevert(uint _i) public pure{
        //if you want detailed error check maybe use revert 
        if(_i>1){
            //code
            if(_i>10){
                revert ("i>10");
            }
        }
    }

    uint public num=123; //state variable should be stay exactly 123 because it doesn't change anywhere in this code
    function testAssert() public view{
        assert( num == 123); // this controls num is equal 123 because if it is not there must be a bug in this code
    }

    //lets say num+=1; after this num is not going to be 123 anymore and assert will throw error
    //the longer the error message the higher gas fee for this create custom error

    error myError(address caller, uint i);
    function testCustomError(uint _i) public view{
        //because msg.sender is public we change pure to view
        if(_i>10){
            revert myError(msg.sender,_i);
        }
    }

}

contract Libraries{
    //allows seperate and reuse code 
    function testMax(uint x, uint y) external pure returns( uint){
        return Math.max(x,y);
    }
}

// library functions with state variables
contract TestArray {
    // we declared ArrayLib for uint arrays
    // now we can use method without calling the library
    using ArrayLib for uint256[];
    uint256[] public arr = [3, 2, 1];

    function testFind() external view returns (uint256) {
        // return ArrayLib.find(arr, 1);
        return arr.find(1);
    }
}
 
library Math{
    //you can not use state variables here
    //internal measn embedded in the used contract and you do not need to deploy the library
    function max(uint x,uint y) external pure returns(uint){
        return x >= y ? x : y ;
    }
}

library ArrayLib {
    // finds given number is in the array or not.
    function find(uint256[] storage arr, uint256 x)
        internal
        view
        returns (uint256)
    {
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] == x) {
                return i;
            }
        }
        // reverts function and saves gas
        // if given number is not in the array
        revert("not found");
    }
}

contract DataLocations{
    //Data location - storage, memory and calldata
    //storage --> data is state variable
    //memory --> data is loaded to memory
    //calldata --> like memory except that can only be used for function inputs

    struct MyStruct{
        uint foo;
        string text;
    }
    mapping (address =>MyStruct) public myStructs;
    //in calldata the data can not be changed and you can save gas  because less copying to do
    function examples(uint y, uint s) external returns (uint[] memory){
        myStructs[msg.sender]=MyStruct({foo:123, text:"bar"});
        //update data --> storage
        MyStruct storage myStruct = myStructs[msg.sender];
        myStruct.text="foo";

        //this change will not be saved or modifying data without saving it onto blockchain
        MyStruct memory readOnly = myStructs[msg.sender];
        readOnly.foo=456;

        //with memory only fixed sized arrays can be created
        uint[] memory memArr= new uint[](3);
        memArr[0]=123;
        return memArr;
    }
}

//INHERITANCE EXAMPLE

contract A{
    //virtual means can be inherited and customized by the child contract 

    function foo() public  pure virtual returns (string memory){
        return "A";
    }

    function bar() public  pure virtual returns (string memory){
        return "A";
    }

    function baz() public  pure virtual returns (string memory){
        return "A";
    }
}

contract B is A{
    function foo() public  pure override returns (string memory){
        return "B";
    }

    function bar() public  pure virtual override returns (string memory){
        return "B";
    }
}

contract C is B{
    function bar() public  pure virtual override returns (string memory){
        return "C";
    }
}

//INTERFACES
contract Counter{
    uint public count;

    function inc() external{
        count +=1;
    }

    function dec() external{
        count -=1;
    }
}

interface ICounter{
    function count() external view returns (uint);
    function inc() external;
}

contract CallInterface{
    uint public count;
    
    function examples(address _counter) external{
        ICounter(_counter).inc();
        count=ICounter(_counter).count();
    }
}

contract TestCall{
    string public message;
    uint public x;

    event Log(string message);

    fallback() external payable{
        emit Log("fallback was cancelled");
    }

    function foo(string memory _message, uint _x) external payable returns (bool, uint){
        message=_message;
        x=_x;
        return (true, 999);
    }
}

contract Call{
    bytes public data;
    function callFoo(address _test) external payable{
        (bool success, bytes memory _data)=_test.call{value:111}(abi.encodeWithSignature("foo(string,uint256", "call foo", 123));
        require(success,"call failed");
        data=_data;
    }

    function callDoesNotExist(address _test) external{
        (bool success, )=_test.call(abi.encodeWithSignature("doesNotExist()"));
        require(success,"call failed");
    }
}

contract S{
    string public name;
    constructor(string memory _name){
        name=_name;
    }
}

contract T{
    string public text;
    constructor(string memory _text){
        text=_text;
    }
}

contract U is S("s"), T("t"){
   
}

contract V is S, T{
    constructor(string memory _name, string memory _text) S(_name) T(_text){

    }
}

contract W is S("s"),T{
    constructor( string memory _text) T(_text){

    }
}

//CALLING PARENT FUNCTIONS

contract E{
    event Log(string message);
    function foo() public virtual {
        emit Log("E.foo");
    }
    function bar() public virtual {
        emit Log("E.bar");
    }
}

contract F is E{
    function foo() public virtual override {
        emit Log("F.foo");
        E.foo();
    }
    function bar() public virtual override {
        emit Log("F.bar");
        super.bar();
    }
}

contract G is E{
    function foo() public virtual override {
        emit Log("G.foo");
        E.foo();
    }
    function bar() public virtual override {
        emit Log("G.bar");
        super.bar();
    }
}

contract H is F, G{
    function foo() public override(F, G) {
        F.foo();
    }
    function bar() public override(F, G) {
        super.bar();
    }
}

//CALL OTHER CONTRACTS

contract CallTestContract{
    //first initialize the contract
    function setX1(address _test , uint _x) external{
        //initialize _test addressed TestContract and call the setX function
        TestContract(_test).setX(_x);
    }

    //second option not giving the address directly but giving the contract name itself
    function setX2(TestContract _test , uint _x) external{        
        _test.setX(_x);
    }

    function getX(TestContract _test) external view returns(uint x ){        
        x = _test.getX(); // equals return _test.getX();
        
    }

    function setXandSendEther(TestContract _test , uint _x) external payable{        
        _test.setXandReceiveEther{value: msg.value}(_x);
    }

    function getXandValue(TestContract _test , uint _x) external view returns (uint, uint){        
        (uint x, uint value)=_test.getXandValue();
        return (x,value);
    }

}

contract TestContract{
    uint public x;
    uint public value=123;

    function setX(uint _x) external {
        x=_x;
    }

    function getX() external view returns (uint){
        return x;
    }

    function setXandReceiveEther(uint _x) external payable{
        x=_x;
        value=msg.value;
    }

    function getXandValue() external view returns (uint, uint){
        return (x,value);
    }
}

//SEND ETH

contract SendEth{
    //there are 3 ways to send ETH
    //transfer --> 2300 gas , reverts if failes whole function failes 
    //send --> 2300 gas , returns bool successfull or nor
    //call --> all gas , returns bool and data  successfull or nor
 
    //first way 
    constructor () payable{}

    //second way
    receive() external payable{}

    function sendViaTransfer(address payable _to) external payable {
        _to.transfer(msg.value);
    }

    function sendViaSend(address payable _to) external payable {
        bool sent = _to.send(msg.value);
        // if send = false "send failed"
        require(sent, "send failed");
    }

    function sendViaCall(address payable _to) external payable {
        (bool success, ) = _to.call{value: msg.value}("");
        require(success, "call failed");
    }
}

contract EthReceiver {
    event Log(uint256 amount, uint256 gas);

    receive() external payable {
        emit Log(msg.value, gasleft());
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

//VERIFYING SIGNATURE

//How to Sign and Verify
//# Signing
//1. Create message to sign
//2. Hash the message
//3. Sign the hash (off chain, keep your private key secret)

//# Verify
//1. Recreate hash from the original message
//2. Recover signer from signature and hash
//3. Compare recovered signer to claimed signer


contract VerifySignature {
    /* 1. Unlock MetaMask account
    ethereum.enable()
    */

    /* 2. Get message hash to sign
    getMessageHash(
        0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C,
        123,
        "coffee and donuts",
        1
    )

    hash = "0xcf36ac4f97dc10d91fc2cbb20d718e94a8cbfe0f82eaedc6a4aa38946fb797cd"
    */
    function getMessageHash(
        address _to,
        uint _amount,
        string memory _message,
        uint _nonce
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_to, _amount, _message, _nonce));
    }

    /* 3. Sign message hash
    # using browser
    account = "copy paste account of signer here"
    ethereum.request({ method: "personal_sign", params: [account, hash]}).then(console.log)

    # using web3
    web3.personal.sign(hash, web3.eth.defaultAccount, console.log)

    Signature will be different for different accounts
    0x993dab3dd91f5c6dc28e17439be475478f5635c92a56e17e82349d3fb2f166196f466c0b4e0c146f285204f0dcb13e5ae67bc33f4b888ec32dfe0a063e8f3f781b
    */
    function getEthSignedMessageHash(
        bytes32 _messageHash
    ) public pure returns (bytes32) {
        /*
        Signature is produced by signing a keccak256 hash with the following format:
        "\x19Ethereum Signed Message\n" + len(msg) + msg
        */
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
            );
    }

    /* 4. Verify signature
    signer = 0xB273216C05A8c0D4F0a4Dd0d7Bae1D2EfFE636dd
    to = 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C
    amount = 123
    message = "coffee and donuts"
    nonce = 1
    signature =
        0x993dab3dd91f5c6dc28e17439be475478f5635c92a56e17e82349d3fb2f166196f466c0b4e0c146f285204f0dcb13e5ae67bc33f4b888ec32dfe0a063e8f3f781b
    */
    function verify(
        address _signer,
        address _to,
        uint _amount,
        string memory _message,
        uint _nonce,
        bytes memory signature
    ) public pure returns (bool) {
        bytes32 messageHash = getMessageHash(_to, _amount, _message, _nonce);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recoverSigner(ethSignedMessageHash, signature) == _signer;
    }

    function recoverSigner(
        bytes32 _ethSignedMessageHash,
        bytes memory _signature
    ) public pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);

        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function splitSignature(
        bytes memory sig
    ) public pure returns (bytes32 r, bytes32 s, uint8 v) {
        require(sig.length == 65, "invalid signature length");

        assembly {
            /*
            First 32 bytes stores the length of the signature

            add(sig, 32) = pointer of sig + 32
            effectively, skips first 32 bytes of signature

            mload(p) loads next 32 bytes starting at the memory address p into memory
            */

            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

        // implicitly return (r, s, v)
    }
}