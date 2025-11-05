<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>คำสั่งซื้อ</title>
    <link rel="stylesheet" type="text/css" href="assets/css/orders.css"> 
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
        <a href="Orders" style="font-weight: bold;">คำสั่งซื้อ</a>
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

    <h1 style="text-align: center; padding-top: 20px;">คำสั่งซื้อ</h1>

    <div class="alert-container">
        <c:if test="${not empty successMessage}">
            <div class="alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert-error">${errorMessage}</div>
        </c:if>
    </div>

    <c:choose>
        <c:when test="${not empty orderList}">
            <table class="cart-table">
                <thead>
                    <tr>
                        <th style="width: 20%;">หมายเลขคำสั่งซื้อ</th>
                        <th style="width: 10%;">วันที่สั่งซื้อ</th>
                        <th>รายการสินค้า</th>
                        <th class="text-right" style="width: 12%;">ยอดรวม</th>
                        <th class="text-center" style="width: 15%;">สถานะ</th>
                        <th class="text-center" style="width: 15%;"></th> <%-- (สำหรับปุ่ม) --%>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${orderList}" var="order">
                        <tr>
                            <td>${order.ordersId}</td>
                            <td>
                                <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/>
                            </td>
                            <td>
                                <ul class="order-item-list">
                                    <c:forEach items="${order.orderDetails}" var="detail">
                                        <li>
                                            ${detail.product.productName} (x${detail.quantity})
                                        </li>
                                    </c:forEach>
                                </ul>
                            </td>
                            <td class="text-right">
                                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="฿" maxFractionDigits="2"/>
                            </td>
                            <td class="text-center">
                                <span class="status 
                                    ${order.status == 'รอดำเนินการชำระเงิน' ? 'status-pending' : ''}
                                    ${order.status == 'กำลังตรวจสอบ' ? 'status-inspecting' : ''}
                                    ${order.status == 'VerifyingPayment' ? 'status-verifying' : ''}
                                    ${order.status == 'Shipping' ? 'status-shipping' : ''}
                                    ${order.status == 'Completed' ? 'status-completed' : ''}
                                    ${order.status == 'Cancelled' ? 'status-cancelled' : ''}
                                ">
                                    ${order.status}
                                </span>
                            </td>
                            <td class="text-center">
                                <c:if test="${order.status == 'Pending Payment'}">
                                    <a href="uploadSlip?orderId=${order.ordersId}" class="btn btn-pay">
                                        แจ้งชำระเงิน
                                    </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <p class="empty-cart">คุณยังไม่มีคำสั่งซื้อที่กำลังดำเนินการ</p>
        </c:otherwise>
    </c:choose>

</body>
</html>