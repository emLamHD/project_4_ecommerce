using Microsoft.AspNetCore.Mvc;

namespace back_end.Core.UseCases.Auth
{
    public interface ISearchProductsUseCase
    {
        Task<PagedResultDto<ProductSummaryDto>> ExecuteAsync(ProductSearchQueryDto query);
    }
    public class ProductSearchQueryDto
    {
        public int PageIndex { get; set; } = 1;
        public int PageSize { get; set; } = 10;
        public string SearchKeyword { get; set; }
        public int? CategoryId { get; set; }
        public int? BrandId { get; set; }
        public decimal? MinPrice { get; set; }
        public decimal? MaxPrice { get; set; }
        public string SortBy { get; set; }
        public string SortOrder { get; set; }
    }
}
