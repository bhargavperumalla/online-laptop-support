namespace Attendance.Models
{
    public class BiometricReport
    {
        public int Id { get; set; }
        public string EmployeeID { get; set; }
        public string Date { get; set; }
        public string Name { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public string Duration { get; set; }
    }
}