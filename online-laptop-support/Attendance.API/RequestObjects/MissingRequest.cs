using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Attendance.API.RequestObjects
{
    public class MissingRequest
    {
        public string EmployeeID { get; set; }

        public string Date { get; set; }
        
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public int Leave { get; set; }
        public string LeaveType { get; set; }
        public string PermissionHrs { get; set; }
        public int WFH { get; set; }
        public string EmployeeName { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public string CheckIn { get; set; }
        public string CheckOut { get; set; }
        public string ExtraHrsWorked { get; set; }
    }
}