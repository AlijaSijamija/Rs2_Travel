using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Account;

namespace Travel.Models.Agency
{
    public class AgencyRequest
    {
        public string Web { get; set; }
        public string Name { get; set; }
        public string Contact { get; set; }
        public long CityId { get; set; }
        public string AdminId { get; set; }
    }
}
