using Attendance.Attributes;
using Attendance.Model;
using Attendance.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
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
    [Authorization]
    public class AdminController : BaseController
    {
        readonly WebInstance WebAPI = new WebInstance(MvcApplication.APIBaseUrl);

        public ActionResult Reset()
        {
            return View();
        }

        [HttpPost]
        public JsonResult ResetPassword(EmployeesDto model)
        {
            try
            {
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
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Json(status, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult Attendance()
        {
            ViewBag.ToDay=Utility.GetIndianTime().ToString("MM/dd/yyyy");
            return View();
        }

        public JsonResult AttendanceDetails(Attendance.Models.Attendance model)
        {
            Status status = WebAPI.Post<Status>("employees/Attendance/", model);

            List<AttendanceDto> response = (status.Text.ToLower() == "ok") ? JsonConvert.DeserializeObject<List<AttendanceDto>>(status.Data.ToString()) : new List<AttendanceDto>();

            return Json(response, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult SaveAttendanceDetails(AttendanceList model)
        {

            Status status = WebAPI.Post<Status>("employees/SaveAttendance", model);
            if (status.Text == "OK")
            {
                return Json(new { Valid = "true", Success = "true", Data = "Saved Successfully" }, JsonRequestBehavior.AllowGet);
            }
            return Json(model, JsonRequestBehavior.AllowGet);
        }

        #region Employee
        public ActionResult Employee()
        {
            return View();
        }

        public ActionResult AddEmployee()
        {
            return View();
        }

        [HttpPost]
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
            Status status = WebAPI.Get<Status>("employees/status/" + Active);

            List<EmployeesDto> model = (status.Text.ToLower() == "ok") ? JsonConvert.DeserializeObject<List<EmployeesDto>>(status.Data.ToString()) : new List<EmployeesDto>();

            return Json(model, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult SaveEmployees(Employees model)
        {
            try
            {
                if (model == null) return BadPayload();
                HttpPostedFileBase fileupload;

                if (model.MaritalStatus && model.DOA == null)
                    ModelState.AddModelError("DOA", "DOA is required");

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
                    return Json(data, JsonRequestBehavior.AllowGet);
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
        public JsonResult UpdateEmployee(Employees model)
        {
            try
            {
                if (model == null) return BadPayload();
                HttpPostedFileBase fileupload;

                if (model.MaritalStatus)
                    if (model.DOA == null)
                        ModelState.AddModelError("DOA", "DOA is required");

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
                    return Json(status, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(status, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Json(status, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public JsonResult DeleteEmp(int id)
        {
            try
            {
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
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Json(status, JsonRequestBehavior.AllowGet);
            }
        }

        #endregion

        #region Departments

        public ActionResult Departments()
        {
            return View();
        }

        [HttpGet]
        public JsonResult GetDepartments(string Active)
        {
            Status status = WebAPI.Get<Status>("department", Active);

            List<DepartmentDto> model = (status.Text.ToLower() == "ok") ? JsonConvert.DeserializeObject<List<DepartmentDto>>(status.Data.ToString()) : new List<DepartmentDto>();

            return Json(model, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult EditDepartment(DeptMODEL model)
        {
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
        [HttpPost]
        public JsonResult SaveDepartment(DeptMODEL model)
        {

            if (model == null) return BadPayload();

            if (string.IsNullOrWhiteSpace(model.Department))
                ModelState.AddModelError("Department", "Department is required");

            if (!ModelState.IsValid)
            {
                var errorModel = ModelState.GetModelErrors();
                string Json = "{\"Valid\":\"false\",\"Data\":" + JsonConvert.SerializeObject(errorModel) + "}";
                return new JsonResult { Data = Json };
            }

            Status status = WebAPI.Post<Status>("department", model);

            if (status.Text.ToLower() == "ok")
                return Json(new { Valid = "true", Success = "true", Data = "Department added successfully" }, JsonRequestBehavior.AllowGet);
            else return Json(new { Valid = "true", Success = "false", Data = status.Errors }, JsonRequestBehavior.AllowGet);

        }

        [HttpGet]
        public JsonResult DeleteDepartment(int Val)
        {
            HttpResponseMessage response = WebAPI.Delete("department/Id", Val.ToString());
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

        #endregion

        #region Designations

        public ActionResult Designations()
        {
            return View();
        }
       
        [HttpGet]
        public JsonResult GetDesignations(string Active)
        {
            Status status = WebAPI.Get<Status>("designation", Active);

            List<DesignationDto> model = (status.Text.ToLower() == "ok") ? JsonConvert.DeserializeObject<List<DesignationDto>>(status.Data.ToString()) : new List<DesignationDto>();

            return Json(model, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult DeleteDesignation(int Val)
        {
            HttpResponseMessage response = WebAPI.Delete("designation/Id", Val.ToString());
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

        [HttpPost]
        public JsonResult EditDesignation(DesignationMODEL model)
        {
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

        [HttpPost]
        public JsonResult SaveDesignation(DesignationDto model)
        {
            if (model == null) return BadPayload();

            if (string.IsNullOrWhiteSpace(model.Designation))
                ModelState.AddModelError("Designation", "Designation is required");

            if (!ModelState.IsValid)
            {
                var errorModel = ModelState.GetModelErrors();
                string Json = "{\"Valid\":\"false\",\"Data\":" + JsonConvert.SerializeObject(errorModel) + "}";
                return new JsonResult { Data = Json };
            }

            Status status = WebAPI.Post<Status>("designation", model);

            if (status.Text.ToLower() == "ok")
                return Json(new { Valid = "true", Success = "true", Data = "Designation added successfully" }, JsonRequestBehavior.AllowGet);
            else return Json(new { Valid = "true", Success = "false", Data = status.Errors }, JsonRequestBehavior.AllowGet);

        }

        #endregion

    }

}
