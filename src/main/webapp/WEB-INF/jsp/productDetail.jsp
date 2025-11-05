<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <title>รายละเอียดสินค้า</title>
   	<link rel="stylesheet" type="text/css" href="assets/css/productDetail.css">
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
<c:choose>
    <c:when test="${not empty product}">
        <div class="product-container">
            <div class="product-image">
                <img src="${product.productImg}" alt="${product.productName}" class="main-img">
            </div>

            <div class="product-info">
                <h2 class="product-name">${product.productName}</h2>
                <p class="product-id">${product.productId}</p>
                <p class="product-price">${product.price} บาท</p>

                <div class="product-details">
                    <p>แหล่งกำเนิด: ${product.origin}</p>
                    <p>ประเภทน้ำ: ${product.waterType}</p>
                    <p>อุณหภูมิที่เหมาะสม: ${product.temperature}</p>
                    <p>ขนาด: ${product.size}</p>
                    <p>อายุขัย: ${product.lifeSpan}</p>
                    <p>ความก้าวร้าว: ${product.isAggressive}</p>
                    <p>ระดับการดูแล: ${product.careLevel}</p>
                </div>

                <div class="quantity-box">
                    <label>คงเหลือ</label>
                    <span>${product.stock}</span> ตัว
                    <div class="quantity-control">
                        <button type="button" class="btn-qty">-</button>
                        <input type="text" value="1" class="qty-input" readonly>
                        <button type="button" class="btn-qty">+</button>
                    </div>
                </div>

                <button class="add-to-cart-btn">หยิบใส่ตะกร้า</button>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <h3 style="color:red;">ไม่พบข้อมูลสินค้าในระบบ</h3>
    </c:otherwise>
</c:choose>

</body>
</html>
