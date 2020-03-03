using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Attendance.Model
{
    public class LoginDto
    {
     
        public string UserID { get; set; }
     
        public string Password { get; set; }
        public bool IsActive { get; set; }
    }
}
