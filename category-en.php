<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Product Categories | Zhejiang Tianhong Fasteners Co., Ltd.</title>
  <meta name="description" content="Tianhong Fasteners product categories – Nuts, Bolts, Screws, Rivets, Security Screws, Custom Parts, Inserts & Sleeves. 533 products with HS codes. Serving 50+ countries since 1987." />
  <meta name="keywords" content="fastener categories,HS code bolts,nuts,screws,rivets,security screws,pan head,hex bolt,socket cap,HS7318,Tianhong fasteners" />
  <meta name="author" content="Zhejiang Tianhong Fasteners Co., Ltd." />
  <meta property="og:title" content="Product Categories | Zhejiang Tianhong Fasteners Co., Ltd." />
  <meta property="og:description" content="Professional manufacturer of high-strength bolts, nuts, security screws and custom fasteners with HS code support, founded 1987." />
  <meta property="og:type" content="website" />
  <meta property="og:locale" content="en_US" />

  <link rel="stylesheet" href="css/tailwind.css" />
  <link rel="stylesheet" href="assets/css/product-style.css" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

  <style>
    html { scroll-behavior: smooth; }
    .nav-link { position: relative; }
    .nav-link::after {
      content: '';
      position: absolute; bottom: -2px; left: 0;
      width: 0; height: 2px;
      background: #d4891a;
      transition: width 0.3s ease;
    }
    .nav-link:hover::after { width: 100%; }
    .lang-toggle {
      display: inline-flex; align-items: center;
      border: 1.5px solid #d4891a; border-radius: 999px; overflow: hidden;
    }
    .lang-btn { padding: 4px 12px; font-size: 0.8rem; font-weight: 600; transition: background 0.2s, color 0.2s; cursor: pointer; -webkit-tap-highlight-color: transparent; text-decoration: none; display: inline-block; }
    .lang-btn.active { background: #d4891a; color: #fff; }
    .lang-btn:not(.active) { background: transparent; color: #d4891a; }
    .section-divider { width: 60px; height: 4px; background: linear-gradient(90deg, #d4891a, #f0a833); border-radius: 2px; margin: 12px auto 0; }

    /* Category card grid */
    .cat-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
      gap: 20px;
    }
    .cat-card {
      border-radius: 16px;
      overflow: hidden;
      background: #fff;
      border: 1.5px solid #f0f0f0;
      box-shadow: 0 2px 10px rgba(13,27,42,0.07);
      cursor: pointer;
      transition: transform 0.25s ease, box-shadow 0.25s ease, border-color 0.25s ease;
    }
    .cat-card:hover, .cat-card.active {
      transform: translateY(-5px);
      box-shadow: 0 14px 36px rgba(13,27,42,0.13);
      border-color: #d4891a;
    }
    .cat-card.active {
      outline: 2px solid #d4891a;
    }
    .cat-card-img {
      position: relative;
      aspect-ratio: 4/3;
      overflow: hidden;
      background: linear-gradient(135deg, #1b263b 0%, #374151 60%, rgba(212,137,26,0.15) 100%);
    }
    .cat-card-img img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 0.4s ease;
      display: block;
    }
    .cat-card:hover .cat-card-img img {
      transform: scale(1.06);
    }
    .cat-card-body {
      padding: 12px 14px 14px;
      text-align: center;
    }
    .cat-card-name {
      font-size: 14px;
      font-weight: 700;
      color: #0d1b2a;
      margin: 0 0 4px;
      font-family: Poppins, sans-serif;
    }
    .cat-card-count {
      font-size: 12px;
      color: #6b7280;
      margin: 0 0 4px;
    }
    .cat-card-hs {
      font-size: 11px;
      color: #9ca3af;
      font-family: 'Courier New', monospace;
    }
    .cat-card-hs strong {
      color: #d4891a;
    }

    /* HS code badge in banner */
    .hs-pill {
      display: inline-flex;
      align-items: center;
      gap: 5px;
      background: rgba(212,137,26,0.15);
      border: 1px solid rgba(212,137,26,0.35);
      border-radius: 999px;
      padding: 3px 10px;
      font-size: 11px;
      color: #f0a833;
      font-family: 'Courier New', monospace;
      font-weight: 600;
    }

    @media (max-width: 640px) {
      .cat-grid { grid-template-columns: repeat(2, 1fr); gap: 12px; }
    }

    #browser-hint { display: none; }
    #browser-hint.show { display: flex; }
    ::-webkit-scrollbar { width: 6px; }
    ::-webkit-scrollbar-track { background: #f1f5f9; }
    ::-webkit-scrollbar-thumb { background: #d4891a; border-radius: 3px; }
  </style>
</head>

<body class="font-sans antialiased bg-white text-gray-800">

<!-- DOUYIN / WECHAT IN-APP BROWSER HINT -->
<div id="browser-hint" role="alert"
  style="position:fixed;top:0;left:0;right:0;z-index:9999;background:#d4891a;color:#fff;padding:10px 16px;font-size:13px;align-items:center;justify-content:space-between;gap:8px;">
  <span>📱 For the best experience, please open in your default browser.</span>
  <button onclick="document.getElementById('browser-hint').remove()" aria-label="Dismiss"
    style="background:rgba(0,0,0,0.2);border:none;color:#fff;border-radius:50%;width:22px;height:22px;cursor:pointer;font-size:14px;flex-shrink:0;display:flex;align-items:center;justify-content:center;line-height:1;">✕</button>
</div>

<!-- HEADER -->
<header id="site-header" class="fixed top-0 left-0 right-0 z-50 bg-[#0d1b2a]/95 backdrop-blur-sm shadow-lg">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex items-center justify-between h-16">
      <a href="en.html" class="flex items-center gap-3 flex-shrink-0">
        <div class="w-9 h-9 bg-[#d4891a] rounded-lg flex items-center justify-center">
          <i class="fas fa-bolt text-white text-sm"></i>
        </div>
        <div>
          <div class="text-white font-bold text-base leading-tight" style="font-family:Poppins,sans-serif">Tianhong Fasteners</div>
          <div class="text-[#f0a833] text-xs">Since 1987</div>
        </div>
      </a>

      <nav class="hidden md:flex items-center gap-6">
        <a href="en.html" class="nav-link text-gray-300 hover:text-white text-sm font-medium transition-colors">Home</a>
        <a href="en-products.html" class="nav-link text-gray-300 hover:text-white text-sm font-medium transition-colors">Products</a>
        <a href="category-en.php" class="nav-link text-[#d4891a] text-sm font-medium transition-colors" aria-current="page">Categories</a>
        <a href="en.html#about" class="nav-link text-gray-300 hover:text-white text-sm font-medium transition-colors">About</a>
        <a href="en.html#contact" class="nav-link text-gray-300 hover:text-white text-sm font-medium transition-colors">Contact</a>
      </nav>

      <div class="flex items-center gap-3">
        <div class="lang-toggle" role="group" aria-label="Language selector">
          <a class="lang-btn" href="category-zh.php" aria-label="中文">中文</a>
          <span class="lang-btn active" aria-current="page">EN</span>
        </div>
        <button onclick="openInquiry()"
          class="hidden md:inline-flex items-center gap-2 bg-[#d4891a] hover:bg-[#f0a833] text-white text-sm font-semibold px-4 py-2 rounded-lg transition-colors">
          <i class="fas fa-envelope text-xs"></i>
          Inquire
        </button>
        <button id="menu-btn" onclick="toggleMenu()" class="md:hidden text-gray-300 hover:text-white p-2" aria-label="Menu">
          <i class="fas fa-bars text-lg"></i>
        </button>
      </div>
    </div>
  </div>

  <div id="mobile-menu" class="hidden md:hidden bg-[#1b263b] border-t border-gray-700">
    <div class="px-4 py-3 space-y-2">
      <a href="en.html" onclick="toggleMenu()" class="block text-gray-300 hover:text-white py-2 text-sm">Home</a>
      <a href="en-products.html" onclick="toggleMenu()" class="block text-gray-300 hover:text-white py-2 text-sm">Products</a>
      <a href="category-en.php" onclick="toggleMenu()" class="block text-[#d4891a] py-2 text-sm font-semibold">Categories</a>
      <a href="en.html#about" onclick="toggleMenu()" class="block text-gray-300 hover:text-white py-2 text-sm">About</a>
      <a href="en.html#contact" onclick="toggleMenu()" class="block text-gray-300 hover:text-white py-2 text-sm">Contact</a>
      <button onclick="openInquiry(); toggleMenu();"
        class="w-full bg-[#d4891a] hover:bg-[#f0a833] text-white text-sm font-semibold px-4 py-2 rounded-lg transition-colors mt-2">
        Inquire Now
      </button>
    </div>
  </div>
</header>


<!-- PAGE BANNER -->
<section class="bg-[#0d1b2a] pt-16">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 text-center">
    <p class="text-[#d4891a] font-semibold text-sm uppercase tracking-widest mb-3">Product Categories</p>
    <h1 class="text-3xl md:text-5xl font-extrabold text-white mb-4" style="font-family:Poppins,sans-serif">
      Professional Fastener Catalog
    </h1>
    <div class="w-16 h-1 bg-[#d4891a] rounded mx-auto mb-5"></div>
    <p class="text-gray-400 text-base md:text-lg max-w-2xl mx-auto mb-6">
      9 categories, 533 professional fasteners — including HS codes and export tax rebate data for seamless customs clearance.
    </p>
    <div class="flex flex-wrap justify-center gap-2 mb-4">
      <span class="hs-pill"><i class="fas fa-barcode"></i> HS 7318.15 Bolts/Screws</span>
      <span class="hs-pill"><i class="fas fa-barcode"></i> HS 7318.16 Nuts</span>
      <span class="hs-pill"><i class="fas fa-barcode"></i> HS 7318.24 Rivets</span>
      <span class="hs-pill"><i class="fas fa-barcode"></i> HS 7318.29 Custom Parts</span>
    </div>
    <div class="flex items-center justify-center gap-2 mt-4 text-sm text-gray-500">
      <a href="en.html" class="hover:text-[#d4891a] transition-colors">Home</a>
      <i class="fas fa-chevron-right text-xs"></i>
      <span class="text-[#d4891a]">Categories</span>
    </div>
  </div>
</section>


<!-- CATEGORY CARDS -->
<section id="cat-section" class="py-16 bg-gray-50">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="text-center mb-10">
      <p class="text-[#d4891a] font-semibold text-sm uppercase tracking-widest mb-2">Click a category to filter</p>
      <h2 class="text-2xl md:text-3xl font-extrabold text-[#0d1b2a]" style="font-family:Poppins,sans-serif">
        Category Overview
      </h2>
      <div class="section-divider"></div>
    </div>

    <!-- Category grid — populated by JS -->
    <div id="cat-grid" class="cat-grid">
      <!-- Skeleton placeholders -->
      <?php for ($i = 0; $i < 9; $i++): ?>
      <div class="cat-card animate-pulse">
        <div class="cat-card-img" style="background:#e5e7eb;"></div>
        <div class="cat-card-body">
          <div style="height:14px;background:#e5e7eb;border-radius:4px;margin-bottom:6px;"></div>
          <div style="height:11px;background:#f3f4f6;border-radius:4px;width:60%;margin:0 auto;"></div>
        </div>
      </div>
      <?php endfor; ?>
    </div>
  </div>
</section>


<!-- PRODUCT CATALOG -->
<section id="pg-section" class="py-16 bg-white">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="text-center mb-10">
      <p class="text-[#d4891a] font-semibold text-sm uppercase tracking-widest mb-2">Product Catalog</p>
      <h2 id="pg-heading" class="text-2xl md:text-3xl font-extrabold text-[#0d1b2a]" style="font-family:Poppins,sans-serif">
        All Products
      </h2>
      <div class="section-divider"></div>
      <p class="text-gray-500 mt-3 text-sm">
        Search by product name, specification or HS code
      </p>
    </div>

    <!-- Search Bar -->
    <div class="pg-search-wrap">
      <div class="flex flex-col sm:flex-row gap-3 mb-4">
        <div class="pg-search-input-wrap">
          <i class="fas fa-search pg-search-icon"></i>
          <input id="pg-search" type="search" class="pg-search-input" autocomplete="off" />
        </div>
      </div>
      <div id="pg-tabs" class="pg-filter-tabs">
        <!-- Populated by JavaScript -->
      </div>
    </div>

    <!-- Results Bar -->
    <div class="pg-results-bar">
      <span id="pg-results-bar" class="pg-results-count"></span>
    </div>

    <!-- Product Grid -->
    <div id="pg-grid" class="pg-grid">
      <!-- Populated by JavaScript -->
    </div>

    <!-- Pagination -->
    <div id="pg-pagination" class="pg-pagination"></div>
  </div>
</section>


<!-- CTA SECTION -->
<section class="py-20 bg-gradient-to-br from-[#0d1b2a] to-[#1a5f7a] text-center">
  <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
    <h2 class="text-3xl md:text-4xl font-extrabold text-white mb-5" style="font-family:Poppins,sans-serif">
      Need Custom Fasteners?
    </h2>
    <p class="text-gray-300 text-base md:text-lg leading-relaxed mb-8">
      Contact us for custom solutions — prototyping, small-batch and bulk orders. We assist with HS code classification and export documentation.
    </p>
    <div class="flex flex-col sm:flex-row gap-4 justify-center">
      <button onclick="openInquiry()"
        class="inline-flex items-center justify-center gap-2 bg-[#d4891a] hover:bg-[#f0a833] text-white font-semibold px-8 py-3 rounded-xl transition-all shadow-lg">
        <i class="fas fa-envelope"></i>
        Send Inquiry
      </button>
      <a href="https://wa.me/8618958770140"
        class="inline-flex items-center justify-center gap-2 bg-white/10 hover:bg-white/20 border border-white/30 text-white font-semibold px-8 py-3 rounded-xl transition-all">
        <i class="fab fa-whatsapp"></i>
        WhatsApp: +86 189 5877 0140
      </a>
    </div>
  </div>
</section>


<!-- FOOTER -->
<footer class="bg-[#0d1b2a] text-gray-400">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
      <div class="lg:col-span-2">
        <div class="flex items-center gap-3 mb-4">
          <div class="w-9 h-9 bg-[#d4891a] rounded-lg flex items-center justify-center">
            <i class="fas fa-bolt text-white text-sm"></i>
          </div>
          <div>
            <div class="text-white font-bold" style="font-family:Poppins,sans-serif">Zhejiang Tianhong Fasteners Co., Ltd.</div>
          </div>
        </div>
        <p class="text-sm leading-relaxed mb-4 max-w-xs">
          Professional manufacturer of high-strength bolts, nuts, washers and custom fasteners, serving 50+ countries since 1987.
        </p>
        <div class="flex gap-3">
          <a href="tel:+8618958770140" class="w-9 h-9 bg-gray-700 hover:bg-[#d4891a] rounded-lg flex items-center justify-center transition-colors" aria-label="Phone">
            <i class="fas fa-phone text-xs"></i>
          </a>
          <a href="mailto:xiebaole5@gmail.com" class="w-9 h-9 bg-gray-700 hover:bg-[#d4891a] rounded-lg flex items-center justify-center transition-colors" aria-label="Email">
            <i class="fas fa-envelope text-xs"></i>
          </a>
          <a href="https://wa.me/8618958770140" target="_blank" rel="noopener noreferrer" class="w-9 h-9 bg-gray-700 hover:bg-green-500 rounded-lg flex items-center justify-center transition-colors" aria-label="WhatsApp">
            <i class="fab fa-whatsapp text-sm"></i>
          </a>
        </div>
      </div>

      <div>
        <h4 class="text-white font-semibold mb-4 text-sm uppercase tracking-wider">Quick Links</h4>
        <ul class="space-y-2 text-sm">
          <li><a href="en.html" class="hover:text-[#d4891a] transition-colors">Home</a></li>
          <li><a href="en-products.html" class="hover:text-[#d4891a] transition-colors">Products</a></li>
          <li><a href="category-en.php" class="text-[#d4891a]">Categories</a></li>
          <li><a href="en.html#about" class="hover:text-[#d4891a] transition-colors">About Us</a></li>
          <li><a href="en.html#contact" class="hover:text-[#d4891a] transition-colors">Contact</a></li>
        </ul>
      </div>

      <div>
        <h4 class="text-white font-semibold mb-4 text-sm uppercase tracking-wider">Contact</h4>
        <ul class="space-y-3 text-sm">
          <li class="flex items-start gap-2">
            <i class="fas fa-phone text-[#d4891a] mt-0.5 text-xs flex-shrink-0"></i>
            <a href="tel:+8618958770140" class="hover:text-[#d4891a] transition-colors">+86 189-5877-0140</a>
          </li>
          <li class="flex items-start gap-2">
            <i class="fas fa-envelope text-[#d4891a] mt-0.5 text-xs flex-shrink-0"></i>
            <a href="mailto:xiebaole5@gmail.com" class="hover:text-[#d4891a] transition-colors break-all">xiebaole5@gmail.com</a>
          </li>
          <li class="flex items-start gap-2">
            <i class="fas fa-map-marker-alt text-[#d4891a] mt-0.5 text-xs flex-shrink-0"></i>
            <span>No. 309, Weishi Road, Yueqing Economic Development Zone, Zhejiang, China</span>
          </li>
        </ul>
      </div>
    </div>
  </div>

  <div class="border-t border-gray-700">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 flex flex-col sm:flex-row items-center justify-between gap-3 text-xs">
      <div>© 2026 Zhejiang Tianhong Fasteners Co., Ltd. All rights reserved.</div>
    </div>
  </div>
</footer>


<!-- INQUIRY MODAL -->
<div id="inquiry-modal" class="hidden fixed inset-0 z-[200] flex items-center justify-center p-4" role="dialog" aria-modal="true" aria-labelledby="modal-title">
  <div class="absolute inset-0 bg-black/60 backdrop-blur-sm" onclick="closeInquiry()"></div>
  <div class="relative bg-white rounded-2xl w-full max-w-lg shadow-2xl max-h-[90vh] overflow-y-auto">
    <div class="flex items-center justify-between p-6 border-b">
      <h2 id="modal-title" class="font-bold text-xl text-[#0d1b2a]" style="font-family:Poppins,sans-serif">Product Inquiry</h2>
      <button onclick="closeInquiry()" class="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100 transition-colors" aria-label="Close">
        <i class="fas fa-times text-gray-500"></i>
      </button>
    </div>
    <div class="p-6">
      <form id="modal-form" onsubmit="submitModalForm(event)">
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Name *</label>
            <input type="text" name="name" required class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#d4891a]/40 focus:border-[#d4891a]" />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Company</label>
            <input type="text" name="company" class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#d4891a]/40 focus:border-[#d4891a]" />
          </div>
        </div>
        <div class="mb-4">
          <label class="block text-sm font-medium text-gray-700 mb-1">Email *</label>
          <input type="email" name="email" required class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#d4891a]/40 focus:border-[#d4891a]" />
        </div>
        <div class="mb-4">
          <label class="block text-sm font-medium text-gray-700 mb-1">Phone / WhatsApp</label>
          <input type="tel" name="phone" class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#d4891a]/40 focus:border-[#d4891a]" />
        </div>
        <div class="mb-4">
          <label class="block text-sm font-medium text-gray-700 mb-1">Product of Interest</label>
          <input type="text" name="product" id="modal-product" class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#d4891a]/40 focus:border-[#d4891a]" />
        </div>
        <div class="mb-6">
          <label class="block text-sm font-medium text-gray-700 mb-1">Message *</label>
          <textarea name="message" rows="4" required class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#d4891a]/40 focus:border-[#d4891a] resize-none"></textarea>
        </div>
        <button type="submit"
          class="w-full bg-[#0d1b2a] hover:bg-[#1b263b] text-white font-semibold py-3 px-6 rounded-xl transition-colors flex items-center justify-center gap-2">
          <i class="fas fa-paper-plane text-sm"></i>
          Send Inquiry
        </button>
      </form>
    </div>
  </div>
</div>


<!-- FLOATING BUTTONS -->
<button id="back-to-top"
  onclick="window.scrollTo({top:0,behavior:'smooth'})"
  class="hidden fixed bottom-6 right-6 z-40 w-11 h-11 bg-[#0d1b2a] hover:bg-[#1b263b] text-white rounded-xl shadow-lg transition-all items-center justify-center"
  aria-label="Back to Top">
  <i class="fas fa-chevron-up text-sm"></i>
</button>

<a href="https://wa.me/8618958770140" target="_blank" rel="noopener noreferrer"
  class="fixed bottom-20 right-6 z-40 w-11 h-11 bg-green-500 hover:bg-green-600 text-white rounded-xl shadow-lg transition-all flex items-center justify-center"
  aria-label="WhatsApp">
  <i class="fab fa-whatsapp text-xl"></i>
</a>


<!-- JAVASCRIPT -->
<script>
/* Mobile Menu */
function toggleMenu() {
  document.getElementById('mobile-menu').classList.toggle('hidden');
}

/* Inquiry Modal */
function openInquiry(productName) {
  var modal = document.getElementById('inquiry-modal');
  modal.classList.remove('hidden');
  document.body.style.overflow = 'hidden';
  if (productName) document.getElementById('modal-product').value = productName;
}
function closeInquiry() {
  document.getElementById('inquiry-modal').classList.add('hidden');
  document.body.style.overflow = '';
}
document.addEventListener('keydown', function(e) { if (e.key === 'Escape') closeInquiry(); });

/* Form */
function submitModalForm(e) {
  e.preventDefault();
  alert('Thank you for your inquiry! We will respond within 24 hours.');
  e.target.reset();
  closeInquiry();
}

/* Back to Top */
window.addEventListener('scroll', function() {
  var btn = document.getElementById('back-to-top');
  if (window.scrollY > 400) { btn.classList.remove('hidden'); btn.classList.add('flex'); }
  else { btn.classList.add('hidden'); btn.classList.remove('flex'); }
});

/* Douyin / WeChat in-app browser detection */
(function() {
  var ua = navigator.userAgent || '';
  var isInApp = /Aweme|BytedanceWebview|musical_ly|MicroMessenger|MQQBrowser|QQ\//i.test(ua);
  if (isInApp) {
    var hint = document.getElementById('browser-hint');
    if (hint) hint.classList.add('show');
  }
})();

/* ─────────────────────────────────────────────────────────────────────
   Category Cards — load from products_data.json, render cat-grid,
   wire click → filter product gallery
   ─────────────────────────────────────────────────────────────────── */
window.PG_LANG = 'en';
window.PG_OPEN_INQUIRY = openInquiry;

function esc(s) {
  return String(s)
    .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;').replace(/'/g, '&#39;');
}

function renderCategoryCards(categories, activeCat) {
  var grid = document.getElementById('cat-grid');
  if (!grid) return;

  grid.innerHTML = categories.map(function(cat) {
    var isActive = activeCat === cat.en;
    return (
      '<div class="cat-card' + (isActive ? ' active' : '') + '" ' +
           'data-cat="' + esc(cat.en) + '" ' +
           'role="button" tabindex="0" aria-pressed="' + isActive + '">' +
        '<div class="cat-card-img">' +
          '<img src="' + esc(cat.image) + '" ' +
               'alt="' + esc(cat.en) + '" ' +
               'loading="lazy" ' +
               'onerror="this.style.display=\'none\'">' +
        '</div>' +
        '<div class="cat-card-body">' +
          '<div class="cat-card-name">' + esc(cat.en) + '</div>' +
          '<div class="cat-card-count">' + cat.count + ' items</div>' +
          '<div class="cat-card-hs"><strong>HS</strong> ' + esc(cat.hs_code || '') + '</div>' +
        '</div>' +
      '</div>'
    );
  }).join('');

  grid.querySelectorAll('.cat-card').forEach(function(card) {
    function activate() {
      var cat = card.getAttribute('data-cat');
      if (window.PG_SET_CATEGORY) window.PG_SET_CATEGORY(cat);
      updateHeading(cat, categories);
      renderCategoryCards(categories, cat);
      var pgSection = document.getElementById('pg-section');
      if (pgSection) pgSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
    card.addEventListener('click', activate);
    card.addEventListener('keydown', function(e) { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); activate(); } });
  });
}

function updateHeading(activeCat, categories) {
  var heading = document.getElementById('pg-heading');
  if (!heading) return;
  if (activeCat === 'all') {
    heading.textContent = 'All Products';
    return;
  }
  var found = categories.filter(function(c) { return c.en === activeCat; })[0];
  heading.textContent = found ? found.en + ' — ' + found.count + ' items' : activeCat;
}

/* Pre-load categories for initial render of skeleton replacement */
window.PG_ON_DATA_LOADED = function(data) {
  var cats = (data.meta && data.meta.categories) || [];
  renderCategoryCards(cats, 'all');
};
</script>
<script src="assets/js/product-gallery.js"></script>
</body>
</html>
