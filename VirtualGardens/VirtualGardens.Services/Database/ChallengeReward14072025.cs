using VirtualGardens.Models;

namespace VirtualGardens.Services.Database
{
    public class ChallengeReward14072025
    {
        public int Id { get; set; }
        public int IzazovId { get; set; }
        public virtual Challenge14072025 Izazov { get; set; }
        public string Naziv { get; set; }
        public Nagrada Tip { get; set; }
        public int BrojPonavljanja { get; set; }
    }
}
