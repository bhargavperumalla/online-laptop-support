using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Attendance.DAL
{
   public class HelperDAL
    {
        public static string CONNECTIONSTRING = System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString();

    }
}
