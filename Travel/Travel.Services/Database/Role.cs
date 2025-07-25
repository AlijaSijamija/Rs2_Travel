﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Services.Database
{
    public class Role
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public virtual ICollection<User> Users { get; set; }
    }
}
