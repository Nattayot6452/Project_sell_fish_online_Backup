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
    <title>รายการสินค้า</title>
    <link rel="stylesheet" type="text/css" href="assets/css/products.css">
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
            <c:choose>
                <c:when test="${not empty param.searchtext}">
                    <h1><i class="fas fa-search"></i> ผลการค้นหา: <span>"${param.searchtext}"</span></h1>
                </c:when>
                <c:otherwise>
                    <h1><i class="fas fa-th-large"></i> รายการสินค้าทั้งหมด</h1>
                </c:otherwise>
            </c:choose>
            <p>พบสินค้าทั้งหมด ${not empty Product ? Product.size() : 0} รายการ</p>
        </div>

        <div class="product-grid">
            <c:choose>
                <c:when test="${not empty Product}">
                    <c:forEach items="${Product}" var="products">
                        <div class="product-card">
                            <div class="product-img-box">
                                
                                <%-- ✅ Logic รูปภาพ (Hybrid) ✅ --%>
                                <c:choose>
                                    <c:when test="${products.productImg.startsWith('assets')}">
                                        <img src="${pageContext.request.contextPath}/${products.productImg}" 
                                             alt="${products.productName}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/profile-uploads/${products.productImg}" 
                                             alt="${products.productName}">
                                    </c:otherwise>
                                </c:choose>
                                <%-- ✅ จบ Logic ✅ --%>
                                
                                <div class="card-actions">
                                    <a href="${empty sessionScope.user ? 'Login' : 'addToCart?productId='.concat(products.productId)}"
                                       class="action-btn" title="หยิบใส่ตะกร้า">
                                       <i class="fas fa-cart-plus"></i>
                                    </a>
                                    <a href="${empty sessionScope.user ? 'Login' : 'addToFavorites?productId='.concat(products.productId)}"
                                       class="action-btn" title="เพิ่มรายการโปรด">
                                       <i class="fas fa-heart"></i>
                                    </a>
                                    <a href="ProductDetail?pid=${products.productId}" class="action-btn" title="ดูรายละเอียด">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                </div>

                                <c:if test="${products.stock == 0}">
                                    <div class="out-of-stock-badge">สินค้าหมด</div>
                                </c:if>
                            </div>

                            <div class="product-info">
                                <h3 class="product-name">${products.productName}</h3>
                                <div class="price-row">
                                    <span class="price">
                                        <fmt:formatNumber value="${products.price}" type="currency" currencySymbol="฿"/>
                                    </span>
                                    <span class="stock-status ${products.stock > 0 ? 'in-stock' : 'out-stock'}">
                                        ${products.stock > 0 ? 'มีสินค้า' : 'หมด'}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-box-open"></i>
                        <p>ไม่พบสินค้าที่คุณค้นหา ลองใช้คำค้นอื่นดูนะ</p>
                        <a href="AllProduct" class="btn-back">ดูสินค้าทั้งหมด</a>
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