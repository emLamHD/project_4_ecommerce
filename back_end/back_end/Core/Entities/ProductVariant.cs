using Microsoft.AspNetCore.Mvc;

namespace back_end.Core.Entities
{
    public class ProductVariant
    {
        public int Id { get; set; }
        public int ProductId { get; set; }
        public decimal Price { get; set; }
        public decimal OldPrice { get; set; }
        public int Stock { get; set; } = 0;
        public string Sku { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public virtual Product Product { get; set; }
        public virtual ICollection<ProductVariantCombination> Combinations { get; set; } = new List<ProductVariantCombination>();
        public virtual ICollection<InventoryLog> InventoryLogs { get; set; } = new List<InventoryLog>();
    }
}