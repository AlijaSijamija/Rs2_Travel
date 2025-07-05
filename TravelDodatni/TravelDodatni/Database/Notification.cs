using static System.Collections.Specialized.BitVector32;

namespace TravelDodatni.Database
{
    public class Notification
    {
        public long Id { get; set; }
        public string Heading { get; set; }
        public string Content { get; set; }
        public long SectionId { get; set; }
        public Section Section { get; set; }
        public string AdminId { get; set; }
        public User Admin { get; set; }
    }
}
