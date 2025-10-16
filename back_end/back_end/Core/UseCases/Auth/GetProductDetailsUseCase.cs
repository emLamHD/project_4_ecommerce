using Microsoft.AspNetCore.Mvc;

namespace back_end.Core.UseCases.Auth
{
    public interface GetProductDetailsUseCase
    {
        Task<ProductDetailDto> ExecuteAsync(int productId);
    }
    public class ProductDetailDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string CategoryName { get; set; }
        public double AverageRating { get; set; }
        public int TotalFeedbacks { get; set; }
        public List<VariantDetailDto> Variants { get; set; }
        public List<string> ImageUrls { get; set; }
    }
}
