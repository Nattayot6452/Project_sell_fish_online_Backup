<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %> 

<!DOCTYPE html>
<html>
<head>
    <title>ประวัติการสั่งซื้อ</title>
    <link rel="stylesheet" type="text/css" href="assets/css/history.css"> 
</head>
<body>

    <div class="header">
        <a href="Home"><img src="assets/images/icon/fishTesting.png" alt="โลโก้ปลา" class="logo"></a>
        <form action="SearchProducts" method="POST" class="search-box">
            <input type="text" name="searchtext" placeholder="ค้นหา...">
            <button type="submit">🔍</button>
        </form>
    </div>

    <div class="nav">
        <a href="Home">หน้าแรก</a>
        <a href="AllProduct">สินค้าทั้งหมด</a>
        <a href="Orders">คำสั่งซื้อ</a>
        <a href="History" style="font-weight: bold;">ประวัติ</a>
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

    <h1 style="text-align: center; padding-top: 20px;">ประวัติการสั่งซื้อ</h1>

</body>
</html>