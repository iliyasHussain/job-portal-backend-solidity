// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract JobPortal {
    address private admin;
    
    struct Applicant {
        uint id;
        string name;
        string profileLink; //URL to applicant's profile data
    }
    
    struct Job {
        uint id;
        string title;
        string description;
        uint256 salary;
        address[] candidates; // Store addresses of applicants applying for a job
    }
    
    mapping(uint => Applicant) applicants;
    mapping(uint => Job) jobs;
    mapping(uint => uint) applicantRatings; // Applicant ID to rating
    
    uint applicantCount;
    uint jobCount;
    
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }
    
    constructor() {
        admin = msg.sender;
    }
    
    function addApplicant(uint _id, string memory _name, string memory _profileLink) external onlyAdmin {
        applicants[_id] = Applicant(_id, _name, _profileLink);
        applicantCount++;
    }
    
    function getApplicantDetails(uint _id) external view returns (uint, string memory, string memory) {
        require(_id <= applicantCount && _id > 0, "Invalid applicant ID");
        Applicant memory applicant = applicants[_id];
        return (applicant.id, applicant.name, applicant.profileLink);
    }
    
    function getApplicantType(int _appId) external pure returns (string memory) {
        //Some logic to determine applicant type based on _appId
        if(_appId > 0){
            return "Valid Applicant";
        } else
        return "Invalid Applicant";
    }
    
    function addJob(uint _id, string memory _title, string memory _description, uint256 _salary) external onlyAdmin {
        jobs[_id] = Job(_id, _title, _description, _salary, new address[](0));
        jobCount++;
    }
    
    function getJobDetails(uint _id) external view returns (uint, string memory, string memory, uint256) {
        require(_id <= jobCount && _id > 0, "Invalid job ID");
        Job memory job = jobs[_id];
        return (job.id, job.title, job.description, job.salary);
    }
    
    function applyForJob(uint _jobId) external {
        require(_jobId <= jobCount && _jobId > 0, "Invalid job ID");
        jobs[_jobId].candidates.push(msg.sender); // Changed from applicants to candidates
    }
    
    function provideRating(uint _applicantId, uint _rating) external {
        require(_applicantId <= applicantCount && _applicantId > 0, "Invalid applicant ID");
        applicantRatings[_applicantId] = _rating;
    }
    
    function fetchApplicantRating(uint _applicantId) external view returns (uint) {
        require(_applicantId <= applicantCount && _applicantId > 0, "Invalid applicant ID");
        return applicantRatings[_applicantId];
    }
}
