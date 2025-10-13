<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <title>หน้าแรก</title>
   <style>
    :root {
        --mj-green: #00571d;
        --mj-yellow: #f9e547;
        --mj-white: #fffef9;
    }

    body {
        margin: 0;
        font-family: "Sarabun", sans-serif;
        background-color: var(--mj-white);
    }

    /* Header */
    .header {
        display: flex;
        align-items: center;
        padding: 10px 20px;
        background-color: var(--mj-yellow);
    }

    .logo {
        width: 60px;
        height: 60px;
        transform: scale(1.5); /* ขยายรูป 1.5 เท่า */
    	transform-origin: center; /* ขยายจากตรงกลาง */
    }

    .search-box {
        margin-left: 20px;
        flex: 1;
        display: flex;
        align-items: center;
    }

    .search-box input[type="text"] {
        width: 100%;
        padding: 10px;
        font-size: 16px;
        border: none;
        border-radius: 5px 0 0 5px;
    }

    .search-box button {
        padding: 10px;
        background-color: var(--mj-green);
        color: white;
        border: none;
        border-radius: 0 5px 5px 0;
        cursor: pointer;
    }

    /* Menu */
    .nav {
        display: flex;
        justify-content: center;
        background-color: var(--mj-green);
    }

    .nav a {
        padding: 14px 20px;
        text-decoration: none;
        color: white;
        border-right: 1px solid #ccc;
    }

    .nav a:hover {
        background-color: #004414;
    }

    /* Product Section */
    .product-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
        gap: 20px;
        padding: 30px;
    }

    .product-card {
        background-color: #ffffff;
        border: 1px solid #ddd;
        border-radius: 10px;
        padding: 15px;
        text-align: center;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        transition: transform 0.2s ease-in-out;
    }

    .product-card:hover {
        transform: scale(1.03);
    }

    .product-card img {
        width: 100%;
        height: 180px;
        object-fit: cover;
        border-radius: 8px;
        margin-bottom: 10px;
    }

    .product-name {
        font-size: 16px;
        font-weight: bold;
        color: #333;
        margin-bottom: 10px;
    }

  
</style>
<body>

	<div class="header">
    <a href="gHome">
        <img src="assets/images/icon/fishTesting.png" alt="โลโก้ปลา" class="logo">
    </a>      
    <form action="gSearchProducts" method="POST" class="search-box">
        <input type="text" name="searchtext" placeholder="ปลาหางนกยูง">
        <button type="submit">🔍</button>
    </form>
</div>

    <!-- Menu -->
    <div class="nav">
        <a href="gHome">หน้าแรก</a>
        <a href="gAllProduct">สินค้าทั้งหมด</a>
        <a href="#">รายการโปรด</a>
        <a href="#">คำสั่งซื้อ</a>
        <a href="#">ประวัติ</a>
        <a href="#">ตะกร้าสินค้า</a>
        <a href="gLogin">เข้าสู่ระบบ</a>
    </div>
    
   <!-- Main Content -->
<h1 style="text-align: center; padding-top: 20px;">
    ผลการค้นหา "<c:out value="${param.searchtext}" />"
</h1>

<div class="product-grid">
    <c:forEach items="${Product}" var="products">
        <div class="product-card">
            <img src="${products.productImg}" alt="รูปภาพของ ${products.productName}">
            <div class="product-name">${products.productName}
            <div class="product-price">ราคา: ${products.price} บาท</div>
            <div class="product-price">จำนวน: ${products.stock} ตัว</div>
            </div>
        </div>
    </c:forEach>
</div>

   
</body>
</html>