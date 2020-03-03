using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Attendance.Models
{
    public class Monthly
    {
        public int EmployeeId { get; set; }
        public string EmployeeName { get; set; }       
        public string Duration { get; set; }
        public string Permission { get; set; }
        public string Leaves { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public decimal TotalDaysPresent { get; set; }
        public string SL { get; set; }
        public string PL { get; set; }
        public string ML { get; set; }
        public string COFF { get; set; }
        public string WFH { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public string Date { get; set; }
        public string ExtraHrsWorked { get; set; }

    }
}