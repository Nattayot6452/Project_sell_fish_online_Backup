<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ข้อมูลส่วนตัว</title>
    <link rel="stylesheet" type="text/css" href="assets/css/allProduct.css">
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
            <a href="#">รายการโปรด</a>
            <a href="#">คำสั่งซื้อ</a>
            <a href="#">ประวัติ</a>
            <a href="#">ตะกร้าสินค้า</a>
            <a href="Profile" style="font-weight: bold;">สวัสดี, ${sessionScope.user.memberName}</a> 
            <a href="Logout">ออกจากระบบ</a>
        </c:if>
    </div>

    <div class="main-content">
        <h1>ข้อมูลส่วนตัว</h1>
        
        <p>ชื่อผู้ใช้: ${sessionScope.user.memberName}</p>
        <p>อีเมล: ${sessionScope.user.email}</p>
        <p>เบอร์โทร: ${sessionScope.user.phone}</p>
        
        <p>รูปโปรไฟล์:</p>
        <img src="${pageContext.request.contextPath}/profile-uploads/${sessionScope.user.memberImg}" alt="Profile Image" width="150">
		<a href="Editprofile" class="btn">แก้ไขข้อมูลส่วนตัว</a>
		
    </div>

</body>
</html>