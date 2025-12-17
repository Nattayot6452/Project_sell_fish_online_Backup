<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>รายละเอียดสมาชิก | Admin</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="admin-wrapper">
        <nav class="sidebar">
            <div class="sidebar-header">
                <img src="${pageContext.request.contextPath}/assets/images/icon/fishTesting.png" alt="Logo">
                <h3>Admin Panel</h3>
            </div>
            <ul class="list-unstyled components">
                <li><a href="AdminCenter"><i class="fas fa-chart-line"></i> ภาพรวมระบบ</a></li>
                <li class="active"><a href="ManageUsers"><i class="fas fa-users"></i> จัดการสมาชิก</a></li>
                <li><a href="SellerOrders"><i class="fas fa-clipboard-list"></i> รายการคำสั่งซื้อ</a></li>
                <li><a href="AllProduct"><i class="fas fa-boxes"></i> ตรวจสอบสินค้า</a></li>
            </ul>
            <div class="sidebar-footer">
                <a href="Logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> ออกจากระบบ</a>
            </div>
        </nav>

        <div class="content">
            <nav class="top-navbar">
                <a href="ManageUsers" style="text-decoration: none; color: #333; font-weight: bold;">
                    <i class="fas fa-arrow-left"></i> ย้อนกลับ
                </a>
                <div class="admin-profile"><span>Admin</span></div>
            </nav>

            <div class="dashboard-container">
                <div class="stats-grid" style="grid-template-columns: 1fr 2fr; align-items: start;">
                    
                    <div class="card" style="display: block; text-align: center;">
                        <img src="${pageContext.request.contextPath}/profile-uploads/user/${member.memberImg}" 
                             style="width: 120px; height: 120px; border-radius: 50%; object-fit: cover; margin-bottom: 15px; border: 3px solid #eee;"
                             onerror="this.src='https://cdn-icons-png.flaticon.com/512/149/149071.png'">
                        <h2 style="margin: 0; color: #333;">${member.memberName}</h2>
                        <p style="color: #666; font-size: 14px;">Member ID: ${member.memberId}</p>
                        
                        <div style="text-align: left; margin-top: 20px; border-top: 1px solid #eee; padding-top: 15px;">
                            <p><strong><i class="fas fa-envelope"></i> อีเมล:</strong> ${member.email}</p>
                            <p><strong><i class="fas fa-phone"></i> เบอร์โทร:</strong> ${member.phone}</p>
                        </div>

                        <div style="margin-top: 30px;">
                            <a href="BanUser?id=${member.memberId}" class="btn-logout" 
                               onclick="return confirm('ยืนยันการลบสมาชิกคนนี้?');">
                                <i class="fas fa-ban"></i> Ban / Delete User
                            </a>
                        </div>
                    </div>

                    <div class="recent-section">
                        <div class="section-header">
                            <h3><i class="fas fa-history"></i> ประวัติการสั่งซื้อ (${userOrders.size()})</h3>
                        </div>
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>วันที่</th>
                                    <th>ยอดรวม</th>
                                    <th>สถานะ</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty userOrders}">
                                        <c:forEach items="${userOrders}" var="o">
                                            <tr>
                                                <td><a href="OrderDetail?orderId=${o.ordersId}" style="color: #00571d; font-weight: bold;">#${o.ordersId}</a></td>
                                                <td><fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                <td><fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="฿"/></td>
                                                <td>
                                                    <span class="status-dot ${o.status == 'Completed' ? 'dot-green' : (o.status == 'Cancelled' ? 'dot-red' : 'dot-yellow')}"></span>
                                                    ${o.status}
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr><td colspan="4" style="text-align: center; color: #999;">ยังไม่มีประวัติการสั่งซื้อ</td></tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                </div>
            </div>
        </div>
    </div>
</body>
</html>