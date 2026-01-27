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

    <jsp:include page="navbar.jsp" />

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
                                
                                <c:choose>
                                    <c:when test="${p.productImg.startsWith('assets')}">
                                        <img src="${pageContext.request.contextPath}/${p.productImg}" alt="${p.productName}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/displayImage?name=${p.productImg}" alt="${p.productName}">
                                    </c:otherwise>
                                </c:choose>
                                
                                <a href="RemoveFavorite?favId=${fav.favoriteId}" class="btn-remove" 
                                   title="ลบออกจากรายการโปรด"
                                   onclick="confirmRemoveFavorite(event, this.href);">
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

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    function confirmRemoveFavorite(event, url) {
        event.preventDefault(); 

        Swal.fire({
            title: 'ลบจากรายการโปรด?',
            text: "สินค้านี้จะถูกนำออกจากรายการโปรดของคุณ",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#e53e3e',  
            cancelButtonColor: '#718096',   
            confirmButtonText: 'ใช่, ลบเลย!',
            cancelButtonText: 'ยกเลิก',
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = url; 
            }
        });
    }
</script>

</body>
</html>