using Attendance.DAL;
using Attendance.Model;
using log4net;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Net;
using System.Net.Http;
using System.Reflection;
using System.Web.Http;

namespace Attendance.API.Controllers
{
    [TokenAuthentication]
    [RoutePrefix("v1/department")]
    public class DepartmentController : BaseController
    {
        private static readonly ILog log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        [Route("{val}"), HttpGet]
        public HttpResponseMessage GetDetails(bool val)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("GetDetails Started");
                DepartmentsDAL _departmentDAL = new DepartmentsDAL();
                log.Info("Entereed into departmentDAL");
                List<DepartmentDto> res = _departmentDAL.GetDetails(val);
                log.Info("Getting data from departmentDAL");
                Status status = new Status("OK", null, (res != null) ? res : new List<DepartmentDto>());
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
                log.Info("Time elapsed : " + stopwatch.Elapsed);
            }
        }

        [Route(""), HttpPost]
        public HttpResponseMessage Insert(DepartmentDto Model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Insert Started");
                if (Model == null) return BadPayload();
                if (string.IsNullOrWhiteSpace(Model.Department))
                    ModelState.AddModelError("DepartmentName", "Department name is required");
                else
                {
                    if ((System.Text.RegularExpressions.Regex.IsMatch(Model.Department, @"[!/<>*%^`~'@#$^&*()+={}[]|\/?]")))
                        ModelState.AddModelError("DepartmentName", "Enter valid department name");
                }
                Status status;
                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    log.Debug("Errors:" + string.Join(",", errors));
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                DepartmentsDAL _departmentDAL = new DepartmentsDAL();
                log.Info("Entered into departmentDAL");
                int res = _departmentDAL.Insert(Model);

                log.Info("Getting data from departmentDAL");

                List<string> error = new List<string>();
                if (res == -1) error.Add("Department already exists");
                else if (res == 0) error.Add("Department not inserted");
                if (error.Count > 0)
                {   
                    status = new Status("BadRequest", error[0]);
                    log.Debug($"Errors:{error[0]}");
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }
                status = new Status("OK", null, "Department has been saved successfully");
               
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
                log.Info("Time elapsed : " + stopwatch.Elapsed);
            }
        }

        [Route("{departmentId}"), HttpPut]
        public HttpResponseMessage Update(int departmentId, DepartmentDto model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Update Started");
                if (model == null) return BadPayload();

                if (model.DepartmentId < 0)
                    ModelState.AddModelError("DepartmentId", "DepartmentId is required");
                else model.DepartmentId =model. DepartmentId;

                if (string.IsNullOrWhiteSpace(model.Department))
                    ModelState.AddModelError("DepartmentName", "Department name is required");
                else
                {
                    if ((System.Text.RegularExpressions.Regex.IsMatch(model.Department, @"[!/<>*%^`~'@#$^&*()+={}[]|\/?]")))
                        ModelState.AddModelError("DepartmentName", "Enter valid department name");
                }

                Status status;
                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    log.Debug("Errors:" + string.Join(",", errors));
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                DepartmentsDAL _departmentDAL = new DepartmentsDAL();
                log.Info("Entereed into departmentDAL");
                int res = _departmentDAL.Update(model.DepartmentId,model.Department,model.IsActive);
                log.Info("Getting data from departmentDAL");
                List<string> error = new List<string>();
                if (res == -1) error.Add("Department already exists");
                else if (res == 0) error.Add("Department not Updated");
                if (error.Count > 0)
                {
                    status = new Status("BadRequest", error[0]);
                    log.Debug($"Errors:{error[0]}");
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }
                status = new Status("OK", null, "Department has been Updated successfully");

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
                log.Info("Time elapsed : " + stopwatch.Elapsed);
            }
        }

        [Route("Id/{departmentId}"), HttpDelete]
        public HttpResponseMessage DeleteEmployee(int departmentId)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("DeleteEmployee Started");
                if (departmentId < 0)
                    ModelState.AddModelError("DepartmentId", "Enter valid departmentId");

                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    log.Debug("Errors:" + string.Join(",", errors));
                    Status badstatus = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, badstatus, _jsonMediaTypeFormatter);
                }
                DepartmentsDAL _departmentDAL = new DepartmentsDAL();
                log.Info("Entered into departmentDAL");
                int res = _departmentDAL.Delete(departmentId);
                log.Info("Getting data from departmentDAL");

                if (res <= 0)
                {
                    ModelState.AddModelError("DepartmentId", " Department has active employees ");
                    if (!ModelState.IsValid)
                    {
                        List<string> errors = GetModelStateErrors();
                        log.Debug($"Errors:{errors}");
                        Status badstatus = new Status("BadRequest", errors[0]);
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
                log.Info("Time elapsed : " + stopwatch.Elapsed);
            }
        }
    }
}
