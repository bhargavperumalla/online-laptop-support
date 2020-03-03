using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Attendance.Models
{
    public class Columns
    {
        public string CurrentColumn { get; set; }

        public string ActualColumn { get; set; }
    }
}