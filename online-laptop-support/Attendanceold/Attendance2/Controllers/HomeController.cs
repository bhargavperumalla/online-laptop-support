using Attendance.Attributes;
using Attendance.Model;
using Attendance.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Mvc;
using System.Web.Security;

namespace Attendance.Controllers
{
    [SessionAuthorize]
    public class HomeController : BaseController
    {
        readonly WebInstance WebAPI = new WebInstance(MvcApplication.APIBaseUrl);
        // GET: Home
        public ActionResult Index()
        {
            ViewBag.Years = Utility.GetYears();
            ViewBag.Months= Utility.GetMonths();
            return View();
        }

        public JsonResult GetEmployees()
        {
            Status status = WebAPI.Get<Status>("employees");

            List<Employees> list = JsonConvert.DeserializeObject<List<Employees>>(status.Data.ToString());
            return Json(list, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult GetMonthlyData(string year, string month)
        {
            try
            {
                Monthly model = new Monthly();

                DateTime[] dates = Utility.GetDates(year, month);
                model.FromDate = dates[0].ToString();
                model.ToDate = dates[1].ToString();

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.GetModelErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Json(badstatus, JsonRequestBehavior.AllowGet);
                }
                HttpResponseMessage response = WebAPI.Post("Reports/Monthly", model);
                Status data = response.Content.ReadAsAsync<Status>().Result;

                if (data.Code == HttpStatusCode.OK)
                {
                    var userdetails = JsonConvert.DeserializeObject<List<MonthlyDto>>(data.Data.ToString());
                    Status status = new Status("OK", null, userdetails);
                    return Json(status, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(data, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Json(status, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult Change()
        {
            return View();
        }

        [HttpPost]
        public JsonResult ChangePassword(ChangePassword model)
        {
            try
            {
                if (model == null) return BadPayload();
                if (model.oldPassword == model.newPassword)
                    ModelState.AddModelError("NewPassword", "Password and New Password should not be same");

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.GetModelErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Json(badstatus, JsonRequestBehavior.AllowGet);
                }

                model.EmployeeID = Convert.ToInt32(Session["EmployeeId"]);
                model.newPassword = FormsAuthentication.HashPasswordForStoringInConfigFile(model.newPassword, "SHA1");
                model.oldPassword = FormsAuthentication.HashPasswordForStoringInConfigFile(model.oldPassword, "SHA1");
                model.confirmPassword = FormsAuthentication.HashPasswordForStoringInConfigFile(model.confirmPassword, "SHA1");
                HttpResponseMessage response = WebAPI.Post("user/ChangePassword", model);
                Status data = response.Content.ReadAsAsync<Status>().Result;

                if (data.Code == HttpStatusCode.OK)
                    return Json(new { Valid = "true", Success = "true", Data = "Password has been " + (model.EmployeeID == 0 ? "saved successfully" : "updated successfully") }, JsonRequestBehavior.AllowGet);
                else
                    return Json(new { Valid = "true", Success = "false", Data = data.Errors }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Json(status, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult GetTime(int employeeId, string year, string month)
        {
            try
            {
                Monthly model = new Monthly();

                DateTime[] dates = Utility.GetDates(year, month);
                model.FromDate = dates[0].ToString();
                model.ToDate = dates[1].ToString();
                model.EmployeeId = employeeId;

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.GetModelErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Json(badstatus, JsonRequestBehavior.AllowGet);
                }
                HttpResponseMessage response = WebAPI.Post("Reports/Time", model);
                Status data = response.Content.ReadAsAsync<Status>().Result;

                if (data.Code == HttpStatusCode.OK)
                {
                    var userdetails = JsonConvert.DeserializeObject<List<MonthlyDto>>(data.Data.ToString());
                    Status status = new Status("OK", null, userdetails);
                    return Json(status, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(data, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Json(status, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult InsertCheckInDetails(Models.Attendance model)
        {
            try
            {
                model.EmployeeID = Convert.ToInt32(Session["EmployeeId"]);
                model.CreatedBy = Session["UserId"].ToString();

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.GetModelErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Json(badstatus, JsonRequestBehavior.AllowGet);
                }
                HttpResponseMessage response = WebAPI.Post("employees/TimeInsert", model);
                Status data = response.Content.ReadAsAsync<Status>().Result;

                if (data.Code == HttpStatusCode.OK)
                {
                    var userdetails = JsonConvert.DeserializeObject<List<AttendanceDto>>(data.Data.ToString());
                    Status status = new Status("OK", null, userdetails);
                    return Json(status, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(data, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Json(status, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult GetCheckInDetails()
        {
            Status status = WebAPI.Get<Status>("employees/Check/" + Session["EmployeeId"].ToString());

            List<AttendanceDto> model = (status.Text.ToLower() == "ok") ? JsonConvert.DeserializeObject<List<AttendanceDto>>(status.Data.ToString()) : new List<AttendanceDto>();

            return Json(model, JsonRequestBehavior.AllowGet);
        }

        #region Missed CheckIn
        public JsonResult UpdateCheckOutDetails(string OutTime, string Date)
        {
            int employeeId = Convert.ToInt32(Session["EmployeeId"]);
            Models.Attendance model = new Models.Attendance();
            model.OutTime = OutTime;
            model.CurrentDateTime = Convert.ToDateTime(Date);
            if (OutTime == null)
                ModelState.AddModelError("OutTime", "OutTime is required");

            if (!ModelState.IsValid)
            {
                var errorModel = ModelState.GetModelErrors();
                string Json = "{\"Valid\":\"false\",\"Data\":" + JsonConvert.SerializeObject(errorModel) + "}";
                return new JsonResult { Data = Json };
            }
            Status status = WebAPI.Put<Status>("employees/UpdateTime", employeeId.ToString(), model);

            if (status.Text.ToLower() == "ok")
                return Json(new { Valid = "true", Success = "true", Data = "CheckOutTime updated successfully" }, JsonRequestBehavior.AllowGet);
            else return Json(new { Valid = "true", Success = "false", Data = status.Errors }, JsonRequestBehavior.AllowGet);

        }

        public JsonResult GetCheckOutDetails()
        {
            Status status = WebAPI.Get<Status>("employees/CheckOut/" + Session["EmployeeId"].ToString());

            List<AttendanceDto> model = (status.Text.ToLower() == "ok") ? JsonConvert.DeserializeObject<List<AttendanceDto>>(status.Data.ToString()) : new List<AttendanceDto>();

            return Json(model, JsonRequestBehavior.AllowGet);
        }
        #endregion

        public JsonResult EmployeeAnniversary()
        {
            TimeZoneInfo oTZInfo = TimeZoneInfo.FindSystemTimeZoneById("India Standard Time");
            DateTime dtCurrentDateTime = TimeZoneInfo.ConvertTime(DateTime.Now, oTZInfo);
            string date = DateTime.Parse((dtCurrentDateTime.ToString())).ToString("MM-dd-yyyy");
            Status status = WebAPI.Get<Status>("employees/Anniversay/" + date);

            List<AnniversaryDto> model = (status.Text.ToLower() == "ok") ? JsonConvert.DeserializeObject<List<AnniversaryDto>>(status.Data.ToString()) : new List<AnniversaryDto>();

            return Json(model, JsonRequestBehavior.AllowGet);
        }
    }
}
