using Attendance.API.RequestObjects;
using Attendance.DAL;
using Attendance.Model;
using log4net;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Attendance.API.Controllers
{
    [TokenAuthentication]
    [RoutePrefix("V1/Reports")]
    public class ReportsController : BaseController
    {
        private static readonly ILog log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        [Route("Monthly"), HttpPost]
        public HttpResponseMessage GetMonthlyReport(MothlyRequest model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered MonthlyReport method");
                DAL.ReportsDAL _ReportsDAL = new ReportsDAL();
                log.Info("Getting MonthlyReport data from the database ");
                if (model.FromDate == null)
                    ModelState.AddModelError("FromDate", "FromDate is required");
                if (model.ToDate == null)
                    ModelState.AddModelError("ToDate", "ToDate is required");
                List<MonthlyDto> res = _ReportsDAL.GetMonthlyReport(model.FromDate, model.ToDate);
                log.Info("Getting MonthlyReport data from the database is completed . Returning the status object ");
                Status status = new Status("OK", null, (res != null) ? res : new List<MonthlyDto>());
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
                log.Info("MonthlyReport -Elapsed " + stopwatch.Elapsed);
            }

        }

        [Route("Biometric"), HttpPost]
        public HttpResponseMessage GetBiometricReport(BiometricRequest model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered BiometricReport method ");
                ReportsDAL _ReportsDAL = new ReportsDAL();
                log.Info("Getting BiometricReport data from the database ");
                if (model.FromDate == null)
                    ModelState.AddModelError("FromDate", "FromDate is required");

                if (model.ToDate == null)
                    ModelState.AddModelError("ToDate", "ToDateis required");
                Status status = new Status("OK");

                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    log.Debug("Errors:" + string.Join(",", errors));
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }
                List<BiometricReportDto> res = _ReportsDAL.GetBioMetricReport(model.FromDate, model.ToDate, model.EmployeeID);
                log.Info("Getting BiometricReport data from the database is completed . Returning the status object ");
                status = new Status("OK", null, (res != null) ? res : new List<BiometricReportDto>());
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
                log.Info("BiometricReport-Elapsed " + stopwatch.Elapsed);
            }
        }

        [Route("Missing"), HttpPost]
        public HttpResponseMessage MissingEntries(MissingRequest model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered MissingEntriesReport method");

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
                    log.Debug("Errors:" + string.Join(",", errors));
                    Status badstatus = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, badstatus, _jsonMediaTypeFormatter);
                }
                ReportsDAL _ReportsDAL = new ReportsDAL();
                log.Info("Getting MissingEntriesReport data from the database ");
                List<MissingEntriesDto> res = _ReportsDAL.GetMissingEntries(model.FromDate, model.ToDate, model.EmployeeID);
                log.Info("Getting MissingEntriesReport data from the database is completed . Returning the status object ");
                Status status = new Status("OK", null, (res != null) ? res : new List<MissingEntriesDto>());
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
                log.Info("MissingEntriesReport-Elapsed" + stopwatch.Elapsed);
            }
        }

        [Route("Daily"), HttpPost]
        public HttpResponseMessage GetDailyReport(DailyRequest model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered DailyReport method");
                ReportsDAL _ReportsDAL = new ReportsDAL();
                log.Info("Getting DailyReport data from the database");
                if (model.FromDate == null)
                    ModelState.AddModelError("FromDate", "FromDate is required");

                if (model.ToDate == null)
                    ModelState.AddModelError("ToDate", "To Date is required");
                Status status = new Status("OK");

                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    log.Debug("Errors:" + string.Join(",", errors));
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }
                List<DailyDto> res = _ReportsDAL.GetReport(model.FromDate, model.ToDate, model.EmployeeID);
                log.Info("Getting DailyReport data from the database is completed . Returning the status object ");
                status = new Status("OK", null, (res != null) ? res : new List<DailyDto>());
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
                log.Info("DailyReport-Elapsed " + stopwatch.Elapsed);
            }

        }

        [Route("Time"), HttpPost]
        public HttpResponseMessage TimeReport(MothlyRequest model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered TimeReport method");
                DAL.ReportsDAL _ReportsDAL = new ReportsDAL();
                log.Info("Getting data from the database");
                if (model.FromDate == null)
                    ModelState.AddModelError("FromDate", "FromDate is required");
                if (model.ToDate == null)
                    ModelState.AddModelError("ToDate", "ToDateis required");
                List<MonthlyDto> res = _ReportsDAL.GetTimeReport(model.FromDate, model.ToDate, model.EmployeeID);
                log.Info("Getting TimeReport data from the database is completed . Returning the status object ");
                Status status = new Status("OK", null, (res != null) ? res : new List<MonthlyDto>());
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
                log.Info("TimeReport-Elapsed " + stopwatch.Elapsed);
            }

        }
    }
}
