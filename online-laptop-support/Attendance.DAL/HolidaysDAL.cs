using System;
using Attendance.Model;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace Attendance.DAL
{
   public class HolidaysDAL
    {
        public int SaveHolidayList(HolidaysDto model)
        {
            int res = 0;
            try
            {
                SqlConnection con = new SqlConnection(HelperDAL.CONNECTIONSTRING);
                SqlCommand cmd = new SqlCommand(HelperDAL.SCHEMA + "USP_GetHolidays", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@iMode", 100);
                cmd.Parameters.AddWithValue("@Year", model.Year);
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();

                foreach (Holidays item in model.HolidaysList)
                {
                    con = new SqlConnection(HelperDAL.CONNECTIONSTRING);
                    cmd = new SqlCommand(HelperDAL.SCHEMA + "USP_GetHolidays", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@iMode", 101);
                    cmd.Parameters.AddWithValue("@Year", model.Year);
                    cmd.Parameters.AddWithValue("@Date", item.Date);
                    cmd.Parameters.AddWithValue("@Day", item.Day);
                    cmd.Parameters.AddWithValue("@Festival", item.Festival);
                    cmd.Parameters.AddWithValue("@iRetVal", SqlDbType.Int).Direction = ParameterDirection.Output;
                    con.Open();
                    cmd.ExecuteNonQuery();
                    res = (int)cmd.Parameters["@iRetVal"].Value;
                    con.Close();
                }
            }
            catch
            {
                throw;
            }
            return res;
        }

        public List<Holidays> GetHolidays(string Year)
        {
            try
            {
                using (SqlConnection oSqlCon = new SqlConnection(HelperDAL.CONNECTIONSTRING))
                {
                    SqlDataAdapter da = new SqlDataAdapter(HelperDAL.SCHEMA + "USP_GetHolidays", oSqlCon);
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@iMode", 102);
                    da.SelectCommand.Parameters.AddWithValue("@Year", Year);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    if (dt != null && dt.Rows.Count > 0) return Utility.ConvertDataTable<Holidays>(dt).ToList();
                    else return null;
                }
            }
            catch (Exception ex)
            {
                string x = ex.Message;
                throw;
            }
        }

    }
}
