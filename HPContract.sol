pragma solidity >=0.4.22 <0.7.0;


contract PatientHospital {
    mapping (address => Patientrecords) public patientrecords;
    mapping(address => uint) balances;
    mapping(address=>uint)public balanceReceived;

     uint256 public PatientCount = 0;

    
    struct Hospitalrecords{
        uint Hid;
        address hospitaladdress;
        string name;
        string Haddr;
        uint HPhoneNumber;
    } 
    
     Hospitalrecords  hospital;
     function addHospitalRecord (
        address _hospitalAddress,
        uint256 _Hid,
        string memory _name,
        string memory _Haddr,
        uint _HphoneNumber)
        public
        {
           hospital = Hospitalrecords(_Hid,_hospitalAddress,_name,_Haddr,_HphoneNumber);
        // Hospitalrecords.hospital = _hospitalAddress;
        // Hospitalrecords.Hid = _Hid;
        // Hospitalrecords.name = _name;
        // Hospitalrecords.HPhoneNumber = _HphoneNumber;
        // Hospitalrecords.Haddr = _Haddr;
        // HospitalCount += 1;
    }
    
    function getHospitalRecord() public view returns( address _hospitalAddress,
        uint256 _Hid,
        string  _name,
        string  _Haddr,
        uint _HphoneNumber){
            return(hospital.hospitaladdress,hospital.Hid,hospital.name,hospital.Haddr,hospital.HPhoneNumber );
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
    
     function getRecord( address _patientAddress)
      public
      view
      returns (
        string _name,
        string _Paddr,
        uint _PPhoneNumber,
        uint _BillAmount)
      {
         _name = patientrecords[_patientAddress].name;
         _Paddr = patientrecords[_patientAddress].Paddr;
         _PPhoneNumber = patientrecords[_patientAddress].PPhoneNumber;
         _BillAmount = patientrecords[_patientAddress].BillAmount;
         
         return(_name,_Paddr,_PPhoneNumber,_BillAmount);
        //  _visitReason = patientrecords[_recordID][_patientAddress].visitReason;
      }
      function getBill(address _patientAddress) public returns(uint256 _billAmount){
         _billAmount = patientrecords[_patientAddress].BillAmount;
         return(_billAmount);
      }
    
    function pay(address _patientAddress) public payable{
        require(msg.value==patientrecords[_patientAddress].BillAmount,"incorrect amount");
        balanceReceived[msg.sender]+=msg.value;
    }
    
    function balanceOf() external view returns(uint){
        return address(this).balance;
    }
    // function withdrawMoney(address _to, uint _amount) public{
    //     require(_amount<=balanceReceived[msg.sender],"not enough funds.");
    //     balanceReceived[msg.sender]-=_amount;
    //     _to.transfer(_amount);
    // } 
    // function hello(string _ab) external pure returns(string memory){
    //     return _ab;
    // }
}



contract HospitalInsurance{
    address addressPatientHospital;
    bool public isCorrect;
    mapping(address=>uint)public balanceReceived;
    uint256 public billAmount;


    function setAddress(address _addressPatientHospital) external {
        addressPatientHospital = _addressPatientHospital;
    }
    
    function getRecord(address _patientAddress) external view returns (
        string _name,
        string _Paddr,
        uint _PPhoneNumber,
        uint _BillAmount)
        {
            PatientHospital patienthospital = PatientHospital(addressPatientHospital);
           
            return patienthospital.getRecord(_patientAddress);
            
        }
    
    function checkRecords(bool _recordCheck) public returns(string memory) {
        isCorrect = _recordCheck;
        require(isCorrect==true,"match not found");
        return "match found";
    }
    
    function getBill(address _patientAddress) public returns(uint256){
         PatientHospital patienthospital = PatientHospital(addressPatientHospital);
         billAmount = patienthospital.getBill(_patientAddress);
    }
    
     function pay(address _patientAddress) public payable{
        require(msg.value==billAmount,"incorrect amount");
        balanceReceived[_patientAddress]+=msg.value;
    }
    
    function balanceOf() external view returns(uint){
        return address(this).balance;
    }
}
