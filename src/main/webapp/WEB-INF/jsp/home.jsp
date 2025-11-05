<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.springmvc.model.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> 

<!DOCTYPE html>
<html>
<head>
    <title>หน้าแรก</title>
    <link rel="stylesheet" type="text/css" href="assets/css/home.css">
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

    <div class="nav">
        <a href="Home">หน้าแรก</a>
        <a href="AllProduct">สินค้าทั้งหมด</a>
        <a href="Orders">คำสั่งซื้อ</a>
        <a href="History">ประวัติ</a>
        <a href="Cart">ตะกร้าสินค้า</a>
        <c:if test="${not empty sessionScope.user}">
            <a href="Favorites">รายการโปรด</a>
            <a href="Profile">สวัสดี, ${sessionScope.user.memberName}</a>
            <a href="Logout">ออกจากระบบ</a>
        </c:if>
        <c:if test="${empty sessionScope.user}">
            <a href="Login">เข้าสู่ระบบ</a>
        </c:if>
    </div>

    <section class="news-slider">
        <div class="slides">
            <div class="slide active">
              <img src="assets/images/slider/slide1.jpg" alt="โปรโมชั่น">
            </div>
            <div class="slide">
              <img src="assets/images/slider/slide2.jpg" alt="ปลาใหม่">
            </div>
        </div>
        <button class="prev">&#10094;</button>
        <button class="next">&#10095;</button>
    </section>

    <div class="container">
        <section class="categories-section">
            <h2>เลือกตามหมวดหมู่</h2>
            <div class="category-grid">
                <a href="AllProduct?category=ปลากัด" class="category-card">
                    <img src="assets/images/categories/betta.jpg" alt="ปลากัด">
                    <h3>ปลากัด</h3>
                </a>
                <a href="AllProduct?category=ปลาหางนกยูง" class="category-card">
                    <img src="assets/images/categories/guppy.jpg" alt="ปลาหางนกยูง">
                    <h3>ปลาหางนกยูง</h3>
                </a>
                <a href="AllProduct?category=ปลาทอง" class="category-card">
                    <img src="assets/images/categories/goldfish.jpg" alt="ปลาทอง">
                    <h3>ปลาทอง</h3>
                </a>
                <a href="AllProduct?category=ปลาเล็ก" class="category-card">
                    <img src="assets/images/categories/tetra.jpeg" alt="ปลาเล็ก (เตตร้า)">
                    <h3>ปลาเล็ก</h3>
                </a>
            </div>
        </section>
    </div>

    <div class="container">
        <section class="featured-products">
            <h2>สินค้าแนะนำ</h2>
            <div class="product-grid">
                <c:choose>
                    <c:when test="${not empty featuredProducts}">
                        <c:forEach items="${featuredProducts}" var="products">
                            <div class="product-card">
                                <div class="card-buttons">
                                   <a href="${empty sessionScope.user ? 'Login' : 'addToFavorites?productId='.concat(products.productId)}"
                                       class="card-icon-btn add-to-favorite-btn" title="เพิ่มเข้ารายการโปรด">❤️</a>
                                   <a href="${empty sessionScope.user ? 'Login' : 'addToCart?productId='.concat(products.productId)}"
                                      class="card-icon-btn add-to-cart-btn" title="หยิบใส่ตะกร้า">🛒</a>
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
                    </c:when>
                    <c:otherwise>
                        <p>ยังไม่มีสินค้าแนะนำในขณะนี้</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </div>

    <section class="promo-banner">
    </section>

    <script>
      document.addEventListener("DOMContentLoaded", () => {
        let current = 0;
        const slides = document.querySelectorAll(".slide");
        if (slides.length === 0) return; // (เพิ่ม) ป้องกัน Error ถ้าไม่มีสไลด์
        const total = slides.length;
        const nextBtn = document.querySelector(".next");
        const prevBtn = document.querySelector(".prev");
        
        function showSlide(n) {
          slides.forEach(s => s.classList.remove("active"));
          slides[n].classList.add("active");
        }
        function nextSlide() {
          current = (current + 1) % total;
          showSlide(current);
        }
        function prevSlide() {
          current = (current - 1 + total) % total;
          showSlide(current);
        }
        
        nextBtn.addEventListener("click", nextSlide);
        prevBtn.addEventListener("click", prevSlide);
        setInterval(nextSlide, 5000); // 5 วินาที
      });
    </script>

</body>
</html>