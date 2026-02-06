<?php
/**
 * 网站底部文件
 * Footer Component
 */
?>
    </main>

    <!-- Footer -->
    <footer class="main-footer">
        <!-- Footer Top Section -->
        <div class="footer-top">
            <div class="container">
                <div class="footer-grid">
                    <!-- Company Info -->
                    <div class="footer-widget company-info" data-aos="fade-up" data-aos-delay="100">
                        <div class="footer-logo">
                            <div class="logo-icon">
                                <i class="fas fa-cogs"></i>
                            </div>
                            <div class="logo-text">
                                <span class="logo-name"><?php echo COMPANY_NAME; ?></span>
                            </div>
                        </div>
                        <p class="company-description">
                            Founded in <?php echo COMPANY_FOUNDED; ?>, we are a professional manufacturer of high-difficulty and special fasteners. 
                            With over 30 years of experience, we focus on custom fastening solutions for demanding applications.
                        </p>
                        <div class="social-links">
                            <a href="<?php echo FACEBOOK_URL; ?>" target="_blank" class="social-link" aria-label="Facebook">
                                <i class="fab fa-facebook-f"></i>
                            </a>
                            <a href="<?php echo LINKEDIN_URL; ?>" target="_blank" class="social-link" aria-label="LinkedIn">
                                <i class="fab fa-linkedin-in"></i>
                            </a>
                            <a href="<?php echo YOUTUBE_URL; ?>" target="_blank" class="social-link" aria-label="YouTube">
                                <i class="fab fa-youtube"></i>
                            </a>
                            <a href="https://wa.me/<?php echo COMPANY_WHATSAPP; ?>" target="_blank" class="social-link" aria-label="WhatsApp">
                                <i class="fab fa-whatsapp"></i>
                            </a>
                        </div>
                    </div>

                    <!-- Quick Links -->
                    <div class="footer-widget quick-links" data-aos="fade-up" data-aos-delay="200">
                        <h4 class="footer-title">Quick Links</h4>
                        <ul class="footer-links">
                            <li><a href="index.php"><i class="fas fa-chevron-right"></i> Home</a></li>
                            <li><a href="products.php"><i class="fas fa-chevron-right"></i> Products</a></li>
                            <li><a href="about.php"><i class="fas fa-chevron-right"></i> About Us</a></li>
                            <li><a href="contact.php"><i class="fas fa-chevron-right"></i> Contact Us</a></li>
                        </ul>
                    </div>

                    <!-- Product Categories -->
                    <div class="footer-widget products" data-aos="fade-up" data-aos-delay="300">
                        <h4 class="footer-title">Product Categories</h4>
                        <ul class="footer-links">
                            <?php foreach (array_slice(PRODUCT_CATEGORIES, 0, 5) as $category): ?>
                            <li>
                                <a href="products.php?category=<?php echo $category['id']; ?>">
                                    <i class="fas fa-chevron-right"></i>
                                    <?php echo $category['name']; ?>
                                </a>
                            </li>
                            <?php endforeach; ?>
                        </ul>
                    </div>

                    <!-- Contact Info -->
                    <div class="footer-widget contact-info" data-aos="fade-up" data-aos-delay="400">
                        <h4 class="footer-title">Contact Us</h4>
                        <ul class="contact-list">
                            <li>
                                <i class="fas fa-map-marker-alt"></i>
                                <span><?php echo COMPANY_ADDRESS; ?></span>
                            </li>
                            <li>
                                <i class="fas fa-phone-alt"></i>
                                <a href="tel:<?php echo COMPANY_PHONE; ?>"><?php echo COMPANY_PHONE; ?></a>
                            </li>
                            <li>
                                <i class="fab fa-whatsapp"></i>
                                <a href="https://wa.me/<?php echo COMPANY_WHATSAPP; ?>" target="_blank">
                                    <?php echo COMPANY_WHATSAPP; ?> (WhatsApp)
                                </a>
                            </li>
                            <li>
                                <i class="fas fa-envelope"></i>
                                <a href="mailto:<?php echo COMPANY_EMAIL; ?>"><?php echo COMPANY_EMAIL; ?></a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer Bottom Section -->
        <div class="footer-bottom">
            <div class="container">
                <div class="footer-bottom-content">
                    <div class="copyright">
                        <p>
                            &copy; 2026 Zhejiang Tianhong Fasteners Co., Ltd. All Rights Reserved.
                        </p>
                    </div>
                    <div class="footer-bottom-links">
                        <a href="privacy.php">Privacy Policy</a>
                        <span class="separator">|</span>
                        <a href="terms.php">Terms of Service</a>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <!-- Back to Top Button -->
    <button class="back-to-top" id="backToTop" aria-label="Back to top">
        <i class="fas fa-arrow-up"></i>
    </button>

    <!-- WhatsApp Float Button -->
    <a href="https://wa.me/<?php echo COMPANY_WHATSAPP; ?>" class="whatsapp-float" target="_blank" aria-label="Contact via WhatsApp">
        <i class="fab fa-whatsapp"></i>
    </a>

    <!-- Inquiry Modal -->
    <div class="modal fade" id="inquiryModal" tabindex="-1" role="dialog" aria-labelledby="inquiryModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="inquiryModalLabel">
                        <i class="fas fa-paper-plane"></i>
                        Send Inquiry
                    </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="inquiryForm" class="inquiry-form">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="inquiryName">Your Name *</label>
                                <input type="text" class="form-control" id="inquiryName" name="name" required>
                            </div>
                            <div class="form-group">
                                <label for="inquiryEmail">Email Address *</label>
                                <input type="email" class="form-control" id="inquiryEmail" name="email" required>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="inquiryPhone">Phone Number</label>
                                <input type="tel" class="form-control" id="inquiryPhone" name="phone">
                            </div>
                            <div class="form-group">
                                <label for="inquiryCompany">Company Name</label>
                                <input type="text" class="form-control" id="inquiryCompany" name="company">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inquiryProduct">Product Interest</label>
                            <select class="form-control" id="inquiryProduct" name="product">
                                <option value="">Select a product category...</option>
                                <?php foreach (PRODUCT_CATEGORIES as $category): ?>
                                <option value="<?php echo $category['name']; ?>">
                                    <?php echo $category['name']; ?>
                                </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="inquiryMessage">Your Message *</label>
                            <textarea class="form-control" id="inquiryMessage" name="message" rows="4" required 
                                placeholder="Please describe your requirements, including quantity, specifications, etc."></textarea>
                        </div>
                        <div class="form-group">
                            <label for="inquiryFile">Attach File (Optional)</label>
                            <input type="file" class="form-control-file" id="inquiryFile" name="file" accept=".pdf,.doc,.docx,.jpg,.png">
                        </div>
                        <button type="submit" class="btn btn-primary btn-block">
                            <i class="fas fa-paper-plane"></i>
                            Send Inquiry
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://code.jquery.com/jquery-3.6.3.min.js" 
            integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" 
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" 
            integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" 
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js" 
            integrity="sha384-+sLIOodYLS7CIJrQpWdK2MAuPbstNV8ityt0bRMV6P6QYCkK6P6W6Q==" 
            crossorigin="anonymous"></script>
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script src="js/main.js"></script>
    
    <!-- Structured Data for SEO -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "Organization",
        "name": "<?php echo COMPANY_NAME; ?>",
        "alternateName": "<?php echo COMPANY_NAME_EN; ?>",
        "url": "<?php echo SITE_URL; ?>",
        "logo": "<?php echo SITE_URL; ?>/images/logo.png",
        "description": "Professional manufacturer of high-difficulty and special fasteners since <?php echo COMPANY_FOUNDED; ?>",
        "foundingDate": "<?php echo COMPANY_FOUNDED; ?>",
        "address": {
            "@type": "PostalAddress",
            "streetAddress": "No. 309, Weishi Road",
            "addressLocality": "Yueqing City",
            "addressRegion": "Zhejiang Province",
            "addressCountry": "China"
        },
        "contactPoint": {
            "@type": "ContactPoint",
            "telephone": "<?php echo COMPANY_PHONE; ?>",
            "contactType": "customer service",
            "availableLanguage": ["English", "Chinese"]
        }
    }
    </script>
</body>
</html>
