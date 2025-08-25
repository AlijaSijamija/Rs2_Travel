using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Enums;
using Travel.Services.Domain.Base;

namespace Travel.Services.Database
{
    public class AgencyAvailableBus : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public BusType BusType { get; set; }
        public long AgencyId { get; set; }
        public Agency Agency { get; set; }
    }
}
