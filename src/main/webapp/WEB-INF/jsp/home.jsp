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
    <title>Fish Online - ยินดีต้อนรับ</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" type="text/css" href="assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    
    <jsp:include page="loading.jsp" />

   <jsp:include page="navbar.jsp" />
    
   <div class="hero-section">
        <div class="slider-container">
            <div class="slide active">
                <img src="${pageContext.request.contextPath}/assets/images/slider/slide1.jpg" alt="Slide 1">
            </div>
            <div class="slide">
                <img src="${pageContext.request.contextPath}/assets/images/slider/slide2.jpg" alt="Slide 2">
            </div>
        </div>
        
        <div class="hero-content">
            <h1>โลกแห่งปลาสวยงาม<br>รอคุณอยู่ที่นี่</h1>
            <p>คัดสรรปลาสายพันธุ์ดี แข็งแรง สีสวย พร้อมส่งตรงถึงหน้าบ้านคุณ รับประกันคุณภาพทุกตัว</p>
            <a href="AllProduct" class="cta-btn">ช้อปเลยตอนนี้ <i class="fas fa-arrow-right"></i></a>
        </div>
        
        <button class="prev"><i class="fas fa-chevron-left"></i></button>
        <button class="next"><i class="fas fa-chevron-right"></i></button>
    </div>

    <div class="section-container">
        <div class="section-header">
            <h2 class="section-title"><i class="fas fa-star"></i> หมวดหมู่ยอดนิยม</h2>
        </div>
        
        <div class="categories-grid">
            <a href="AllProduct?category=ปลากัดไทย" class="category-card">
                <div class="cat-img-wrapper">
                    <img src="${pageContext.request.contextPath}/assets/images/categories/betta.jpg" alt="ปลากัด">
                </div>
                <span>ปลากัด</span>
            </a>
            <a href="AllProduct?category=ปลาหางนกยูง" class="category-card">
                <div class="cat-img-wrapper">
                    <img src="${pageContext.request.contextPath}/assets/images/categories/guppy.jpg" alt="ปลาหางนกยูง">
                </div>
                <span>ปลาหางนกยูง</span>
            </a>
            <a href="AllProduct?category=ปลาทอง" class="category-card">
                <div class="cat-img-wrapper">
                    <img src="${pageContext.request.contextPath}/assets/images/categories/goldfish.jpg" alt="ปลาทอง">
                </div>
                <span>ปลาทอง</span>
            </a>
            <a href="AllProduct?category=ปลาเนออน" class="category-card">
                <div class="cat-img-wrapper">
                    <img src="${pageContext.request.contextPath}/assets/images/categories/tetra.jpeg" alt="ปลาเนออน">
                </div>
                <span>ปลาเล็ก/ปลาเนออน</span>
            </a>
        </div>
    </div>

    <div class="section-container bg-light">
        <div class="section-header">
            <h2 class="section-title"><i class="fas fa-fire"></i> สินค้าแนะนำ</h2>
            <a href="AllProduct" class="view-all-link">ดูทั้งหมด <i class="fas fa-angle-right"></i></a>
        </div>
        
        <div class="product-grid">
            <c:choose>
                <c:when test="${not empty featuredProducts}">
                    <c:forEach items="${featuredProducts}" var="p">
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
                                
                                <div class="card-actions">
                                    <c:if test="${p.stock > 0}">
                                        <a href="addToCart?productId=${p.productId}" class="action-btn" title="หยิบใส่ตะกร้า"><i class="fas fa-cart-plus"></i></a>
                                    </c:if>
                                    <a href="addToFavorites?productId=${p.productId}" class="action-btn" title="เพิ่มรายการโปรด"><i class="fas fa-heart"></i></a>
                                    <a href="ProductDetail?pid=${p.productId}" class="action-btn" title="ดูรายละเอียด"><i class="fas fa-eye"></i></a>
                                </div>
                                <c:if test="${p.stock == 0}">
                                    <span class="out-of-stock-badge">สินค้าหมด</span>
                                </c:if>
                            </div>
                            <div class="product-info">
                                <h3 class="product-name">${p.productName}</h3>
                                <small style="color: #999; font-size: 12px; display: block; margin-bottom: 5px;">ID: ${p.productId}</small>
                                <div class="price-row">
                                    <span class="price"><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="฿"/></span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-box-open"></i>
                        <p>ยังไม่มีสินค้าแนะนำในขณะนี้</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <footer class="site-footer">
        <p>&copy; 2025 Fish Online Shop. All rights reserved.</p>
    </footer>
    
    <script>
      document.addEventListener("DOMContentLoaded", () => {
        const slides = document.querySelectorAll(".slide");
        if(slides.length === 0) return;
        
        let current = 0;
        const total = slides.length;
        
        function showSlide(n) {
          slides.forEach(s => s.classList.remove("active"));
          slides[n].classList.add("active");
        }
        
        setInterval(() => {
          current = (current + 1) % total;
          showSlide(current);
        }, 5000);

        const nextBtn = document.querySelector(".next");
        const prevBtn = document.querySelector(".prev");
        if(nextBtn && prevBtn) {
            nextBtn.addEventListener("click", () => {
                current = (current + 1) % total;
                showSlide(current);
            });
            prevBtn.addEventListener("click", () => {
                current = (current - 1 + total) % total;
                showSlide(current);
            });
        }
      });
    </script>
    
</body>
</html>