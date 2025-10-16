using Microsoft.AspNetCore.Mvc;

namespace back_end.Core.Entities
{
    public class ProductVariant : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
