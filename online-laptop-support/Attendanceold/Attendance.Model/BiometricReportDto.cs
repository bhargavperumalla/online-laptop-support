using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Attendance.Model
{
    public class BiometricReportDto
    {
        public string Date { get; set; }
        public string EmployeeID { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public string Name { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public string Duration { get; set; }
    }
}
