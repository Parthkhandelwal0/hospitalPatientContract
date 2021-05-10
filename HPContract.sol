pragma solidity >=0.4.22 <0.7.0;


contract PatientHospital {
    mapping (uint256 => Hospitalrecords) public hospitalrecords;
    mapping (address => Patientrecords) public patientrecords;
    mapping(address => uint) balances;
    mapping(address=>uint)public balanceReceived;

     uint256 public HospitalCount = 0;
     uint256 public PatientCount = 0;

    
    struct Hospitalrecords{
        uint Hid;
        address hospital;
        string name;
        string Haddr;
        uint HPhoneNumber;
    } 
    
     function addHospitalRecord (
        address _hospitalAddress,
        uint256 _Hid,
        string memory _name,
        string memory _Haddr,
        uint _HphoneNumber)
        public
        {
        hospitalrecords[HospitalCount].hospital = _hospitalAddress;
        hospitalrecords[HospitalCount].Hid = _Hid;
        hospitalrecords[HospitalCount].name = _name;
        hospitalrecords[HospitalCount].HPhoneNumber = _HphoneNumber;
        hospitalrecords[HospitalCount].Haddr = _Haddr;
        HospitalCount += 1;
    }
    
    struct Patientrecords{
        uint Pid;
        address _patientAddress;
        address hospitalAddress;
        string name;
        string Paddr;
        uint PPhoneNumber;
        uint BillAmount;
    }
    function addRecord (
        uint _Pid,
        address _patientAddress,
        address _hospitalAddress,
        string memory _name,
        string memory _Paddr,
        uint _PphoneNumber,
        uint _BillAmount)
        public
        
    {
        patientrecords[_patientAddress].Pid = _Pid;
        patientrecords[_patientAddress]._patientAddress = _patientAddress;
        patientrecords[_patientAddress].hospitalAddress = _hospitalAddress;
        patientrecords[_patientAddress].name = _name;
        patientrecords[_patientAddress].Paddr = _Paddr;
        patientrecords[_patientAddress].PPhoneNumber = _PphoneNumber;
        patientrecords[_patientAddress].BillAmount = _BillAmount;


        PatientCount += 1;
     
    }
    
    function pay(address _patientAddress) public payable{
        
        require(msg.value==patientrecords[_patientAddress].BillAmount);
        balanceReceived[msg.sender]+=msg.value;
    }
    // function balanceOf() external view returns(uint){
    //     return address(this).balance;
    //}
    function withdrawMoney(address _to, uint _amount) public{
        require(_amount<=balanceReceived[msg.sender],"not enough funds.");
        balanceReceived[msg.sender]-=_amount;
        _to.transfer(_amount);
    } 
}