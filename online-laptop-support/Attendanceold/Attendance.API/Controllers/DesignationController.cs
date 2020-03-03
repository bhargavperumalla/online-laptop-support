using Attendance.DAL;
using Attendance.Model;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Attendance.API.Controllers
{
    [RoutePrefix("v1/designation")]
    public class DesignationController : BaseController
    {
        [Route("{val}"), HttpGet]
        public HttpResponseMessage GetDetails(bool val)
        {
            try
            {
                DesignationsDAL _designationDAL = new DesignationsDAL();
                List<DesignationDto> res = _designationDAL.GetDetails(val);
                Status status = new Status("OK", null, (res != null) ? res : new List<DesignationDto>());
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }

        }

        [Route(""), HttpPost]
        public HttpResponseMessage Insert(DesignationDto Model)
        {
            try
            {
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
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                DesignationsDAL _designationDAL = new DesignationsDAL();
                int res = _designationDAL.Insert(Model);

                List<string> error = new List<string>();
                if (res == -1) error.Add("Designation already exists");
                else if (res == 0) error.Add("Designation not inserted");
                if (error.Count > 0)
                {
                    status = new Status("BadRequest", error);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                status = new Status("OK", null, "Designation has been saved successfully");

                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }

        }

        [Route("{designationId}"), HttpPut]
        public HttpResponseMessage Update( int DesignationID,DesignationDto model)
        {
            try
            {
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
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                DesignationsDAL _designationDAL = new DesignationsDAL();
                int res = _designationDAL.Update(model);

                List<string> error = new List<string>();
                if (res == -1) error.Add("Designation already exists");
                else if (res == 0) error.Add("Designation not Up[dated");
                if (error.Count > 0)
                {
                    status = new Status("BadRequest", error);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                status = new Status("OK", null, "Designation has been Updated successfully");

                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }

        }

        //[Route("{designationId}"), HttpGet]
        //public HttpResponseMessage GetDetailsById(int designationId)
        //{
        //    try
        //    {
        //        DesignationsDAL _designationDAL = new DesignationsDAL();
        //        if (!(designationId >= 0))
        //            ModelState.AddModelError("DesignationId", "DesignationID is required");

        //        List<DesignationDto> res = _designationDAL.GetDetailsById(designationId);

        //        Status status = new Status("OK", null, (res != null) ? res : new List<DesignationDto>());

        //        return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
        //    }
        //    catch (Exception ex)
        //    {
        //        Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
        //    }

        //}

        [Route("status/{activeValue}"), HttpGet]
        public HttpResponseMessage GetDetailsByActive(int activeValue)
        {
            try
            {
                DesignationsDAL _designationDAL = new DesignationsDAL();

                List<DesignationDto> res = _designationDAL.GetByActive(activeValue);

                Status status = new Status("OK", null, (res != null) ? res : new List<DesignationDto>());
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }

        }

        [Route("Id/{designationId}"), HttpDelete]
        public HttpResponseMessage DeleteEmployee(int designationId)
        {
            try
            {
                if (!(designationId >= 0))
                    ModelState.AddModelError("DesignationId", "Enter valid designationId");

                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();

                    Status badstatus = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, badstatus, _jsonMediaTypeFormatter);
                }
                DesignationsDAL _designationDAL = new DesignationsDAL();

                int res = _designationDAL.Delete(designationId);

                if (res <= 0)
                {
                    ModelState.AddModelError("DesignationId", "This status can't change, it is active");
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

    }
}
