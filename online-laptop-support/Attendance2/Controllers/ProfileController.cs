using Attendance.Attributes;
using Attendance.Model;
using Attendance.Models;
using log4net;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
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
    public class ProfileController : BaseController
    {
        readonly WebInstance WebAPI = new WebInstance(MvcApplication.APIBaseUrl);

        private static readonly ILog log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public ActionResult Index()
        {

            Status status = WebAPI.Get<Status>("employees/" + Session["EmployeeId"]);
            Employees model = (status.Text.ToLower() == "ok") ? JsonConvert.DeserializeObject<Employees>(status.Data.ToString()) : new Employees();

            if (model.DOA.HasValue && model.DOA.Value.ToString("dd/MM/yyyy") == "01/01/1900")
                model.DOA = null;
            if (model.DOJ.HasValue && model.DOJ.Value.ToString("dd/MM/yyyy") == "01/01/1900")
                model.DOJ = null;
            if (model.DOB.HasValue && model.DOB.Value.ToString("dd/MM/yyyy") == "01/01/1900")
                model.DOB = null;

            return View(model);
        }

        [HttpPost]
        public JsonResult UpdateProfile(Employees model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered UpdateProfile method");
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
                if (model.DepartmentID < 0)
                    ModelState.AddModelError("Department", "Department is required");
                if (model.DesignationID < 0)
                    ModelState.AddModelError("Designation", "Designation is required");
                if (!(string.IsNullOrWhiteSpace(model.Email)))
                    if (!System.Text.RegularExpressions.Regex.IsMatch(model.Email, @"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"))
                        ModelState.AddModelError("Email", "Enter valid WorkEmail");
                if (!(string.IsNullOrWhiteSpace(model.PersonalEmail)))
                    if (!System.Text.RegularExpressions.Regex.IsMatch(model.PersonalEmail, @"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"))
                        ModelState.AddModelError("PersonalEmail", "Enter valid PersonalEmail");
                if (string.IsNullOrWhiteSpace(model.Mobile))
                    ModelState.AddModelError("Mobile", "Mobile is required");
                if (!(string.IsNullOrWhiteSpace(model.Mobile)))
                {
                    model.Mobile = new string(model.Mobile.Where(char.IsDigit).ToArray());
                    if (!System.Text.RegularExpressions.Regex.IsMatch(model.Mobile, @"^[0-9]*$"))
                        ModelState.AddModelError("Mobile", "Enter a valid Mobile number");
                    else if (model.Mobile.Length != 10)
                        ModelState.AddModelError("Mobile", "Mobile number should be 10 digits");
                }
                if (model.DOB == null)
                    ModelState.AddModelError("DOB", "Date of birth is required");
                else if (model.DOB > DateTime.Now)
                    ModelState.AddModelError("DOB", "Date of birth should less than current date");

                if ((string.IsNullOrWhiteSpace(model.EmergencyContactNumber)))
                {
                    ModelState.AddModelError("EmergencyContactNumber", "Emergency contact Number is required");
                }

                if ((string.IsNullOrWhiteSpace(model.Email)))
                {
                    ModelState.AddModelError("Email", " Work Email is required");
                }

                if ((model.BloodGroup == "-1"))
                {
                    ModelState.AddModelError("BloodGroup", " Blood group is required");
                }
                if ((string.IsNullOrWhiteSpace(model.EmergencyContactPerson)))
                {
                    ModelState.AddModelError("EmergencyContactPerson", "Emergency contact person is required");
                }
                else if ((model.EmergencyContactPerson.Length > 50))
                {
                    ModelState.AddModelError("EmergencyContactPerson", " EmergencyContactPerson name should not exceed 50 characters ");
                }

                if ((string.IsNullOrWhiteSpace(model.EmergencyContactRelation)))
                {
                    ModelState.AddModelError("EmergencyContactRelation", "Emergency contact Relation is required");
                }
                else if ((model.EmergencyContactRelation.Length > 50))
                {
                    ModelState.AddModelError("EmergencyContactRelation", "EmergencyContact Relation should not exceed 50 characters ");
                }

                if (!(string.IsNullOrWhiteSpace(model.EmergencyContactNumber)))
                {
                    model.EmergencyContactNumber = new string(model.EmergencyContactNumber.Where(char.IsDigit).ToArray());
                    if (!System.Text.RegularExpressions.Regex.IsMatch(model.EmergencyContactNumber, @"^[0-9]*$"))
                        ModelState.AddModelError("EmergencyContactNumber", "Enter a valid Mobile number");
                    else if (model.EmergencyContactNumber.Length != 10)
                        ModelState.AddModelError("EmergencyContactNumber", "Mobile number should be 10 digits");
                }

                if (model.MaritalStatus)
                    if (model.DOA == null)
                        ModelState.AddModelError("DOA", "DOA is required");

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.GetModelErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Json(badstatus, JsonRequestBehavior.AllowGet);
                }

                Status status = WebAPI.Put<Status>("employees", Session["EmployeeId"].ToString(), model);

                if (status.Code == HttpStatusCode.OK)
                {
                    Session["IsProfileUpdated"] = true;
                    var Employeedetails = JsonConvert.DeserializeObject<EmployeesDto>(status.Data.ToString());
                    if (Employeedetails != null)
                    {
                        if (model.ProfilePic == null)
                        {
                            if (System.Web.HttpContext.Current.Request.Files.AllKeys.Any())
                            {
                                model.fileupload = Request.Files[0];

                                if (model.fileupload.ContentLength > 0)
                                {
                                    string filePath = Server.MapPath("~/Content/ProfilePics/");
                                    string[] files = Directory.GetFiles(filePath, Employeedetails.EmployeeID.ToString() + ".*");
                                    if (files != null) foreach (string f in files) { System.IO.File.Delete(f); }
                                    model.fileupload.SaveAs(filePath + Employeedetails.EmployeeID.ToString() + Path.GetExtension(model.fileupload.FileName));
                                    Session["ProfilePic"] = Utility.GetImagePath(Employeedetails.EmployeeID.ToString(), Convert.ToInt32(Employeedetails.Gender)) + "?t=" + DateTime.Now.Ticks;
                                }
                            }
                            Employeedetails.ProfilePic = Session["ProfilePic"].ToString();
                        }
                    }
                    status.Data = Employeedetails;
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
                log.Info(" UpdateProfile-Elapsed" + stopwatch.Elapsed);
            }
        }
    }
}