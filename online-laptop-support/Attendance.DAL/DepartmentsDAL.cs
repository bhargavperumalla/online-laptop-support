using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;
using Attendance.Model;

namespace Attendance.DAL
{
    public class DepartmentsDAL
    {
        public int Insert(DepartmentDto Model)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(HelperDAL.CONNECTIONSTRING))
                {
                    SqlCommand cmd = new SqlCommand(HelperDAL.SCHEMA + "USP_IUD_Departments", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Mode", 100);
                    cmd.Parameters.AddWithValue("@departmentName", Model.Department);
                    cmd.Parameters.AddWithValue("@active", Model.IsActive);
                    cmd.Parameters.AddWithValue("@iRetVal", SqlDbType.Int).Direction = ParameterDirection.Output;
                    con.Open();
                    cmd.ExecuteNonQuery();
                    int ReturnVal = Convert.ToInt32(cmd.Parameters["@iRetVal"].Value);
                    return ReturnVal;
                }
            }
            catch(Exception ex)
            {
                string x = ex.Message;
                return 0;
            }
        }
            

        public int Update(int DepartmentId, string Department,bool IsActive)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(HelperDAL.CONNECTIONSTRING))
                {
                    SqlCommand cmd = new SqlCommand(HelperDAL.SCHEMA + "USP_IUD_Departments", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Mode", 101);
                    cmd.Parameters.AddWithValue("@departmentId", DepartmentId);
                    cmd.Parameters.AddWithValue("@departmentName",Department);
                   cmd.Parameters.AddWithValue("@active", IsActive);
                    cmd.Parameters.AddWithValue("@iRetVal", SqlDbType.Int).Direction = ParameterDirection.Output;
                    con.Open();
                    cmd.ExecuteNonQuery();
                    int ReturnVal = Convert.ToInt32(cmd.Parameters["@iRetVal"].Value);
                    return ReturnVal;
                }
            }
            catch(Exception ex)
            {
                string x = ex.Message;
                return 0;
            }

        }

        public int Delete(int DepartmentId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(HelperDAL.CONNECTIONSTRING))
                {
                    SqlCommand cmd = new SqlCommand(HelperDAL.SCHEMA + "USP_IUD_Departments", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Mode", 104);
                    cmd.Parameters.AddWithValue("@departmentId", DepartmentId);
                    cmd.Parameters.AddWithValue("@iRetVal", SqlDbType.Int).Direction = ParameterDirection.Output;
                    con.Open();
                    cmd.ExecuteNonQuery();
                    int ReturnVal = Convert.ToInt32(cmd.Parameters["@iRetVal"].Value);
                    return ReturnVal;
                }
            }
            catch(Exception ex)
            {
                string x = ex.Message;
                return 0;
            }
        }

        public List<DepartmentDto> GetDetails(bool val)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(HelperDAL.CONNECTIONSTRING))
                {
                    //int modeval = 0;
                    //if (val == "NULL")
                    //{
                    //    modeval = 102;
                    //}
                    //if (val != "NULL")
                    //{
                    //    modeval = 102;
                    //}
                    SqlDataAdapter sda = new SqlDataAdapter(HelperDAL.SCHEMA + "USP_IUD_Departments", con);
                    sda.SelectCommand.CommandType = CommandType.StoredProcedure;
                    sda.SelectCommand.Parameters.AddWithValue("@Mode", 102);
                    sda.SelectCommand.Parameters.AddWithValue("@active", val);
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    if (dt != null && dt.Rows.Count > 0) return Utility.ConvertDataTable<DepartmentDto>(dt);
                    else return null;
                }
            }
            catch(Exception ex)
            {
                string x = ex.Message;
                throw;
            }
        }

        public List<DepartmentDto> GetDetailsById(int departmentId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(HelperDAL.CONNECTIONSTRING))
                {
                    SqlDataAdapter sda = new SqlDataAdapter(HelperDAL.SCHEMA + "USP_IUD_Departments", con);
                    sda.SelectCommand.CommandType = CommandType.StoredProcedure;
                    sda.SelectCommand.Parameters.AddWithValue("@Mode", 103);
                    sda.SelectCommand.Parameters.AddWithValue("@departmentId", departmentId);
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    if (dt != null && dt.Rows.Count > 0) return Utility.ConvertDataTable<DepartmentDto>(dt);
                    else return null;
                }
            }
            catch(Exception ex)
            {
                string x = ex.Message;
                throw;
            }
        }

        public List<DepartmentDto> GetByActive(bool IsActive)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(HelperDAL.CONNECTIONSTRING))
                {
                    SqlDataAdapter sda = new SqlDataAdapter(HelperDAL.SCHEMA + "USP_IUD_Departments", con);
                    sda.SelectCommand.CommandType = CommandType.StoredProcedure;
                    sda.SelectCommand.Parameters.AddWithValue("@Mode", 105);
                    sda.SelectCommand.Parameters.AddWithValue("@active", IsActive);
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    if (dt != null && dt.Rows.Count > 0) return Utility.ConvertDataTable<DepartmentDto>(dt);
                    else return null;
                }
            }
            catch(Exception ex)
            {
                string x = ex.Message;
                throw;
            }
        }

    }
}
