using Attendance.API.RequestObjects;

using Attendance.DAL;
using Attendance.Model;
using log4net;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using static Attendance.API.Utility;

namespace Attendance.API.Controllers
{
    [TokenAuthentication]
    [RoutePrefix("v1/user")]
    public class UserController : BaseController
    {
        private static readonly ILog log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        [Route("login"), HttpPost]
        public HttpResponseMessage UserAuthenticate(LoginRequest model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered UserAuthenticate method ");
                if (model == null)
                    return BadPayload();
                UserDAL _UserDAL = new UserDAL();
                log.Info("Getting UserDetails from database");
                var users = _UserDAL.AutheticateUser(model.UserName, model.Password);
                log.Info("Getting UserDetails from database is completed. Returning the status object ");
                Status status = new Status("OK", null, users);

                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                log.Error(ex);
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }
            finally
            {
                stopwatch.Stop();
                log.Info("UserAuthenticate-Elapsed " + stopwatch.Elapsed);
            }
        }

        [Route("ChangePassword"), HttpPost]
        public HttpResponseMessage ChangePassword(ChangePasswordRequest model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered ChangePassword method ");

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
                    log.Debug("Errors:" + string.Join(",", errors));
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }
                log.Info("Getting Password Details from the database");
                UserDAL _UserDAL = new UserDAL();

                int res = _UserDAL.ChangePassword(model.EmployeeId, model.OldPassword, model.NewPassword);
                log.Info("Getting Password Details from the database is completed. Returning the status object ");
                string error = string.Empty;
                if (res == -1) error = ("Invalid old password");
                else if (res == 0) error = ("Password not changed");
                if (!string.IsNullOrEmpty(error))
                {
                    log.Debug($"Errors:{error}");
                    status = new Status("BadRequest", error);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }
                status = new Status("OK", null, res);
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                log.Error(ex);
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }
            finally
            {
                stopwatch.Stop();
                log.Info("ChangePassword-Elapsed " + stopwatch.Elapsed);
            }

        }

        [Route("Reset/{EmployeeId}"), HttpPut]
        public HttpResponseMessage ResetPassword(int EmployeeId, EmployeesDto model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered ResetPassword method");
                if (EmployeeId <= 0)
                {
                    ModelState.AddModelError("EmployeeId", "EmployeeId is Required");
                }
                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    log.Debug("Errors:" + string.Join(",", errors));
                    Status badstatus = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, badstatus, _jsonMediaTypeFormatter);
                }
                UserDAL _UserDAL = new UserDAL();
                log.Info("Getting ResetPassword data from database");
                int res = _UserDAL.Resetpassword(EmployeeId);
                log.Info("Getting ResetPassword data from the database is completed. Returning the status object ");
                Status status = new Status("OK", null, res);
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                log.Error(ex);
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }
            finally
            {
                stopwatch.Stop();
                log.Info("ResetPassword-Elapsed " + stopwatch.Elapsed);
            }
        }
    }
}