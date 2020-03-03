using Attendance.Attributes;
using Attendance.Model;
using Attendance.Models;
using log4net;
using Newtonsoft.Json;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Mvc;

namespace Attendance.Controllers
{
    [SessionAuthorize]

    public class ReportsController : BaseController
    {
        readonly WebInstance WebAPI = new WebInstance(MvcApplication.APIBaseUrl);

        private static readonly ILog log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        #region Daily Report
        [Authorization]
        public ActionResult Daily()
        {
            ViewBag.Dates = Utility.GetToFromDates();
            return View();
        }
        [Authorization]
        public ActionResult GetDailyReportExcel(string id)
        {
            Daily model = new Daily();
            string[] parms = id.Split('$');
            model.FromDate = parms[0];
            model.ToDate = parms[1];
            model.EmployeeID = parms[2];
            HttpResponseMessage response = WebAPI.Post("Reports/Daily", model);
            Status data = response.Content.ReadAsAsync<Status>().Result;
            List<DailyDto> model1 = (data.Text.ToLower() == "ok") ? JsonConvert.DeserializeObject<List<DailyDto>>(data.Data.ToString()) : new List<DailyDto>();

            var distinct = model1.Select(o => o.EmployeeName).Distinct();

            using (ExcelPackage ep = new ExcelPackage())
            {

                foreach (var Name in distinct)
                {
                    ep.Workbook.Worksheets.Add(Name);
                    ExcelWorksheet ws = ep.Workbook.Worksheets[Name];

                    ws.Cells.Style.Font.Size = 12;
                    ws.Cells.Style.Font.Name = "Calibri";

                    int i = 1, j = 1;
                    var cell = ws.Cells[i, j];


                    var fill = cell.Style.Fill;
                    fill.PatternType = ExcelFillStyle.Solid;
                    fill.BackgroundColor.SetColor(Color.LightCyan);

                    var border = ws.Cells[i, j, i, j + 7].Style.Border;
                    border.Bottom.Style = border.Top.Style = border.Left.Style = border.Right.Style = ExcelBorderStyle.Thin;
                    ws.Cells[i, j, i, j + 7].Style.Font.Bold = true;


                    ws.Cells[i, j, i, j + 7].Merge = true;
                    cell.Value = "Employee Name :" + "  " + Name;


                    i = 2; j = 1;
                    string[] columns = new string[] { "Date", "InTime", "OutTime", "Duration", "Permission", "Extra Hrs Worked", "Leave", "LeaveType", "WFH" };
                    foreach (var col in columns)

                    {
                        cell = ws.Cells[i, j];
                        fill = cell.Style.Fill;
                        fill.PatternType = ExcelFillStyle.Solid;
                        fill.BackgroundColor.SetColor(Color.LightYellow);
                        border = cell.Style.Border;
                        border.Bottom.Style = border.Top.Style = border.Left.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        cell.Style.Font.Bold = true;
                        cell.Value = col;
                        j++;
                    }

                    foreach (DailyDto t in model1)
                    {
                        if (t.EmployeeName == Name)
                        {
                            i++;
                            j = 1;
                            ws.Cells[i, j].Value = t.Date;
                            ws.Cells[i, j].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;

                            j++;
                            ws.Cells[i, j].Value = t.InTime;
                            ws.Cells[i, j].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Right;

                            j++;
                            ws.Cells[i, j].Value = t.OutTime;
                            ws.Cells[i, j].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Right;

                            j++;
                            ws.Cells[i, j].Value = t.Duration;
                            ws.Cells[i, j].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Right;

                            j++;
                            ws.Cells[i, j].Value = t.PermissionHrs;
                            ws.Cells[i, j].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Right;

                            j++;
                            ws.Cells[i, j].Value = t.ExtraHrsWorked;
                            ws.Cells[i, j].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Right;
                            
                            j++;
                            ws.Cells[i, j].Value = t.Leave;
                            ws.Cells[i, j].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;

                            j++;
                            ws.Cells[i, j].Value = t.LeaveType;
                            ws.Cells[i, j].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;

                            j++;
                            ws.Cells[i, j].Value = t.WorkFromHome;
                            ws.Cells[i, j].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;

                        }
                    }

                    var range = ws.Cells[1, 1, i, j];
                    range.AutoFitColumns();
                    border = range.Style.Border;
                    border.Bottom.Style = border.Top.Style = border.Left.Style = border.Right.Style = OfficeOpenXml.Style.ExcelBorderStyle.Thin;
                }

                using (MemoryStream stream = new MemoryStream())
                {
                    ep.SaveAs(stream);
                    return File(stream.ToArray(), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "DailyReport - " + model.FromDate + '-' + model.ToDate + ".xlsx");
                }

            }
        }

