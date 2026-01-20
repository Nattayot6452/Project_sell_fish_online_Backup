<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>สินค้าทั้งหมด | Fish Online</title>
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/allProduct.css?v=<%=System.currentTimeMillis()%>">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
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

    <div class="main-container">
        
        <div class="page-header">
            <h1><i class="fas fa-store"></i> สินค้าทั้งหมด</h1>
            <p>เลือกชมปลาสวยงามคุณภาพดีที่เราคัดสรรมาเพื่อคุณ</p>
        </div>

        <form action="AllProduct" method="get" class="filter-bar">
            <div class="filter-wrapper">
                <div class="filter-group">
                    <label for="category"><i class="fas fa-filter"></i> หมวดหมู่:</label>
                    <div class="select-wrapper">
                        <select name="category" id="category" onchange="this.form.submit()">
                            <option value="all" ${param.category == 'all' || empty param.category ? 'selected' : ''}>ทั้งหมด</option>
                            <c:forEach items="${speciesList}" var="species">
                                <option value="${species.speciesName}" ${param.category == species.speciesName ? 'selected' : ''}>
                                    ${species.speciesName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="filter-group">
                    <label for="sortBy"><i class="fas fa-sort-amount-down"></i> เรียงตาม:</label>
                    <div class="select-wrapper">
                        <select name="sortBy" id="sortBy" onchange="this.form.submit()">
                            <option value="default" ${param.sortBy == 'default' ? 'selected' : ''}>แนะนำ</option>
                            <option value="best_selling" ${param.sortBy == 'best_selling' ? 'selected' : ''}>สินค้าขายดี</option>
                            <option value="newest" ${param.sortBy == 'newest' ? 'selected' : ''}>ใหม่ที่สุด</option>
                            <option value="oldest" ${param.sortBy == 'oldest' ? 'selected' : ''}>เก่าที่สุด</option>
                            <option value="price_asc" ${param.sortBy == 'price_asc' ? 'selected' : ''}>ราคา: ต่ำ ➜ สูง</option>
                            <option value="price_desc" ${param.sortBy == 'price_desc' ? 'selected' : ''}>ราคา: สูง ➜ ต่ำ</option>
                            <option value="name_asc" ${param.sortBy == 'name_asc' ? 'selected' : ''}>ชื่อ: A-Z</option>
                        </select>
                    </div>
                </div>
            </div>
            <noscript><button type="submit" class="btn-filter">กรองข้อมูล</button></noscript>
        </form>

        <div class="product-grid">
            <c:forEach items="${Product}" var="p">
                <div class="product-card">
                    <div class="product-img-box">
                        <c:choose>
                            <c:when test="${empty p.productImg}">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/fishTesting.png" alt="No Image" style="opacity: 0.5;">
                            </c:when>
                            <c:when test="${p.productImg.startsWith('assets')}">
                                <img src="${pageContext.request.contextPath}/${p.productImg}" alt="${p.productName}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/profile-uploads/${p.productImg}" alt="${p.productName}">
                            </c:otherwise>
                        </c:choose>
                        
                        <div class="card-actions">
                        <c:if test="${p.stock > 0}">
                            <a href="${empty sessionScope.user ? 'Login' : 'addToCart?productId='.concat(p.productId)}"
                            class="action-btn" title="หยิบใส่ตะกร้า">
                            <i class="fas fa-cart-plus"></i>
                            </a>
                        </c:if>

                        <a href="${empty sessionScope.user ? 'Login' : 'addToFavorites?productId='.concat(p.productId)}"
                        class="action-btn" title="เพิ่มรายการโปรด">
                        <i class="fas fa-heart"></i>
                        </a>
                        <a href="ProductDetail?pid=${p.productId}" class="action-btn" title="ดูรายละเอียด">
                        <i class="fas fa-eye"></i>
                        </a>
                    </div>

                        <c:if test="${p.stock == 0}">
                            <div class="out-of-stock-badge">สินค้าหมด</div>
                        </c:if>
                    </div>

                    <div class="product-info">
                        <h3 class="product-name">${p.productName}</h3>
                        
                        <div class="price-row" style="display: flex; justify-content: space-between; align-items: center; margin-top: 10px;">
                            <span class="price" style="font-size: 1.1rem; font-weight: bold; color: #00571d;">
                                <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="฿"/>
                            </span>
                            
                            <span class="stock-badge-info ${p.stock < 5 ? 'low-stock' : ''}">
                                <i class="fas fa-box-open"></i> 
                                ${p.stock > 0 ? p.stock : 'หมด'} 
                                ${p.stock > 0 ? 'ตัว' : ''}
                            </span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <a href="AllProduct?page=${currentPage - 1}&sortBy=${param.sortBy}&category=${param.category}"
                   class="page-link ${currentPage == 1 ? 'disabled' : ''}">
                   <i class="fas fa-chevron-left"></i> ก่อนหน้า
                </a>

                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="AllProduct?page=${i}&sortBy=${param.sortBy}&category=${param.category}"
                       class="page-link ${i == currentPage ? 'active' : ''}">
                       ${i}
                    </a>
                </c:forEach>

                <a href="AllProduct?page=${currentPage + 1}&sortBy=${param.sortBy}&category=${param.category}"
                   class="page-link ${currentPage == totalPages ? 'disabled' : ''}">
                   ถัดไป <i class="fas fa-chevron-right"></i>
                </a>
            </div>
        </c:if>

    </div>

    <footer class="site-footer">
        <p>&copy; 2025 Fish Online Shop. All rights reserved.</p>
    </footer>

</body>
</html>