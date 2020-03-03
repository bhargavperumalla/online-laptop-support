using Attendance.Model;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Attendance.DAL
{
    public  class EmployeesDAL
    {
        public List<EmployeesDto> Employees()
        {
            using (SqlConnection oSqlCon = new SqlConnection(HelperDAL.CONNECTIONSTRING))
            {
                SqlDataAdapter da = new SqlDataAdapter("ATT.USP_GetEmployees", oSqlCon);
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                da.SelectCommand.Parameters.AddWithValue("@iMode", 106);
                DataTable dt = new DataTable();
                da.Fill(dt);
                if (dt != null && dt.Rows.Count > 0) return Utility.ConvertDataTable<EmployeesDto>(dt).ToList();
                else return null;
            }
        }

        public int SaveEmployee(EmployeesDto model)
        {
            int res = 0;
            try
            {
                SqlConnection con = new SqlConnection(HelperDAL.CONNECTIONSTRING);
                SqlCommand cmd = new SqlCommand("ATT.USP_GetEmployees", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@iMode", 105);
                cmd.Parameters.AddWithValue("@nFirstName", model.FirstName);
                cmd.Parameters.AddWithValue("@nLastName", model.LastName);
                cmd.Parameters.AddWithValue("@iMapleID", model.MapleID);
                cmd.Parameters.AddWithValue("@iEmpBiometricID", model.BiometricID);
                cmd.Parameters.AddWithValue("@iEmpDepartmentID", model.DepartmentID);
                cmd.Parameters.AddWithValue("@iEmpDigID", model.DesignationID);
                cmd.Parameters.AddWithValue("@nEmpMail", model.Email);
                cmd.Parameters.AddWithValue("@nEmpPersonalEmail", model.PersonalEmail);
                cmd.Parameters.AddWithValue("@nEmpMob", model.Mobile);
                cmd.Parameters.AddWithValue("@nEmpGender", model.Gender);
                cmd.Parameters.AddWithValue("@nEmpDOB", model.DOB);
                cmd.Parameters.AddWithValue("@nEmpDOJ", model.DOJ);
                cmd.Parameters.AddWithValue("@nEmpMaritalStatus", model.MaritalStatus);
                cmd.Parameters.AddWithValue("@nEmpDOA", model.DOA);
                cmd.Parameters.AddWithValue("@nEmpBloodGroup", model.BloodGroup);
                cmd.Parameters.AddWithValue("@nEmpEmergencyContactPerson", model.EmergencyContactPerson);
                cmd.Parameters.AddWithValue("@nEmpEmergencyContactRelation", model.EmergencyContactRelation);
                cmd.Parameters.AddWithValue("@nEmpEmergencyContactNumber", model.EmergencyContactNumber);
                cmd.Parameters.AddWithValue("@nUserid", model.UserID);
                cmd.Parameters.AddWithValue("@nPassword", model.Password);
                cmd.Parameters.AddWithValue("@IsActive", model.IsActive);
                cmd.Parameters.AddWithValue("@IsAdmin", model.IsAdmin);
                cmd.Parameters.AddWithValue("@dtActiveDate", model.ActiveDate);
                cmd.Parameters.AddWithValue("@iRetVal", SqlDbType.Int).Direction = ParameterDirection.Output;
                con.Open();
                cmd.ExecuteNonQuery();
                res = (int)cmd.Parameters["@iRetVal"].Value;
                con.Close();
                return res;
            }
            catch
            {
                throw;
            }
        }

        public int UpdateEmployee(EmployeesDto model)
        {
            int res = 0;
            try
            {
                using (SqlConnection con = new SqlConnection(HelperDAL.CONNECTIONSTRING))
                {
                    SqlCommand cmd = new SqlCommand("ATT.USP_GetEmployees", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@iMode", 104);
                    cmd.Parameters.AddWithValue("@nFirstName", model.FirstName);
                    cmd.Parameters.AddWithValue("@nLastName", model.LastName);
                    cmd.Parameters.AddWithValue("@iEmpBiometricID", model.BiometricID);
                    cmd.Parameters.AddWithValue("@nEmpDOJ", model.DOJ);
                    cmd.Parameters.AddWithValue("@iEmpID", model.EmployeeID);
                    cmd.Parameters.AddWithValue("@iEmpDepartmentID", model.DepartmentID);
                    cmd.Parameters.AddWithValue("@iMapleID", model.MapleID);
                    cmd.Parameters.AddWithValue("@iEmpDigID", model.DesignationID);
                    cmd.Parameters.AddWithValue("@nEmpMail", model.Email);
                    cmd.Parameters.AddWithValue("@nEmpPersonalEmail", model.PersonalEmail);
                    cmd.Parameters.AddWithValue("@nEmpMob", model.Mobile);
                    cmd.Parameters.AddWithValue("@nEmpGender", model.Gender);
                    cmd.Parameters.AddWithValue("@nEmpDOB", model.DOB);
                    cmd.Parameters.AddWithValue("@nEmpMaritalStatus", model.MaritalStatus);
                    cmd.Parameters.AddWithValue("@nEmpDOA", model.DOA);
                    cmd.Parameters.AddWithValue("@nEmpBloodGroup", model.BloodGroup);
                    cmd.Parameters.AddWithValue("@nEmpEmergencyContactPerson", model.EmergencyContactPerson);
                    cmd.Parameters.AddWithValue("@nEmpEmergencyContactRelation", model.EmergencyContactRelation);
                    cmd.Parameters.AddWithValue("@nEmpEmergencyContactNumber", model.EmergencyContactNumber);
                    cmd.Parameters.AddWithValue("@iRetVal", SqlDbType.Int).Direction = ParameterDirection.Output;
                    con.Open();
                    cmd.ExecuteNonQuery();
                    res = (int)cmd.Parameters["@iRetVal"].Value;
                    con.Close();
                    return res;
                }
            }
            catch
            {
                throw;
            }
        }

        public EmployeesDto EmployeeById(int EmployeeId)
        {
            using (SqlConnection oSqlCon = new SqlConnection(HelperDAL.CONNECTIONSTRING))
            {
                SqlDataAdapter oSqlDa = new SqlDataAdapter("ATT.USP_GetEmployees", oSqlCon);
                oSqlDa.SelectCommand.CommandType = CommandType.StoredProcedure;
                oSqlDa.SelectCommand.Parameters.AddWithValue("@iMode", 102);
                oSqlDa.SelectCommand.Parameters.AddWithValue("@iEmpID", EmployeeId);
                DataTable oDtUser = new DataTable();
                oSqlDa.Fill(oDtUser);
                if (oDtUser != null && oDtUser.Rows.Count > 0) return Utility.ConvertDataTable<EmployeesDto>(oDtUser).ToList().FirstOrDefault();
                else return null;

            }
        }

        public List<EmployeesDto> EmployeesByStatus(bool isActive)
        {
            using (SqlConnection con = new SqlConnection(HelperDAL.CONNECTIONSTRING))
            {
                SqlDataAdapter da = new SqlDataAdapter("ATT.USP_GetEmployees", con);
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                da.SelectCommand.Parameters.AddWithValue("@iMode", 109);
                da.SelectCommand.Parameters.AddWithValue("@IsActive", isActive);
                DataTable dt = new DataTable();
                da.Fill(dt);
                if (dt != null && dt.Rows.Count > 0) return Utility.ConvertDataTable<EmployeesDto>(dt).ToList();
                else return null;

            }
        }

        public int DeleteEmployee(int EmployeeId)
        {
            try
            {
                SqlConnection oSqlCon = new SqlConnection(HelperDAL.CONNECTIONSTRING);
                int iOutput = 0;
                SqlCommand oSqlcmd = new SqlCommand("ATT.USP_GetEmployees", oSqlCon);
                oSqlcmd.CommandType = CommandType.StoredProcedure;
                oSqlCon.Open();
                oSqlcmd.Parameters.AddWithValue("@iMode", 110);
                oSqlcmd.Parameters.AddWithValue("@iEmpID", EmployeeId);
                oSqlcmd.Parameters.AddWithValue("@iRetVal", SqlDbType.Int).Direction = ParameterDirection.Output;
                oSqlcmd.ExecuteNonQuery();
                iOutput = (int)oSqlcmd.Parameters["@iRetVal"].Value;
                oSqlCon.Close();
                return iOutput;
            }
            catch
            {
                throw;
            }
        }


        public DataTable DailyAttendance(DateTime currentDateTime)
        {
            using (SqlConnection oSqlCon = new SqlConnection(HelperDAL.CONNECTIONSTRING))
            {
                SqlDataAdapter oSqlDa = new SqlDataAdapter("ATT.USP_GetAttendance", oSqlCon);
                oSqlDa.SelectCommand.CommandType = CommandType.StoredProcedure;
                oSqlDa.SelectCommand.Parameters.AddWithValue("@iMode", 101);
                oSqlDa.SelectCommand.Parameters.AddWithValue("@dtCurrentDateTime", currentDateTime);
                DataTable oDtUser = new DataTable();
                oSqlDa.Fill(oDtUser);
                return oDtUser;
            }
        }
        public List<AttendanceDto> GetEmployeeAttendanceDetails(int EmployeeId,DateTime createdDateTime)
        {
            using (SqlConnection oSqlCon = new SqlConnection(HelperDAL.CONNECTIONSTRING))
            {
                SqlDataAdapter oSqlDa = new SqlDataAdapter("ATT.USP_GetAttendance", oSqlCon);
                oSqlDa.SelectCommand.CommandType = CommandType.StoredProcedure;
                oSqlDa.SelectCommand.Parameters.AddWithValue("@iMode", 104);
                oSqlDa.SelectCommand.Parameters.AddWithValue("@iEmployeeID", EmployeeId);
                oSqlDa.SelectCommand.Parameters.AddWithValue("@dtCurrentDateTime", createdDateTime);
                DataSet oDtUser = new DataSet();
                oSqlDa.Fill(oDtUser);
                if (oDtUser != null && oDtUser.Tables[0].Rows.Count > 0) return Utility.ConvertDataTable<AttendanceDto>(oDtUser.Tables[0]);
                else return null;
            }
        }

        public int SaveAttendance(AttendanceList2 model)
        {
            int iRval = -1;

            using (SqlConnection oSqlCon = new SqlConnection(HelperDAL.CONNECTIONSTRING))
            {
                try
                {

                    oSqlCon.Open();
                    SqlTransaction oTran = oSqlCon.BeginTransaction();
                    for (int i = 0; i < model.values.Count(); i++)
                    {
                        SqlCommand oSqlDa = new SqlCommand("ATT.USP_GetAttendance", oSqlCon);
                        oSqlDa.CommandType = CommandType.StoredProcedure;
                        oSqlDa.Parameters.AddWithValue("@iMode", 102);
                        oSqlDa.Parameters.AddWithValue("@dtCurrentDateTime", model.values[i].CurrentDateTime);
                        oSqlDa.Parameters.AddWithValue("@iEmployeeID", model.values[i].EmployeeID);
                        if (model.values[i].InTime == null)
                        {
                            model.values[i].InTime = "12:00";
                        }
                        if (model.values[i].OutTime == null)
                        {
                            model.values[i].OutTime = "12:00";
                        }
                        if (model.values[i].LeaveType == null)
                        {
                            model.values[i].LeaveType = "-1";
                        }
                        if (model.values[i].PermissionHrs == null)
                        {
                            model.values[i].PermissionHrs = "12:00";
                        }
                        if (model.values[i].ExtraHrsWorked == null)
                        {
                            model.values[i].ExtraHrsWorked = "12:00";
                        }

                        oSqlDa.Parameters.AddWithValue("@tInTime", TimeSpan.Parse(model.values[i].InTime));
                        oSqlDa.Parameters.AddWithValue("@tOutTime", TimeSpan.Parse(model.values[i].OutTime));
                        if (model.values[i].Leave.ToString() != "-1")
                            oSqlDa.Parameters.AddWithValue("@iLeave", model.values[i].Leave);
                        if (model.values[i].LeaveType.ToString() != "-1")
                            oSqlDa.Parameters.AddWithValue("@vLeaveType", model.values[i].LeaveType.ToString());
                        if (model.values[i].PermissionHrs != null)
                            oSqlDa.Parameters.AddWithValue("@tPermission", model.values[i].PermissionHrs);
                        if (model.values[i].WFH.ToString() != "-1" || model.values[i].WFH.ToString() != "null")
                            oSqlDa.Parameters.AddWithValue("@vWFH", model.values[i].WFH);
                        if (model.values[i].ExtraHrsWorked != null)
                            oSqlDa.Parameters.AddWithValue("@ExtraHrsWorked", model.values[i].ExtraHrsWorked);
                        oSqlDa.Transaction = oTran;
                        oSqlDa.ExecuteNonQuery();
                    }
                    oTran.Commit();
                    iRval = 1;
                }

                catch (Exception ex)
                {
                    iRval = -1;
                }
                finally
                {
                    if (oSqlCon.State == ConnectionState.Open)
                        oSqlCon.Close();
                }

                return iRval;
            }
        }

        public int SaveEmployeeAttendance(AttendanceDto model, DateTime dtCurrentDateTime)
        {
            TimeSpan CurrrentTime = new TimeSpan(dtCurrentDateTime.Hour, dtCurrentDateTime.Minute, 0);

            using (SqlConnection oSqlCon = new SqlConnection(HelperDAL.CONNECTIONSTRING))
            {
                SqlCommand oSqlcmd = new SqlCommand("ATT.USP_GetAttendance", oSqlCon);
                oSqlcmd.CommandType = CommandType.StoredProcedure;
                oSqlCon.Open();
                oSqlcmd.Parameters.AddWithValue("@iEmployeeID", model.EmployeeID);
                oSqlcmd.Parameters.AddWithValue("@dtCurrentDateTime", dtCurrentDateTime);
                oSqlcmd.Parameters.AddWithValue("@iMode", 105);
                oSqlcmd.Parameters.AddWithValue("@vCreatedBy", model.CreatedBy);
                oSqlcmd.Parameters.AddWithValue("@tInTime", CurrrentTime);
                oSqlcmd.Parameters.AddWithValue("@dtCreatedDateTime", dtCurrentDateTime);
                oSqlcmd.Parameters.AddWithValue("@retVal", SqlDbType.Int).Direction = ParameterDirection.Output;
                oSqlcmd.ExecuteNonQuery();
                int ReturnVal = Convert.ToInt32(oSqlcmd.Parameters["@retVal"].Value);
                oSqlCon.Close();
                return ReturnVal;
            }
        }

        public int SaveEmployeeCheckOutTime(int iEmpid, string checkoutTime, string CheckOutDate, DateTime dtCurrentDateTime)
        {
            TimeSpan CurrrentTime = new TimeSpan(dtCurrentDateTime.Hour, dtCurrentDateTime.Minute, 0);

            using (SqlConnection oSqlCon = new SqlConnection(HelperDAL.CONNECTIONSTRING))
            {
                SqlCommand oSqlcmd = new SqlCommand("ATT.USP_GetAttendance", oSqlCon);
                oSqlcmd.CommandType = CommandType.StoredProcedure;
                oSqlCon.Open();
                oSqlcmd.Parameters.AddWithValue("@iMode", 106);
                oSqlcmd.Parameters.AddWithValue("@iEmployeeID", iEmpid);
                oSqlcmd.Parameters.AddWithValue("@dtPreviousDateTime", CheckOutDate);
                oSqlcmd.Parameters.AddWithValue("@tInTime", checkoutTime);
                oSqlcmd.Parameters.AddWithValue("@retVal", SqlDbType.Int).Direction = ParameterDirection.Output;
                oSqlcmd.ExecuteNonQuery();
                int ReturnVal = Convert.ToInt32(oSqlcmd.Parameters["@retVal"].Value);
                oSqlCon.Close();
                return ReturnVal;
            }
        }

        public List<AttendanceDto> GetCheckOutTime(int EmployeeId, DateTime createdDateTime)
        {
            try
            {
                using (SqlConnection oSqlCon = new SqlConnection(HelperDAL.CONNECTIONSTRING))
                {
                    SqlDataAdapter oSqlDa = new SqlDataAdapter("ATT.USP_GetAttendance", oSqlCon);
                    oSqlDa.SelectCommand.CommandType = CommandType.StoredProcedure;
                    oSqlDa.SelectCommand.Parameters.AddWithValue("@iMode", 109);
                    oSqlDa.SelectCommand.Parameters.AddWithValue("@iEmployeeID", EmployeeId);
                    oSqlDa.SelectCommand.Parameters.AddWithValue("@dtCurrentDateTime", createdDateTime);
                    DataSet oDtUser = new DataSet();
                    oSqlDa.Fill(oDtUser);
                    if (oDtUser != null && oDtUser.Tables[0].Rows.Count > 0) return Utility.ConvertDataTable<AttendanceDto>(oDtUser.Tables[0]);
                    else return null;
                }
            }
            catch (Exception ex)
            {
                string x = ex.Message;
                throw;
            }
        }

        public List<AnniversaryDto> GetAnniversary(string date)
        {
            using (SqlConnection oSqlCon = new SqlConnection(HelperDAL.CONNECTIONSTRING))
            {
                SqlDataAdapter da = new SqlDataAdapter("ATT.USP_GetAnniversary", oSqlCon);
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                da.SelectCommand.Parameters.AddWithValue("@iMode", 100);
                da.SelectCommand.Parameters.AddWithValue("@Date", date);
                DataTable dt = new DataTable();
                da.Fill(dt);
                if (dt != null && dt.Rows.Count > 0) return Utility.ConvertDataTable<AnniversaryDto>(dt).ToList();
                else return null;
            }
        }

    }
}
