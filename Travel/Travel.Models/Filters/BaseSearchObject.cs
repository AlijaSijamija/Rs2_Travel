﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Models.Filters
{
    public class BaseSearchObject
    {
        public int? Page { get; set; }
        public int? PageSize { get; set; }
    }
}
