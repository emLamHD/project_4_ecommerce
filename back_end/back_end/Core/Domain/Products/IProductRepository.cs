using back_end.Core.Entities;

namespace back_end.Core.Domain.Products
{
    public interface IProductRepository
    {
        Task<Product> GetProductByIdAsync(int id);
        Task<IEnumerable<Product>> GetProductsAsync(int pageIndex, int pageSize, int? categoryId, int? brandId, string searchKeyword);
        Task<Product> AddProductAsync(Product product);
        Task<bool> UpdateProductAsync(Product product);
        Task<bool> SoftDeleteProductAsync(int id, int updatedByUserId);
        Task<bool> IncrementPurchaseCountAsync(int productId, int quantity);
        Task<IEnumerable<ProductImage>> GetProductImagesAsync(int productId);
        Task<IEnumerable<Product>> GetTopSellingProductsAsync(int count);
        Task<(double AverageStar, int TotalFeedbackCount)> GetProductRatingSummaryAsync(int productId);
    }
}
