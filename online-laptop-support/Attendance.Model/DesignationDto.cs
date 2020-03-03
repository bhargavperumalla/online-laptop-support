using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Attendance.Model
{
   public class DesignationDto
    {
        public int DesignationID { get; set; }
        public string Designation { get; set; }
        public bool IsActive { get; set; }
    }
}
