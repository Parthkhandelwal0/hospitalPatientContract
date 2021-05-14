pragma solidity >=0.4.22 <0.7.0;

contract PatientHospital {
    mapping (address => Patientrecords) public patientrecords;
    mapping (address => Insurance) public patientinsurancerecords;
    mapping(address=>uint)public balanceReceived;
    uint256 public PatientCount = 0;

    struct Hospitalrecords{
        uint Hid;
        address hospitaladdress;
        string name;
        string Hlocation;
        uint HPhoneNumber;
    } 
     struct Patientrecords{
        uint Pid;
        bool isInsurance;
        address _patientAddress;
        address hospitalAddress;
        string name;
        string Plocation;
        uint PPhoneNumber;
        uint BillAmount;
        string visitReason;
    }
    struct Insurance{
        uint256 InsuranceNo;
        uint256 InsuranceCover;
        string CompanyName;
        string ExpiryDate;
    }
     Hospitalrecords hospital;
     function addHospitalRecord (
        address _hospitalAddress,
        uint256 _Hid,
        string memory _name,
        string memory _Hlocation,
        uint _HphoneNumber)
        public
        {
           hospital = Hospitalrecords(_Hid,_hospitalAddress,_name,_Hlocation,_HphoneNumber);
    }
    function getHospitalRecord() public view returns( address _hospitalAddress,
        uint256 _Hid,
        string  _name,
        string  _location,
        uint _HphoneNumber){
            return(hospital.hospitaladdress,hospital.Hid,hospital.name,hospital.Hlocation,hospital.HPhoneNumber );
        }
    function addPatientRecord (
        uint _Pid,
        bool _isInsurance,
        address _patientAddress,
        address _hospitalAddress,
        string memory _name,
        string memory _visitReason,
        string memory _Plocation,
        uint _PphoneNumber,
        uint _BillAmount
       )
        public
    {
        patientrecords[_patientAddress].Pid = _Pid;
        patientrecords[_patientAddress].isInsurance = _isInsurance;
        patientrecords[_patientAddress]._patientAddress = _patientAddress;
        patientrecords[_patientAddress].hospitalAddress = _hospitalAddress;
        patientrecords[_patientAddress].name = _name;
        patientrecords[_patientAddress].Plocation = _Plocation;
        patientrecords[_patientAddress].PPhoneNumber = _PphoneNumber;
        patientrecords[_patientAddress].BillAmount = _BillAmount;
        patientrecords[_patientAddress].visitReason = _visitReason;
        PatientCount += 1;
    }
     function addPatientInsuranceRecord (
        address _patientAddress,
        uint256 _insuranceNo,
        uint256 _insuranceCover,
        string _companyName,
        string _expiryDate
        )
        public{
            require(patientrecords[_patientAddress].isInsurance==true,"insurance not provided");
            patientinsurancerecords[_patientAddress].InsuranceNo = _insuranceNo;
            patientinsurancerecords[_patientAddress].InsuranceCover = _insuranceCover;
            patientinsurancerecords[_patientAddress].CompanyName = _companyName;
            patientinsurancerecords[_patientAddress].ExpiryDate = _expiryDate;
        }
     function getPatientRecord( address _patientAddress)
      public
      view
      returns (
        string _name,
        string _Plocation,
        uint _PPhoneNumber,
        uint _BillAmount,
        uint256 _insuranceNo,
        uint256 _insuranceCover,
        string _companyName,
        string _expiryDate,
        string _visitReason
        )
      {
         _name = patientrecords[_patientAddress].name;
         _Plocation = patientrecords[_patientAddress].Plocation;
         _PPhoneNumber = patientrecords[_patientAddress].PPhoneNumber;
         _BillAmount = patientrecords[_patientAddress].BillAmount;
         _insuranceNo = patientinsurancerecords[_patientAddress].InsuranceNo;
         _insuranceCover = patientinsurancerecords[_patientAddress].InsuranceCover;
         _companyName = patientinsurancerecords[_patientAddress].CompanyName;
         _expiryDate = patientinsurancerecords[_patientAddress].ExpiryDate;
         _visitReason = patientrecords[_patientAddress].visitReason;
         return(_name,_Plocation,_PPhoneNumber,_BillAmount,_insuranceNo,_insuranceCover,_companyName,_expiryDate,_visitReason);
      }
      function Bill(address _patientAddress) public view returns(uint256 _billAmount){
         _billAmount = patientrecords[_patientAddress].BillAmount;
         return(_billAmount);
      }
    function pay(address _patientAddress) public payable returns(string){
        require(msg.value==patientrecords[_patientAddress].BillAmount,"incorrect amount");
        balanceReceived[msg.sender] += msg.value;
        return "payment done";
    }
    function balanceOf() external view returns(uint){
        return address(this).balance;
    }
}
    
contract HospitalInsurance{
    address addressPatientHospital;
    bool public isCorrect;
    mapping(address=>uint)public balanceReceived;
    uint256 public billAmount;
    address public patientAddress;

    function setAddress(address _addressPatientHospital) external {
        addressPatientHospital = _addressPatientHospital;
    }
    
    function setPatientAddress(address _patientAddress) public{
        patientAddress = _patientAddress;
    }
    function getRecord() external view returns (
        string _name,
        string _Paddr,
        uint _PPhoneNumber,
        uint _BillAmount,
        uint256 _insuranceNo,
        uint256 _insuranceCover,
        string _companyName,
        string _expiryDate,
        string _visitReason)
        {
            PatientHospital patienthospital = PatientHospital(addressPatientHospital);
            return patienthospital.getPatientRecord(patientAddress);
        }
    function checkRecords(bool _recordCheck) public returns(string memory) {
        isCorrect = _recordCheck;
        require(isCorrect==true,"match not found");
        return "match found";
    }
    function getBill() public returns(uint256){
         PatientHospital patienthospital = PatientHospital(addressPatientHospital);
         billAmount = patienthospital.Bill(patientAddress);
    }
     function pay() public payable returns(string){
        require(isCorrect==true,"incorrect information");
        require(msg.value==billAmount,"incorrect amount");
        balanceReceived[patientAddress]+=msg.value;
        return "payment done by the Insurance Company";
    }
    function balanceOf() external view returns(uint){
        return address(this).balance;
    }
}
