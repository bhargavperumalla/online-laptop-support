using Attendance.Model;
using Attendance.Models;
using log4net;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Net;
using System.Net.Http;
using System.Web.Mvc;
using System.Web.Security;
using static Attendance.Utility;

namespace Attendance.Controllers
{
    public class LoginController : BaseController
    {
        readonly WebInstance WebAPI = new WebInstance(MvcApplication.APIBaseUrl);

        private static readonly ILog log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        // GET: Login
        public ActionResult Index()
        {
            Session.Clear();
            Session.RemoveAll();
            Session.Abandon();
            return View();
        }

        [HttpPost]
        [AllowAnonymous]
        public JsonResult UserAuthentication(LoginModel model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered UserAuthentication method");
                if (model == null) return BadPayload();

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.GetModelErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Json(badstatus, JsonRequestBehavior.AllowGet);
                }
                model.Password = FormsAuthentication.HashPasswordForStoringInConfigFile(model.Password, "SHA1");
                HttpResponseMessage response = WebAPI.Post("user/login", model);
                Status data = response.Content.ReadAsAsync<Status>().Result;

                if (data.Code == HttpStatusCode.OK)
                {
                    var userdetails = JsonConvert.DeserializeObject<List<EmployeesDto>>(data.Data.ToString());

                    if (userdetails != null && userdetails.Count > 0)
                    {
                        Session["UserId"] = userdetails[0].UserID;
                        Session["EmployeeId"] = userdetails[0].EmployeeID;
                        Session["Name"] = userdetails[0].FirstName.ToString() + ", " + userdetails[0].LastName[0].ToString();
                        Session["IsAdmin"] = userdetails[0].IsAdmin.ToString().ToLower();
                        Session["Designation"] = userdetails[0].Designation;
                        Session["IsProfileUpdated"] = userdetails[0].IsProfileUpdated.ToString().ToLower();
                        Session["ProfilePic"] = Utility.GetImagePath(userdetails[0].EmployeeID.ToString(), Convert.ToInt32(userdetails[0].Gender));
                    }

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
                log.Error(ex);
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Json(status, JsonRequestBehavior.AllowGet);
            }
            finally
            {
                stopwatch.Stop();
                log.Info("Elapsed" + stopwatch.Elapsed);
            }
        }
    }
}