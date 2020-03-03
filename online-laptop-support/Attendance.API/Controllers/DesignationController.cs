using Attendance.DAL;
using Attendance.Model;
using log4net;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Attendance.API.Controllers
{
    [TokenAuthentication]
    [RoutePrefix("v1/designation")]
    public class DesignationController : BaseController
    {
        private static readonly ILog log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        [Route("{val}"), HttpGet]
        public HttpResponseMessage GetDetails(bool val)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("GetDetails Started");
                DesignationsDAL _designationDAL = new DesignationsDAL();
                log.Info("Entereed into designationDAL");
                List<DesignationDto> res = _designationDAL.GetDetails(val);
                log.Info("Getting data from designationDAL");
                Status status = new Status("OK", null, (res != null) ? res : new List<DesignationDto>());
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
        public HttpResponseMessage Insert(DesignationDto Model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Insert Started");
                if (Model == null) return BadPayload();

                if (string.IsNullOrWhiteSpace(Model.Designation))
                    ModelState.AddModelError("DesignationName", "Designation name is required");
                else
                {
                    if ((System.Text.RegularExpressions.Regex.IsMatch(Model.Designation, @"[!/<>*%^`~'@#$^&*()+={}[]|\/?]")))
                        ModelState.AddModelError("DesignationName", "Enter valid designation name");
                }

                Status status = new Status("OK");
                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    log.Debug("Errors:" + string.Join(",", errors));
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                DesignationsDAL _designationDAL = new DesignationsDAL();
                log.Info("Entered into departmentDAL");
                int res = _designationDAL.Insert(Model);
                log.Info("Getting data from departmentDAL");
                List<string> error = new List<string>();
                if (res == -1) error.Add("Designation already exists");
                else if (res == 0) error.Add("Designation not inserted");
                if (error.Count > 0)
                {
                    status = new Status("BadRequest", error[0]);
                    log.Debug($"Errors:{error[0]}");
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                status = new Status("OK", null, "Designation has been saved successfully");

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

        [Route("{designationId}"), HttpPut]
        public HttpResponseMessage Update( int DesignationID,DesignationDto model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Update Started");
                if (model == null) return BadPayload();

                if (!(DesignationID > 0))
                    ModelState.AddModelError("DesignationId", "DesignationId is required");
                else model.DesignationID = model.DesignationID;

                if (string.IsNullOrWhiteSpace(model.Designation))
                    ModelState.AddModelError("DesignationName", "Designation name is required");
                else
                {
                    if ((System.Text.RegularExpressions.Regex.IsMatch(model.Designation, @"[!/<>*%^`~'@#$^&*()+={}[]|\/?]")))
                        ModelState.AddModelError("DepartmentName", "Enter valid department name");
                }
                Status status = new Status("OK");
                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    log.Debug("Errors:" + string.Join(",", errors));
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                DesignationsDAL _designationDAL = new DesignationsDAL();
                log.Info("Entered into designationDAL");
                int res = _designationDAL.Update(model);
                log.Info("Getting data from designationDAL");

                List<string> error = new List<string>();
                if (res == -1) error.Add("Designation already exists");
                else if (res == 0) error.Add("Designation not Up[dated");
                if (error.Count > 0)
                {
                    status = new Status("BadRequest", error[0]);
                    log.Debug($"Errors:{error[0]}");
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                status = new Status("OK", null, "Designation has been Updated successfully");

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

        [Route("status/{activeValue}"), HttpGet]
        public HttpResponseMessage GetDetailsByActive(int activeValue)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("GetDetailsByActive Started");
                DesignationsDAL _designationDAL = new DesignationsDAL();
                log.Info("Entered into designationDAL");
                List<DesignationDto> res = _designationDAL.GetByActive(activeValue);
                log.Info("Getting data from designationDAL");
                Status status = new Status("OK", null, (res != null) ? res : new List<DesignationDto>());
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

        [Route("Id/{designationId}"), HttpDelete]
        public HttpResponseMessage DeleteEmployee(int designationId)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("DeleteEmployee Started");
                if (!(designationId >= 0))
                    ModelState.AddModelError("DesignationId", "Enter valid designationId");

                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    log.Debug("Errors:" + string.Join(",", errors));
                    Status badstatus = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, badstatus, _jsonMediaTypeFormatter);
                }
                DesignationsDAL _designationDAL = new DesignationsDAL();
                log.Info("Entered into designationDAL");
                int res = _designationDAL.Delete(designationId);
                log.Info("Getting data from designationDAL");
                if (res <= 0)
                {
                    ModelState.AddModelError("DesignationId","Designation has active employees ");
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
