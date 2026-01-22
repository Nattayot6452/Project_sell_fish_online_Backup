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

      <jsp:include page="navbar.jsp" />

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