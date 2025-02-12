using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs.StatisticsDTOs
{
    public class StatisticsDTO
    {
        public List<Buyers> kupci { get; set; }
        public List<Workers> workers { get; set; }
        public List<int> narudzbe { get; set; }
        public List<float> prihodi { get; set; }
    }
}
