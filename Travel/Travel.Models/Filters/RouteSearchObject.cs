using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Models.Filters
{
    public class RouteSearchObject : BaseSearchObject
    {
        public long? FromCityId { get; set; }
        public long? ToCityId { get; set; }
    }
}
