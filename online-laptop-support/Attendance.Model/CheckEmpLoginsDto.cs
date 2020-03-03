using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Attendance.Model
{
    public class CheckEmpLoginsDto
    {
        public string EmployeeName { get; set; }
        public string SlackId { get; set; }
        public int type { get; set; }
    }
}
