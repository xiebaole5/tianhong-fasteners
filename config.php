<?php
/**
 * 天宏紧固件 - 外贸独立站
 * Tianhong Fasteners - Foreign Trade Website
 * 
 * 网站配置信息
 */

// 网站基本设置
define('SITE_NAME', '天宏紧固件 | 专业紧固件制造商');
define('SITE_TITLE', 'Custom Fasteners Manufacturer - High-Strength & Special Fasteners');
define('SITE_URL', 'https://www.yourdomain.com');
define('SITE_EMAIL', 'info@yourdomain.com');

// 公司信息
define('COMPANY_NAME', '浙江天宏紧固件有限公司');
define('COMPANY_NAME_EN', 'Zhejiang Tianhong Fasteners Co., Ltd.');
define('COMPANY_FOUNDED', '1987');
define('COMPANY_ADDRESS', 'No. 309, Weishi Road, Economic Development Zone, Yueqing City, Zhejiang Province, China');
define('COMPANY_PHONE', '+86 18958770140');
define('COMPANY_WHATSAPP', '+86 18958770140');
define('COMPANY_EMAIL', 'xiebaole5@gmail.com');

// 社交媒体链接
define('FACEBOOK_URL', 'https://www.facebook.com/yourcompany');
define('LINKEDIN_URL', 'https://www.linkedin.com/company/yourcompany');
define('YOUTUBE_URL', 'https://www.youtube.com/yourcompany');

// 产品分类
define('PRODUCT_CATEGORIES', [
    ['id' => 'long-fasteners', 'name' => 'Long Fasteners', 'name_cn' => '长紧固件', 'description' => 'Custom screws and bolts up to 300mm and above'],
    ['id' => 'high-strength', 'name' => 'High-Strength Fasteners', 'name_cn' => '高强度紧固件', 'description' => 'Strength classes up to 12.9 and above'],
    ['id' => 'special-head', 'name' => 'Special Head Designs', 'name_cn' => '特殊头型紧固件', 'description' => 'Developed from your drawings or clear pictures'],
    ['id' => 'composite', 'name' => 'Composite Structures', 'name_cn' => '复合结构紧固件', 'description' => 'Formed by cold forging plus CNC machining'],
    ['id' => 'u-bolts', 'name' => 'U-Bolts & Shaped Parts', 'name_cn' => 'U型螺栓及异形件', 'description' => 'Custom U-bolts and bent fasteners according to your requirements'],
    ['id' => 'automotive', 'name' => 'Automotive Fasteners', 'name_cn' => '汽车紧固件', 'description' => 'High-strength and special-structure screws and bolts'],
    ['id' => 'solar', 'name' => 'Solar Mounting Fasteners', 'name_cn' => '太阳能支架紧固件', 'description' => 'Fasteners for photovoltaic brackets and support structures'],
    ['id' => 'machinery', 'name' => 'Machinery Fasteners', 'name_cn' => '机械紧固件', 'description' => 'Custom fasteners and special-shaped parts for mechanical assemblies']
]);

// 服务行业
define('INDUSTRIES', [
    'Automotive Fasteners' => 'High-strength and special-structure screws and bolts',
    'Solar Mounting Systems' => 'Fasteners for photovoltaic brackets and support structures',
    'Machinery & Equipment' => 'Custom fasteners and special-shaped parts for mechanical assemblies',
    'Electric Meter Fasteners' => 'Precision and reliable screws and parts for electric meters'
]);

// 邮件发送配置
define('SMTP_HOST', 'smtp.yourdomain.com');
define('SMTP_PORT', 587);
define('SMTP_USER', 'info@yourdomain.com');
define('SMTP_PASS', 'your-email-password');
define('SMTP_FROM', 'info@yourdomain.com');
define('SMTP_FROM_NAME', SITE_NAME);

// 时区设置
date_default_timezone_set('Asia/Shanghai');
