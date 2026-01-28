<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>จัดการคำสั่งซื้อทั้งหมด | Fish Online</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* สไตล์เพิ่มเติมสำหรับตาราง */
        .badge { padding: 5px 10px; border-radius: 50px; font-size: 12px; font-weight: bold; }
        .bg-pending { background: #ffeeba; color: #856404; }
        .bg-checking { background: #d1ecf1; color: #0c5460; }
        .bg-shipping { background: #c3e6cb; color: #155724; }
        .bg-completed { background: #28a745; color: white; }
        .bg-cancelled { background: #dc3545; color: white; }
    </style>
</head>
<body>
    <jsp:include page="loading.jsp" />

    <div class="admin-wrapper">
        
        <jsp:include page="adminNavbar.jsp" />

        <div class="content">
            <nav class="top-navbar">
                <div class="navbar-title">รายการคำสั่งซื้อทั้งหมด</div>
                <div class="admin-profile">
                    <img src="${pageContext.request.contextPath}/assets/images/icon/admin-avatar.png" onerror="this.src='https://cdn-icons-png.flaticon.com/512/2942/2942813.png'" alt="Admin">
                    <span>Admin</span>
                </div>
            </nav>

            <div class="dashboard-container">
                <div class="recent-section">
                    <div class="section-header">
                        <h3><i class="fas fa-list-alt"></i> รายการออเดอร์ (${orderList.size()})</h3>
                    </div>

                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>วันที่สั่งซื้อ</th>
                                <th>ลูกค้า</th>
                                <th>ราคารวม</th>
                                <th>สถานะ</th>
                                <th>จัดการ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty orderList}">
                                    <c:forEach items="${orderList}" var="order">
                                        <tr>
                                            <td><strong>#${order.ordersId}</strong></td>
                                            <td>
                                                <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td>
                                                <div style="display: flex; align-items: center; gap: 10px;">
                                                    <img src="${pageContext.request.contextPath}/displayImage?name=user/${not empty order.member.memberImg ? order.member.memberImg : 'default.png'}" 
                                                         style="width: 30px; height: 30px; border-radius: 50%; object-fit: cover;"
                                                         onerror="this.src='https://cdn-icons-png.flaticon.com/512/149/149071.png'">
                                                    <c:out value="${order.member.memberName}"/>
                                                </div>
                                            </td>
                                            <td style="font-weight: bold; color: #00571d;">
                                                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="฿"/>
                                            </td>
                                            <td>
                                                <span class="badge 
                                                    ${order.status == 'Pending Payment' ? 'bg-pending' : ''}
                                                    ${order.status == 'กำลังตรวจสอบ' ? 'bg-checking' : ''}
                                                    ${order.status == 'สินค้าพร้อมรับ' ? 'bg-shipping' : ''}
                                                    ${order.status == 'Completed' ? 'bg-completed' : ''}
                                                    ${order.status == 'Cancelled' ? 'bg-cancelled' : ''}
                                                ">
                                                    ${order.status}
                                                </span>
                                            </td>
                                            <td>
                                                <a href="AdminOrderDetail?orderId=${order.ordersId}" class="btn-small" title="ดูรายละเอียด">
                                                    <i class="fas fa-eye"></i> ตรวจสอบ
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" style="text-align: center; padding: 30px; color: #999;">
                                            ยังไม่มีคำสั่งซื้อในระบบ
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

</body>
</html>