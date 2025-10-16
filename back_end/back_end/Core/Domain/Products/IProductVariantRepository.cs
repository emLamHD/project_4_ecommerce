using back_end.Core.Entities;

namespace back_end.Core.Domain.Products
{
    public interface IProductVariantRepository
    {
        Task<ProductVariant> GetVariantByIdAsync(int id);
        Task<IEnumerable<ProductVariant>> GetVariantsByProductIdAsync(int productId);
        Task<ProductVariant> AddVariantAsync(ProductVariant variant);
        Task<bool> UpdateVariantAsync(ProductVariant variant);
        Task<bool> DeleteVariantAsync(int id);
        Task<bool> UpdateStockAsync(int variantId, int changeAmount, string reason);
        Task<bool> IsVariantInStockAsync(int variantId, int quantity);
        Task<IEnumerable<ProductVariantCombination>> GetVariantCombinationsAsync(int variantId);
        Task<ProductVariant> GetVariantBySkuAsync(string sku);
    }
}
