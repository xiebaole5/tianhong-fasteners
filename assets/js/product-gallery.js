/**
 * product-gallery.js
 * Handles loading, filtering, searching, and rendering the 533-item product catalog.
 * Used by products.html (zh) and en-products.html (en).
 *
 * Config object expected on window:
 *   window.PG_LANG  = 'zh' | 'en'          (default: 'zh')
 *   window.PG_OPEN_INQUIRY = function(name) (injected by host page)
 */

(function () {
  'use strict';

  /* ─── Constants ─────────────────────────────────────────────────── */
  var ITEMS_PER_PAGE = 24;
  var DATA_URL = 'data/products_data.json';

  /* ─── State ──────────────────────────────────────────────────────── */
  var state = {
    lang: (window.PG_LANG || 'zh'),
    allProducts: [],
    categories: [],
    filtered: [],
    activeCategory: 'all',
    searchQuery: '',
    page: 1,
  };

  /* ─── i18n ───────────────────────────────────────────────────────── */
  var i18n = {
    zh: {
      allCategory: '全部',
      searchPlaceholder: '搜索产品名称、规格或HS编码…',
      resultsOf: function (n, t) { return '找到 <strong>' + n + '</strong> 项，共 ' + t + ' 项'; },
      spec: '规格',
      hsCode: 'HS编码',
      inquire: '询价',
      emptyTitle: '未找到相关产品',
      emptyDesc: '请尝试更换关键词或切换分类',
      prev: '上一页',
      next: '下一页',
    },
    en: {
      allCategory: 'All',
      searchPlaceholder: 'Search by name, spec or HS code…',
      resultsOf: function (n, t) { return 'Showing <strong>' + n + '</strong> of ' + t + ' products'; },
      spec: 'Spec',
      hsCode: 'HS Code',
      inquire: 'Inquire',
      emptyTitle: 'No products found',
      emptyDesc: 'Try a different keyword or category',
      prev: 'Prev',
      next: 'Next',
    },
  };

  function t(key) {
    return (i18n[state.lang] || i18n.zh)[key];
  }

  /* ─── DOM helpers ────────────────────────────────────────────────── */
  function $(id) { return document.getElementById(id); }
  function esc(str) {
    return String(str)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  /* ─── Category name accessor ─────────────────────────────────────── */
  function catName(p) {
    return state.lang === 'en' ? p.category_en : p.category_zh;
  }
  function productName(p) {
    return state.lang === 'en' ? p.name_en : p.name_zh;
  }

  /* ─── Filter logic ───────────────────────────────────────────────── */
  function applyFilters() {
    var q = state.searchQuery.trim().toLowerCase();
    var cat = state.activeCategory;

    state.filtered = state.allProducts.filter(function (p) {
      var matchCat = (cat === 'all') ||
        (state.lang === 'en' ? p.category_en === cat : p.category_zh === cat);

      if (!matchCat) return false;

      if (!q) return true;

      var haystack = (p.name_zh + ' ' + p.name_en + ' ' + p.spec + ' ' + p.category_zh + ' ' + (p.hs_code || '')).toLowerCase();
      return haystack.indexOf(q) !== -1;
    });

    state.page = 1;
  }

  /* ─── Render category tabs ───────────────────────────────────────── */
  function renderTabs() {
    var container = $('pg-tabs');
    if (!container) return;

    var catLabel = state.lang === 'en' ? 'category_en' : 'category_zh';

    // Build count map
    var counts = {};
    state.allProducts.forEach(function (p) {
      var c = p[catLabel];
      counts[c] = (counts[c] || 0) + 1;
    });

    var total = state.allProducts.length;
    var html = '<button class="pg-tab' + (state.activeCategory === 'all' ? ' active' : '') + '" data-cat="all">' +
      esc(t('allCategory')) +
      '<span class="pg-tab-count">' + total + '</span>' +
      '</button>';

    state.categories.forEach(function (cat) {
      var key = state.lang === 'en' ? cat.en : cat.zh;
      var count = counts[key] || 0;
      if (!count) return;
      var isActive = state.activeCategory === key;
      html += '<button class="pg-tab' + (isActive ? ' active' : '') + '" data-cat="' + esc(key) + '">' +
        esc(key) +
        '<span class="pg-tab-count">' + count + '</span>' +
        '</button>';
    });

    container.innerHTML = html;

    container.querySelectorAll('.pg-tab').forEach(function (btn) {
      btn.addEventListener('click', function () {
        state.activeCategory = this.getAttribute('data-cat');
        applyFilters();
        renderTabs();
        renderGrid();
        renderPagination();
        renderResultsBar();
      });
    });
  }

  /* ─── Render results bar ─────────────────────────────────────────── */
  function renderResultsBar() {
    var bar = $('pg-results-bar');
    if (!bar) return;
    var fn = t('resultsOf');
    bar.innerHTML = fn(state.filtered.length, state.allProducts.length);
  }

  /* ─── Render product grid ────────────────────────────────────────── */
  function renderGrid() {
    var grid = $('pg-grid');
    if (!grid) return;

    var start = (state.page - 1) * ITEMS_PER_PAGE;
    var pageItems = state.filtered.slice(start, start + ITEMS_PER_PAGE);

    if (pageItems.length === 0) {
      grid.innerHTML =
        '<div class="pg-empty">' +
        '<div class="pg-empty-icon"><i class="fas fa-search"></i></div>' +
        '<div class="pg-empty-title">' + esc(t('emptyTitle')) + '</div>' +
        '<div class="pg-empty-desc">' + esc(t('emptyDesc')) + '</div>' +
        '</div>';
      return;
    }

    grid.innerHTML = pageItems.map(function (p) {
      var name = esc(productName(p));
      var spec = esc(p.spec || '—');
      var cat = esc(catName(p));
      var img = esc(p.image || '');
      var altText = esc(p.name_zh);
      var hsCode = esc(p.hs_code || '');
      // Use data attribute to avoid inline onclick XSS risk
      var inquireData = esc(productName(p) + ' ' + (p.spec || ''));

      return (
        '<div class="pg-card">' +
        '<div class="pg-card-img-wrap">' +
        '<img src="' + img + '" alt="' + altText + '" loading="lazy" onerror="this.style.display=\'none\'">' +
        '<span class="pg-card-badge">' + cat + '</span>' +
        '</div>' +
        '<div class="pg-card-body">' +
        '<h3 class="pg-card-title">' + name + '</h3>' +
        '<p class="pg-card-spec"><span>' + esc(t('spec')) + ': </span>' + spec + '</p>' +
        (hsCode ? '<p class="pg-card-hs"><span>' + esc(t('hsCode')) + ': </span>' + hsCode + '</p>' : '') +
        '<div class="pg-card-body-spacer"></div>' +
        '<button class="pg-card-btn pg-inquire-btn" data-inquiry="' + inquireData + '">' +
        esc(t('inquire')) + '</button>' +
        '</div>' +
        '</div>'
      );
    }).join('');
  }

  /* ─── Render pagination ──────────────────────────────────────────── */
  function renderPagination() {
    var container = $('pg-pagination');
    if (!container) return;

    var totalPages = Math.ceil(state.filtered.length / ITEMS_PER_PAGE);
    if (totalPages <= 1) { container.innerHTML = ''; return; }

    var html = '';
    var cur = state.page;

    // Prev button
    html += '<button class="pg-page-btn" id="pg-prev"' + (cur <= 1 ? ' disabled' : '') + '>' +
      '<i class="fas fa-chevron-left text-xs"></i>' +
      '</button>';

    // Page numbers with ellipsis
    var pages = buildPageRange(cur, totalPages);
    pages.forEach(function (p) {
      if (p === '…') {
        html += '<span class="pg-page-ellipsis">…</span>';
      } else {
        html += '<button class="pg-page-btn' + (p === cur ? ' active' : '') + '" data-page="' + p + '">' + p + '</button>';
      }
    });

    // Next button
    html += '<button class="pg-page-btn" id="pg-next"' + (cur >= totalPages ? ' disabled' : '') + '>' +
      '<i class="fas fa-chevron-right text-xs"></i>' +
      '</button>';

    container.innerHTML = html;

    // Events
    container.querySelectorAll('.pg-page-btn[data-page]').forEach(function (btn) {
      btn.addEventListener('click', function () {
        state.page = parseInt(this.getAttribute('data-page'));
        renderGrid();
        renderPagination();
        renderResultsBar();
        scrollToGrid();
      });
    });

    var prev = $('pg-prev');
    if (prev) prev.addEventListener('click', function () {
      if (state.page > 1) { state.page--; renderGrid(); renderPagination(); renderResultsBar(); scrollToGrid(); }
    });

    var next = $('pg-next');
    if (next) next.addEventListener('click', function () {
      if (state.page < totalPages) { state.page++; renderGrid(); renderPagination(); renderResultsBar(); scrollToGrid(); }
    });
  }

  function buildPageRange(cur, total) {
    if (total <= 7) {
      var arr = [];
      for (var i = 1; i <= total; i++) arr.push(i);
      return arr;
    }
    var pages = [1];
    if (cur > 3) pages.push('…');
    for (var i = Math.max(2, cur - 1); i <= Math.min(total - 1, cur + 1); i++) {
      pages.push(i);
    }
    if (cur < total - 2) pages.push('…');
    pages.push(total);
    return pages;
  }

  function scrollToGrid() {
    var el = $('pg-section');
    if (el) { el.scrollIntoView({ behavior: 'smooth', block: 'start' }); }
  }

  /* ─── Search input wiring ────────────────────────────────────────── */
  function wireSearch() {
    var input = $('pg-search');
    if (!input) return;
    input.placeholder = t('searchPlaceholder');

    var timer;
    input.addEventListener('input', function () {
      clearTimeout(timer);
      var val = this.value;
      timer = setTimeout(function () {
        state.searchQuery = val;
        applyFilters();
        renderGrid();
        renderPagination();
        renderResultsBar();
      }, 250);
    });
  }

  /* ─── Init ───────────────────────────────────────────────────────── */
  function init(data) {
    state.allProducts = data.products || [];
    state.categories = (data.meta && data.meta.categories) || [];
    state.filtered = state.allProducts.slice();

    // Expose category setter for category pages (category-zh.php / category-en.php)
    window.PG_SET_CATEGORY = function (cat) {
      state.activeCategory = cat || 'all';
      applyFilters();
      renderTabs();
      renderResultsBar();
      renderGrid();
      renderPagination();
    };

    wireSearch();
    wireGridDelegation();
    renderTabs();
    renderResultsBar();
    renderGrid();
    renderPagination();

    // Notify category page that data is ready
    if (typeof window.PG_ON_DATA_LOADED === 'function') {
      window.PG_ON_DATA_LOADED(data);
    }
  }

  /* ─── Event delegation for inquire buttons ───────────────────────── */
  function wireGridDelegation() {
    var grid = $('pg-grid');
    if (!grid) return;
    grid.addEventListener('click', function (e) {
      var btn = e.target.closest('.pg-inquire-btn');
      if (!btn) return;
      var name = btn.getAttribute('data-inquiry') || '';
      if (window.PG_OPEN_INQUIRY) {
        window.PG_OPEN_INQUIRY(name);
      }
    });
  }

  /* ─── Load data ──────────────────────────────────────────────────── */
  function load() {
    fetch(DATA_URL)
      .then(function (r) {
        if (!r.ok) throw new Error('HTTP ' + r.status);
        return r.json();
      })
      .then(function (data) { init(data); })
      .catch(function (err) {
        console.warn('product-gallery: failed to load products_data.json', err);
        // Show error in grid
        var grid = $('pg-grid');
        if (grid) {
          grid.innerHTML =
            '<div class="pg-empty">' +
            '<div class="pg-empty-icon"><i class="fas fa-exclamation-triangle"></i></div>' +
            '<div class="pg-empty-title">Failed to load product data</div>' +
            '</div>';
        }
      });
  }

  // Start when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', load);
  } else {
    load();
  }

})();
