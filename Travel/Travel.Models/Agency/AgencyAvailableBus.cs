using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Enums;

namespace Travel.Models.Agency
{
    public class AgencyAvailableBus
    {
        public long Id { get; set; }
        public BusType BusType { get; set; }
        public long AgencyId { get; set; }
    }
}
