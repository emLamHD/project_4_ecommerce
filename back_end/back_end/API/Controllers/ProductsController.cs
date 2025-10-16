using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using Core.Entities;
using Core.Interfaces;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductsController : ControllerBase
    {
        private readonly IProductRepository _productRepository;

        public ProductsController(IProductRepository productRepository)
        {
            _productRepository = productRepository;
        }

        //[HttpGet]
        //public async Task<IActionResult> GetAll()
        //{
        //    var products = await _productRepository.GetAllAsync();
        //    return Ok(products);
        //}

        //[HttpGet("{id}")]
        //public async Task<IActionResult> GetById(int id)
        //{
        //    var product = await _productRepository.GetByIdAsync(id);
        //    if (product == null) return NotFound();
        //    return Ok(product);
        //}

        //[HttpGet("category/{categoryId}")]
        //public async Task<IActionResult> GetByCategory(int categoryId)
        //{
        //    var products = await _productRepository.GetByCategoryAsync(categoryId);
        //    return Ok(products);
        //}

        //[HttpPost]
        //public async Task<IActionResult> Create(Product product)
        //{
        //    var newProduct = await _productRepository.AddAsync(product);
        //    return CreatedAtAction(nameof(GetById), new { id = newProduct.Id }, newProduct);
        //}

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, Product product)
        {
            if (id != product.Id) return BadRequest();
            await _productRepository.UpdateAsync(product);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            await _productRepository.DeleteAsync(id);
            return NoContent();
        }
    }
}
