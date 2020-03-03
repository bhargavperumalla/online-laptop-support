using Attendance.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace Attendance.DAL
{
    public class DesignationsDAL
    {
        public int Insert(DesignationDto Model)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(HelperDAL.CONNECTIONSTRING))
                {
                    SqlCommand cmd = new SqlCommand(HelperDAL.SCHEMA + "USP_IUD_Designation", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Mode", 100);
                    cmd.Parameters.AddWithValue("@designationName", Model.Designation);
                    cmd.Parameters.AddWithValue("@active", Model.IsActive);
                    cmd.Parameters.AddWithValue("@iRetVal", SqlDbType.Int).Direction = ParameterDirection.Output;
                    con.Open();
                    cmd.ExecuteNonQuery();
                    int ReturnVal = Convert.ToInt32(cmd.Parameters["@iRetVal"].Value); con.Close();
                    return ReturnVal;
                }
            }
            catch(Exception ex)
            {
                string x = ex.Message;
                return 0;
            }
        }

        public int Update(DesignationDto Model)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(HelperDAL.CONNECTIONSTRING))
                {
                    SqlCommand cmd = new SqlCommand(HelperDAL.SCHEMA + "USP_IUD_Designation", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Mode", 101);
                    cmd.Parameters.AddWithValue("@designationId", Model.DesignationID);
                    cmd.Parameters.AddWithValue("@designationName", Model.Designation);
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

        public int Delete(int DesignationID)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(HelperDAL.CONNECTIONSTRING))
                {
                    SqlCommand cmd = new SqlCommand(HelperDAL.SCHEMA + "USP_IUD_Designation", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Mode", 104);
                    cmd.Parameters.AddWithValue("@designationId", DesignationID);
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

        public List<DesignationDto> GetDetails( bool val)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(HelperDAL.CONNECTIONSTRING))
                {
                    SqlDataAdapter sda = new SqlDataAdapter(HelperDAL.SCHEMA + "USP_IUD_Designation", con);
                    sda.SelectCommand.CommandType = CommandType.StoredProcedure;
                    sda.SelectCommand.Parameters.AddWithValue("@Mode", 102);
                    sda.SelectCommand.Parameters.AddWithValue("@active", val);
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    if (dt != null && dt.Rows.Count > 0) return Utility.ConvertDataTable<DesignationDto>(dt);
                    else return null;
                }
            }
            catch(Exception ex)
            {
                string x = ex.Message;
                throw;
            }
        }

        public List<DesignationDto> GetDetailsById(int DesignationID)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(HelperDAL.CONNECTIONSTRING))
                {
                    SqlDataAdapter sda = new SqlDataAdapter(HelperDAL.SCHEMA + "USP_IUD_Designation", con);
                    sda.SelectCommand.CommandType = CommandType.StoredProcedure;
                    sda.SelectCommand.Parameters.AddWithValue("@Mode", 103);
                    sda.SelectCommand.Parameters.AddWithValue("@designationId", DesignationID);
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    if (dt != null && dt.Rows.Count > 0) return Utility.ConvertDataTable<DesignationDto>(dt);
                    else return null;
                }
            }
            catch(Exception ex)
            {
                string x = ex.Message;
                throw;
            }

        }

        public List<DesignationDto> GetByActive(int IsActive)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(HelperDAL.CONNECTIONSTRING))
                {
                    SqlDataAdapter sda = new SqlDataAdapter(HelperDAL.SCHEMA + "USP_IUD_Designation", con);
                    sda.SelectCommand.CommandType = CommandType.StoredProcedure;
                    sda.SelectCommand.Parameters.AddWithValue("@Mode", 105);
                    sda.SelectCommand.Parameters.AddWithValue("@active", IsActive);
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    if (dt != null && dt.Rows.Count > 0) return Utility.ConvertDataTable<DesignationDto>(dt);
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
