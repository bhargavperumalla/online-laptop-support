namespace Attendance.Model
{
    public class MonthlyDto
    {
        public int EmpID { get; set; }
        public string Name { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public decimal WorkFromHome { get; set; }
        public string Duration { get; set; }
        public string Permission { get; set; }
        public decimal Leaves { get; set; }
        public decimal DurationMIN { get; set; }
        public decimal SL { get; set; }
        public decimal PL { get; set; }
        public decimal ML { get; set; }
        public decimal COFF { get; set; }
        public string WFH { get; set; }
        public decimal TotalDaysPresent { get; set; }
        public int Order { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public int EmployeeID { get; set; }
        public string InTime { get; set; }
        public string OutTime { get; set; }
        public string Date { get; set; }
    }
}
