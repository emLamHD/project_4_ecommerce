using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Core.Entities;
using Core.Interfaces;
using Infrastructure.Data;

namespace Infrastructure.Repositories
{
    public class ProductRepository : IProductRepository
    {
        private readonly AppDbContext _context;
        public ProductRepository(AppDbContext context)
        {
            _context = context;
        }

        //public async Task<Product> GetByIdAsync(int id)
        //{
        //    return await _context.Products
        //        .Include(p => p.Brand)
        //        .Include(p => p.Category)
        //        .FirstOrDefaultAsync(p => p.Id == id && !p.IsDeleted);
        //}

        //public async Task<IEnumerable<Product>> GetAllAsync()
        //{
        //    return await _context.Products
        //        .Include(p => p.Brand)
        //        .Include(p => p.Category)
        //        .Where(p => !p.IsDeleted)
        //        .ToListAsync();
        //}

        //public async Task<IEnumerable<Product>> GetByCategoryAsync(int categoryId)
        //{
        //    return await _context.Products
        //        .Include(p => p.Brand)
        //        .Where(p => p.CategoryId == categoryId && !p.IsDeleted)
        //        .ToListAsync();
        //}

        public async Task<Product> AddAsync(Product product)
        {
            _context.Products.Add(product);
            await _context.SaveChangesAsync();
            return product;
        }

        public async Task UpdateAsync(Product product)
        {
            _context.Products.Update(product);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var product = await _context.Products.FindAsync(id);
            if (product != null)
            {
                product.IsDeleted = true;
                _context.Products.Update(product);
                await _context.SaveChangesAsync();
            }
        }
    }
}
