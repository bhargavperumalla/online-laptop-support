using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace Attendance.Models
{
    public class Employees
    {
        [Required( ErrorMessage = "First name is required")]
        public string FirstName { get; set; }

        [Required( ErrorMessage = "Last name is required")]
        public string LastName { get; set; }

        [Required( ErrorMessage = "Designation is required"), Range(1, int.MaxValue, ErrorMessage = "Designation is  required")]
        public int DesignationID { get; set; }

        public string Designation { get; set; }

        public int EmployeeID { get; set; }

        public string MapleID { get; set; }
        public string SlackId { get; set; }
        public string BiometricID { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Department is required"), Range(1, int.MaxValue, ErrorMessage = "Department is  required")]
        public int DepartmentID { get; set; }

        public string Department { get; set; }

        [Required(ErrorMessage = "Mobile is required")]
        [RegularExpression(@"^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$", ErrorMessage = "Not a valid mobile number")]
        public string Mobile { get; set; }

        [EmailAddress(ErrorMessage = "Enter valid Email address")]
        public string Email { get; set; }

        [EmailAddress(ErrorMessage = "Enter valid Email address")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Personal email is required")]
        public string PersonalEmail { get; set; }

        //[DataType(DataType.DateTime)]
        //[DisplayFormat(DataFormatString = "{0:dd/mmm/yyyy HH:mm:ss}")]
        public DateTime? DOB { get; set; }

        //[DataType(DataType.DateTime)]
        //[DisplayFormat(DataFormatString = "{0:dd/mmm/yyyy HH:mm:ss}")]
        public DateTime? DOJ { get; set; }

        //[DataType(DataType.DateTime)]
        //[DisplayFormat(DataFormatString = "{0:dd/mmm/yyyy HH:mm:ss}")]
        public DateTime? DOA { get; set; }

        
        public int Gender { get; set; }

        public bool MaritalStatus { get; set; }


        [Required(ErrorMessage ="Blood group is required")]
        public string BloodGroup { get; set; }

        public string EmergencyContactPerson { get; set; }

        public string EmergencyContactRelation { get; set; }
    
        [RegularExpression(@"^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$", ErrorMessage = "Not a valid phone number")]
        public string EmergencyContactNumber { get; set; }

        //[RegularExpression(@"([a-zA-Z0-9\s_\\.\-:])+(.png|.jpg|.gif)$", ErrorMessage = "Only Image files allowed.")]
        public string ProfilePic { get; set; }

        public bool IsActive { get; set; }

        public bool IsAdmin { get; set; }

        //public int Action { get; set; }

        [Required( ErrorMessage = "User name is required")]
        public string UserID { get; set; }
        [Required(ErrorMessage = "Password is required")]
        public string Password { get; set; }

        [Required(ErrorMessage = "Confirm password is required.")]
        [Compare("Password", ErrorMessage = "Password and Confirm password Password should match.")]
        public string ConfirmPassword { get; set; }
        public HttpPostedFileBase fileupload;

        public bool IsProfileUpdated { get; set; }

    }
}