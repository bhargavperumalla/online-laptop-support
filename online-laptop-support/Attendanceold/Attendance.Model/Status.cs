using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;

namespace Attendance.Model
{
    public class Status
    {
        /// <summary>
        /// The status as the <see cref="HttpStatusCode"/>.
        /// </summary>
        public HttpStatusCode Code { get; set; }

        /// <summary>
        /// The status as a string.
        /// </summary>
        public string Text { get; set; }

        /// <summary>
        /// A collection of errors information if any.
        /// </summary>

        public object Errors { get; set; }

        /// <summary>
        /// Data object if the process is succeess.
        /// </summary>

        public object Data { get; set; }

        /// <summary>
        /// The date time.
        /// </summary>
        public DateTime? Timestamp { get; set; }

        public Status(string text, object errors = null, object data = null)
        {
            Errors = errors;
            Data = data;
            switch (text)
            {
                case "OK":
                    Code = HttpStatusCode.OK;
                    Text = "OK";
                    break;
                case "BadRequest":
                    Code = HttpStatusCode.BadRequest;
                    Text = "Bad Request";
                    Timestamp = DateTime.Now;
                    break;
                case "Unauthorized":
                    Code = HttpStatusCode.BadRequest;
                    Text = "Unauthorized";
                    Timestamp = DateTime.Now;
                    break;
                case "NotFound":
                    Code = HttpStatusCode.NotFound;
                    Text = "Not Found";
                    break;
                case "InternalServerError":
                    Code = HttpStatusCode.InternalServerError;
                    Text = "Internal Server Error";
                    Timestamp = DateTime.Now;
                    break;
                case "Created":
                    Code = HttpStatusCode.Created;
                    Text = "Created";
                    break;
                case "InActive":
                    Code = HttpStatusCode.Created;
                    Text = "InActive email";
                    break;
                case "Expired":
                    Code = HttpStatusCode.GatewayTimeout;
                    Text = "Link expired";
                    break;
                case "Unavailable":
                    Code = HttpStatusCode.ServiceUnavailable;
                    Text = "Link unavailable";
                    break;
                case "NotAcceptable":
                    Code = HttpStatusCode.NotAcceptable;
                    Text = "NotAcceptable";
                    break;
            }
        }
    }
}