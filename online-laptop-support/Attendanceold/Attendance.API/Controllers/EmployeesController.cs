
using Attendance.API.RequestObjects;
using Attendance.DAL;
using Attendance.Model;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Attendance.API.Controllers
{
    [RoutePrefix("v1/employees")]
    public class EmployeesController : BaseController
    {
        [Route(""), HttpGet]
        public HttpResponseMessage Employees()
        {
            try
            {
                EmployeesDAL _employeesDAL = new EmployeesDAL();
                List<EmployeesDto> res = _employeesDAL.Employees();
                Status status = new Status("OK", null, (res != null) ? res : new List<EmployeesDto>());
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }

        }

        [Route(""), HttpPost]
        public HttpResponseMessage CreateEmployee(EmployeesDto model)
        {
            try
            {
                if (model == null) return BadPayload();

                if (string.IsNullOrWhiteSpace(model.FirstName))
                    ModelState.AddModelError("FirstName", "First name is required");
                else
                {
                    if ((System.Text.RegularExpressions.Regex.IsMatch(model.FirstName, @"[!/<>*%^`~'@#$^&*()+={}[]|\/?]")))
                        ModelState.AddModelError("FirstName", "Enter valid first name");
                }

                if (string.IsNullOrWhiteSpace(model.LastName))
                    ModelState.AddModelError("LastName", "Last name is required");
                else
                {
                    if ((System.Text.RegularExpressions.Regex.IsMatch(model.LastName, @"[!/<>*%^`~'@#$^&*()+={}[]|\/?]")))
                        ModelState.AddModelError("LastName", "Enter valid last name");
                }

                if (model.DepartmentID < 0)
                    ModelState.AddModelError("Department", "Department is required");

                if (model.DesignationID < 0)
                    ModelState.AddModelError("Designation", "Designation is required");

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

                if (!(model.Gender != 0))
                    ModelState.AddModelError("Gender", "Gender is required");

                if (model.DOB == null)
                    ModelState.AddModelError("DateOfBirth", "Date of birth is required");
                else if (model.DOB > DateTime.Now)
                    ModelState.AddModelError("DateOfBirth", "Date of birth should less than current date");

                if (model.UserID == null)
                    ModelState.AddModelError("UserName", "UserName is required");

                if (model.Password == null)
                    ModelState.AddModelError("Password", "Password is required");

                Status status = new Status("OK");
                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                EmployeesDAL _employeesDAL = new EmployeesDAL();
                int res = _employeesDAL.SaveEmployee(model);
                //if (res == -1) error.Add("Employee already exists");
                //else if (res == 0) error.Add("Employee not inserted");

                List<string> error = new List<string>();
                if (res == -1) error.Add("Employee already exists");
                else if (res == 0) error.Add("Employee not inserted");
                if (error.Count > 0)
                {
                    status = new Status("BadRequest", error);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                model.EmployeeID = res;

                status = new Status("OK", null, model);
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }
        }

        [Route("{employeeId}"), HttpPut]
        public HttpResponseMessage UpdateEmployee(int employeeId, EmployeesDto model)
        {
            try
            {
                if (model == null) return BadPayload();
                if (!(employeeId > 0))
                    ModelState.AddModelError("EmployeeId", "EmployeeId is required");
                else model.EmployeeID = employeeId;
                if (model.DepartmentID < 0)
                    ModelState.AddModelError("Department", "Department is required");
                if (model.DesignationID < 0)
                    ModelState.AddModelError("Designation", "Designation is required");
                if (!(string.IsNullOrWhiteSpace(model.Email)))
                    if (!System.Text.RegularExpressions.Regex.IsMatch(model.Email, @"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"))
                        ModelState.AddModelError("WorkEmail", "Enter valid WorkEmail");
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
                if (!(model.Gender != 0))
                    ModelState.AddModelError("Gender", "Gender is required");
                if (model.DOB == null)
                    ModelState.AddModelError("DateOfBirth", "Date of birth is required");
                else if (model.DOB > DateTime.Now)
                    ModelState.AddModelError("DateOfBirth", "Date of birth should less than current date");

                Status status;
                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }
                EmployeesDAL _employeesDAL = new EmployeesDAL();
                int res = _employeesDAL.UpdateEmployee(model);

                List<string> error = new List<string>();
                if (res == -1) error.Add("Employee already exists");
                else if (res == 0) error.Add("Employee not updated");
                if (error.Count > 0)
                {
                    status = new Status("BadRequest", error);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }
                //model.EmployeeID = res;

                status = new Status("OK", null, model);
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }
        }

        [Route("{employeeId}"), HttpGet]
        public HttpResponseMessage EmployeeById(int employeeId)
        {
            try
            {
                EmployeesDAL _EmployeesDAL = new EmployeesDAL();
                if (!(employeeId >= 0))
                    ModelState.AddModelError("EmployeeId", "EmployeeId is required");
                EmployeesDto res = _EmployeesDAL.EmployeeById(employeeId);
                Status status = new Status("OK", null, (res != null) ? res : new EmployeesDto());
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }

        }


        [Route("status/{isActive}"), HttpGet]
        public HttpResponseMessage EmployeesByStatus(bool isActive)
        {

            try
            {
                EmployeesDAL _EmployeesDAL = new EmployeesDAL();
                List<EmployeesDto> res = _EmployeesDAL.EmployeesByStatus(isActive);
                Status status = new Status("OK", null, (res != null) ? res : new List<EmployeesDto>());
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }

        }

        [Route("{employeeId}"), HttpDelete]
        public HttpResponseMessage DeleteEmployee(int employeeId)
        {
            try
            {
                if (!(employeeId >= 0))
                    ModelState.AddModelError("EmployeeId", "Enter valid patientId");

                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, badstatus, _jsonMediaTypeFormatter);
                }
                EmployeesDAL _EmployeesDAL = new EmployeesDAL();

                int res = _EmployeesDAL.DeleteEmployee(employeeId);
                if (res <= 0)
                {
                    ModelState.AddModelError("EmployeeId", "This status can't change, it has active orders");
                    if (!ModelState.IsValid)
                    {
                        List<string> errors = GetModelStateErrors();
                        Status badstatus = new Status("BadRequest", errors);
                        return Request.CreateResponse(HttpStatusCode.BadRequest, badstatus, _jsonMediaTypeFormatter);
                    }
                }

                Status status = new Status("OK");
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }

        }

        [Route("Attendance"), HttpPost]
        public HttpResponseMessage Attendance(AttendanceRequest model)
        {
            try
            {
                //if (model.CurrentDateTime == null)
                //    ModelState.AddModelError("CurrentDateTime", " Date is required");

                //if (!ModelState.IsValid)
                //{
                //    List<string> errors = GetModelStateErrors();
                //    Status badstatus = new Status("BadRequest", errors);
                //    return Request.CreateResponse(HttpStatusCode.BadRequest, badstatus, _jsonMediaTypeFormatter);
                //}

                EmployeesDAL _EmployeesDAL = new EmployeesDAL();
                //model.CurrentDateTime = new DateTime();
                DataTable res = _EmployeesDAL.DailyAttendance(Convert.ToDateTime(model.CurrentDateTime));
                Status status = new Status("OK", null, JsonConvert.SerializeObject(res));
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }
        }

        [Route("SaveAttendance"), HttpPost]
        public HttpResponseMessage SaveAttendance(AttendanceList2 model)
        {

            try
            {
                Status status;
                EmployeesDAL _EmployeesDAL = new EmployeesDAL();

                int res = _EmployeesDAL.SaveAttendance(model);
                List<string> error = new List<string>();
                if (res == -1) error.Add("Employee not inserted");

                if (error.Count > 0)
                {
                    status = new Status("BadRequest", error);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                status = new Status("OK", null, JsonConvert.SerializeObject(res));
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);

            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }

        }

        [Route("Check/{EmployeeId}"), HttpGet]
        public HttpResponseMessage GetCheckInTime(int EmployeeId)
        {
            try
            {
                EmployeesDAL _EmployeesDAL = new EmployeesDAL();
                if (EmployeeId < 0)
                    ModelState.AddModelError("EmployeeId", "EmployeeId is required");
                List<AttendanceDto> res = _EmployeesDAL.GetEmployeeAttendanceDetails(EmployeeId, Utility.GetIndianTime());
                Status status = new Status("OK", null, (res != null) ? res : new List<AttendanceDto>());
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }

        }

        [Route("TimeInsert"), HttpPost]
        public HttpResponseMessage InsertTime(AttendanceDto model)
        {
            try
            {
                if (model == null) return BadPayload();

                if (model.EmployeeID < 0)
                    ModelState.AddModelError("EmployeeId", "Employee Id is required");

                if (model.CreatedBy == null)
                    ModelState.AddModelError("CreatedBy", "CreatedBy is required");

                Status status;
                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                EmployeesDAL _employeesDAL = new EmployeesDAL();

                _employeesDAL.SaveEmployeeAttendance(model, Utility.GetIndianTime());

                status = new Status("OK", null, model);
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }
        }

        [Route("UpdateTime/{employeeId}"), HttpPut]
        public HttpResponseMessage UpdateTime(int employeeId, AttendanceDto model)
        {
            try
            {
                if (model == null) return BadPayload();
                model.EmployeeID = employeeId;
                if (model.EmployeeID < 0)
                    ModelState.AddModelError("EmployeeId", "EmployeeId is required");
                else model.EmployeeID = model.EmployeeID;

                if (model.OutTime == null)
                    ModelState.AddModelError("OutTime", "OutTime is required");


                Status status;
                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                EmployeesDAL _employeeDAL = new EmployeesDAL();
                int res = _employeeDAL.SaveEmployeeCheckOutTime(model.EmployeeID, model.OutTime.ToString(), model.CurrentDateTime.ToString(), Utility.GetIndianTime());

                List<string> error = new List<string>();

                if (error.Count > 0)
                {
                    status = new Status("BadRequest", error);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                status = new Status("OK", null, "CheckOutTime has been Updated successfully");

                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }
        }

        [Route("CheckOut/{EmployeeId}"), HttpGet]
        public HttpResponseMessage GetCheckOutTime(int EmployeeId)
        {
            try
            {
                EmployeesDAL _EmployeesDAL = new EmployeesDAL();

                List<AttendanceDto> res = _EmployeesDAL.GetCheckOutTime(EmployeeId, Utility.GetIndianTime());
                Status status = new Status("OK", null, (res != null) ? res : new List<AttendanceDto>());
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }

        }

        [Route("Anniversay/{dtCurrentDateTime}"), HttpGet]
        public HttpResponseMessage GetAnniversary(string dtCurrentDateTime)
        {
            try
            {
                EmployeesDAL _employeesDAL = new EmployeesDAL();
                List<AnniversaryDto> res = _employeesDAL.GetAnniversary(dtCurrentDateTime);
                Status status = new Status("OK", null, (res != null) ? res : new List<AnniversaryDto>());
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
