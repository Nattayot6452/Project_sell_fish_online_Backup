<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ข้อมูลส่วนตัว</title>
    <link rel="stylesheet" type="text/css" href="assets/css/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <div class="header">
        <a href="Home"><img src="assets/images/icon/fishTesting.png" alt="โลโก้ปลา" class="logo"></a>
        <form action="SearchProducts" method="POST" class="search-box">
            <input type="text" name="searchtext" placeholder="ปลาหางนกยูง">
            <button type="submit">🔍</button>
        </form>
    </div>

    <div class="nav">
        <a href="Home">หน้าแรก</a>
        <a href="AllProduct">สินค้าทั้งหมด</a>
        <c:if test="${not empty sessionScope.user}">
            <a href="Favorites">รายการโปรด</a>
            <a href="Orders">คำสั่งซื้อ</a>
            <a href="History">ประวัติ</a>
            <a href="Cart">ตะกร้าสินค้า</a>
            <a href="Profile" style="font-weight: bold;">สวัสดี, ${sessionScope.user.memberName}</a> 
            <a href="Logout">ออกจากระบบ</a>
        </c:if>
    </div>

    <div class="main-content">
        <div class="profile-card">
            <div class="profile-header-bg"></div> <div class="profile-img-container">
                <img src="${pageContext.request.contextPath}/profile-uploads/${sessionScope.user.memberImg}" 
                     alt="รูปโปรไฟล์" class="profile-img">
            </div>

            <div class="profile-body">
                <h1 class="username">${sessionScope.user.memberName}</h1>
                <p class="role-badge">สมาชิกทั่วไป</p> <div class="info-list">
                    <div class="info-item">
                        <span class="label"><i class="fas fa-envelope"></i> อีเมล</span>
                        <span class="value">${sessionScope.user.email}</span>
                    </div>
                    <div class="info-item">
                        <span class="label"><i class="fas fa-phone"></i> เบอร์โทร</span>
                        <span class="value">${sessionScope.user.phone}</span>
                    </div>
                </div>

                <div class="action-buttons">
                    <%-- แก้ลิงก์ให้ถูกต้อง (ตัว e เล็ก) --%>
                    <a href="editProfile" class="btn btn-edit">
                        <i class="fas fa-edit"></i> แก้ไขข้อมูลส่วนตัว
                    </a>
                </div>
            </div>
        </div>
    </div>
    </body>
</html>