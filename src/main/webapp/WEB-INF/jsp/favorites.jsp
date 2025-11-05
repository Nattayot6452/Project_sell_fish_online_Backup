<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <title>รายการโปรด</title>
    <link rel="stylesheet" type="text/css" href="assets/css/favarite.css"> 
    
</head>
<body>

    <div class="header">
        <a href="Home">
            <img src="assets/images/icon/fishTesting.png" alt="โลโก้ปลา" class="logo">
        </a>      
        <form action="SearchProducts" method="POST" class="search-box">
            <input type="text" name="searchtext" placeholder="ค้นหาสินค้าในรายการโปรด...">
            <button type="submit">🔍</button>
        </form>
    </div>

    <div class="nav">
        <a href="Home">หน้าแรก</a>
        <a href="AllProduct">สินค้าทั้งหมด</a>
        <a href="Favorites" style="font-weight: bold;">รายการโปรด</a> <a href="Orders">คำสั่งซื้อ</a>
        <a href="History">ประวัติ</a>
        <a href="Cart">ตะกร้าสินค้า</a>

        <c:if test="${not empty sessionScope.user}">
            <a href="Profile">สวัสดี, ${sessionScope.user.memberName}</a>
            <a href="Logout">ออกจากระบบ</a>
        </c:if>

        <c:if test="${empty sessionScope.user}">
            <a href="Login">เข้าสู่ระบบ</a> 
        </c:if>
    </div>

    <h1 style="text-align: center; padding-top: 20px;">รายการโปรดของคุณ</h1>

    <div class="product-grid">
        
        <c:choose>
            <c:when test="${not empty favoriteList}">
                
                <c:forEach items="${favoriteList}" var="fav">
                    <c:set var="product" value="${fav.product}"/>
                    <div class="product-card">
                        <img src="${product.productImg}" alt="รูปภาพของ ${product.productName}">
                        <div class="product-name">${product.productName}</div>
                        <div class="product-price">ราคา: ${product.price} บาท</div>
                        
                        <a href="ProductDetail?pid=${product.productId}" class="btn">ดูรายละเอียด</a>
                        
                        <a href="RemoveFavorite?favId=${fav.favoriteId}" class="remove-fav-btn" 
                           onclick="return confirm('คุณต้องการลบสินค้านี้ออกจากรายการโปรดใช่หรือไม่?');">
                           ลบออกจากโปรด
                        </a>
                    </div>
                </c:forEach>
                
            </c:when>
            <c:otherwise>
                <p class="empty-favorites">คุณยังไม่มีสินค้าในรายการโปรด</p>
            </c:otherwise>
        </c:choose>
        
    </div>
</body>
</html>