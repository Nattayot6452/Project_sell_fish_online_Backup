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
    <title>รายการโปรด | Fish Online</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/favarite.css">
    <link rel="stylesheet" type="text/css" href="assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

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
                    <a href="Cart" class="cart-link" title="ตะกร้าสินค้า">
                        <i class="fas fa-shopping-cart"></i>
                    </a>

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

    <div class="container main-container">
        
        <div class="page-header">
            <h1><i class="fas fa-heart" style="color: #e74c3c;"></i> รายการโปรดของคุณ</h1>
            <p>รวมสินค้าที่คุณชื่นชอบและบันทึกไว้</p>
        </div>

        <div class="product-grid">
            <c:choose>
                <c:when test="${not empty favoriteList}">
                    <c:forEach items="${favoriteList}" var="fav">
                        <c:set var="p" value="${fav.product}"/>
                        
                        <div class="product-card">
                            <div class="product-img-box">
                                
                                <%-- ✅ Logic รูปภาพ (Hybrid) ✅ --%>
                                <c:choose>
                                    <c:when test="${p.productImg.startsWith('assets')}">
                                        <img src="${pageContext.request.contextPath}/${p.productImg}" alt="${p.productName}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/profile-uploads/${p.productImg}" alt="${p.productName}">
                                    </c:otherwise>
                                </c:choose>
                                <%-- ✅ จบ Logic ✅ --%>
                                
                                <a href="RemoveFavorite?favId=${fav.favoriteId}" class="btn-remove" 
                                   title="ลบออกจากรายการโปรด"
                                   onclick="return confirm('คุณต้องการลบสินค้านี้ออกจากรายการโปรดใช่หรือไม่?');">
                                    <i class="fas fa-times"></i>
                                </a>

                                <c:if test="${p.stock == 0}">
                                    <div class="out-of-stock-badge">สินค้าหมด</div>
                                </c:if>
                            </div>

                            <div class="product-info">
                                <h3 class="product-name">${p.productName}</h3>
                                <div class="price-row">
                                    <span class="price">
                                        <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="฿"/>
                                    </span>
                                </div>
                                
                                <div class="action-buttons">
                                    <a href="ProductDetail?pid=${p.productId}" class="btn-detail">
                                        ดูรายละเอียด
                                    </a>
                                    <c:if test="${p.stock > 0}">
                                        <a href="addToCart?productId=${p.productId}" class="btn-cart">
                                            <i class="fas fa-cart-plus"></i> ใส่ตะกร้า
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-icon">
                            <i class="far fa-heart"></i>
                        </div>
                        <h2>ยังไม่มีสินค้าในรายการโปรด</h2>
                        <p>กดหัวใจที่สินค้าเพื่อบันทึกไว้ดูภายหลังได้เลย</p>
                        <a href="AllProduct" class="btn-shop-now">
                            <i class="fas fa-store"></i> เลือกชมสินค้า
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <footer class="site-footer">
        <p>&copy; 2025 Fish Online Shop. All rights reserved.</p>
    </footer>

</body>
</html>