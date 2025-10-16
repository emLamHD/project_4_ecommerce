using Microsoft.AspNetCore.Mvc;

namespace back_end.Core.UseCases.Auth
{
    public class IGetProductsUseCase : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
