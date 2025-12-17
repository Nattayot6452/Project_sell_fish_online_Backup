<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>แก้ไขข้อมูลส่วนตัว | Fish Online</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/editProfile.css">
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
    
    <div class="container main-container">
        <div class="edit-card">
            
            <div class="card-header">
                <h1><i class="fas fa-user-edit"></i> แก้ไขข้อมูลส่วนตัว</h1>
                <p>อัปเดตข้อมูลของคุณให้เป็นปัจจุบัน</p>
            </div>

            <div class="card-body">
                <div class="current-img-wrapper">
                    <img src="${pageContext.request.contextPath}/profile-uploads/user/${sessionScope.user.memberImg}" 
                         alt="Profile Image" class="profile-img-preview">
                    <div class="edit-icon-overlay"><i class="fas fa-camera"></i></div>
                </div>

                <form action="updateProfile" method="post" enctype="multipart/form-data" class="edit-form">
                    <input type="hidden" name="memberId" value="${sessionScope.user.memberId}">

                    <div class="form-group">
                        <label for="memberName">ชื่อผู้ใช้งาน</label>
                        <div class="input-with-icon">
                            <i class="fas fa-user"></i>
                            <input type="text" id="memberName" name="memberName" value="${sessionScope.user.memberName}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="email">อีเมล</label>
                        <div class="input-with-icon">
                            <i class="fas fa-envelope"></i>
                            <input type="email" id="email" name="email" value="${sessionScope.user.email}" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">เบอร์โทรศัพท์</label>
                        <div class="input-with-icon">
                            <i class="fas fa-phone"></i>
                            <input type="tel" id="phone" name="phone" value="${sessionScope.user.phone}" required
                                   maxlength="10" oninput="this.value=this.value.replace(/[^0-9]/g,'');">
                        </div>
                    </div>

                    <div class="form-group file-group">
                        <label for="profileImg">เปลี่ยนรูปโปรไฟล์</label>
                        <input type="file" id="profileImg" name="profileImg" accept="image/*" class="file-input">
                        <small class="file-hint">รองรับไฟล์ JPG, PNG (อัปโหลดเฉพาะเมื่อต้องการเปลี่ยน)</small>
                    </div>
                    
                    <div class="btn-group">
                        <button type="submit" class="save-btn">
                            <i class="fas fa-save"></i> บันทึก
                        </button>
                        <a href="Profile" class="cancel-link">ยกเลิก</a>
                    </div>
                </form>

                <c:if test="${not empty error}">
                    <div class="error-msg">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                    </div>
                </c:if>
            </div>
        </div>	
    </div>
    
 </body>
 </html>