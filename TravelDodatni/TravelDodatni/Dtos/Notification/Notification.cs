namespace TravelDodatni.Dtos.Notification
{
    public class Notification
    {
        public long Id { get; set; }
        public string Heading { get; set; }
        public string Content { get; set; }
        public long SectionId { get; set; }
        public string AdminId { get; set; }
    }
}
