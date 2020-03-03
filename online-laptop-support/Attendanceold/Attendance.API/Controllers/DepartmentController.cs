using Attendance.DAL;
using Attendance.Model;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Attendance.API.Controllers
{
    [RoutePrefix("v1/department")]
    public class DepartmentController : BaseController
    {
        [Route("{val}"), HttpGet]
        public HttpResponseMessage GetDetails(bool val)
        {
            try
            {
                DepartmentsDAL _departmentDAL = new DepartmentsDAL();
                List<DepartmentDto> res = _departmentDAL.GetDetails(val);
                Status status = new Status("OK", null, (res != null) ? res : new List<DepartmentDto>());
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }
        }

        [Route(""), HttpPost]
        public HttpResponseMessage Insert(DepartmentDto Model)
        {
            try
            {
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
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                DepartmentsDAL _departmentDAL = new DepartmentsDAL();
                int res = _departmentDAL.Insert(Model);

                List<string> error = new List<string>();
                if (res == -1) error.Add("Department already exists");
                else if (res == 0) error.Add("Department not inserted");
                if (error.Count > 0)
                {
                    status = new Status("BadRequest", error);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }
                status = new Status("OK", null, "Department has been saved successfully");

                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }
        }

        [Route("{departmentId}"), HttpPut]
        public HttpResponseMessage Update(int departmentId, DepartmentDto model)
        {
           try
            {
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
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                DepartmentsDAL _departmentDAL = new DepartmentsDAL();
                int res = _departmentDAL.Update(model.DepartmentId,model.Department,model.IsActive);

                List<string> error = new List<string>();
                if (res == -1) error.Add("Department already exists");
                else if (res == 0) error.Add("Department not Updated");
                if (error.Count > 0)
                {
                    status = new Status("BadRequest", error);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                status = new Status("OK", null, "Department has been Updated successfully");

                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }
        }

        //[Route("{departmentId}"), HttpGet]
        //public HttpResponseMessage GetDetailsById(int departmentId)
        //{
        //    try
        //    {
        //        DepartmentsDAL _departmentDAL = new DepartmentsDAL();
        //        if (departmentId < 0)
        //            ModelState.AddModelError("DepartmentId", "DepartmentId is required");

        //        List<DepartmentDto> res = _departmentDAL.GetDetailsById(departmentId);

        //        Status status = new Status("OK", null, (res != null) ? res : new List<DepartmentDto>());

        //        return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
        //    }
        //    catch (Exception ex)
        //    {
        //        Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
        //    }
        //}

        //[Route("status/{activeValue}"), HttpGet]
        //public HttpResponseMessage GetDetailsByActive(int activeValue)
        //{
        //    try
        //    {
        //        DepartmentsDAL _departmentDAL = new DepartmentsDAL();

        //        List<DepartmentDto> res = _departmentDAL.GetByActive(activeValue);

        //        Status status = new Status("OK", null, (res != null) ? res : new List<DepartmentDto>());
        //        return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
        //    }
        //    catch (Exception ex)
        //    {
        //        Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
        //        return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
        //    }
        //}

        [Route("Id/{departmentId}"), HttpDelete]
        public HttpResponseMessage DeleteEmployee(int departmentId)
        {
            try
            {
                if (departmentId < 0)
                    ModelState.AddModelError("DepartmentId", "Enter valid departmentId");

                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, badstatus, _jsonMediaTypeFormatter);
                }
                DepartmentsDAL _departmentDAL = new DepartmentsDAL();
                int res = _departmentDAL.Delete(departmentId);
                if (res <= 0)
                {
                    ModelState.AddModelError("DepartmentId", "This status can't change, it is active");
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
