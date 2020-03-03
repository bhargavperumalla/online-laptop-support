using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Attendance.Models
{
    public class DeptMODEL
    {
        //public string Dept_ID { get; set; }
        //[Required]
        //public string Dept_Name { get; set; }

        public int DepartmentId { get; set; }
        [Required(ErrorMessage = "Department name is required")]
        public string Department { get; set; }
        public bool IsActive { get; set; }        
    }
}