<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <title>สมัครบัญชีผู้ใช้</title>
    <link rel="stylesheet" type="text/css" href="assets/css/register.css">
    <script>
    function setRole(role, btn) {
        document.getElementById("role").value = role;

        const buttons = btn.parentNode.querySelectorAll("button");
        buttons.forEach(b => {
            b.classList.remove("active");
            b.classList.add("inactive");
        });

        btn.classList.remove("inactive");
        btn.classList.add("active");
    }
	</script>
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

    <!-- Menu -->
    <div class="nav">
        <a href="Home">หน้าแรก</a>
        <a href="#">รายการโปรด</a>
        <a href="#">คำสั่งซื้อ</a>
        <a href="#">ประวัติ</a>
        <a href="#">ตะกร้าสินค้า</a>
        <a href="Login">เข้าสู่ระบบ</a>
    </div>
    
   <!-- Main Content -->
<div class="main-content">
    <div class="login-container">
        <div class="login-box">
            <img src="assets/images/icon/fishTesting.png" alt="Fish Logo">

            <!-- ฟอร์ม -->
            <form action="saveRegister" method="post" enctype="multipart/form-data">
                <!-- hidden field เก็บค่า role -->
                <input type="hidden" id="role" name="role" value="user">

                <div class="form-group">
                    <label for="name">ชื่อผู้ใช้งาน</label>
                    <div class="fill-box">
                        <input type="text" id="name" name="name" placeholder="กรอกชื่อผู้ใช้งานของท่าน" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="tel">เบอร์โทร</label>
                    <div class="fill-box">
                        <input type="tel" id="tel" name="tel" placeholder="กรอกเบอร์โทรติดต่อของท่าน" required
                               maxlength="10" oninput="this.value=this.value.replace(/[^0-9]/g,'');">
                    </div>
                </div>

                <div class="form-group">
                    <label for="profileImg">รูปภาพโปรไฟล์</label>
                    <div class="fill-box">
                        <input type="file" id="profileImg" name="profileImg" accept="image/*" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="email">อีเมล</label>
                    <div class="fill-box">
                        <input type="email" id="email" name="email" placeholder="กรอกอีเมลของท่าน" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password">รหัสผ่าน</label>
                    <div class="fill-box">
                        <input type="password" id="password" name="password" placeholder="กรอกรหัสผ่าน" required>
                    </div>
                </div>

                <button type="submit" class="register-btn">สมัครสมาชิก</button>
            </form>
        </div>	
    </div>
</div>
    
 </body>
 </html>