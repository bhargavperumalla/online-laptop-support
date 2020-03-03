using Attendance.Model;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace Attendance.DAL
{
    public class UserDAL
    {
        public int Resetpassword(int iEmployeeID)
        {
            try
            {
                int iOutput = 0;
                SqlConnection oCon = new SqlConnection(HelperDAL.CONNECTIONSTRING);
                oCon.Open();
                SqlCommand oCmd = new SqlCommand("ATT.USP_ResetPassword", oCon);
                oCmd.CommandType = CommandType.StoredProcedure;
                oCmd.Parameters.AddWithValue("@iMode", 101);
                oCmd.Parameters.AddWithValue("@iEmpID", iEmployeeID);
                oCmd.Parameters.AddWithValue("@iRetVal", SqlDbType.Int).Direction = ParameterDirection.Output;
                oCmd.ExecuteNonQuery();
                iOutput = (int)oCmd.Parameters["@iRetVal"].Value;
                oCon.Close();
                return iOutput;
            }
            catch
            {
                throw;
            }
        }

        public int ChangePassword(int iEmployeeID, string sOldPassword, string sNewPassword)
        {
            try
            {
                int iOutput = 0;
                SqlConnection oCon = new SqlConnection(HelperDAL.CONNECTIONSTRING);
                oCon.Open();
                SqlCommand oCmd = new SqlCommand("ATT.USP_GetEmployees", oCon);
                oCmd.CommandType = CommandType.StoredProcedure;
                oCmd.Parameters.AddWithValue("@iMode", 107);
                oCmd.Parameters.AddWithValue("@iEmpID", iEmployeeID);
                oCmd.Parameters.AddWithValue("@nPassword", sNewPassword);
                oCmd.Parameters.AddWithValue("@vOldPassword", sOldPassword);
                oCmd.Parameters.AddWithValue("@iRetVal", SqlDbType.Int).Direction = ParameterDirection.Output;
                oCmd.ExecuteNonQuery();
                iOutput = (int)oCmd.Parameters["@iRetVal"].Value;
                oCon.Close();
                return iOutput;
            }
            catch
            {
                throw;
            }
        }
        public List<EmployeesDto> AutheticateUser(string sUserId, string sPassword)
        {
            using (SqlConnection oSqlCon = new SqlConnection(HelperDAL.CONNECTIONSTRING))
            {
                SqlDataAdapter da = new SqlDataAdapter("ATT.USP_GetUsers", oSqlCon);
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                da.SelectCommand.Parameters.AddWithValue("@iMode", 101);
                da.SelectCommand.Parameters.AddWithValue("@vUserID", sUserId);
                da.SelectCommand.Parameters.AddWithValue("@vPassword", sPassword);
                DataTable dt = new DataTable();
                da.Fill(dt);
                if (dt.Rows.Count > 0) return Utility.ConvertDataTable<EmployeesDto>(dt);
                else return new List<EmployeesDto>();
            }
        }

    }
}
