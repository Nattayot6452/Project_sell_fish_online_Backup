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

    <jsp:include page="navbar.jsp" />

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
                                <option value="<c:out value="${species.speciesName}" />" ${param.category == species.speciesName ? 'selected' : ''}>
                                    <c:out value="${species.speciesName}" />
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
                <div class="product-card" data-aos="fade-up" data-aos-duration="1000">
                    <div class="product-img-box">
                        <c:choose>
                            <c:when test="${empty p.productImg}">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/fishTesting.png" alt="No Image" style="opacity: 0.5;">
                            </c:when>
                            <c:when test="${p.productImg.startsWith('assets')}">
                                <img src="${pageContext.request.contextPath}/${p.productImg}" alt="${p.productName}">
                            </c:when>
                            <c:otherwise>
                               <img src="${pageContext.request.contextPath}/displayImage?name=${p.productImg}" alt="${p.productName}">
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
                        <h3 class="product-name"><c:out value="${p.productName}" /></h3>
                        <div class="rating-container" style="margin-bottom: 5px;">
                            <c:set var="rating" value="${productRatings[p.productId]}" />
                            <span style="color: #ffc107; font-size: 14px;">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${rating >= i}">
                                            <i class="fas fa-star"></i>
                                        </c:when>
                                        <c:when test="${rating >= i - 0.5}">
                                            <i class="fas fa-star-half-alt"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="far fa-star"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </span>
                            <span style="font-size: 12px; color: #777;">(${rating})</span>
                        </div>
                        <small style="color: #999; font-size: 12px; display: block; margin-bottom: 5px;">
                            ID: ${p.productId}
                        </small>
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