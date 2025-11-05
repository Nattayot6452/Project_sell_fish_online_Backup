<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>อัปโหลดสลิป</title>
    <link rel="stylesheet" type="text/css" href="assets/css/uploadSlip.css">
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
        <a href="Orders">คำสั่งซื้อ</a>
        <a href="History">ประวัติ</a>
        <a href="Cart">ตะกร้าสินค้า</a>
        <c:if test="${not empty sessionScope.user}">
            <a href="Favorites">รายการโปรด</a>
            <a href="Profile">สวัสดี, ${sessionScope.user.memberName}</a>
            <a href="Logout">ออกจากระบบ</a>
        </c:if>
        <c:if test="${empty sessionScope.user}">
            <a href="Login">เข้าสู่ระบบ</a>
        </c:if>
    </div>
   
    <div class="upload-container">
        <h2>อัปโหลดหลักฐานการชำระเงิน</h2>
        
        <p>สำหรับคำสั่งซื้อหมายเลข: <strong>${orderId}</strong></p>
        
        <form action="doUploadSlip" method="post" enctype="multipart/form-data">
            
            <input type="hidden" name="orderId" value="${orderId}">
            
            <div class="form-group">
                <label for="slipImage">เลือกไฟล์สลิป (JPG, PNG):</label>
                <input type="file" name="slipImage" id="slipImage" accept="image/jpeg, image/png" required>
            </div>
            
            <button type="submit" class="submit-btn">ยืนยันการอัปโหลด</button>
        </form>
    </div>
</body>
</html>