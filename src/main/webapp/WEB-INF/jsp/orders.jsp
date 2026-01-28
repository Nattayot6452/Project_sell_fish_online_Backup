<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>คำสั่งซื้อของฉัน | Fish Online</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/orders.css">
    <link rel="stylesheet" type="text/css" href="assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <jsp:include page="loading.jsp" />

    <jsp:include page="navbar.jsp" />

    <div class="container main-container">
        
        <div class="page-header">
            <h1><i class="fas fa-box-open"></i> รายการคำสั่งซื้อ</h1>
            <p>ติดตามสถานะคำสั่งซื้อและประวัติการสั่งซื้อของคุณ</p>
        </div>

        <div class="alert-container">
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${errorMessage}</div>
            </c:if>
            <c:if test="${param.upload == 'success'}">
                <div class="alert alert-success"><i class="fas fa-check-circle"></i> แจ้งโอนเงินเรียบร้อยแล้ว! เจ้าหน้าที่จะตรวจสอบสลิปของท่านโดยเร็วที่สุด</div>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${not empty orderList}">
                <div class="orders-table-wrapper">
                    <table class="orders-table">
                        <thead>
                            <tr>
                                <th>หมายเลขคำสั่งซื้อ</th>
                                <th>วันที่สั่งซื้อ</th>
                                <th>รายการสินค้า</th>
                                <th>ยอดรวม</th>
                                <th>สถานะ</th>
                                <th>ดำเนินการ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${orderList}" var="order">
                                <tr>
                                    <td class="order-id">
                                        <span class="id-badge">#${order.ordersId}</span>
                                    </td>
                                    <td>
                                        <div class="date-box">
                                            <i class="far fa-calendar-alt"></i> 
                                            <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/>
                                        </div>
                                    </td>
                                    <td class="product-list-col">
                                        <ul class="order-item-list">
                                            <c:forEach items="${order.orderDetails}" var="detail">
                                                <li>
                                                    <span class="p-name"><c:out value="${detail.product.productName}" /></span>
                                                    <span class="p-qty">x${detail.quantity}</span>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </td>
                                    <td class="total-price">
                                        <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="฿" maxFractionDigits="2"/>
                                    </td>
                                    <td>
                                        <%-- Logic เลือกสีป้ายสถานะ --%>
                                        <span class="status-badge 
                                            ${order.status == 'รอดำเนินการชำระเงิน' ? 'status-pending' : ''}
                                            ${order.status == 'กำลังตรวจสอบ' ? 'status-checking' : ''}
                                            ${order.status == 'ยืนยันการชำระเงิน' ? 'status-completed' : ''}
                                            ${order.status == 'ยกเลิกการสั่งซื้อ' ? 'status-cancelled' : ''}
                                        ">
                                            ${order.status}
                                        </span>
                                    </td>
                                    <td>
                                        <c:if test="${order.status == 'Pending Payment'}">
                                            <a href="uploadSlip?orderId=${order.ordersId}" class="btn-action btn-pay">
                                                <i class="fas fa-file-invoice-dollar"></i> แจ้งโอนเงิน
                                            </a>
                                        </c:if>
                                        <c:if test="${order.status != 'Pending Payment'}">
                                           <a href="OrderDetail?orderId=${order.ordersId}" class="btn-action btn-view">
                                                <i class="fas fa-eye"></i> ดูรายละเอียด
                                            </a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-receipt"></i>
                    <h2>คุณยังไม่มีคำสั่งซื้อ</h2>
                    <p>เลือกซื้อปลาสวยงามที่คุณชื่นชอบได้เลย</p>
                    <a href="AllProduct" class="btn-shop-now">ไปเลือกซื้อสินค้า</a>
                </div>
            </c:otherwise>
        </c:choose>

    </div>

    <footer class="site-footer">
        <p>&copy; 2025 Fish Online Shop. All rights reserved.</p>
    </footer>

</body>
</html>