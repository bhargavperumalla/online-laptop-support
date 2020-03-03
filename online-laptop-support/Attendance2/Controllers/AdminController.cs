using Attendance.Attributes;
using Attendance.Model;
using Attendance.Models;
using log4net;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace Attendance.Controllers
{
    [SessionAuthorize]

    public class AdminController : BaseController
    {
        private static readonly ILog log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        readonly WebInstance WebAPI = new WebInstance(MvcApplication.APIBaseUrl);

        #region Attendance
        [Authorization]
        public ActionResult Reset()
        {
            return View();
        }

        [HttpPost]
        [Authorization]
        public JsonResult ResetPassword(EmployeesDto model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered ResetPassword method");

                if (model == null) return BadPayload();

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.GetModelErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Json(badstatus, JsonRequestBehavior.AllowGet);
                }

                Status status = WebAPI.Put<Status>("user/Reset", model.EmployeeID.ToString(), model);
                return Json(status, JsonRequestBehavior.AllowGet);
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
                log.Info("ResetPassword-Elapsed" + stopwatch.Elapsed);
            }
        }

        [Authorization]
        public ActionResult Attendance()
        {
            ViewBag.ToDay = Utility.GetIndianTime().ToString("MM/dd/yyyy");
            return View();
        }

        [Authorization]
        public JsonResult AttendanceDetails(Attendance.Models.Attendance model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered AttendanceDetails method");

                Status status = WebAPI.Post<Status>("employees/Attendance/", model);

                List<AttendanceDto> response = (status.Text.ToLower() == "ok") ? JsonConvert.DeserializeObject<List<AttendanceDto>>(status.Data.ToString()) : new List<AttendanceDto>();

                return Json(response, JsonRequestBehavior.AllowGet);
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
                log.Info("AttendanceDetails-Elapsed" + stopwatch.Elapsed);
            }

        }

        [HttpPost]
        [Authorization]
        public JsonResult SaveAttendanceDetails(AttendanceList model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered SaveAttendanceDetails method");

                Status status = WebAPI.Post<Status>("employees/SaveAttendance", model);
                if (status.Text == "OK")
                {
                    return Json(new { Valid = "true", Success = "true", Data = "Saved Successfully" }, JsonRequestBehavior.AllowGet);
                }
                return Json(new { Valid = "true", Success = "false", Data = status.Errors }, JsonRequestBehavior.AllowGet);
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
                log.Info("SaveAttendanceDetails-Elapsed" + stopwatch.Elapsed);
            }
        }

        #endregion

        #region Employee
        [Authorization]
        public ActionResult Employee()
        {
            if (Session["employee"] != null)
            {
                ViewBag.emp = Session["employee"];
                Session.Remove("employee");
            }
            else
            {
                ViewBag.emp = "";
            }
            if (Session["empupdate"] != null)
            {
                ViewBag.empupdate = Session["empupdate"];
                Session.Remove("empupdate");
            }
            else
            {
                ViewBag.empupdate = "";
            }
            return View();
        }

        [Authorization]
        public ActionResult AddEmployee()
        {
            return View();
        }

        [HttpPost]
        [Authorization]
        public ActionResult AddEmployee(Employees emp, HttpPostedFileBase image)
        {
            if (ModelState.IsValid)
            {
                return Redirect("AddEmployees");
            }
            else
            {
                return View(emp);
            }
        }

        public JsonResult EmployeeDetails(string Active)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered EmployeeDetails method");
                Status status = WebAPI.Get<Status>("employees/status/" + Active);

                List<EmployeesDto> model = (status.Text.ToLower() == "ok") ? JsonConvert.DeserializeObject<List<EmployeesDto>>(status.Data.ToString()) : new List<EmployeesDto>();

                return Json(model, JsonRequestBehavior.AllowGet);
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
                log.Info("EmployeeDetails-Elapsed" + stopwatch.Elapsed);
            }
        }

        [HttpPost]
        [Authorization]
        public JsonResult SaveEmployees(Employees model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered SaveEmployees method");

                if (model == null) return BadPayload();
                HttpPostedFileBase fileupload;

                if (System.Web.HttpContext.Current.Request.Files.AllKeys.Any())
                {
                    fileupload = Request.Files[0];
                    string fileName = fileupload.FileName;
                    if (fileName != null && fileName != "")
                    {
                        string ext = Path.GetExtension(fileName);
                        if (ext.ToLower() != ".jpg" && ext.ToLower() != ".jpeg" && ext.ToLower() != ".png" && ext.ToLower() != ".gif")
                        {
                            ModelState.AddModelError("fileUpload", "Please upload profilepic(jpg,jpeg,png,gif) formats only");
                        }
                    }
                    else
                    {
                        if (fileupload.ContentLength > 1048576)
                        {
                            ModelState.AddModelError("fileUpload", "Please upload profilepic of size below 1mb only");
                        }
                    }
                }
                if (model.MaritalStatus && model.DOA == null)
                    ModelState.AddModelError("DOA", "DOA is required");

                if (model.DOB >= DateTime.Now)
                    ModelState.AddModelError("DOB", "Date of birth should less than current date");

                if (model.DOJ > DateTime.Now)
                    ModelState.AddModelError("DOJ", "Date of joining should less than current date");

                if (model.DOA > DateTime.Now)
                    ModelState.AddModelError("DOA", "Date of anniversary should less than current date");

                if (model.DOB >= model.DOJ)
                    ModelState.AddModelError("DOB", "Date of birth should less than Date of joining");

                if (model.DOB >= model.DOA)
                    ModelState.AddModelError("DOB", "Date of birth should less than Date of anniversary");

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.GetModelErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Json(badstatus, JsonRequestBehavior.AllowGet);
                }

                model.Password = FormsAuthentication.HashPasswordForStoringInConfigFile(model.Password, "SHA1");
                HttpResponseMessage response = WebAPI.Post("employees", model);
                Status data = response.Content.ReadAsAsync<Status>().Result;

                if (data.Code == HttpStatusCode.OK)
                {
                    var Employeedetails = JsonConvert.DeserializeObject<EmployeesDto>(data.Data.ToString());
                    if (Employeedetails != null && System.Web.HttpContext.Current.Request.Files.AllKeys.Any())
                    {
                        fileupload = Request.Files[0];
                        if (fileupload.ContentLength > 0)
                        {
                            string filePath = Server.MapPath("~/Content/ProfilePics/");
                            fileupload.SaveAs(filePath + Employeedetails.EmployeeID.ToString() + Path.GetExtension(fileupload.FileName));
                        }
                    }
                    Session["employee"] = "Employee saved successfully";
                    return Json(data, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(new { Valid = "true", Success = "false", Data = data.Errors }, JsonRequestBehavior.AllowGet);
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
                log.Info("SaveEmployees-Elapsed" + stopwatch.Elapsed);
            }

        }
        [Authorization]
        public ActionResult EditEmployee(string id)
        {
            Status status = WebAPI.Get<Status>("employees", id);
            Employees model = (status.Text.ToLower() == "ok") ? JsonConvert.DeserializeObject<Employees>(status.Data.ToString()) : new Employees();
            if (model.DOA.HasValue && model.DOA.Value.ToString("dd/MM/yyyy") == "01/01/1900")
                model.DOA = null;
            if (model.DOJ.HasValue && model.DOJ.Value.ToString("dd/MM/yyyy") == "01/01/1900")
                model.DOJ = null;
            if (model.DOB.HasValue && model.DOB.Value.ToString("dd/MM/yyyy") == "01/01/1900")
                model.DOB = null;
            ViewBag.hdnFlag = id;
            return View(model);
        }

        [HttpPost]
        [Authorization]
        public JsonResult UpdateEmployee(Employees model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered UpdateEmployee method");

                if (model == null) return BadPayload();

                HttpPostedFileBase fileupload;
                if (System.Web.HttpContext.Current.Request.Files.AllKeys.Any())
                {
                    fileupload = Request.Files[0];
                    string fileName = fileupload.FileName;
                    if (fileName != null && fileName != "")
                    {
                        string ext = Path.GetExtension(fileName);
                        if (ext.ToLower() != ".jpg" && ext.ToLower() != ".jpeg" && ext.ToLower() != ".png" && ext.ToLower() != ".gif")
                        {
                            ModelState.AddModelError("fileUpload", "Please upload profilepic(jpg, jpeg,png,gif) formats only");
                        }
                    }
                    else
                    {
                        if (fileupload.ContentLength > 1048576)
                        {
                            ModelState.AddModelError("fileUpload", "Please upload profilepic of size 1mb only");
                        }
                    }
                }

                if (model.MaritalStatus)
                    if (model.DOA == null)
                        ModelState.AddModelError("DOA", "DOA is required");

                if (model.DOB >= DateTime.Now)
                    ModelState.AddModelError("DOB", "Date of birth should less than current date");

                if (model.DOJ > DateTime.Now)
                    ModelState.AddModelError("DOJ", "Date of joining should less than current date");

                if (model.DOA > DateTime.Now)
                    ModelState.AddModelError("DOA", "Date of anniversary should less than current date");

                if (model.DOB >= model.DOJ)
                    ModelState.AddModelError("DOB", "Date of birth should less than Date of joining");

                if (model.DOB >= model.DOA)
                    ModelState.AddModelError("DOB", "Date of birth should less than Date of anniversary");

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.GetModelErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Json(badstatus, JsonRequestBehavior.AllowGet);
                }
                model.Password = FormsAuthentication.HashPasswordForStoringInConfigFile(model.Password, "SHA1");
                Status status = WebAPI.Put<Status>("employees", model.EmployeeID.ToString(), model);

                if (status.Code == HttpStatusCode.OK)
                {
                    var Employeedetails = JsonConvert.DeserializeObject<EmployeesDto>(status.Data.ToString());
                    if (Employeedetails != null)
                    {
                        if (System.Web.HttpContext.Current.Request.Files.AllKeys.Any())
                        {
                            fileupload = Request.Files[0];
                            if (fileupload.ContentLength > 0)
                            {

                                string filePath = Server.MapPath("~/Content/ProfilePics/");
                                string[] files = Directory.GetFiles(filePath, Employeedetails.EmployeeID.ToString() + ".*");
                                if (files != null) foreach (string f in files) { System.IO.File.Delete(f); }
                                fileupload.SaveAs(filePath + Employeedetails.EmployeeID.ToString() + Path.GetExtension(fileupload.FileName));

                            }
                        }
                    }
                    Session["empupdate"] = "Employee updated successfully";
                    return Json(status, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(status, JsonRequestBehavior.AllowGet);
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
                log.Info("UpdateEmployee-Elapsed" + stopwatch.Elapsed);
            }
        }

        [HttpPost]
        [Authorization]
        public JsonResult DeleteEmp(int id)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered DeleteEmployee method ");
                if (id <= 0) return BadPayload();

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.GetModelErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Json(badstatus, JsonRequestBehavior.AllowGet);
                }
                HttpResponseMessage response = WebAPI.Delete("employees", id.ToString());
                Status data = response.Content.ReadAsAsync<Status>().Result;

                if (data.Code == HttpStatusCode.OK)
                {
                    Status status = new Status("OK", null, null);
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
                log.Info("DeleteEmp-Elapsed" + stopwatch.Elapsed);
            }
        }

        #endregion

        #region Departments
        [Authorization]
        public ActionResult Departments()
        {
            return View();
        }

        [HttpGet]
        [Authorization]
        public JsonResult GetDepartments(string Active)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered GetDepartments method ");

                Status status = WebAPI.Get<Status>("department", Active);

                List<DepartmentDto> model = (status.Text.ToLower() == "ok") ? JsonConvert.DeserializeObject<List<DepartmentDto>>(status.Data.ToString()) : new List<DepartmentDto>();

                return Json(model, JsonRequestBehavior.AllowGet);
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
                log.Info("GetDepartments-Elapsed" + stopwatch.Elapsed);
            }

        }

        [HttpPost]
        [Authorization]
        public JsonResult EditDepartment(DeptMODEL model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered EditDepartment method ");
                if (string.IsNullOrWhiteSpace(model.Department))
                    ModelState.AddModelError("Department", "Department is required");
                if (!ModelState.IsValid)
                {
                    var errorModel = ModelState.GetModelErrors();
                    string Json = "{\"Valid\":\"false\",\"Data\":" + JsonConvert.SerializeObject(errorModel) + "}";
                    return new JsonResult { Data = Json };
                }

                Status status = WebAPI.Put<Status>("department", model.DepartmentId.ToString(), model);

                if (status.Text.ToLower() == "ok")
                    return Json(new { Valid = "true", Success = "true", Data = "Department updated successfully" }, JsonRequestBehavior.AllowGet);
                else return Json(new { Valid = "true", Success = "false", Data = status.Errors }, JsonRequestBehavior.AllowGet);
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
                log.Info("EditDepartment-Elapsed" + stopwatch.Elapsed);
            }
        }
        [HttpPost]
        [Authorization]
        public JsonResult SaveDepartment(DeptMODEL model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered SaveDepartment method ");

                if (model == null) return BadPayload();

                if (string.IsNullOrWhiteSpace(model.Department))
                    ModelState.AddModelError("Department", "Department is required");

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.GetModelErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Json(badstatus, JsonRequestBehavior.AllowGet);
                }

                Status data = WebAPI.Post<Status>("department", model);

                if (data.Code == HttpStatusCode.OK)
                {
                    return Json(data, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    //return Json(data, JsonRequestBehavior.AllowGet);
                    return Json(new { Valid = "true", Success = "false", Data = data.Errors }, JsonRequestBehavior.AllowGet);
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
                log.Info("SaveDepartment-Elapsed" + stopwatch.Elapsed);
            }
        }

        [HttpGet]
        [Authorization]
        public JsonResult DeleteDepartment(int Val)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered DeleteDepartment method ");
                HttpResponseMessage response = WebAPI.Delete("department/Id", Val.ToString());
                Status data = response.Content.ReadAsAsync<Status>().Result;
                if (data.Code == HttpStatusCode.OK)
                {
                    Status status = new Status("OK", null, null);
                    return Json(status, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(new { Valid = "true", Success = "false", Data = data.Errors }, JsonRequestBehavior.AllowGet);
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
                log.Info("DeleteDepartment-Elapsed" + stopwatch.Elapsed);
            }
        }

        #endregion

        #region Designations
        [Authorization]
        public ActionResult Designations()
        {
            return View();
        }

        [HttpGet]
        [Authorization]
        public JsonResult GetDesignations(string Active)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered GetDesignations method ");

                Status status = WebAPI.Get<Status>("designation", Active);

                List<DesignationDto> model = (status.Text.ToLower() == "ok") ? JsonConvert.DeserializeObject<List<DesignationDto>>(status.Data.ToString()) : new List<DesignationDto>();

                return Json(model, JsonRequestBehavior.AllowGet);
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
                log.Info("GetDesignations-Elapsed" + stopwatch.Elapsed);
            }
        }

        [HttpGet]
        [Authorization]
        public JsonResult DeleteDesignation(int Val)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered DeleteDesignation method ");

                HttpResponseMessage response = WebAPI.Delete("designation/Id", Val.ToString());
                Status data = response.Content.ReadAsAsync<Status>().Result;
                if (data.Code == HttpStatusCode.OK)
                {
                    Status status = new Status("OK", null, null);
                    return Json(status, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(new { Valid = "true", Success = "false", Data = data.Errors }, JsonRequestBehavior.AllowGet);

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
                log.Info("DeleteDesignation-Elapsed" + stopwatch.Elapsed);
            }
        }

        [HttpPost]
        [Authorization]
        public JsonResult EditDesignation(DesignationMODEL model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered EditDesignation method");

                if (string.IsNullOrWhiteSpace(model.Designation))
                    ModelState.AddModelError("Designation", "Designation is required");

                if (!ModelState.IsValid)
                {
                    var errorModel = ModelState.GetModelErrors();
                    string Json = "{\"Valid\":\"false\",\"Data\":" + JsonConvert.SerializeObject(errorModel) + "}";
                    return new JsonResult { Data = Json };
                }
                Status status = WebAPI.Put<Status>("designation", model.DesignationId.ToString(), model);

                if (status.Text.ToLower() == "ok")
                    return Json(new { Valid = "true", Success = "true", Data = "Designation updated successfully" }, JsonRequestBehavior.AllowGet);
                else return Json(new { Valid = "true", Success = "false", Data = status.Errors }, JsonRequestBehavior.AllowGet);
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
                log.Info("EditDesignation-Elapsed" + stopwatch.Elapsed);
            }
        }

        [HttpPost]
        [Authorization]
        public JsonResult SaveDesignation(DesignationDto model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered SaveDesignation method");

                if (model == null) return BadPayload();

                if (string.IsNullOrWhiteSpace(model.Designation))
                    ModelState.AddModelError("Designation", "Designation is required");

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.GetModelErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Json(badstatus, JsonRequestBehavior.AllowGet);
                }

                Status data = WebAPI.Post<Status>("designation", model);

                if (data.Code == HttpStatusCode.OK)
                {
                    return Json(data, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    //return Json(data, JsonRequestBehavior.AllowGet);
                    return Json(new { Valid = "true", Success = "true", Data = data.Errors }, JsonRequestBehavior.AllowGet);
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
                log.Info("SaveDesignation-Elapsed" + stopwatch.Elapsed);
            }
        }

        #endregion

        #region Logs
        [Authorization]
        public ActionResult Logs()
        {
            ViewBag.ToDay = Utility.GetIndianTime().ToString("MM/dd/yyyy");
            return View();
        }

        [HttpPost]
        public ActionResult GetLogdata(DateTime Date, string html, string logType)
        {
            DateTime date = Date; string sFilePath = "";

            if (logType == "1")
            {
                sFilePath = Server.MapPath("../logs/") + "Attendance2_" + date.ToString("ddMMMyyyy") + ".txt"; ;
            }
            else if (logType == "2")
            {
                sFilePath = ConfigurationManager.AppSettings["APILogPath"].ToString() + "Attendance.API_" + date.ToString("ddMMMyyyy") + ".txt";
            }

            if (System.IO.File.Exists(sFilePath))
            {
                html = System.IO.File.ReadAllText(sFilePath);
            }

            if (html == null) html = "No logs found";

            return Content(html);
        }

        #endregion

    }
}