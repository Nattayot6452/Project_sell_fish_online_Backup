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
    
    <style>
        .user-avatar {
            width: 120px; 
            height: 120px; 
            border-radius: 50%; 
            object-fit: cover; 
            margin-bottom: 15px; 
            border: 3px solid #eee;
            transition: all 0.3s ease;
        }
        /* ถ้าโดนแบน ให้รูปเป็นขาวดำ */
        .user-avatar.banned {
            filter: grayscale(100%);
            opacity: 0.8;
            border-color: #dc3545;
        }
        /* ป้ายสถานะ BANNED */
        .badge-banned { 
            background: #dc3545; 
            color: white; 
            padding: 3px 10px; 
            border-radius: 20px; 
            font-size: 12px; 
            vertical-align: middle; 
            margin-left: 8px;
            font-weight: bold;
        }
    </style>
</head>
<body>

    <div class="admin-wrapper">
        <jsp:include page="adminNavbar.jsp" />
        <div class="content">
            <nav class="top-navbar">
                <a href="ManageUsers" style="text-decoration: none; color: #333; font-weight: bold;">
                    <i class="fas fa-arrow-left"></i> ย้อนกลับ
                </a>
                <div class="admin-profile">
                    <img src="${pageContext.request.contextPath}/assets/images/icon/admin-avatar.png" onerror="this.src='https://cdn-icons-png.flaticon.com/512/2942/2942813.png'" alt="Admin">
                    <span>Admin</span>
                </div>
            </nav>

            <div class="dashboard-container">
                <div class="stats-grid" style="grid-template-columns: 1fr 2fr; align-items: start;">
                    
                    <div class="card" style="display: block; text-align: center;">
                        
                        <img src="${pageContext.request.contextPath}/displayImage?name=user/${not empty member.memberImg ? member.memberImg : 'default.png'}" 
                             class="user-avatar ${member.status == 'Banned' ? 'banned' : ''}"
                             onerror="this.src='https://cdn-icons-png.flaticon.com/512/149/149071.png'">
                        
                        <h2 style="margin: 0; color: #333;">
                            <c:out value="${member.memberName}" />
                            <c:if test="${member.status == 'Banned'}">
                                <span class="badge-banned">BANNED</span>
                            </c:if>
                        </h2>
                        <p style="color: #666; font-size: 14px;">Member ID: ${member.memberId}</p>
                        
                        <div style="text-align: left; margin-top: 20px; border-top: 1px solid #eee; padding-top: 15px;">
                            <p><strong><i class="fas fa-envelope"></i> อีเมล:</strong> <c:out value="${member.email}" /></p>
                            <p><strong><i class="fas fa-phone"></i> เบอร์โทร:</strong> <c:out value="${member.phone}" /></p>
                        </div>

                        <div style="margin-top: 30px;">
                            <c:choose>
                                <c:when test="${member.status == 'Banned'}">
                                    <a href="BanUser?id=${member.memberId}" class="btn-logout" 
                                       style="background-color: #28a745; color: white; border: none; width: 100%; display: inline-block;"
                                       onclick="confirmAction(event, this.href, 'ยืนยันการปลดแบน?', 'สมาชิกจะกลับมาใช้งานได้ตามปกติ');">
                                        <i class="fas fa-unlock"></i> ปลดระงับบัญชี
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="BanUser?id=${member.memberId}" class="btn-logout" 
                                       style="background-color: #dc3545; color: white; border: none; width: 100%; display: inline-block;"
                                       onclick="confirmAction(event, this.href, 'ยืนยันการระงับผู้ใช้?', 'สมาชิกคนนี้จะไม่สามารถเข้าสู่ระบบได้');">
                                        <i class="fas fa-ban"></i> ระงับบัญชีผู้ใช้
                                    </a>
                                </c:otherwise>
                            </c:choose>
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

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function confirmAction(event, url, title, text) {
            event.preventDefault(); 
            
            Swal.fire({
                title: title || 'คุณแน่ใจไหม?',
                text: text || "การกระทำนี้สามารถแก้ไขได้ในภายหลัง",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#e53e3e', 
                cancelButtonColor: '#888',
                confirmButtonText: 'ใช่, ยืนยันเลย!',
                cancelButtonText: 'ยกเลิก'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = url;
                }
            });
        }
    </script>

</body>
</html>