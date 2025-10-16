using Microsoft.AspNetCore.Mvc;

namespace back_end.Core.Domain.Products
{
    public class IProductVariantRepository : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
