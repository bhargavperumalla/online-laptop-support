using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Attendance.API.RequestObjects
{
    public class MothlyRequest
    {
        public int EmployeeID { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }

    }
}