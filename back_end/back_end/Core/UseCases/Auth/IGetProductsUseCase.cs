using Microsoft.AspNetCore.Mvc;

namespace back_end.Core.UseCases.Auth
{
    public interface IGetProductsUseCase
    {
        Task<PagedResultDto<ProductSummaryDto>> ExecuteAsync(ProductQueryDto query);
    }

    public class ProductQueryDto
    {
        public int PageIndex { get; set; } = 1;
        public int PageSize { get; set; } = 10;
        public int? CategoryId { get; set; }
        public int? BrandId { get; set; }
        public string SearchKeyword { get; set; }
        public string SortBy { get; set; } // Ví dụ: "name", "price", "purchase_count"
    }

    public class ProductSummaryDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string CategoryName { get; set; }
        public string BrandName { get; set; }
        public string DefaultImageUrl { get; set; }
        public decimal MinPrice { get; set; } // Giá thấp nhất trong các biến thể
        public decimal MaxPrice { get; set; } // Giá cao nhất trong các biến thể
        public double AverageRating { get; set; } // Điểm đánh giá trung bình
        public int TotalFeedbacks { get; set; }
        public int PurchaseCount { get; set; }
    }

    public class PagedResultDto<T>
    {
        public int TotalCount { get; set; }
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public IEnumerable<T> Items { get; set; }
    }
}
