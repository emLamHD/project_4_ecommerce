using Microsoft.AspNetCore.Mvc;

namespace back_end.Core.UseCases.Auth
{
    public interface ICreateProductUseCase
    {
        Task<int> ExecuteAsync(CreateProductDto productData);
    }

    public class CreateProductDto
    {
        public string Name { get; set; }
        public string Description { get; set; }
        public string Specification { get; set; }
        public int BrandId { get; set; }
        public int CategoryId { get; set; }
        public int CreatedByUserId { get; set; }
        public List<CreateVariantDto> Variants { get; set; }
        public List<string> ImageUrls { get; set; }
    }

    public class CreateVariantDto
    {
        public decimal Price { get; set; }
        public decimal OldPrice { get; set; }
        public int Stock { get; set; }
        public string Sku { get; set; }
        public List<int> AttributeValueIds { get; set; }
    }
}