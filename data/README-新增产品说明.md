# 如何新增产品（无价格展示）

产品数据存放在 **`data/products.json`**，不包含价格字段，仅用于展示。

**说明**：当前第 12 款产品「螺母螺栓组合」使用 Unsplash 免费图作为临时图（`image` 为网络 URL），正式上线建议替换为本地图并改为 `images/products/xxx.jpg`。

## 新增步骤

1. **准备图片**  
   将产品图片上传到 `images/products/` 目录，例如：`images/products/my-new-product.jpg`。

2. **编辑 `products.json`**  
   在 `products` 数组中新增一条，按下面格式填写（不要加 `price` 字段）：

```json
{
  "id": "p9",
  "name": "产品中文名",
  "nameEn": "Product Name in English",
  "description": "简短描述，用于卡片下方展示",
  "image": "images/products/my-new-product.jpg",
  "category": "hex-bolts",
  "sort": 9
}
```

- **id**：唯一标识，建议 `p1`、`p2`、`p10` 这样递增。  
- **category**：必须与 `categories` 里某一项的 `id` 一致（如 `hex-bolts`、`stainless`、`custom`、`special`）。  
- **sort**：数字越小越靠前显示。

3. **保存并部署**  
   保存 JSON 后，将整站重新上传到国内服务器或静态空间，刷新产品页即可看到新产品。

## 分类说明

当前可用分类 ID：

| id         | 中文     | 英文               |
|-----------|----------|--------------------|
| hex-bolts | 六角螺栓 | Hex Bolts          |
| stainless | 不锈钢件 | Stainless Steel    |
| custom    | 定制紧固件 | Custom Fasteners   |
| special   | 特殊/异形件 | Special & Shaped   |

如需新分类，在 `categories` 数组中增加一项，再在产品里使用新的 `id` 即可。
