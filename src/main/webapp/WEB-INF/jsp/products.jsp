<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <title>สินค้าทั้งหมด</title>
    <link rel="stylesheet" type="text/css" href="assets/css/products.css">
</head>
<body>
	<div class="header">
    <a href="Home">
        <img src="assets/images/icon/fishTesting.png" alt="โลโก้ปลา" class="logo">
    </a>      
    <form action="SearchProducts" method="POST" class="search-box">
        <input type="text" name="searchtext" placeholder="ปลาหางนกยูง">
        <button type="submit">🔍</button>
    </form>
</div>

    <!-- Menu -->
    <div class="nav">
        <a href="Home">หน้าแรก</a>
        <a href="AllProduct">สินค้าทั้งหมด</a>
        <a href="#">รายการโปรด</a>
        <a href="#">คำสั่งซื้อ</a>
        <a href="#">ประวัติ</a>
        <a href="#">ตะกร้าสินค้า</a>
        <a href="Login">เข้าสู่ระบบ</a>
    </div>
    
   <!-- Main Content -->
<h1 style="text-align: center; padding-top: 20px;">
    ผลการค้นหา "<c:out value="${param.searchtext}" />"
</h1>
   
    <div class="product-grid">
        <c:forEach items="${Product}" var="products">
            <div class="product-card">

                <div class="card-buttons">
                   <a href="${empty sessionScope.user ? 'Login' : 'addToFavorites?productId='.concat(products.productId)}"
					   class="card-icon-btn add-to-favorite-btn"
					   title="เพิ่มเข้ารายการโปรด">
					   ❤ 
					</a>
                    <a href="${empty sessionScope.user ? 'Login' : 'addToCart?productId='.concat(products.productId)}"
                       class="card-icon-btn add-to-cart-btn" 
                       title="หยิบใส่ตะกร้า">
                       🛒 
                    </a>
                </div>
               <img src="${products.productImg}" alt="รูปภาพของ ${products.productName}"> 

                <div class="product-info">
                    <div class="product-name">${products.productName}</div>
                    <div class="product-price">ราคา: ${products.price} บาท</div>
                    <div class="product-price">จำนวน: ${products.stock} ตัว</div>
                   	<a href="ProductDetail?pid=${products.productId}" class="btn">ดูรายละเอียดสินค้า</a> 
                </div>
                
            </div>
        </c:forEach>
    </div>
   
</body>
</html>