using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Attendance.Models
{
    public class DesignationMODEL
    {
        //public string Desig_ID { get; set; }
        //[Required]
        //public string Desig_Name { get; set; }

        public int DesignationId { get; set; }
        [Required(ErrorMessage = "Designation Name is Required")]
        public string Designation { get; set; }
        public bool IsActive { get; set; }

    }
}