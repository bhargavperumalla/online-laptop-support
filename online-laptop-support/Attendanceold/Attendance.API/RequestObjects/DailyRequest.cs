using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Attendance.API.RequestObjects
{
    public class DailyRequest
    {
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public string EmployeeID { get; set; }
    }
}