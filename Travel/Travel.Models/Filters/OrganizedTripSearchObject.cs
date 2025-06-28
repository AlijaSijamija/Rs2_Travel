using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Models.Filters
{
    public class OrganizedTripSearchObject : BaseSearchObject
    {
        public long? AgencyId { get; set; }
        public bool? Future { get; set; }
    }
}
