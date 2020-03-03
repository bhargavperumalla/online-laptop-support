using System;

namespace Attendance.Models
{
    public class Attendance
    {
        public int ID { get; set; }
        public int EmployeeID { get; set; }
        public string EmployeeName { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public int? Leave { get; set; }
        public string LeaveType { get; set; }
        public string PermissionHrs { get; set; }
        public string ExtraHrsWorked { get; set; }
        public string WFH { get; set; }
        public string TrInfo { get; set; }
        public DateTime CurrentDateTime { get; set; }
        public string CreatedBy { get; set; }
    }

    public class AttendanceRequest
    {
        public string CurrentDateTime { get; set; }
        public string test { get; set; }
    }


}