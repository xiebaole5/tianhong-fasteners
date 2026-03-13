# ERP Version Change Notice / ERP 版本变更说明

## English

### Summary

ERP-related settings in this repository have been reviewed and set to **v1.0.0** (the stable baseline version). A new ERP version is planned for a future update.

### Current ERP Version

| Setting | Value |
|---------|-------|
| ERP Version | `v1.0.0` |
| Status | Stable baseline |
| Data Source | `data/官网产品清单_从ERP导出.txt` |

### What Changed

- Reviewed all ERP-related references in the repository.
- The product data exported from ERP (`data/官网产品清单_从ERP导出.txt`) and its usage guide (`data/官网产品清单_使用说明.md`) are based on the ERP `material` table at version v1.0.0.
- No ERP version upgrade or breaking configuration changes have been applied at this time.

### Planned New Version

A new ERP version is under preparation. When it is ready, the following steps should be taken:

1. Re-export the product list from the new ERP version using the same rules (see `data/官网产品清单_使用说明.md` for column definitions).
2. Update the `data/官网产品清单_从ERP导出.txt` file with the new export.
3. Verify HS codes, tax-rebate rates, and any new fields added in the new ERP version.
4. Update this document to reflect the new ERP version number.
5. Run `scripts/verify_erp_version.sh` to confirm all version references are consistent.

### How to Revert to v1.0.0

If the new version causes issues, revert by checking out the last commit tagged `erp-v1.0.0` or by restoring the `data/` directory files from the previous state:

```bash
git checkout erp-v1.0.0 -- data/
```

---

## 中文

### 摘要

本仓库中与 ERP 相关的设定已审查完毕，当前统一设为 **v1.0.0**（稳定基线版本）。后续将发布新版本 ERP，届时需按下方步骤进行升级。

### 当前 ERP 版本

| 设置项 | 值 |
|-------|----|
| ERP 版本 | `v1.0.0` |
| 状态 | 稳定基线 |
| 数据来源 | `data/官网产品清单_从ERP导出.txt` |

### 变更内容

- 已检查仓库中所有与 ERP 相关的引用。
- 官网产品清单（`data/官网产品清单_从ERP导出.txt`）及其使用说明（`data/官网产品清单_使用说明.md`）均基于 ERP `material` 表 v1.0.0 导出，保持不变。
- 本次未进行 ERP 版本升级或破坏性配置变更。

### 新版本计划

新版 ERP 正在准备中。待新版本就绪后，请按以下步骤操作：

1. 按相同规则从新版 ERP 重新导出产品清单（列定义详见 `data/官网产品清单_使用说明.md`）。
2. 用新导出文件替换 `data/官网产品清单_从ERP导出.txt`。
3. 核实 HS 编码、退税率及新版 ERP 中新增字段。
4. 更新本文档中的 ERP 版本号。
5. 运行 `scripts/verify_erp_version.sh` 确认所有版本引用一致。

### 回退到 v1.0.0

如果新版本出现问题，可通过以下命令回退到 v1.0.0：

```bash
git checkout erp-v1.0.0 -- data/
```

---

*Last updated: 2026-03-13 | 最后更新：2026年3月13日*
