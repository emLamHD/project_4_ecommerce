using Microsoft.AspNetCore.Mvc;

namespace back_end.Core.UseCases.Auth
{
    public interface CreateProductUseCase
    {
        Task<int> ExecuteAsync(CreateProductDto productData);
    }
}
