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
        <jsp:include page="loading.jsp" />

       <jsp:include page="navbar.jsp" />
    
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
                    <c:forEach items="${Product}" var="p">
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
                                
                                <c:if test="${p.newProduct}">
                                    <div class="new-badge">NEW</div>
                                </c:if>

                                <div class="card-actions">
                                    <c:if test="${p.stock > 0}"> <a href="addToCart?productId=${p.productId}" class="action-btn" title="หยิบใส่ตะกร้า">
                                            <i class="fas fa-cart-plus"></i>
                                        </a>
                                    </c:if>

                                    <a href="addToFavorites?productId=${p.productId}" class="action-btn" title="เพิ่มรายการโปรด">
                                        <i class="fas fa-heart"></i>
                                    </a>
                                    <a href="ProductDetail?pid=${p.productId}" class="action-btn" title="ดูรายละเอียด">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                </div>

                                <c:if test="${p.stock == 0}"> <div class="out-of-stock-badge">สินค้าหมด</div>
                                </c:if>
                            </div>

                            <div class="product-info">
                                <h3 class="product-name">${p.productName}</h3> <small style="color: #999; font-size: 12px; display: block; margin-bottom: 5px;">
                                    ID: ${p.productId}
                                </small>
                                <div class="price-row">
                                    <span class="price">
                                        <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="฿"/>
                                    </span>
                                    <span class="stock-status ${p.stock > 0 ? 'in-stock' : 'out-stock'}">
                                        ${p.stock > 0 ? 'มีสินค้า' : 'หมด'}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <style>
                        body {
                            height: 100vh;      
                            overflow: hidden;  
                            display: flex;
                            flex-direction: column;
                        }
                        .main-container {
                            flex: 1;
                            display: flex;
                            flex-direction: column;
                            justify-content: center;
                        }
                        .site-footer {
                            margin-top: auto;
                            width: 100%;
                        }
                        .page-header {
                            margin-top: 0;
                            margin-bottom: 20px;
                            text-align: center;
                        }
                    </style>

                    <div class="empty-state" style="text-align: center;">
                        <i class="fas fa-box-open" style="font-size: 100px; margin-bottom: 20px; color: #ccc;"></i>
                        <p style="font-size: 18px; color: #666; margin-bottom: 20px;">ไม่พบสินค้าที่คุณค้นหา ลองใช้คำค้นอื่นดูนะ</p>
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