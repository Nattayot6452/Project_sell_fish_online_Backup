<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <title>ล็อคอิน</title>
    <link rel="stylesheet" type="text/css" href="assets/css/login.css">
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
<div class="login-container">
    <div class="login-box">
        <img src="assets/images/icon/fishTesting.png" alt="Fish Logo">

        <!-- ปุ่มเลือกประเภทการเข้าสู่ระบบ -->
<div class="tab">
    <button type="button" class="active" onclick="setRole('user', this)">ผู้ใช้</button>
    <button type="button" class="inactive" onclick="setRole('staff', this)">เจ้าหน้าที่</button>
</div>

<!-- ฟอร์ม -->
<form action="login" method="post">
    <!-- hidden field เก็บค่า role -->
    <input type="hidden" id="role" name="role" value="user">

    <div class="form-group">
        <label for="email">อีเมล</label>
        <div class="email-box">
            <input type="text" id="email" name="email" placeholder="กรอกอีเมล" required>
        </div>
    </div>

    <div class="form-group">
        <label for="password">รหัสผ่าน</label>
        <div class="password-box">
            <input type="password" id="password" name="password" placeholder="กรอกรหัสผ่าน" required>
        </div>
    </div>

    <div class="register-link">
        <a href="Register">สมัครสมาชิก</a>
    </div>

    <button type="submit" class="login-btn">เข้าสู่ระบบ</button>
</form>

<c:if test="${not empty error}">
    <p style="color:red;">${error}</p>
</c:if>

</div>
</div>
   
 </body>
 </html>