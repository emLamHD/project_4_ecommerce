using Microsoft.AspNetCore.Mvc;

namespace back_end.Core.Entities
{
    public class ProductAttribute
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public virtual ICollection<ProductAttributeValue> Values { get; set; } = new List<ProductAttributeValue>();
    }

    public class ProductAttributeValue
    {
        public int Id { get; set; }
        public int AttributeId { get; set; }
        public string Value { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public virtual ProductAttribute Attribute { get; set; }
        public virtual ICollection<ProductVariantCombination> VariantCombinations { get; set; } = new List<ProductVariantCombination>();
    }

    public class ProductVariantCombination
    {
        public int Id { get; set; }
        public int VariantId { get; set; }
        public int AttributeValueId { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public virtual ProductVariant Variant { get; set; }
        public virtual ProductAttributeValue AttributeValue { get; set; }
    }
}
