<?php
/**
 * 网站头部文件
 * Header Component
 */
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="description" content="<?php echo SITE_TITLE; ?> - Professional manufacturer of high-difficulty and special fasteners in China">
    <meta name="keywords" content="fasteners, bolts, nuts, screws, custom fasteners, China manufacturer, high-strength fasteners">
    <meta name="author" content="<?php echo COMPANY_NAME; ?>">
    
    <!-- Open Graph Meta Tags -->
    <meta property="og:title" content="<?php echo SITE_NAME; ?>">
    <meta property="og:description" content="<?php echo SITE_TITLE; ?>">
    <meta property="og:type" content="website">
    <meta property="og:url" content="<?php echo SITE_URL; ?>">
    <meta property="og:image" content="<?php echo SITE_URL; ?>/images/og-image.jpg">
    
    <!-- Twitter Card Meta Tags -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="<?php echo SITE_NAME; ?>">
    <meta name="twitter:description" content="<?php echo SITE_TITLE; ?>">
    
    <title><?php echo isset($page_title) ? $page_title . ' | ' . SITE_NAME : SITE_NAME; ?></title>
    
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="/favicon.ico">
    <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- AOS Animation Library -->
    <link rel="stylesheet" href="https://unpkg.com/aos@2.3.1/dist/aos.css">
    
    <!-- Main Stylesheet -->
    <link rel="stylesheet" href="css/style.css">
    
    <!--[if lt IE 9]>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body <?php body_class(); ?>>
    <!-- Preloader -->
    <div class="preloader">
        <div class="preloader-content">
            <div class="preloader-spinner">
                <div class="spinner"></div>
            </div>
            <div class="preloader-text">Loading...</div>
        </div>
    </div>

    <!-- Top Bar -->
    <div class="top-bar">
        <div class="container">
            <div class="top-bar-content">
                <div class="top-bar-left">
                    <span class="top-bar-item">
                        <i class="fas fa-map-marker-alt"></i>
                        <?php echo COMPANY_ADDRESS; ?>
                    </span>
                </div>
                <div class="top-bar-right">
                    <a href="tel:<?php echo COMPANY_PHONE; ?>" class="top-bar-item">
                        <i class="fas fa-phone-alt"></i>
                        <?php echo COMPANY_PHONE; ?>
                    </a>
                    <a href="mailto:<?php echo COMPANY_EMAIL; ?>" class="top-bar-item">
                        <i class="fas fa-envelope"></i>
                        <?php echo COMPANY_EMAIL; ?>
</a>
                    <a href="<?php echo FACEBOOK_URL; ?>" target="_blank" class="top-bar-item social-link">
                        <i class="fab fa-facebook-f"></i>
                    </a>
                    <a href="<?php echo LINKEDIN_URL; ?>" target="_blank" class="top-bar-item social-link">
                        <i class="fab fa-linkedin-in"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Header -->
    <header class="main-header" id="mainHeader">
        <div class="container">
            <div class="header-content">
                <!-- Logo -->
                <a href="index.php" class="logo" data-aos="fade-right">
                    <div class="logo-icon">
                        <i class="fas fa-cogs"></i>
                    </div>
                    <div class="logo-text">
                        <span class="logo-name"><?php echo COMPANY_NAME; ?></span>
                        <span class="logo-tagline"><?php echo COMPANY_NAME_EN; ?></span>
                    </div>
                </a>

                <!-- Mobile Menu Toggle -->
                <button class="mobile-menu-toggle" id="mobileMenuToggle" aria-label="Toggle menu">
                    <span class="hamburger-line"></span>
                    <span class="hamburger-line"></span>
                    <span class="hamburger-line"></span>
                </button>

                <!-- Main Navigation -->
                <nav class="main-nav" id="mainNav">
                    <ul class="nav-menu">
                        <li class="nav-item <?php echo basename($_SERVER['PHP_SELF']) == 'index.php' ? 'active' : ''; ?>">
                            <a href="index.php" class="nav-link">
                                <i class="fas fa-home"></i>
                                HOME
                            </a>
                        </li>
                        <li class="nav-item has-dropdown <?php echo basename($_SERVER['PHP_SELF']) == 'products.php' ? 'active' : ''; ?>">
                            <a href="products.php" class="nav-link">
                                <i class="fas fa-box"></i>
                                PRODUCTS
                                <i class="fas fa-chevron-down dropdown-arrow"></i>
                            </a>
                            <ul class="dropdown-menu">
                                <?php foreach (PRODUCT_CATEGORIES as $category): ?>
                                <li>
                                    <a href="products.php?category=<?php echo $category['id']; ?>">
                                        <?php echo $category['name']; ?>
                                    </a>
                                </li>
                                <?php endforeach; ?>
                            </ul>
                        </li>
                        <li class="nav-item <?php echo basename($_SERVER['PHP_SELF']) == 'about.php' ? 'active' : ''; ?>">
                            <a href="about.php" class="nav-link">
                                <i class="fas fa-building"></i>
                                ABOUT US
                            </a>
                        </li>
                        <li class="nav-item <?php echo basename($_SERVER['PHP_SELF']) == 'contact.php' ? 'active' : ''; ?>">
                            <a href="contact.php" class="nav-link">
                                <i class="fas fa-envelope"></i>
                                CONTACT US
                            </a>
                        </li>
                    </ul>
                </nav>

                <!-- Header CTA Button -->
                <div class="header-cta" data-aos="fade-left">
                    <a href="contact.php" class="btn btn-primary">
                        <i class="fas fa-paper-plane"></i>
                        Get Quote
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- Page Banner -->
    <?php if (isset($show_banner) && $show_banner): ?>
    <section class="page-banner" style="background-image: url('images/page-banner.jpg');">
        <div class="page-banner-overlay"></div>
        <div class="container">
            <div class="page-banner-content" data-aos="fade-up">
                <h1><?php echo $page_title ?? 'Our Products'; ?></h1>
                <div class="breadcrumb">
                    <a href="index.php">Home</a>
                    <span class="breadcrumb-separator">/</span>
                    <span class="current"><?php echo $page_title ?? 'Products'; ?></span>
                </div>
            </div>
        </div>
    </section>
    <?php endif; ?>

    <!-- Main Content -->
    <main class="main-content">
