using System.Collections.Generic;

namespace Attendance.Model
{
    public class HolidaysDto
    {
        public string Year { get; set; }
        public List<Holidays> HolidaysList { get; set; }
    }

    public class Holidays
    {
        public int Sno { get; set; }
        public string Year { get; set; }
        public string Date { get; set; }
        public string Day { get; set; }
        public string Festival { get; set; }
    }
}
