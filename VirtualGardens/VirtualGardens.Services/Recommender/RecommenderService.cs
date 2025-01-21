using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Trainers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.Recommender
{
    public class RecommenderService : IRecommenderService
    {
        _210011Context _context;
        IMapper _mapper;
        static MLContext mLContext = null;
        static object isLocked = new object();
        static ITransformer model = null;

        private const string ModelFilePath = "set-model.zip";
        public RecommenderService(_210011Context context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }
        public List<ProizvodiDTO> Recommend(int id)
        {
            if (mLContext == null)
            {
                lock (isLocked)
                {
                    mLContext = new MLContext();
                    if(File.Exists(ModelFilePath))
                    {
                        using(var stream = new FileStream(ModelFilePath, FileMode.Open, FileAccess.Read, FileShare.Read))
                        {
                            model = mLContext.Model.Load(stream, out var modelInputSchema);
                        }
                    }
                    else
                    {
                        TrainModel();
                    }

                }


            }

            var products = _context.Proizvodis.Where(x => x.ProizvodId != id).Include(x => x.VrstaProizvoda).ToList();
            var predictionResult = new List<(Database.Proizvodi, float)>();

            foreach (var product in products)
            {
                var predictionEngine = mLContext.Model.CreatePredictionEngine<ProductEntry, Copurchase_prediction>(model);
                var prediction = predictionEngine.Predict(new ProductEntry()
                {
                    ProductID = (uint)id,
                    CoPurchaseProductID = (uint)product.ProizvodId
                });

                predictionResult.Add(new(product, prediction.Score));
            }

            var finalResult = predictionResult.Where(x => x.Item1.VrstaProizvoda.Naziv == "Prihrana").OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(1).ToList();
            finalResult.Add(predictionResult.Where(x => x.Item1.VrstaProizvoda.Naziv == "Tlo").OrderByDescending(x => x.Item2).Select(x => x.Item1).FirstOrDefault()!);

            return _mapper.Map<List<ProizvodiDTO>>(finalResult);
        }

        public void TrainModel()
        {
            if(mLContext==null)
                mLContext = new MLContext();

            var tmpData = _context.Setovis.Include(x => x.ProizvodiSets).ToList();
            var data = new List<ProductEntry>();
            foreach (var item in tmpData)
            {
                if (item.ProizvodiSets.Count > 1)
                {
                    var distinctIdemId = item.ProizvodiSets.Select(x => x.ProizvodId).Distinct().ToList();

                    distinctIdemId.ForEach(y =>
                    {
                        var relatedItems = item.ProizvodiSets.Where(t => t.ProizvodId != y);

                        foreach (var relatedItem in relatedItems)
                        {
                            data.Add(new ProductEntry()
                            {
                                ProductID = (uint)y,
                                CoPurchaseProductID = (uint)relatedItem.ProizvodId
                            });
                        }
                    });
                }
            }

            var trainData = mLContext.Data.LoadFromEnumerable(data);
            MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
            options.MatrixColumnIndexColumnName = nameof(ProductEntry.ProductID);
            options.MatrixRowIndexColumnName = nameof(ProductEntry.CoPurchaseProductID);
            options.LabelColumnName = "Label";
            options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
            options.Alpha = 0.01;
            options.Lambda = 0.025;
            options.NumberOfIterations = 100;
            options.C = 0.00001;

            var est = mLContext.Recommendation().Trainers.MatrixFactorization(options);
            model = est.Fit(trainData);
            using (var stream = new FileStream(ModelFilePath, FileMode.Create, FileAccess.Write, FileShare.Write))
            {
                mLContext.Model.Save(model, trainData.Schema, stream);
            }


        }
    }
}
