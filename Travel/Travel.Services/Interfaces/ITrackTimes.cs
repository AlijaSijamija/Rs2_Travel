﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Services.Interfaces
{
    internal interface ITrackTimes : ITrackCreationTime
    {
        DateTime? LastModified { get; set; }
    }
}
