﻿using Travel.Services.Domain.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Services.Database
{
    public class Notification : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public string Heading { get; set; }
        public string Content  { get; set; }
        public long SectionId { get; set; }
        public Section Section { get; set; }
        public string AdminId { get; set; }
        public User Admin { get; set; }
        public virtual ICollection<ReadNotification> ReadNotifications { get; set; } = new List<ReadNotification>();
    }
}
