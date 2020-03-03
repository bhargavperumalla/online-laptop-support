using Attendance.API.RequestObjects;
using Attendance.DAL;
using Attendance.Model;
using log4net;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Attendance.API.Controllers
{
    [TokenAuthentication]
    [RoutePrefix("v1/employees")]
    public class EmployeesController : BaseController
    {
        private static readonly ILog log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        [Route(""), HttpGet]
        public HttpResponseMessage Employees()
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered Employees method");
                EmployeesDAL _employeesDAL = new EmployeesDAL();
                log.Info("Getting employees from database");
                List<EmployeesDto> res = _employeesDAL.Employees();
                log.Info("Getting employees from database completed. Returning the status object");
                Status status = new Status("OK", null, (res != null) ? res : new List<EmployeesDto>());
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
                log.Info("Employees method Elapsed - " + stopwatch.Elapsed);
            }
        }

        [Route(""), HttpPost]
        public HttpResponseMessage CreateEmployee(EmployeesDto model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered CreateEmployee method");
                if (model == null) return BadPayload();

                if (string.IsNullOrWhiteSpace(model.FirstName))
                    ModelState.AddModelError("FirstName", "First name is required");


                if (string.IsNullOrWhiteSpace(model.LastName))
                    ModelState.AddModelError("LastName", "Last name is required");


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


                if (model.DOB > DateTime.Now)
                    ModelState.AddModelError("DOB", "Date of birth should less than current date");

                if (model.DOJ > DateTime.Now)
                    ModelState.AddModelError("DOJ", "Date of joining should less than current date");

                if (model.DOA > DateTime.Now)
                    ModelState.AddModelError("DOA", "Date of anniversary should less than current date");

                if (model.UserID == null)
                    ModelState.AddModelError("UserName", "UserName is required");

                if (model.Password == null)
                    ModelState.AddModelError("Password", "Password is required");

                Status status = new Status("OK");
                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    log.Debug("Errors:" + string.Join(",", errors));
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                EmployeesDAL _employeesDAL = new EmployeesDAL();
                log.Info("Creating employees in database");
                int res = _employeesDAL.SaveEmployee(model);
                log.Info("Creating employees in database completed. Returning the status object");
                string error = string.Empty;
                if (res == 2) error = "Employee Id already exists";
                else if (res == 3) error = "Biometric Id already exists";
                else if (res == -1) error = "Employee already exists";

                if (!string.IsNullOrEmpty(error))
                {
                    log.Debug($"Errors:{error}");
                    status = new Status("BadRequest", error);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                model.EmployeeID = res;
                status = new Status("OK", null, model);
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
                log.Info("CreateEmployee method Elapsed - " + stopwatch.Elapsed);
            }
        }

        [Route("{employeeId}"), HttpPut]
        public HttpResponseMessage UpdateEmployee(int employeeId, EmployeesDto model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered UpdateEmployee method");
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

                if (model.DOB > DateTime.Now)
                    ModelState.AddModelError("DOB", "Date of birth should less than current date");

                if (model.DOJ > DateTime.Now)
                    ModelState.AddModelError("DOJ", "Date of joining should less than current date");

                if (model.DOA > DateTime.Now)
                    ModelState.AddModelError("DOA", "Date of anniversary should less than current date");

                Status status;
                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    log.Debug("Errors:" + string.Join(",", errors));
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }
                EmployeesDAL _employeesDAL = new EmployeesDAL();
                log.Info("Updating employees in database");
                int res = _employeesDAL.UpdateEmployee(model);
                log.Info("Updating employees in database completed. Returning the status object");
                string error = string.Empty;
                if (res == -1) error = "Employee already exists";
                else if (res == 0) error = "Employee not updated";
                if (!string.IsNullOrEmpty(error))
                {
                    log.Debug($"Errors:{error}");
                    status = new Status("BadRequest", error);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }
                status = new Status("OK", null, model);
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
                log.Info("UpdateEmployee method Elapsed - " + stopwatch.Elapsed);
            }

        }

        [Route("{employeeId}"), HttpGet]
        public HttpResponseMessage EmployeeById(int employeeId)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered EmployeeById method");

                if (!(employeeId >= 0))
                    ModelState.AddModelError("EmployeeId", "EmployeeId is required");

                if (!ModelState.IsValid)
                {
                    Status status1;
                    List<string> errors = GetModelStateErrors();
                    log.Debug("Errors:" + string.Join(",", errors));
                    status1 = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status1, _jsonMediaTypeFormatter);
                }
                EmployeesDAL _EmployeesDAL = new EmployeesDAL();
                log.Info("Getting employees by employeeId from database ");
                EmployeesDto res = _EmployeesDAL.EmployeeById(employeeId);
                log.Info("Getting employees by employeeId from database completed. Returning the status object");
                Status status = new Status("OK", null, (res != null) ? res : new EmployeesDto());
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
                log.Info("EmployeeById method Elapsed - " + stopwatch.Elapsed);
            }


        }


        [Route("status/{isActive}"), HttpGet]
        public HttpResponseMessage EmployeesByStatus(bool isActive)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered EmployeesByStatus method");
                EmployeesDAL _EmployeesDAL = new EmployeesDAL();
                log.Info("Getting employees by status from database ");
                List<EmployeesDto> res = _EmployeesDAL.EmployeesByStatus(isActive);
                log.Info("Getting employees  by status from database  completed. Returning the status object");
                Status status = new Status("OK", null, (res != null) ? res : new List<EmployeesDto>());
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
                log.Info("EmployeesByStatus method Elapsed - " + stopwatch.Elapsed);
            }

        }

        [Route("{employeeId}"), HttpDelete]
        public HttpResponseMessage DeleteEmployee(int employeeId)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {

                log.Info("Entered DeleteEmployee method");
                if (!(employeeId >= 0))
                    ModelState.AddModelError("EmployeeId", "Enter valid EmployeeId");

                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    log.Debug("Errors:" + string.Join(",", errors));
                    Status badstatus = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, badstatus, _jsonMediaTypeFormatter);
                }
                EmployeesDAL _EmployeesDAL = new EmployeesDAL();
                log.Info("Deleting employees by employeeId from database");
                int res = _EmployeesDAL.DeleteEmployee(employeeId);
                log.Info("Deleting employees by employeeId from database  by using employeeId completed. Returning the status object");
                if (res <= 0)
                {
                    ModelState.AddModelError("EmployeeId", "This status can't change, it has active orders");
                    if (!ModelState.IsValid)
                    {
                        List<string> errors = GetModelStateErrors();
                        log.Debug("Errors:" + string.Join(",", errors));
                        Status badstatus = new Status("BadRequest", errors);
                        return Request.CreateResponse(HttpStatusCode.BadRequest, badstatus, _jsonMediaTypeFormatter);
                    }
                }

                Status status = new Status("OK");
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
                log.Info("DeleteEmployee method Elapsed - " + stopwatch.Elapsed);
            }


        }

        [Route("Attendance"), HttpPost]
        public HttpResponseMessage Attendance(AttendanceRequest model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered Attendance method");
                EmployeesDAL _EmployeesDAL = new EmployeesDAL();
                log.Info("Getting attendance from database");
                DataTable res = _EmployeesDAL.DailyAttendance(Convert.ToDateTime(model.CurrentDateTime));
                log.Info("Getting attendance from database completed. Returning the status object");
                Status status = new Status("OK", null, JsonConvert.SerializeObject(res));
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
                log.Info("Attendance method Elapsed - " + stopwatch.Elapsed);
            }
        }

        [Route("SaveAttendance"), HttpPost]
        public HttpResponseMessage SaveAttendance(AttendanceList2 model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered SaveAttendance method");
                Status status;
                EmployeesDAL _EmployeesDAL = new EmployeesDAL();
                log.Info("Creating attendance in database");
                int res = _EmployeesDAL.SaveAttendance(model, Utility.GetIndianTime());
                log.Info("Creating attendance in database completed. Returning the status object");
                string error = string.Empty;
                if (res == -1) error = "Employee not inserted";

                if (!string.IsNullOrEmpty(error))
                {
                    log.Debug($"Errors:{error}");
                    status = new Status("BadRequest", error);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                status = new Status("OK", null, JsonConvert.SerializeObject(res));
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
                log.Info("SaveAttendance method Elapsed - " + stopwatch.Elapsed);
            }

        }

        [Route("Check/{EmployeeId}"), HttpGet]
        public HttpResponseMessage GetCheckInTime(int EmployeeId)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered GetCheckInTime method");
                if (EmployeeId < 0)
                    ModelState.AddModelError("EmployeeId", "EmployeeId is required");
                EmployeesDAL _EmployeesDAL = new EmployeesDAL();
                log.Info("Getting CheckInTime from database");
                List<AttendanceDto> res = _EmployeesDAL.GetEmployeeAttendanceDetails(EmployeeId, Utility.GetIndianTime());
                log.Info("Getting CheckInTime from database completed. Returning the status object");
                Status status = new Status("OK", null, (res != null) ? res : new List<AttendanceDto>());
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
                log.Info("GetCheckInTime method Elapsed - " + stopwatch.Elapsed);
            }

        }

        [Route("TimeInsert"), HttpPost]
        public HttpResponseMessage InsertTime(AttendanceDto model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered InsertTime method");
                if (model == null) return BadPayload();

                if (model.EmployeeID < 0)
                    ModelState.AddModelError("EmployeeId", "Employee Id is required");

                if (model.CreatedBy == null)
                    ModelState.AddModelError("CreatedBy", "CreatedBy is required");

                Status status;
                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    log.Debug("Errors:" + string.Join(",", errors));
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }
                log.Info("Inserting time into the database");
                EmployeesDAL _employeesDAL = new EmployeesDAL();
                log.Info("Inserting time into the database completed. Returning the status object");
                _employeesDAL.SaveEmployeeAttendance(model, Utility.GetIndianTime());

                status = new Status("OK", null, model);
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
                log.Info("InsertTime method Elapsed - " + stopwatch.Elapsed);
            }
        }

        [Route("UpdateTime/{employeeId}"), HttpPut]
        public HttpResponseMessage UpdateTime(int employeeId, AttendanceDto model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered UpdateTime method");
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
                    log.Debug("Errors:" + string.Join(",", errors));
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                EmployeesDAL _employeeDAL = new EmployeesDAL();
                log.Info("Updating checkout time into the database");
                int res = _employeeDAL.SaveEmployeeCheckOutTime(model.EmployeeID, model.OutTime.ToString(), model.CurrentDateTime.ToString(), Utility.GetIndianTime());
                log.Info("Updating checkout time into the database completed. Returning the status object");
                status = new Status("OK", null, "CheckOutTime has been Updated successfully");
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
                log.Info("UpdateTime method Elapsed - " + stopwatch.Elapsed);
            }
        }

        [Route("checkOut/{employeeId}"), HttpGet]
        public HttpResponseMessage GetCheckOutTime(int employeeId)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered GetCheckOutTime method");
                EmployeesDAL _employeesDAL = new EmployeesDAL();

                log.Info("Getting checkout time from database");
                List<AttendanceDto> res = _employeesDAL.GetCheckOutTime(employeeId, Utility.GetIndianTime());

                log.Info("Getting checkout time from database completed. Returning the status object");
                Status status = new Status("OK", null, (res != null) ? res : new List<AttendanceDto>());

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
                log.Info("GetCheckOutTime method Elapsed - " + stopwatch.Elapsed);
            }

        }

        [Route("Anniversay/{dtCurrentDateTime}"), HttpGet]
        public HttpResponseMessage GetAnniversary(string dtCurrentDateTime)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered GetAnniversary method");
                EmployeesDAL _employeesDAL = new EmployeesDAL();
                log.Info("Getting Anniversary from database");
                List<AnniversaryDto> res = _employeesDAL.GetAnniversary(dtCurrentDateTime);
                log.Info("Getting Anniversary from database completed. Returning the status object");
                Status status = new Status("OK", null, (res != null) ? res : new List<AnniversaryDto>());
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
                log.Info("GetAnniversary method Elapsed - " + stopwatch.Elapsed);
            }

        }

    }

}
