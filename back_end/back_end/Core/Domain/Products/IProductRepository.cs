using Microsoft.AspNetCore.Mvc;

namespace back_end.Core.Domain.Products
{
    public class IProductRepository : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
