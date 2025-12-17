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
                                                    <span class="p-name">${detail.product.productName}</span>
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