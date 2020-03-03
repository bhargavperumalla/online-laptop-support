using System.Data;
using System.Linq;
using System.Web.Http.ModelBinding;

namespace Attendance.API
{
    public static class Helper
    {
        public static object GetModelErrors(this ModelStateDictionary m)
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