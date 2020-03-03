using System;

namespace Attendance.Model
{
    public  class EmployeesDto
    {
        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string Designation { get; set; }

        public int EmployeeID { get; set; }
        public string MapleID { get; set; }
        public string SlackId { get; set; }
        public string BiometricID { get; set; }

        public string Department { get; set; }

        public string Mobile { get; set; }

        public string Email { get; set; }

        public string PersonalEmail { get; set; }

        public DateTime? DOB { get; set; }

        public DateTime? DOJ { get; set; }

        public DateTime? DOA { get; set; }

        public int DepartmentID { get; set; }

        public int Gender { get; set; }

        public bool MaritalStatus { get; set; }

        public string BloodGroup { get; set; }

        public string ProfilePic { get; set; }

        public string EmergencyContactPerson { get; set; }

        public string EmergencyContactRelation { get; set; }

        public string EmergencyContactNumber { get; set; }

        public int Active { get; set; }

        //public int Admin { get; set; }

        //public int Action { get; set; }

        public string UserID { get; set; }

        public string Password { get; set; }

        public string confirmPassword { get; set; }

        public int DesignationID { get; set; }

        public DateTime? ActiveDate { get; set; }

        public bool IsAdmin { get; set; }

        public bool IsActive { get; set; }

        public bool IsProfileUpdated { get; set; }
    }
}
