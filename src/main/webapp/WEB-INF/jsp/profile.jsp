<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ข้อมูลส่วนตัว | Fish Online</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/profile.css">
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
                            <span>สวัสดี, ${sessionScope.user.memberName}</span>
                            <i class="fas fa-chevron-down" style="font-size: 10px; margin-left: 3px;"></i>
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

    <div class="container main-container">
        <div class="profile-card">
            
            <div class="profile-header-bg">
                <div class="bg-pattern"></div>
            </div>
            
            <div class="profile-img-container">
                <img src="${pageContext.request.contextPath}/profile-uploads/user/${sessionScope.user.memberImg}" 
                     alt="รูปโปรไฟล์" class="profile-img">
            </div>

            <div class="profile-body">
                <h1 class="username">${sessionScope.user.memberName}</h1>
                <span class="role-badge"><i class="fas fa-check-circle"></i> สมาชิกทั่วไป</span>

                <div class="info-grid">
                    <div class="info-item">
                        <div class="icon-box"><i class="fas fa-envelope"></i></div>
                        <div class="text-box">
                            <span class="label">อีเมล</span>
                            <span class="value">${sessionScope.user.email}</span>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="icon-box"><i class="fas fa-phone"></i></div>
                        <div class="text-box">
                            <span class="label">เบอร์โทรศัพท์</span>
                            <span class="value">${sessionScope.user.phone}</span>
                        </div>
                    </div>
                </div>
                
                </div>
        </div>
    </div>

</body>
</html>