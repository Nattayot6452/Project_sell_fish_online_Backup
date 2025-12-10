<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>แก้ไขข้อมูลส่วนตัว</title>
    <link rel="stylesheet" type="text/css" href="assets/css/editProfile.css">
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
            <a href="Profile">สวัสดี, ${sessionScope.user.memberName}</a> 
            <a href="Logout">ออกจากระบบ</a>
        </c:if>
    </div>
    
    <div class="main-content">
        <div class="edit-card">
            
            <div class="card-header">
                <h1><i class="fas fa-user-edit"></i> แก้ไขข้อมูลส่วนตัว</h1>
            </div>

            <div class="card-body">
                <div class="current-img-wrapper">
                    <img src="${pageContext.request.contextPath}/profile-uploads/${sessionScope.user.memberImg}" 
                         alt="Profile Image" class="profile-img-preview">
                    <p class="img-hint">รูปโปรไฟล์ปัจจุบัน</p>
                </div>

                <form action="updateProfile" method="post" enctype="multipart/form-data" class="edit-form">
                    
                    <input type="hidden" name="memberId" value="${sessionScope.user.memberId}">

                    <div class="form-group">
                        <label for="memberName"><i class="fas fa-user"></i> ชื่อผู้ใช้งาน</label>
                        <input type="text" id="memberName" name="memberName" value="${sessionScope.user.memberName}" required>
                    </div>

                    <div class="form-group">
                        <label for="email"><i class="fas fa-envelope"></i> อีเมล</label>
                        <input type="email" id="email" name="email" value="${sessionScope.user.email}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone"><i class="fas fa-phone"></i> เบอร์โทรศัพท์</label>
                        <input type="tel" id="phone" name="phone" value="${sessionScope.user.phone}" required
                               maxlength="10" oninput="this.value=this.value.replace(/[^0-9]/g,'');">
                    </div>

                    <div class="form-group file-group">
                        <label for="profileImg"><i class="fas fa-camera"></i> เปลี่ยนรูปโปรไฟล์</label>
                        <input type="file" id="profileImg" name="profileImg" accept="image/*" class="file-input">
                        <span class="file-hint">(อัปโหลดเฉพาะเมื่อต้องการเปลี่ยนรูป)</span>
                    </div>
                    
                    <button type="submit" class="save-btn">
                        <i class="fas fa-save"></i> บันทึกการเปลี่ยนแปลง
                    </button>
                </form>

                <c:if test="${not empty error}">
                    <div class="error-msg">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                    </div>
                </c:if>

                <div class="cancel-link-container">
                    <a href="Profile" class="cancel-link">ยกเลิก</a>
                </div>
            </div>
        </div>	
    </div>
    
 </body>
 </html>