using Microsoft.AspNetCore.Mvc;

namespace back_end.Core.Entities
{
    public class ProductAttribute : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
