using Attendance.API.RequestObjects;
using Attendance.DAL;
using Attendance.Model;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Attendance.API.Controllers
{
    [RoutePrefix("V1/Reports")]
    public class ReportsController : BaseController
    {
        [Route("Monthly"), HttpPost]
        public HttpResponseMessage GetMonthlyReport(MothlyRequest model)
        {
            try
            {
                DAL.ReportsDAL _ReportsDAL = new ReportsDAL();

                if (model.FromDate == null)
                    ModelState.AddModelError("FromDate", "FromDate is required");

                if (model.ToDate == null)
                    ModelState.AddModelError("ToDate", "ToDateis required");

                List<MonthlyDto> res = _ReportsDAL.GetMonthlyReport(model.FromDate, model.ToDate);

                Status status = new Status("OK", null, (res != null) ? res : new List<MonthlyDto>());
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }

        }

        [Route("Biometric"), HttpPost]
        public HttpResponseMessage GetBiometricReport(BiometricRequest model)
        {
            try
            {
                ReportsDAL _ReportsDAL = new ReportsDAL();

                if (model.FromDate == null)
                    ModelState.AddModelError("FromDate", "FromDate is required");

                if (model.ToDate == null)
                    ModelState.AddModelError("ToDate", "ToDateis required");
                Status status = new Status("OK");

                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }
                List<BiometricReportDto> res = _ReportsDAL.GetBioMetricReport(model.FromDate, model.ToDate, model.EmployeeIds);

                status = new Status("OK", null, (res != null) ? res : new List<BiometricReportDto>());
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }
        }

        [Route("Missing"), HttpPost]
        public HttpResponseMessage MissingEntries(MissingRequest model)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(model.FromDate))
                {
                    ModelState.AddModelError("FromDate", "Date is required");
                }
                if (string.IsNullOrWhiteSpace(model.ToDate))
                {
                    ModelState.AddModelError("ToDate", "Date is required");
                }

                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, badstatus, _jsonMediaTypeFormatter);
                }
                ReportsDAL _ReportsDAL = new ReportsDAL();

                List<MissingEntriesDto> res = _ReportsDAL.GetMissingEntries(model.FromDate, model.ToDate, model.EmployeeID);

                Status status = new Status("OK", null, (res != null) ? res : new List<MissingEntriesDto>());
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }
        }

        [Route("Daily"), HttpPost]
        public HttpResponseMessage GetDailyReport(DailyRequest model)
        {
            try
            {
                ReportsDAL _ReportsDAL = new ReportsDAL();

                if (model.FromDate == null)
                    ModelState.AddModelError("FromDate", "FromDate is required");

                if (model.ToDate == null)
                    ModelState.AddModelError("ToDate", "ToDateis required");
                Status status = new Status("OK");

                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                List<DailyDto> res = _ReportsDAL.GetReport(model.FromDate, model.ToDate, model.EmployeeID);

                status = new Status("OK", null, (res != null) ? res : new List<DailyDto>());
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }
        }

        [Route("Time"), HttpPost]
        public HttpResponseMessage TimeReport(MothlyRequest model)
        {
            try
            {
                DAL.ReportsDAL _ReportsDAL = new ReportsDAL();

                if (model.FromDate == null)
                    ModelState.AddModelError("FromDate", "FromDate is required");

                if (model.ToDate == null)
                    ModelState.AddModelError("ToDate", "ToDateis required");

                List<MonthlyDto> res = _ReportsDAL.GetTimeReport(model.FromDate, model.ToDate, model.EmployeeID);

                Status status = new Status("OK", null, (res != null) ? res : new List<MonthlyDto>());
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
