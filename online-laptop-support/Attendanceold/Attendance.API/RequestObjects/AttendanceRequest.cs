using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Attendance.API.RequestObjects
{
    public class AttendanceRequest
    {
        public DateTime CurrentDateTime { get; set; }
        public int CreatedUserId { get; set; }
        public int EmployeeID { get; set; }
        public string EmployeeName { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public int? Leave { get; set; }
        public string LeaveType { get; set; }
        public string PermissionHrs { get; set; }
        public string WFH { get; set; }
    }
}