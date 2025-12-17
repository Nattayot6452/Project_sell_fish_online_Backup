<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${not empty product ? product.productName : 'รายละเอียดสินค้า'} | Fish Online</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/productDetail.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/sellerHomepage.css">
    <link rel="stylesheet" type="text/css" href="assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        /* CSS ปรับแต่งเพิ่มเติมเฉพาะหน้านี้ */
        .seller-badge { background: #ffc107; color: #333; padding: 2px 8px; border-radius: 10px; font-size: 11px; margin-left: 5px; }
        
        /* สไตล์ปุ่มสำหรับ Seller */
        .seller-actions-row {
            display: flex; gap: 10px; width: 100%; align-items: center;
        }
        .btn-edit-product {
            background-color: #ffc107; color: #333; border: none; flex: 1;
            padding: 12px; border-radius: 50px; text-decoration: none; font-weight: bold; text-align: center;
            transition: transform 0.2s;
        }
        .btn-edit-product:hover { background-color: #e0a800; transform: translateY(-2px); }
        
        .btn-delete-product {
            background-color: #dc3545; color: white; border: none; flex: 1;
            padding: 12px; border-radius: 50px; text-decoration: none; font-weight: bold; text-align: center;
            transition: transform 0.2s;
        }
        .btn-delete-product:hover { background-color: #c82333; transform: translateY(-2px); }
    </style>
</head>
<body>

    <%-- ✅✅✅ แยก Navbar ตามสิทธิ์การใช้งาน (Seller vs User) ✅✅✅ --%>
    <c:choose>
        
        <%-- 🟢 1. Navbar สำหรับ SELLER --%>
        <c:when test="${not empty sessionScope.seller}">
            <nav class="navbar">
                <div class="nav-container">
                    <a href="SellerCenter" class="brand-logo">
                        <img src="${pageContext.request.contextPath}/assets/images/icon/fishTesting.png" alt="Logo">
                        <span>Seller Center</span>
                    </a>
                    <div style="flex: 1;"></div>
                    <div class="nav-links">
                        <div class="dropdown">
                            <a href="#" class="menu-btn" style="color: #333; font-weight: 600; text-decoration: none; display: flex; align-items: center; gap: 5px;">
                                <i class="fas fa-boxes"></i> จัดการสินค้า <i class="fas fa-chevron-down" style="font-size: 10px;"></i>
                            </a>
                            <div class="dropdown-content">
                                <a href="SellerCenter"><i class="fas fa-list"></i> รายการสินค้าทั้งหมด</a>
                                <a href="AddProduct"><i class="fas fa-plus-circle"></i> เพิ่มสินค้าใหม่</a>
                            </div>
                        </div>
                        <a href="SellerOrders" class="menu-btn" style="color: #333; font-weight: 600; text-decoration: none; display: flex; align-items: center; gap: 5px;">
                            <i class="fas fa-clipboard-list"></i> คำสั่งซื้อลูกค้า
                        </a>
                        <a href="AddProduct" class="menu-btn add-product-btn" style="background-color: #17a2b8; color: white !important; padding: 8px 15px; border-radius: 50px; text-decoration: none; font-weight: bold; display: flex; align-items: center; gap: 5px;">
                            <i class="fas fa-plus-circle"></i> เพิ่มสินค้า
                        </a>
                        <div class="dropdown">
                            <a href="#" class="menu-btn" style="color: #333; font-weight: 600; text-decoration: none; display: flex; align-items: center; gap: 5px;">
                                <i class="fas fa-user-tie"></i> เจ้าหน้าที่ <span class="seller-badge">Seller</span>
                                <i class="fas fa-chevron-down" style="font-size: 10px;"></i>
                            </a>
                            <div class="dropdown-content">
                                <a href="Logout" class="menu-logout" style="color: #dc3545 !important;"><i class="fas fa-sign-out-alt"></i> ออกจากระบบ</a>
                            </div>
                        </div>
                    </div>
                </div>
            </nav>
        </c:when>

        <%-- 🔵 2. Navbar สำหรับ USER --%>
        <c:otherwise>
            <nav class="navbar">
                <div class="nav-container">
                    <a href="Home" class="brand-logo">
                        <img src="${pageContext.request.contextPath}/assets/images/icon/fishTesting.png" alt="Logo">
                        <span>Fish Online</span>
                    </a>
                    <form action="SearchProducts" method="POST" class="search-wrapper">
                        <input type="text" name="searchtext" placeholder="ค้นหาปลาที่คุณชอบ...">
                        <button type="submit"><i class="fas fa-search"></i></button>
                    </form>
                    <div class="nav-links">
                        <a href="Home"><i class="fas fa-home"></i> หน้าแรก</a>
                        <a href="AllProduct"><i class="fas fa-fish"></i> สินค้าทั้งหมด</a>
                        <c:if test="${not empty sessionScope.user}">
                            <a href="Cart" class="cart-link" title="ตะกร้าสินค้า"><i class="fas fa-shopping-cart"></i></a>
                            <div class="dropdown">
                                <a href="Profile" class="dropbtn user-profile">
                                    <img src="${pageContext.request.contextPath}/profile-uploads/user/${sessionScope.user.memberImg}" class="nav-avatar">
                                    สวัสดี, ${sessionScope.user.memberName}
                                    <i class="fas fa-chevron-down" style="font-size: 10px;"></i>
                                </a>
                                <div class="dropdown-content">
                                    <a href="editProfile"><i class="fas fa-user-edit"></i> แก้ไขโปรไฟล์</a>
                                    <a href="Favorites"><i class="fas fa-heart"></i> รายการโปรด</a> 
                                    <a href="Orders"><i class="fas fa-box-open"></i> คำสั่งซื้อ</a>
                                    <a href="History"><i class="fas fa-history"></i> ประวัติการสั่งซื้อ</a>
                                    <div style="border-top: 1px solid #eee; margin: 5px 0;"></div>
                                    <a href="Logout" class="menu-logout"><i class="fas fa-sign-out-alt"></i> ออกจากระบบ</a>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${empty sessionScope.user}">
                            <a href="Login" class="btn-login"><i class="fas fa-user"></i> เข้าสู่ระบบ</a>
                        </c:if>
                    </div>
                </div>
            </nav>
        </c:otherwise>
    </c:choose>

    <div class="breadcrumb-container">
        <ul class="breadcrumb">
            <c:choose>
                <c:when test="${not empty sessionScope.seller}">
                    <li><a href="SellerCenter">Seller Center</a></li>
                    <li><a href="SellerCenter">รายการสินค้า</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="Home">หน้าแรก</a></li>
                    <li><a href="AllProduct">สินค้าทั้งหมด</a></li>
                </c:otherwise>
            </c:choose>
            <li>${not empty product ? product.productName : 'รายละเอียดสินค้า'}</li>
        </ul>
    </div>

    <div class="container main-container">
        <c:choose>
            <c:when test="${not empty product}">
                
                <div class="product-wrapper">
                    
                    <div class="product-gallery">
                        <div class="main-img-box">
                            <c:choose>
                                <c:when test="${product.productImg.startsWith('assets')}">
                                    <img src="${pageContext.request.contextPath}/${product.productImg}" alt="${product.productName}" id="mainImage">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/profile-uploads/${product.productImg}" alt="${product.productName}" id="mainImage">
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="product-details-info">
                        <span class="stock-badge ${product.stock > 0 ? 'in-stock' : 'out-stock'}">
                            ${product.stock > 0 ? 'มีสินค้าพร้อมส่ง' : 'สินค้าหมดชั่วคราว'}
                        </span>
                        
                        <h1 class="product-title">${product.productName}</h1>
                        <p class="product-category">รหัสสินค้า: ${product.productId} | หมวดหมู่: ${product.species.speciesName}</p>
                        
                        <div class="price-section">
                            <span class="current-price">
                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="฿"/>
                            </span>
                        </div>

                        <p class="product-desc">${product.description}</p>

                        <div class="specs-grid">
                            <div class="spec-item">
                                <i class="fas fa-globe-asia"></i>
                                <span>แหล่งกำเนิด</span>
                                <strong>${product.origin}</strong>
                            </div>
                            <div class="spec-item">
                                <i class="fas fa-water"></i>
                                <span>ประเภทน้ำ</span>
                                <strong>${product.waterType}</strong>
                            </div>
                            <div class="spec-item">
                                <i class="fas fa-thermometer-half"></i>
                                <span>อุณหภูมิ</span>
                                <strong>${product.temperature}</strong>
                            </div>
                            <div class="spec-item">
                                <i class="fas fa-ruler"></i>
                                <span>ขนาดโตเต็มวัย</span>
                                <strong>${product.size}</strong>
                            </div>
                            <div class="spec-item">
                                <i class="fas fa-heartbeat"></i>
                                <span>อายุขัยเฉลี่ย</span>
                                <strong>${product.lifeSpan}</strong>
                            </div>
                            <div class="spec-item">
                                <i class="fas fa-hand-holding-heart"></i>
                                <span>ระดับการดูแล</span>
                                <strong>${product.careLevel}</strong>
                            </div>
                            <div class="spec-item">
                                <i class="fas fa-paw"></i>
                                <span>นิสัย</span>
                                <strong>${product.isAggressive}</strong>
                            </div>
                        </div>

                        <div class="purchase-action">
                            <c:choose>
                                <%-- ✅ กรณีเป็น Seller: แสดงปุ่มแก้ไข และ ลบ --%>
                                <c:when test="${not empty sessionScope.seller}">
                                    <div class="seller-actions-row">
                                        <a href="EditProduct?id=${product.productId}" class="btn-edit-product">
                                            <i class="fas fa-pen"></i> แก้ไข
                                        </a>
                                        <a href="DeleteProduct?id=${product.productId}" class="btn-delete-product"
                                           onclick="return confirm('⚠️ ยืนยันการลบสินค้า: ${product.productName}? \nการกระทำนี้ไม่สามารถย้อนกลับได้');">
                                            <i class="fas fa-trash-alt"></i> ลบสินค้า
                                        </a>
                                        <a href="SellerCenter" class="btn-fav" title="กลับหลังบ้าน" style="width: auto; padding: 0 20px;">
                                            <i class="fas fa-store"></i>
                                        </a>
                                    </div>
                                </c:when>

                                <%-- กรณีเป็น User/Guest: แสดงปุ่มซื้อ --%>
                                <c:otherwise>
                                    <c:if test="${product.stock > 0}">
                                        <div class="quantity-control">
                                            <button type="button" onclick="decreaseQty()">-</button>
                                            <input type="number" id="qtyInput" value="1" min="1" max="${product.stock}" readonly>
                                            <button type="button" onclick="increaseQty()">+</button>
                                        </div>
                                        <a href="javascript:void(0)" onclick="addToCart('${product.productId}')" class="btn-add-cart">
                                            <i class="fas fa-shopping-cart"></i> หยิบใส่ตะกร้า
                                        </a>
                                    </c:if>
                                    <a href="${empty sessionScope.user ? 'Login' : 'addToFavorites?productId='.concat(product.productId)}" 
                                       class="btn-fav" title="เพิ่มรายการโปรด">
                                        <i class="far fa-heart"></i>
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <c:if test="${product.stock == 0}">
                            <p class="out-stock-msg"><i class="fas fa-exclamation-circle"></i> ขออภัย สินค้าหมดชั่วคราว</p>
                        </c:if>
                    </div>
                </div> <%-- ✅✅✅ ส่วนแสดงรีวิวสินค้า (Review Section) เพิ่มใหม่ตรงนี้ ✅✅✅ --%>
                <div class="reviews-container">
                    <div class="reviews-header">
                        <h3><i class="fas fa-star"></i> รีวิวจากผู้ใช้งาน (${totalReviews})</h3>
                        
                        <div class="rating-summary">
                            <span class="big-score">${avgRating}</span>
                            <div class="stars-display">
                                <c:forEach begin="1" end="5" var="i">
                                    <i class="fas fa-star ${i <= avgRating ? 'filled' : ''}"></i>
                                </c:forEach>
                            </div>
                            <span class="total-text">จาก ${totalReviews} รีวิว</span>
                        </div>
                    </div>

                    <div class="reviews-filter-bar">
                        <form action="ProductDetail" method="get" class="sort-form">
                            <input type="hidden" name="pid" value="${product.productId}">
                            <label><i class="fas fa-filter"></i> เรียงตาม:</label>
                            <select name="sort" onchange="this.form.submit()">
                                <option value="newest" ${currentSort == 'newest' ? 'selected' : ''}>ล่าสุด</option>
                                <option value="oldest" ${currentSort == 'oldest' ? 'selected' : ''}>เก่าที่สุด</option>
                                <option value="rating_desc" ${currentSort == 'rating_desc' ? 'selected' : ''}>คะแนนมากสุด</option>
                                <option value="rating_asc" ${currentSort == 'rating_asc' ? 'selected' : ''}>คะแนนน้อยสุด</option>
                            </select>
                        </form>
                    </div>

                    <div class="reviews-list">
                        <c:choose>
                            <c:when test="${not empty reviews}">
                                <c:forEach items="${reviews}" var="review">
                                    <div class="review-card">
                                        <div class="reviewer-info">
                                            <img src="${pageContext.request.contextPath}/profile-uploads/user/${not empty review.member.memberImg ? review.member.memberImg : 'default.png'}" 
                                                 alt="User" class="reviewer-img">
                                            <div>
                                                <span class="reviewer-name">${review.member.memberName}</span>
                                                <div class="review-meta">
                                                    <div class="mini-stars">
                                                        <c:forEach begin="1" end="5" var="i">
                                                            <i class="fas fa-star ${i <= review.rating ? 'active' : ''}"></i>
                                                        </c:forEach>
                                                    </div>
                                                    <span class="review-date">
                                                        <fmt:formatDate value="${review.reviewDate}" pattern="d MMM yyyy"/>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="review-content">
                                            <p>${review.comment}</p>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="no-reviews">
                                    <i class="far fa-comment-dots"></i>
                                    <p>สินค้านี้ยังไม่มีรีวิว เป็นคนแรกที่รีวิวเลย!</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <%-- ✅✅✅ จบส่วนรีวิว ✅✅✅ --%>

            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-search"></i>
                    <h2>ไม่พบข้อมูลสินค้า</h2>
                    <p>สินค้านี้อาจถูกลบหรือไม่มีอยู่ในระบบ</p>
                    <a href="AllProduct" class="btn-back">กลับไปหน้ารวมสินค้า</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <footer class="site-footer">
        <p>&copy; 2025 Fish Online Shop. All rights reserved.</p>
    </footer>

    <script>
        const maxStock = parseInt('${not empty product ? product.stock : 0}');
        const qtyInput = document.getElementById('qtyInput');

        function increaseQty() {
            if (!qtyInput) return;
            let currentVal = parseInt(qtyInput.value);
            if (!isNaN(maxStock) && currentVal < maxStock) {
                qtyInput.value = currentVal + 1;
            }
        }

        function decreaseQty() {
            if (!qtyInput) return;
            let currentVal = parseInt(qtyInput.value);
            if (currentVal > 1) {
                qtyInput.value = currentVal - 1;
            }
        }

        function addToCart(productId) {
            <c:if test="${empty sessionScope.user}">
                window.location.href = "Login";
                return;
            </c:if>
            
            const qty = qtyInput ? qtyInput.value : 1;
            window.location.href = "addToCart?productId=" + productId + "&quantity=" + qty;
        }
    </script>
</body>
</html>