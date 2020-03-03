using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Attendance
{
    public static class Extensions
    {
        public static object GetModelErrors(this System.Web.Mvc.ModelStateDictionary m)
        {
            var errors = from x in m.Keys
                         where m[x].Errors.Count > 0
                         select new
                         {
                             key = x,
                             errors = m[x].Errors.Select(y => y.ErrorMessage).ToArray()
                         };
            return errors;
        }
    }
}