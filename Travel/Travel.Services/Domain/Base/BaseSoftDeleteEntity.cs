using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Services.Interfaces;

namespace Travel.Services.Domain.Base
{
    public class BaseSoftDeleteEntity : BaseEntity, ISoftDelete
    {
        public DateTime? DeletedAt { get; set; }

        public bool IsDeleted => DeletedAt.HasValue;
    }
}
