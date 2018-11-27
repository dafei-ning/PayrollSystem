/*



*/

pragma solidity >=0.4.0 <0.6.0;
pragma experimental ABIEncoderV2;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint;

    struct Employee {
        address id;
        uint    salary;
        uint    lastPayday;
    }

    uint constant payDuration  = 30 days;

    address owner;
    uint totalSalary = 0;
    mapping(address => Employee) public employees;

    /*
    constructor() public {
        owner = msg.sender;
    }
    */

    /*
    modifier onlyOwner { 
        require(msg.sender == owner); 
        _; 
    }
    */

    modifier employeeExist (address employeeID) {
        var employee = employees[employeeID]; 
        assert(employee.id != 0x0);
        _;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary 
                        .mul(now.sub(employee.lastPayday)) 
                        .div(payDuration);
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeID, uint salary) public onlyOwner {
        var employee = employees[employeeID]; // employee获取返回的两个值中的第一个值
        assert(employee.id == 0x0); //"The employeeID exists!"
        employees[employeeID] = Employee(employeeID, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(employees[employeeID].salary);
    }

    function removeEmployee(address employeeID) public onlyOwner employeeExist(employeeID) {
        var employee = employees[employeeID]; 
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeID].salary);
        delete employees[employeeID];  // entry其实是置换成了初始值
    }

    function updateEmployee(address employeeID, uint salary) public onlyOwner employeeExist(employeeID) {
        var employee = employees[employeeID]; 
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeID].salary);
        employees[employeeID].salary = salary.mul(1 ether); // instead of using memory variable, it should change the storage variable
        employees[employeeID].lastPayday = now;
        totalSalary = totalSalary.add(employees[employeeID].salary);
        
    }

    function addFund() public payable returns(uint){
        return this.balance;
    }

    function calculateRunway() public returns (uint) {  
        return this.balance.div(totalSalary);
    } 

    function hasEnoughFund() public returns (bool) {
        return calculateRunway() > 0;
    }

    /**
    * 下面的函数因为employees变成了可视度public，所以就不需要function了，系统就自动建立的function
    *
    function checkEmployee(address employeeID) public returns (uint salary, uint lastPayday) { //命名返回参数
        var employee = employees[employeeID];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    */

    function getPaid() public employeeExist(msg.sender){
        var employee = employees[msg.sender]; 
        uint nextPayDay = employee.lastPayday.add(payDuration);
        assert(nextPayDay < now);
        employees[msg.sender].lastPayday = nextPayDay; // 这种引用是storage里的，可以对状态变量进行修改
        employee.id.transfer(employee.salary);
    }
}