using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Attendance.API.RequestObjects
{
    public class BiometricRequest
    {
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public string EmployeeIds { get; set; }
    }
}