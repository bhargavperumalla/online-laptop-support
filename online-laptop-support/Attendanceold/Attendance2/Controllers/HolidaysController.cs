using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Attendance.Models;
using System.Data;
using System.IO;
using ExcelDataReader;
using System.Net.Http;
using Attendance.Model;
using Newtonsoft.Json;
using Attendance.Attributes;
//using Excel;

namespace Attendance.Controllers
{
    [SessionAuthorize]
    public class HolidaysController : BaseController
    {

        readonly WebInstance WebAPI = new WebInstance(MvcApplication.APIBaseUrl);

        public ActionResult Holidays()
        {
            ViewBag.Years = Utility.GetHolidaysYears();
            return View();
        }

        [HttpPost]
        public JsonResult ImportHolidays(HolidaysDto model)
        {
            if (model.Year == null) ModelState.AddModelError("Year", "Year is required");

            model.HolidaysList = new List<Holidays>();

            HttpPostedFileBase fileupload;
            if (System.Web.HttpContext.Current.Request.Files.AllKeys.Any())
            {
                fileupload = Request.Files[0];
                string fileName = fileupload.FileName;
                if (fileName != null && fileName != "")
                {
                    string ext = Path.GetExtension(fileName);
                    if (ext.ToLower() != ".xlsx" && ext.ToLower() != ".xls")
                    {
                        ModelState.AddModelError("PicURL", "Please upload excel(xlsx, xls) formats only");
                    }
                    else
                    {
                        if (fileupload.ContentLength > 0)
                        {
                            string filePath = System.Web.HttpContext.Current.Server.MapPath("~/Temp/");
                            string[] files = Directory.GetFiles(filePath, "Holidays.*");
                            if (files != null) foreach (string f in files) { System.IO.File.Delete(f); }

                            fileupload.SaveAs(filePath + "Holidays" + ext);

                            FileStream stream = System.IO.File.Open(filePath + "Holidays" + ext, FileMode.Open, FileAccess.Read);
                           
                            DataSet result = new DataSet();
                            if (ext.ToLower() == ".xls")
                            {
                                IExcelDataReader excelReader = ExcelReaderFactory.CreateBinaryReader(stream);
                                result = excelReader.AsDataSet();
                            }                          
                            if (ext.ToLower() == ".xlsx")
                            {
                                IExcelDataReader excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream);
                                result = excelReader.AsDataSet();
                            }
                            stream.Close();

                            DataTable dt = result.Tables[0];
                            dt = dt.Rows.Cast<DataRow>().Where(row => !row.ItemArray.All(field => field is System.DBNull)).CopyToDataTable();
                            if (dt.Rows.Count > 1)
                            {
                                List<Columns> colsList = FileValidation(dt);

                                if (colsList.Any(p => p.CurrentColumn == null))
                                    ModelState.AddModelError("PicURL", "Invalid Excel File");
                                else
                                {
                                    dt.Rows[0].Delete();
                                    dt.AcceptChanges();

                                    DataTable uDt = new DataTable();
                                    uDt.Columns.Add("S.No");
                                    uDt.Columns.Add("Date");
                                    uDt.Columns.Add("Day");
                                    uDt.Columns.Add("Festival");

                                    foreach (DataRow dr in dt.Rows)
                                    {
                                        string colSno = colsList.Where(p => p.ActualColumn.ToLower() == "s.no").FirstOrDefault().CurrentColumn;
                                        string sno = dr[colSno].ToString();
                                        string date = "";
                                        string colDate = colsList.Where(p => p.ActualColumn.ToLower() == "date").FirstOrDefault().CurrentColumn;
                                        if (DBNull.Value.Equals(dr[colDate]))
                                        {
                                             date = dr[colDate].ToString();
                                        }
                                        else
                                        {
                                            dr[colDate] = DateTime.Parse((dr[colDate].ToString())).ToString("MM/dd/yyyy");
                                            date = dr[colDate].ToString();
                                            DateTime myDate = Convert.ToDateTime(date);
                                            int year = myDate.Year;
                                            if (model.Year != year.ToString())
                                            {
                                                ModelState.AddModelError("Year", "Year Does'nt Match with Excel File Year");
                                            }
                                        }

                                       

                                        string colDay = colsList.Where(p => p.ActualColumn.ToLower() == "day").FirstOrDefault().CurrentColumn;
                                        string day = dr[colDay].ToString();

                                        string colFestival = colsList.Where(p => p.ActualColumn.ToLower() == "festival").FirstOrDefault().CurrentColumn;
                                        string festival = dr[colFestival].ToString();

                                        uDt.Rows.Add(sno, date, day, festival);

                                    }

                                    if (uDt != null && uDt.Rows.Count > 0)
                                    {
                                        model.HolidaysList = Utility.ConvertDataTable<Holidays>(uDt).ToList();
                                        
                                    }
                                    else
                                    {
                                        ModelState.AddModelError("PicURL", "No Data Found");
                                    }

                                }
                            }
                        }

                    }
                }

            }
            else ModelState.AddModelError("PicURL", "Upload excel file");
            
            if (!ModelState.IsValid)
            {
                var errors = ModelState.GetModelErrors();
                Status badstatus = new Status("BadRequest", errors);
                return Json(new { Valid = "true", Success = "false", Data = badstatus.Errors }, JsonRequestBehavior.AllowGet);               
            }
            return Json(new { Valid = "true", Success = "true", Data = Json(model, JsonRequestBehavior.AllowGet) }, JsonRequestBehavior.AllowGet);
           
        }


        [HttpPost]
        public JsonResult SaveHolidays(HolidaysDto model)
        {
            try
            {
                if (model == null) return BadPayload();

                if (model.Year == null)
                    ModelState.AddModelError("Year", "Year is required");

                if (!ModelState.IsValid)
                {
                    var errors = ModelState.GetModelErrors();
                    Status badstatus = new Status("BadRequest", errors);
                    return Json(badstatus, JsonRequestBehavior.AllowGet);
                }

                HttpResponseMessage response = WebAPI.Post("Holidays/", model);
                Status status = response.Content.ReadAsAsync<Status>().Result;
                return Json(status, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Json(status, JsonRequestBehavior.AllowGet);
            }


        }

        private List<Columns> FileValidation(DataTable dt)
        {
            string[] cols = { "S.no", "Date", "Day", "Festival" };

            List<Columns> list = new List<Columns>();
            foreach (string columnName in cols)
            {
                list.Add(new Columns { ActualColumn = columnName });
            }

            foreach (var item in dt.Columns)
            {
                if (list.Any(c => c.ActualColumn.ToLower() == dt.Rows[0][item.ToString().Trim()].ToString().ToLower()))
                {
                    list.Where(c => c.ActualColumn.ToLower() == dt.Rows[0][item.ToString().Trim()].ToString().ToLower()).FirstOrDefault().CurrentColumn = item.ToString().Trim();
                }
            }

            return list;
        }

        public JsonResult HolidayDetails()
        {
            var year = Utility.GetIndianTime().Year.ToString();
            Status status = WebAPI.Get<Status>("Holidays", year);

            List<Holidays> response = (status.Text.ToLower() == "ok") ? JsonConvert.DeserializeObject<List<Holidays>>(status.Data.ToString()) : new List<Holidays>();

            return Json(response, JsonRequestBehavior.AllowGet);
        }
    }
}