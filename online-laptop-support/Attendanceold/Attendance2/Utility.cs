using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Reflection;
using System.Web;
using System.Web.Mvc;

namespace Attendance
{
    public static class Utility
    {
        public static string GetImagePath(string id, int GenderId = 0)
        {
            string profilePicsPath = System.Web.HttpContext.Current.Server.MapPath("~/Content/ProfilePics/");
            string profilePicPath = HttpContext.Current.Request.ApplicationPath.TrimEnd('/') + "/Content/ProfilePics/";

            string path = profilePicPath + "noimage.jpg";

            int genderId = GenderId;

            if (File.Exists(profilePicsPath + id + ".jpg"))
                path = profilePicPath + id + ".jpg";
            else if (File.Exists(profilePicsPath + id + ".jpeg"))
                path = profilePicPath + id + ".jpeg";
            else if (File.Exists(profilePicsPath + id + ".png"))
                path = profilePicPath + id + ".png";
            else if (genderId == 2)
                path = profilePicPath + "noimage_female.jpg";
            return path;
        }

        public static DateTime[] GetDates(string year, string month)
        {
            int iYear = Convert.ToInt32(year);
            int iMonth = Convert.ToInt32(month);
            iMonth = iMonth - 1;
            if (iMonth == 0)
            {
                iYear--;
                iMonth = 12;
            }
            int iStartDate = Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["MonthStartDate"].ToString());
            DateTime dtFromDate = new DateTime(iYear, iMonth, iStartDate);
            DateTime dtToDate = dtFromDate.AddMonths(1).AddDays(-1);

            return new DateTime[] { dtFromDate, dtToDate };
        }

        public static List<SelectListItem> GetYears()
        {
            TimeZoneInfo oTZInfo = TimeZoneInfo.FindSystemTimeZoneById("India Standard Time");
            List<SelectListItem> Years = new List<SelectListItem>();
            Years.Add(new SelectListItem { Text = "Select", Value = "-1" });
            DateTime dtCurrentDateTime = TimeZoneInfo.ConvertTime(DateTime.Now, oTZInfo);
            for (int i = dtCurrentDateTime.Year + 1; i >= dtCurrentDateTime.AddYears(-10).Year; i--)
                Years.Add(new SelectListItem { Text = i.ToString(), Value = i.ToString(), Selected = dtCurrentDateTime.Year == i });
            return Years;
        }

        public static List<SelectListItem> GetHolidaysYears()
        {
            TimeZoneInfo oTZInfo = TimeZoneInfo.FindSystemTimeZoneById("India Standard Time");
            List<SelectListItem> Years = new List<SelectListItem>();
            Years.Add(new SelectListItem { Text = "Select", Value = "-1" });
            DateTime dtCurrentDateTime = TimeZoneInfo.ConvertTime(DateTime.Now, oTZInfo);
            for (int i = dtCurrentDateTime.Year; i <= dtCurrentDateTime.AddYears(5).Year; i++)
                Years.Add(new SelectListItem { Text = i.ToString(), Value = i.ToString(), Selected = dtCurrentDateTime.Year == i });
            return Years;
        }


        public static List<SelectListItem> GetMonths()
        {
            TimeZoneInfo oTZInfo = TimeZoneInfo.FindSystemTimeZoneById("India Standard Time");
            List<SelectListItem> Months = new List<SelectListItem>();
            Months.Add(new SelectListItem { Text = "Select", Value = "-1" });
            DateTime dtCurrentDateTime = TimeZoneInfo.ConvertTime(DateTime.Now, oTZInfo);
            for (int i = 1; i <= 12; i++)
                Months.Add(new SelectListItem { Text = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(i), Value = i.ToString(), Selected = dtCurrentDateTime.Month == i });
            return Months;
        }

        public static string[] GetToFromDates()
        {
            int iStartDate = Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["MonthStartDate"].ToString());

            TimeZoneInfo oTZInfo = TimeZoneInfo.FindSystemTimeZoneById("India Standard Time");
            string dt;

            DateTime dtCurrentDateTime = TimeZoneInfo.ConvertTime(DateTime.Now, oTZInfo);
            if (dtCurrentDateTime.Day < iStartDate)
            {
                dt = new DateTime(dtCurrentDateTime.Year, dtCurrentDateTime.Month, iStartDate).AddMonths(-1).ToString("MM/dd/yyyy");
            }
            else
            {
                dt = new DateTime(dtCurrentDateTime.Year, dtCurrentDateTime.Month, iStartDate).ToString("MM/dd/yyyy");
            }

            return new string[] { dt, dtCurrentDateTime.ToString("MM/dd/yyyy") };
        }

        public static DateTime GetLocalTime(string sTimeZone, DateTime dt)
        {
            TimeZoneInfo oTZInfo = TimeZoneInfo.FindSystemTimeZoneById(sTimeZone.ToString().Trim());
            return TimeZoneInfo.ConvertTime(dt, oTZInfo);
        }

        public static DateTime GetIndianTime()
        {
            TimeZoneInfo oTZInfo = TimeZoneInfo.FindSystemTimeZoneById("India Standard Time");
            return TimeZoneInfo.ConvertTime(DateTime.Now, oTZInfo);
        }

        public static List<T> ConvertDataTable<T>(DataTable dt)
        {
            List<T> data = new List<T>();
            foreach (DataRow row in dt.Rows)
            {
                T item = GetItem<T>(row);
                data.Add(item);
            }
            return data;
        }


        private static T GetItem<T>(DataRow dr)
        {
            Type temp = typeof(T);
            T obj = Activator.CreateInstance<T>();

            foreach (DataColumn column in dr.Table.Columns)
            {
                foreach (PropertyInfo pro in temp.GetProperties())
                {
                    if (pro.Name == column.ColumnName)
                    {
                        object value = dr[column.ColumnName];
                        if (value == DBNull.Value)
                            value = null;
                        pro.SetValue(obj, value, null);
                    }
                    else
                        continue;
                }
            }
            return obj;
        }
    }
}