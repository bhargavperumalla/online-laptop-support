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
    [RoutePrefix("v1/Holidays")]
    public class HolidaysController : BaseController
    {
        HolidaysDAL holidaysDAL = new HolidaysDAL();
        [Route(""), HttpPost]
        public HttpResponseMessage CreateHolidayList(HolidaysDto model)
        {
            try
            {
                if (model == null) return BadPayload();

                if (string.IsNullOrWhiteSpace(model.Year))
                    ModelState.AddModelError("Year", "Year is required");
                

                //if (string.IsNullOrWhiteSpace(model.Date))
                //    ModelState.AddModelError("Date", "Date is required");
               

                //if (string.IsNullOrWhiteSpace(model.Day))
                //    ModelState.AddModelError("Day", "Day is required");

             
                //if (string.IsNullOrWhiteSpace(model.Festival))
                //    ModelState.AddModelError("Festival", "Festival is required");

                Status status = new Status("OK");
                if (!ModelState.IsValid)
                {
                    List<string> errors = GetModelStateErrors();
                    status = new Status("BadRequest", errors);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }

                
                int res = holidaysDAL.SaveHolidayList(model);
                //if (res == -1) error.Add("Employee already exists");
                //else if (res == 0) error.Add("Employee not inserted");

                List<string> error = new List<string>();
                if (res == -1) error.Add("Holiday List already exists");               
                if (error.Count > 0)
                {
                    status = new Status("BadRequest", error);
                    return Request.CreateResponse(HttpStatusCode.BadRequest, status, _jsonMediaTypeFormatter);
                }            

                status = new Status("OK", null, model);
                return Request.CreateResponse(HttpStatusCode.OK, status, _jsonMediaTypeFormatter);
            }
            catch (Exception ex)
            {
                Status status = new Status("InternalServerError", new List<string> { string.Format("Internal server error occurred: {0}", ex.Message) });
                return Request.CreateResponse(HttpStatusCode.InternalServerError, status, _jsonMediaTypeFormatter);
            }
        }

        [Route("{Year}"), HttpGet]
        public HttpResponseMessage Holidays(string Year)
        {
            try
            {
                List<Holidays> res = holidaysDAL.GetHolidays(Year);
                Status status = new Status("OK", null, (res != null) ? res : new List<Holidays>());
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