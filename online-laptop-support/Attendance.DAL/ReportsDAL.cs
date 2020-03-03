using Attendance.Model;
using System;
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
                SqlDataAdapter oSqlDa = new SqlDataAdapter(HelperDAL.SCHEMA + "USP_BiometricReport", oSqlCon);
                oSqlDa.SelectCommand.CommandType = CommandType.StoredProcedure;
                oSqlDa.SelectCommand.Parameters.AddWithValue("@Mode", 100);
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
                SqlDataAdapter oSqlDa = new SqlDataAdapter(HelperDAL.SCHEMA + "USP_GetMissingEntries", oSqlCon);
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
                SqlDataAdapter oSqlDa = new SqlDataAdapter(HelperDAL.SCHEMA + "USP_GetDailyReport", oSqlCon);
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
                SqlDataAdapter oSqlDa = new SqlDataAdapter(HelperDAL.SCHEMA + "USP_GetMonthlyReport", oSqlCon);
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
                SqlDataAdapter oSqlDa = new SqlDataAdapter(HelperDAL.SCHEMA + "USP_GetTimeReport", oSqlCon);
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

        public DataTable BiometricData()
        {
            using (SqlConnection oSqlCon = new SqlConnection(HelperDAL.CONNECTIONSTRING))
            {
                SqlDataAdapter oSqlDa = new SqlDataAdapter(HelperDAL.SCHEMA + "USP_BiometricReport", oSqlCon);
                oSqlDa.SelectCommand.CommandType = CommandType.StoredProcedure;
                oSqlDa.SelectCommand.Parameters.AddWithValue("@Mode", 101);
                
                DataTable oDtUser = new DataTable();
                oSqlDa.Fill(oDtUser);
                return oDtUser;
            }
        }

        public List<BiometricReportDto> GetCardIds()
        {
            using (SqlConnection oSqlCon = new SqlConnection(HelperDAL.CONNECTIONSTRING))
            {
                SqlDataAdapter da = new SqlDataAdapter(HelperDAL.SCHEMA + "USP_BiometricReport", oSqlCon);
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                da.SelectCommand.Parameters.AddWithValue("@Mode", 102);
                DataTable dt = new DataTable();
                da.Fill(dt);
                if (dt != null && dt.Rows.Count > 0) return Utility.ConvertDataTable<BiometricReportDto>(dt).ToList();
                else return null;
            }
        }

        public int Insert(BiometricReportDto Model)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(HelperDAL.CONNECTIONSTRING))
                {
                    SqlCommand cmd = new SqlCommand(HelperDAL.SCHEMA + "USP_BiometricReport", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Mode", 103);
                    cmd.Parameters.AddWithValue("@cardid", Model.CardId);
                    cmd.Parameters.AddWithValue("@date", Model.Date);
                    cmd.Parameters.AddWithValue("@intime", Model.InTime);
                    cmd.Parameters.AddWithValue("@outtime", Model.OutTime);
                    cmd.Parameters.AddWithValue("@name", Model.Name);
                    cmd.Parameters.AddWithValue("@iRetVal", SqlDbType.Int).Direction = ParameterDirection.Output;
                    con.Open();
                    cmd.ExecuteNonQuery();
                    int ReturnVal = Convert.ToInt32(cmd.Parameters["@iRetVal"].Value);
                    con.Close();
                    return ReturnVal;
                }
            }
            catch (Exception ex)
            {
                string x = ex.Message;
                return 0;
            }
        }

    }
}