        [HttpPost]
        [Authorization]
        public JsonResult GetDailyReport(Daily model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered DailyReport method");

                if (model == null) return BadPayload();

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.GetModelErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Json(badstatus, JsonRequestBehavior.AllowGet);
                }
                HttpResponseMessage response = WebAPI.Post("Reports/Daily", model);
                Status data = response.Content.ReadAsAsync<Status>().Result;

                if (data.Code == HttpStatusCode.OK)
                {
                    List<DailyDto> model1 = (data.Text.ToLower() == "ok") ? JsonConvert.DeserializeObject<List<DailyDto>>(data.Data.ToString()) : new List<DailyDto>();
                    return Json(model1, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(data, JsonRequestBehavior.AllowGet);
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
                log.Info("GetDailyReport-Elapsed" + stopwatch.Elapsed);
            }
        }

        #endregion

        #region Monthly Report
        [Authorization]
        public ActionResult Monthly()
        {
            ViewBag.Years = Utility.GetYears();
            ViewBag.Months = Utility.GetMonths();
            return View();
        }

        [HttpPost]
        [Authorization]
        public JsonResult GetMonthlyReport(string year, string month)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered MonthlyReport method");
                Monthly model = new Monthly();

                DateTime[] dates = Utility.GetDates(year, month);
                model.FromDate = dates[0].ToString();
                model.ToDate = dates[1].ToString();

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.GetModelErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Json(badstatus, JsonRequestBehavior.AllowGet);
                }
                HttpResponseMessage response = WebAPI.Post("Reports/Monthly", model);
                Status data = response.Content.ReadAsAsync<Status>().Result;

                if (data.Code == HttpStatusCode.OK)
                {
                    var userdetails = JsonConvert.DeserializeObject<List<MonthlyDto>>(data.Data.ToString());
                    Status status = new Status("OK", null, userdetails);
                    return Json(status, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(data, JsonRequestBehavior.AllowGet);
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
                log.Info("GetMonthlyReport-Elapsed" + stopwatch.Elapsed);
            }
        }
        [Authorization]
        public ActionResult GetMonthlyReportExcel(string id)
        {
            Monthly model = new Monthly();
            string[] result = id.Split('$');
            DateTime[] dates = Utility.GetDates(result[1], result[0]);
            model.FromDate = dates[0].ToString();
            model.ToDate = dates[1].ToString();

            HttpResponseMessage response = WebAPI.Post("Reports/Monthly", model);
            Status data = response.Content.ReadAsAsync<Status>().Result;
            var UserDetails = JsonConvert.DeserializeObject<List<MonthlyDto>>(data.Data.ToString());
            using (ExcelPackage ep = new ExcelPackage())
            {
                ep.Workbook.Worksheets.Add("Monthly Report");
                ExcelWorksheet ws = ep.Workbook.Worksheets[1];
                ws.Cells.Style.Font.Size = 12; //Default font size for whole sheet
                ws.Cells.Style.Font.Name = "Calibri"; //Default Font name for whole sheet

                int i = 1, j = 1;

                ws.Cells[i, j].Value = "Employee Name";
                ws.Cells[i, j].Style.Font.Bold = true;
                ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                j++;
                ws.Cells[i, j].Value = "Duration";
                ws.Cells[i, j].Style.Font.Bold = true;
                ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                j++;
                ws.Cells[i, j].Value = "Permission";
                ws.Cells[i, j].Style.Font.Bold = true;
                ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                j++;
                ws.Cells[i, j].Value = "Leaves";
                ws.Cells[i, j].Style.Font.Bold = true;
                ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                j++;
                ws.Cells[i, j].Value = "SL";
                ws.Cells[i, j].Style.Font.Bold = true;
                ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                j++;
                ws.Cells[i, j].Value = "PL";
                ws.Cells[i, j].Style.Font.Bold = true;
                ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                j++;
                ws.Cells[i, j].Value = "ML";
                ws.Cells[i, j].Style.Font.Bold = true;
                ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                j++;
                ws.Cells[i, j].Value = "COFF";
                ws.Cells[i, j].Style.Font.Bold = true;
                ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                j++;
                ws.Cells[i, j].Value = "WFH";
                ws.Cells[i, j].Style.Font.Bold = true;
                ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;


                ExcelRange range = ws.Cells[1, 1, 1, j];
                range.Style.Fill.PatternType = ExcelFillStyle.Solid;
                range.Style.Fill.BackgroundColor.SetColor(Color.LightYellow);

                var border = range.Style.Border;
                border.Bottom.Style = border.Top.Style = border.Left.Style = border.Right.Style = ExcelBorderStyle.Thin;
                range.Style.Font.Bold = true;

                foreach (MonthlyDto m in UserDetails)
                {
                    i++;
                    j = 1;

                    ws.Cells[i, j].Value = m.Name;
                    ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                    j++;
                    ws.Cells[i, j].Value = m.Duration;
                    ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                    j++;
                    ws.Cells[i, j].Value = m.Permission;
                    ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                    j++;
                    ws.Cells[i, j].Value = m.Leaves;
                    ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                    j++;
                    ws.Cells[i, j].Value = m.SL;
                    ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                    j++;
                    ws.Cells[i, j].Value = m.PL;
                    ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                    j++;
                    ws.Cells[i, j].Value = m.ML;
                    ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                    j++;
                    ws.Cells[i, j].Value = m.COFF;
                    ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                    j++;
                    ws.Cells[i, j].Value = m.WorkFromHome;
                    ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                }

                range = ws.Cells[1, 1, i, j];
                range.AutoFitColumns();
                border = range.Style.Border;
                border.Bottom.Style = border.Top.Style = border.Left.Style = border.Right.Style = OfficeOpenXml.Style.ExcelBorderStyle.Thin;

                using (MemoryStream stream = new MemoryStream())
                {
                    ep.SaveAs(stream);
                    return File(stream.ToArray(), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "Monthly Report - " + dates[1].ToString("Y") + ".xlsx");
                }
            }
        }

