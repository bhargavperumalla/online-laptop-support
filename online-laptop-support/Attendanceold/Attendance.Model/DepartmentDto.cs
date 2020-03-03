using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Attendance.Model
{
    public class DepartmentDto
    {
        public int DepartmentId { get; set;}
        public string Department { get; set; }
        public bool IsActive { get; set; }
    }
}
