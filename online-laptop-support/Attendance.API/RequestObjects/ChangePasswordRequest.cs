﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Attendance.API.RequestObjects
{
    public class ChangePasswordRequest
    {
        public int EmployeeId { get; set; }
        public string OldPassword { get; set; }
        public string NewPassword { get; set; }
        public string ConfirmPassword { get; set; }
    }
}