        #endregion

        #region Biometric Report
        [Authorization]
        public ActionResult Biometric()
        {
            ViewBag.Dates = Utility.GetToFromDates();

            return View();
        }
        [Authorization]
        public ActionResult GetBiometricExcel(string id)
        {
            try
            {
                BiometricReport model = new BiometricReport();
                string[] parms = id.Split('$');
                model.FromDate = parms[0];
                model.ToDate = parms[1];
                model.EmployeeID = parms[2];
                HttpResponseMessage response = WebAPI.Post("Reports/Biometric", model);
                Status data = response.Content.ReadAsAsync<Status>().Result;
                List<BiometricReportDto> model1 = (data.Text.ToLower() == "ok") ? JsonConvert.DeserializeObject<List<BiometricReportDto>>(data.Data.ToString()) : new List<BiometricReportDto>();

                var distinct = model1.Select(o => o.Name).Distinct();

                using (ExcelPackage ep = new ExcelPackage())
                {

                    foreach (var EmployeeName in distinct)
                    {
                        ep.Workbook.Worksheets.Add(EmployeeName);
                        ExcelWorksheet ws = ep.Workbook.Worksheets[EmployeeName];

                        ws.Cells.Style.Font.Size = 12;
                        ws.Cells.Style.Font.Name = "Calibri";

                        int i = 1, j = 1;
                        var cell = ws.Cells[i, j];


                        var fill = cell.Style.Fill;
                        fill.PatternType = ExcelFillStyle.Solid;
                        fill.BackgroundColor.SetColor(Color.LightCyan);

                        var border = ws.Cells[i, j, i, j + 3].Style.Border;
                        border.Bottom.Style = border.Top.Style = border.Left.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        ws.Cells[i, j, i, j + 3].Style.Font.Bold = true;


                        ws.Cells[i, j, i, j + 3].Merge = true;
                        cell.Value = "Employee Name :" + "  " + EmployeeName;


                        i = 2; j = 1;
                        string[] columns = new string[] { "Date", "InTime", "OutTime", "Duration" };
                        foreach (var col in columns)

                        {
                            cell = ws.Cells[i, j];
                            fill = cell.Style.Fill;
                            fill.PatternType = ExcelFillStyle.Solid;
                            fill.BackgroundColor.SetColor(Color.LightYellow);
                            border = cell.Style.Border;
                            border.Bottom.Style = border.Top.Style = border.Left.Style = border.Right.Style = ExcelBorderStyle.Thin;
                            cell.Style.Font.Bold = true;
                            cell.Value = col;
                            j++;
                        }

                        foreach (BiometricReportDto t in model1)
                        {
                            if (t.Name == EmployeeName)
                            {
                                i++;
                                j = 1;
                                ws.Cells[i, j].Value = t.Date;
                                ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                                j++;
                                ws.Cells[i, j].Value = t.InTime;
                                ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                                j++;
                                ws.Cells[i, j].Value = t.OutTime;
                                ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                                j++;
                                ws.Cells[i, j].Value = t.Duration;
                                ws.Cells[i, j].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                            }
                        }

                        var range = ws.Cells[1, 1, i, j];
                        range.AutoFitColumns();
                        border = range.Style.Border;
                        border.Bottom.Style = border.Top.Style = border.Left.Style = border.Right.Style = OfficeOpenXml.Style.ExcelBorderStyle.Thin;
                    }

                    using (MemoryStream stream = new MemoryStream())
                    {
                        ep.SaveAs(stream);
                        return File(stream.ToArray(), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "BiometricReport - " + model.FromDate + '-' + model.ToDate + ".xlsx");
                    }

                }
            }
            catch (Exception ex)
            {
                string x = ex.Message;

                return RedirectToAction("Biometric");
            }
        }
        [Authorization]
        public JsonResult GetBiometricDetails(BiometricReport model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered Biometric Report method");
                if (model == null) return BadPayload();

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.GetModelErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Json(badstatus, JsonRequestBehavior.AllowGet);
                }
                HttpResponseMessage response = WebAPI.Post("Reports/Biometric", model);
                Status data = response.Content.ReadAsAsync<Status>().Result;

