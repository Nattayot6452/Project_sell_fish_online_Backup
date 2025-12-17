<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>รายการคำสั่งซื้อ | Seller Center</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/sellerOrders.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/sellerHomepage.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <nav class="navbar">
        <div class="nav-container">
            <a href="SellerCenter" class="brand-logo">
                <img src="${pageContext.request.contextPath}/assets/images/icon/fishTesting.png" alt="Logo">
                <span>Seller Center</span>
            </a>
            <div class="nav-links">
                <div class="dropdown">
                    <a href="#" class="menu-btn">
                        <i class="fas fa-boxes"></i> จัดการสินค้า <i class="fas fa-chevron-down" style="font-size: 10px;"></i>
                    </a>
                    <div class="dropdown-content">
                        <a href="SellerCenter"><i class="fas fa-list"></i> รายการสินค้าทั้งหมด</a>
                        <a href="AddProduct"><i class="fas fa-plus-circle"></i> เพิ่มสินค้าใหม่</a>
                    </div>
                </div>

                <a href="SellerOrders" class="menu-btn" style="background-color: #e8f5e9; color: #00571d;">
                    <i class="fas fa-clipboard-list"></i> คำสั่งซื้อลูกค้า
                </a>
                
                <a href="AddProduct" class="menu-btn add-product-btn">
                    <i class="fas fa-plus-circle"></i> เพิ่มสินค้า
                </a>

                <div class="dropdown">
                    <a href="#" class="menu-btn">
                        <i class="fas fa-user-tie"></i> เจ้าหน้าที่ <span class="seller-badge">Seller</span>
                        <i class="fas fa-chevron-down" style="font-size: 10px;"></i>
                    </a>
                    <div class="dropdown-content">
                        <a href="Logout" style="color: #dc3545;"><i class="fas fa-sign-out-alt"></i> ออกจากระบบ</a>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <div class="container main-container">
        
        <div class="page-header">
            <div>
                <h1><i class="fas fa-clipboard-list"></i> รายการคำสั่งซื้อ</h1>
                <p>ตรวจสอบและจัดการสถานะออเดอร์ทั้งหมดจากลูกค้า</p>
            </div>
        </div>

        <div class="orders-table-container">
            <c:choose>
                <c:when test="${not empty orderList}">
                    <table class="orders-table">
                        <thead>
                            <tr>
                                <th># รหัสคำสั่งซื้อ</th>
                                <th>ลูกค้า</th>
                                <th>วันที่สั่งซื้อ</th>
                                <th>ยอดรวม</th>
                                <th>สถานะ</th>
                                <th>จัดการ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${orderList}" var="order">
                                <tr>
                                    <td class="order-id">
                                        <i class="fas fa-hashtag"></i> ${order.ordersId}
                                    </td>
                                    <td>
                                        <div class="customer-info">
                                            <span class="name">${order.member.memberName}</span>
                                            <span class="email">${order.member.email}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td class="amount">
                                        <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="฿"/>
                                    </td>
                                    <td>
                                        <%-- Status Badge Logic --%>
                                        <span class="status-badge 
                                            ${order.status == 'Pending Payment' || order.status == 'รอดำเนินการชำระเงิน' ? 'pending' : ''}
                                            ${order.status == 'กำลังตรวจสอบ' ? 'checking' : ''}
                                            ${order.status == 'ยืนยันสลิป' ? 'shipping' : ''}
                                            ${order.status == 'รับสินค้าแล้ว' ? 'completed' : ''}
                                            ${order.status == 'ยกเลิกออเดอร์' ? 'cancelled' : ''}">
                                            ${order.status}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="OrderDetail?orderId=${order.ordersId}" class="btn-view">
                                            <i class="fas fa-eye"></i> ตรวจสอบ
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-inbox"></i>
                        <h3>ยังไม่มีคำสั่งซื้อเข้ามา</h3>
                        <p>รายการสั่งซื้อใหม่จะปรากฏที่นี่เมื่อลูกค้าทำการสั่งซื้อ</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</body>
</html>