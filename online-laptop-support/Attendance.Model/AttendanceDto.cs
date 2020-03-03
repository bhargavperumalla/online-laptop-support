using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Attendance.Model
{
    public class AttendanceDto
    {
        public DateTime CurrentDateTime { get; set; }

        public string EmployeeName { get; set; }

        public string InTime { get; set; }

        public string OutTime { get; set; }

        public int? Leave { get; set; }

        public string LeaveType { get; set; }

        public string PermissionHrs { get; set; }

        public string ExtraHrsWorked { get; set; }

        public string WFH { get; set; }

        public int EmployeeID { get; set; }

        public string CreatedBy { get; set; }

        public string date { get; set; }
    }
}