                if (data.Code == HttpStatusCode.OK)
                {
                    List<BiometricReportDto> model1 = (data.Text.ToLower() == "ok") ? JsonConvert.DeserializeObject<List<BiometricReportDto>>(data.Data.ToString()) : new List<BiometricReportDto>();
                    return Json(model1, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(data, JsonRequestBehavior.AllowGet);
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
                log.Info("GetBiometricDetails-Elapsed" + stopwatch.Elapsed);
            }
        }

        #endregion

        #region Missing entries Report

        public ActionResult Missing(string id)
        {
            if (id == "1" && Session["IsAdmin"].ToString() != "true" || id == "1" && Session["IsAdmin"].ToString() == "true")
            {
                ViewBag.Login = 1;
                ViewBag.Dates = Utility.GetToFromDates();
                string[] s = Utility.GetToFromDates();
                DateTime date1 = DateTime.Parse(s[1]);
                DateTime date = date1.AddDays(-1);
                DateTime dt = date.AddDays(-30);
                ViewBag.FromDate = dt.ToString("MM/dd/yyyy");
                ViewBag.ToDate = date.ToString("MM/dd/yyyy");
            }
            else if (id == null && Session["IsAdmin"].ToString() != "true")
            {
                Response.Redirect("~/Error/Unauthorized");
            }

            else
            {
                ViewBag.Login = 0;
                ViewBag.Dates = Utility.GetToFromDates();
                string[] s = Utility.GetToFromDates();
                DateTime date1 = DateTime.Parse(s[1]);
                DateTime date = date1.AddDays(-1);
                DateTime dt = date.AddDays(-30);
                ViewBag.FromDate = dt.ToString("MM/dd/yyyy");
                ViewBag.ToDate = date.ToString("MM/dd/yyyy");
            }
            return View();
        }

        [HttpPost]
        public JsonResult MissingEntriesDetails(MissingEntries model, int st)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered Missing Entries Details method");
                if (st == 1)
                {
                    string[] s = Utility.GetToFromDates();
                    DateTime date1 = DateTime.Parse(s[1]);
                    DateTime date = date1.AddDays(-1);
                    DateTime dt = date.AddDays(-30);
                    model.FromDate = dt.ToString();
                    model.ToDate = date.ToString();
                    model.EmployeeID = Session["EmployeeId"].ToString();
                }
                if (model == null) return BadPayload();
                if (!ModelState.IsValid)
                {
                    var errors = ModelState.GetModelErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Json(badstatus, JsonRequestBehavior.AllowGet);
                }
                HttpResponseMessage response = WebAPI.Post("Reports/Missing", model);
                Status data = response.Content.ReadAsAsync<Status>().Result;

                if (data.Code == HttpStatusCode.OK)
                {
                    List<MissingEntriesDto> model1 = (data.Text.ToLower() == "ok") ? JsonConvert.DeserializeObject<List<MissingEntriesDto>>(data.Data.ToString()) : new List<MissingEntriesDto>();
                    return Json(model1, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(new { Valid = "true", Success = "false", Data = data.Errors }, JsonRequestBehavior.AllowGet);
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
                log.Info("MissingEntriesDetails-Elapsed" + stopwatch.Elapsed);
            }
        }

        [HttpPost]
        public JsonResult MissingEntries(MissingEntries model)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                log.Info("Entered Missing Entries method");
                if (model == null) return BadPayload();

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.GetModelErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Json(badstatus, JsonRequestBehavior.AllowGet);
                }
                HttpResponseMessage response = WebAPI.Post("Reports/Missing", model);
                Status data = response.Content.ReadAsAsync<Status>().Result;

                if (data.Code == HttpStatusCode.OK)
                {
                    List<MissingEntriesDto> model1 = (data.Text.ToLower() == "ok") ? JsonConvert.DeserializeObject<List<MissingEntriesDto>>(data.Data.ToString()) : new List<MissingEntriesDto>();
                    return Json(model1, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(new { Valid = "true", Success = "false", Data = data.Errors }, JsonRequestBehavior.AllowGet);
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
                log.Info("MissingEntries-Elapsed" + stopwatch.Elapsed);
            }
        }
        #endregion
    }
}