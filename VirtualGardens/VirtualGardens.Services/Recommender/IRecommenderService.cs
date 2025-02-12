using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;

namespace VirtualGardens.Services.Recommender
{
    public interface IRecommenderService
    {
        List<ProizvodiDTO> Recommend(int id);
        void TrainModel();
    }
}
