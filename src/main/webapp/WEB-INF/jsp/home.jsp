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

    <div class="hero-section">
        <div class="slider-container">
            <div class="slide active">
                <img src="${pageContext.request.contextPath}/assets/images/slider/slide1.jpg" alt="Slide 1">
                <div class="hero-content">
                    <h1>ยินดีต้อนรับสู่โลกใต้ผืนน้ำ</h1>
                    <p>รวบรวมปลาสวยงามสายพันธุ์ดี ส่งตรงถึงหน้าบ้านคุณ</p>
                    <a href="AllProduct" class="cta-btn">ช้อปเลย <i class="fas fa-arrow-right"></i></a>
                </div>
            </div>
            <div class="slide">
                <img src="${pageContext.request.contextPath}/assets/images/slider/slide2.jpg" alt="Slide 2">
                <div class="hero-content">
                    <h1>สินค้ามาใหม่!</h1>
                    <p>อัปเดตปลาสายพันธุ์หายาก เพาะพันธุ์ดีเยี่ยม</p>
                    <a href="AllProduct" class="cta-btn">ดูสินค้า <i class="fas fa-arrow-right"></i></a>
                </div>
            </div>
            
            <button class="prev"><i class="fas fa-chevron-left"></i></button>
            <button class="next"><i class="fas fa-chevron-right"></i></button>
        </div>
    </div>

    <div class="section-container">
        <h2 class="section-title"><i class="fas fa-layer-group"></i> หมวดหมู่ยอดนิยม</h2>

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
            <h2 class="section-title"><i class="fas fa-star"></i> สินค้าแนะนำสำหรับคุณ</h2>
            <a href="AllProduct" class="view-all-link">ดูทั้งหมด <i class="fas fa-angle-right"></i></a>
        </div>

        <div class="product-grid">
            <c:choose>
                <c:when test="${not empty featuredProducts}">
                    <c:forEach items="${featuredProducts}" var="p">
                        <div class="product-card">
                            <div class="product-img-box">
                                
                                <%-- vvvvv 🟢 แก้ไข: เพิ่ม Logic Hybrid (เก่า/ใหม่) 🟢 vvvvv --%>
                                <c:choose>
                                    <%-- กรณีรูปเก่า (Assets) --%>
                                    <c:when test="${p.productImg.startsWith('assets')}">
                                        <img src="${pageContext.request.contextPath}/${p.productImg}" alt="${p.productName}">
                                    </c:when>
                                    <%-- กรณีรูปใหม่ (Uploads) --%>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/profile-uploads/${p.productImg}" alt="${p.productName}">
                                    </c:otherwise>
                                </c:choose>
                                <%-- ^^^^^ 🟢 (สิ้นสุดการแก้ไข) 🟢 ^^^^^ --%>
                                
                                <div class="card-actions">
                                    <a href="addToCart?productId=${p.productId}" class="action-btn" title="หยิบใส่ตะกร้า">
                                        <i class="fas fa-cart-plus"></i>
                                    </a>
                                    <a href="addToFavorites?productId=${p.productId}" class="action-btn" title="เพิ่มรายการโปรด">
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
                                <div class="price-row">
                                    <span class="price">
                                        <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="฿"/>
                                    </span>
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