<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <title>แก้ไขข้อมูลส่วนตัว</title>
    <link rel="stylesheet" type="text/css" href="assets/css/register.css">
    <style>
        .profile-img-preview {
            display: block;
            margin: 10px auto;
            border-radius: 50%;
            border: 3px solid #eee;
        }
    </style>
</head>
<body>
    
    <div class="main-content">
    <div class="login-container">
        <div class="login-box">
            
            <h1>แก้ไขข้อมูลส่วนตัว</h1>
            
            <img src="${pageContext.request.contextPath}/profile-uploads/${sessionScope.user.memberImg}" alt="Profile Image" width="150" class="profile-img-preview">            
            <form action="updateProfile" method="post" enctype="multipart/form-data">
                
                <input type="hidden" name="memberId" value="${sessionScope.user.memberId}">

                <div class="form-group">
                    <label for="email">อีเมล</label>
                    <div class="fill-box">
                        <input type="email" id="email" name="email" value="${sessionScope.user.email}" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="memberName">ชื่อผู้ใช้งาน</label>
                    <div class="fill-box">
                        <input type="text" id="memberName" name="memberName" value="${sessionScope.user.memberName}" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="phone">เบอร์โทร</label>
                    <div class="fill-box">
                        <input type="tel" id="phone" name="phone" value="${sessionScope.user.phone}" required
                               maxlength="10" oninput="this.value=this.value.replace(/[^0-9]/g,'');">
                    </div>
                </div>

                <div class="form-group">
                    <label for="profileImg">เปลี่ยนรูปภาพโปรไฟล์ (ว่างไว้ ถ้าไม่เปลี่ยน)</label>
                    <div class="fill-box">
                        <input type="file" id="profileImg" name="profileImg" accept="image/*">
                    </div>
                </div>
                
                <button type="submit" class="register-btn">บันทึกการเปลี่ยนแปลง</button>
            </form>

            <c:if test="${not empty error}">
                <p style="color:red;">${error}</p>
            </c:if>

            <a href="Profile" style="display: block; margin-top: 15px;">ยกเลิก</a>
        </div>	
    </div>
</div>
    
 </body>
 </html>