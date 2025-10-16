using Microsoft.AspNetCore.Mvc;

namespace back_end.Core.Entities
{
    public class Product : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
