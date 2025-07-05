namespace TravelDodatni.Database
{
    public class Section
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public ICollection<Notification> Notifications { get; set; }
    }
}
