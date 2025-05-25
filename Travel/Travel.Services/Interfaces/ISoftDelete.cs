using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Services.Interfaces
{
    public interface ISoftDelete
    {
        DateTime? DeletedAt { get; set; }
    }
}
