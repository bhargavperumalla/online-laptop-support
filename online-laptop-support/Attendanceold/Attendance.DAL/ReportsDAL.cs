using Attendance.Model;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Attendance.DAL
{
    public class ReportsDAL
    {

        public List<BiometricReportDto> GetBioMetricReport(string sFromDate, string sToDate, string sEmployeeID)
        {
            using (SqlConnection oSqlCon = new SqlConnection(HelperDAL.CONNECTIONSTRING))
            {
                SqlDataAdapter oSqlDa = new SqlDataAdapter("ATT.USP_BiometricReport", oSqlCon);
                oSqlDa.SelectCommand.CommandType = CommandType.StoredProcedure;
                if (sFromDate != "" && sFromDate != "01/01/1900")
                    oSqlDa.SelectCommand.Parameters.AddWithValue("@dtFromDate", sFromDate);
                if (sToDate != "" && sToDate != "01/01/1900")
                    oSqlDa.SelectCommand.Parameters.AddWithValue("@dtToDate", sToDate);
                oSqlDa.SelectCommand.Parameters.AddWithValue("@vEmployeeIDs", sEmployeeID);
                DataTable oDtUser = new DataTable();
                oSqlDa.Fill(oDtUser);
                if (oDtUser != null && oDtUser.Rows.Count > 0) return Utility.ConvertDataTable<BiometricReportDto>(oDtUser).ToList();
                else return null;
            }
        }

        public List<MissingEntriesDto> GetMissingEntries(string sFromDate, string sToDate, string EmployeeIDs)
        {
            using (SqlConnection oSqlCon = new SqlConnection(HelperDAL.CONNECTIONSTRING))
            {
                SqlDataAdapter oSqlDa = new SqlDataAdapter("ATT.USP_GetMissingEntries", oSqlCon);
                oSqlDa.SelectCommand.CommandType = CommandType.StoredProcedure;
                if (sFromDate != "" && sFromDate != "01/01/1900")
                    oSqlDa.SelectCommand.Parameters.AddWithValue("@dtFromDate", sFromDate);
                if (sToDate != "" && sToDate != "01/01/1900")
                    oSqlDa.SelectCommand.Parameters.AddWithValue("@dtToDate", sToDate);
                oSqlDa.SelectCommand.Parameters.AddWithValue("@vEmployeeIDs", EmployeeIDs);

                DataTable oDtUser = new DataTable();
                oSqlDa.Fill(oDtUser);
                if (oDtUser != null && oDtUser.Rows.Count > 0) return Utility.ConvertDataTable<MissingEntriesDto>(oDtUser).ToList();
                else return null;
            }
        }

        public List<DailyDto> GetReport(string sFromDate, string sToDate, string sEmployeeID)
        {
            using (SqlConnection oSqlCon = new SqlConnection(HelperDAL.CONNECTIONSTRING))
            {
                SqlDataAdapter oSqlDa = new SqlDataAdapter("ATT.USP_GetDailyReport", oSqlCon);
                oSqlDa.SelectCommand.CommandType = CommandType.StoredProcedure;
                if (sFromDate != "" && sFromDate != "01/01/1900")
                    oSqlDa.SelectCommand.Parameters.AddWithValue("@dtFromDate", sFromDate);
                if (sToDate != "" && sToDate != "01/01/1900")
                    oSqlDa.SelectCommand.Parameters.AddWithValue("@dtToDate", sToDate);
                oSqlDa.SelectCommand.Parameters.AddWithValue("@vEmployeeIDs", sEmployeeID);

                DataTable oDtUser = new DataTable();
                oSqlDa.Fill(oDtUser);

                if (oDtUser != null && oDtUser.Rows.Count > 0) return Utility.ConvertDataTable<DailyDto>(oDtUser).ToList();
                else return null;

            }
        }

        public List<MonthlyDto> GetMonthlyReport(string sFromDate, string sToDate)
        {
            using (SqlConnection oSqlCon = new SqlConnection(HelperDAL.CONNECTIONSTRING))
            {
                SqlDataAdapter oSqlDa = new SqlDataAdapter("ATT.USP_GetMonthlyReport", oSqlCon);
                oSqlDa.SelectCommand.CommandType = CommandType.StoredProcedure;
                if (sFromDate != "" && sFromDate != "01/01/1900")
                    oSqlDa.SelectCommand.Parameters.AddWithValue("@dtFromDate", sFromDate);
                if (sToDate != "" && sToDate != "01/01/1900")
                    oSqlDa.SelectCommand.Parameters.AddWithValue("@dtToDate", sToDate);

                DataTable oDtUser = new DataTable();
                oSqlDa.Fill(oDtUser);
                if (oDtUser != null && oDtUser.Rows.Count > 0) return Utility.ConvertDataTable<MonthlyDto>(oDtUser).ToList();
                else return null;
            }
        }

        public List<MonthlyDto> GetTimeReport(string sFromDate, string sToDate, int EmployeeID)
        {
            using (SqlConnection oSqlCon = new SqlConnection(HelperDAL.CONNECTIONSTRING))
            {
                SqlDataAdapter oSqlDa = new SqlDataAdapter("ATT.USP_GetTimeReport", oSqlCon);
                oSqlDa.SelectCommand.CommandType = CommandType.StoredProcedure;
                if (sFromDate != "" && sFromDate != "01/01/1900")
                    oSqlDa.SelectCommand.Parameters.AddWithValue("@fromdate", sFromDate);
                if (sToDate != "" && sToDate != "01/01/1900")
                    oSqlDa.SelectCommand.Parameters.AddWithValue("@todate", sToDate);
                oSqlDa.SelectCommand.Parameters.AddWithValue("@employeeid", EmployeeID);
                DataTable oDtUser = new DataTable();
                oSqlDa.Fill(oDtUser);
                if (oDtUser != null && oDtUser.Rows.Count > 0) return Utility.ConvertDataTable<MonthlyDto>(oDtUser).ToList();
                else return null;
            }
        }


    }
}
