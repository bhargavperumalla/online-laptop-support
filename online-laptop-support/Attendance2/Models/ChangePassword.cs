using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Attendance.Models
{
    public class ChangePassword
    {
        [Required(ErrorMessage = "Old password is required.")]
        public string oldPassword {get; set;}
       
        [Required(ErrorMessage = "New password is required.")]
        public string newPassword { get; set; }

        [Required(ErrorMessage = "Confirm password is required.")]
        [Compare("newPassword", ErrorMessage = "New password and Confirm password Password should match.")]
        public string confirmPassword { get; set; }
        public int EmployeeID { get; set; }
    }
}