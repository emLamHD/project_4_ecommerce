using Microsoft.AspNetCore.Mvc;

namespace back_end.Core.UseCases.Auth
{
    public interface UpdateProductUseCase
    {
        Task<bool> ExecuteAsync(int productId, UpdateProductDto productData, int updatingUserId);
    }
}
