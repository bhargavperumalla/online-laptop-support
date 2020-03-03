using Attendance.API.RequestObjects;
using Attendance.DAL;
using Attendance.Model;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Attendance.API.Controllers
{
    [RoutePrefix("v1/user")]
    public class UserController : BaseController
    {
        [Route("login"), HttpPost]
        public HttpResponseMessage UserAuthenticate(LoginRequest model)
        {
            try
            {
                if (model == null)
                    return BadPayload();

                UserDAL _UserDAL = new UserDAL();
                var users = _UserDAL.AutheticateUser(model.UserName, model.Password);
                Status status = new Status("OK", null, users);
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }
        }


        [Route("ChangePassword"), HttpPost]
        public HttpResponseMessage ChangePassword(ChangePasswordRequest model)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(model.OldPassword))
                {
                    ModelState.AddModelError("OldPassword", "Old Password should not be Empty");
                }
                if (string.IsNullOrWhiteSpace(model.NewPassword))
                {
                    ModelState.AddModelError("NewPassword", "New Password should not be Empty");
                }
                if (model.OldPassword == model.NewPassword)
                    ModelState.AddModelError("NewPassword", "Password and New Password should not be same");

                if (string.IsNullOrWhiteSpace(model.ConfirmPassword))
                    ModelState.AddModelError("confirmPassword", "Confirm Password should not be Empty");

                if (!string.IsNullOrWhiteSpace(model.NewPassword) && !string.IsNullOrWhiteSpace(model.ConfirmPassword)
                    && model.NewPassword != model.ConfirmPassword)
                {
                    ModelState.AddModelError("ConfirmPassword", "New Password and Confirm Password should be same");
                }

                Status status = new Status("OK");
                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }
                UserDAL _UserDAL = new UserDAL();
                int res = _UserDAL.ChangePassword(model.EmployeeId, model.OldPassword, model.NewPassword);

                List<string> error = new List<string>();
                if (res == -1) error.Add("Invalid old password");
                else if (res == 0) error.Add("Password not changed");
                if (error.Count > 0)
                {
                    status = new Status("BadRequest", error[0]);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }
                status = new Status("OK", null, res);
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }

        }

        [Route("Reset/{EmployeeId}"), HttpPut]
        public HttpResponseMessage ResetPassword(int EmployeeId, EmployeesDto model)
        {
            try
            {
                if (EmployeeId <= 0)
                {
                    ModelState.AddModelError("EmployeeId", "EmployeeId is Required");
                }
                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, badstatus, _jsonMediaTypeFormatter);
                }
                UserDAL _UserDAL = new UserDAL();
                int res = _UserDAL.Resetpassword(EmployeeId);
                Status status = new Status("OK", null, res);
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }
        }
    }
}