using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Attendance.Models
{
    public class Daily
    {
        public string EmployeeID { get; set; }

        public string Date { get; set; }

        public string EmployeeName { get; set; }

        public string InTime { get; set; }

        public string OutTime { get; set; }

        public string Duration { get; set; }

        public string Permission { get; set; }

        public string Leave { get; set; }

        public string LeaveType { get; set; }

        public string FromDate { get; set; }

        public string ToDate { get; set; }

        public string WorkFromHome { get; set; }
        
    }
}