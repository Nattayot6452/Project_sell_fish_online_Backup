<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | Fish Online</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <div class="admin-wrapper">
        <jsp:include page="adminNavbar.jsp" />

        <div class="content">
            <nav class="top-navbar">
                <div class="navbar-title">ยินดีต้อนรับ, ผู้ดูแลระบบ</div>
                <div class="admin-profile">
                    <img src="${pageContext.request.contextPath}/assets/images/icon/admin-avatar.png" onerror="this.src='https://cdn-icons-png.flaticon.com/512/2942/2942813.png'" alt="Admin">
                    <span>Admin</span>
                </div>
            </nav>

            <div class="dashboard-container">
                
                <div class="stats-grid">
                    <div class="card card-blue">
                        <div class="card-info">
                            <h3>${memberCount}</h3>
                            <p>สมาชิกทั้งหมด</p>
                        </div>
                        <div class="card-icon"><i class="fas fa-users"></i></div>
                    </div>
                    <div class="card card-green">
                        <div class="card-info">
                            <h3><fmt:formatNumber value="${totalSales}" type="currency" currencySymbol="฿"/></h3>
                            <p>ยอดขายรวม (สำเร็จ)</p>
                        </div>
                        <div class="card-icon"><i class="fas fa-wallet"></i></div>
                    </div>
                    <div class="card card-orange">
                        <div class="card-info">
                            <h3>${orderCount}</h3>
                            <p>คำสั่งซื้อทั้งหมด</p>
                        </div>
                        <div class="card-icon"><i class="fas fa-shopping-bag"></i></div>
                    </div>
                    <div class="card card-red">
                        <div class="card-info">
                            <h3>${productCount}</h3>
                            <p>สินค้าในระบบ</p>
                        </div>
                        <div class="card-icon"><i class="fas fa-fish"></i></div>
                    </div>
                </div>

                <div class="recent-section">
                    <div class="section-header">
                        <h3><i class="fas fa-clock"></i> คำสั่งซื้อล่าสุด</h3>
                        <a href="AdminOrders" class="btn-view-all">ดูทั้งหมด</a>
                    </div>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>ลูกค้า</th>
                                <th>วันที่</th>
                                <th>ยอดเงิน</th>
                                <th>สถานะ</th>
                                <th>จัดการ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${recentOrders}" var="order">
                                <tr>
                                    <td>#${order.ordersId}</td>
                                    <td><c:out value="${order.member.memberName}" /></td>
                                    <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/></td>
                                    <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="฿"/></td>
                                    <td>
                                        <span class="status-dot ${order.status == 'Completed' ? 'dot-green' : (order.status == 'Cancelled' ? 'dot-red' : 'dot-yellow')}"></span>
                                        ${order.status}
                                    </td>
                                    <td>
                                        <a href="AdminOrderDetail?orderId=${order.ordersId}" class="btn-small"><i class="fas fa-eye"></i></a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>
    </div>

     <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    document.addEventListener("DOMContentLoaded", function() {

        const urlParams = new URLSearchParams(window.location.search);
        const msg = urlParams.get('msg');

        if (msg === 'login_success') {
            Swal.fire({
                icon: 'success',
                title: 'เข้าสู่ระบบสำเร็จ!',
                text: 'ยินดีต้อนรับเข้าสู่ระบบ',
                showConfirmButton: false,
                timer: 1500, 
                position: 'center'
            }).then(() => {

                const newUrl = window.location.pathname;
                window.history.replaceState({}, document.title, newUrl);
            });
        }
    });
</script>

</body>
</html>