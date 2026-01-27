<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ตรวจสอบคำสั่งซื้อ #${order.ordersId} | Admin</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        .detail-card { background: #fff; padding: 25px; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .detail-header { border-bottom: 1px solid #eee; padding-bottom: 15px; margin-bottom: 20px; font-weight: bold; font-size: 18px; color: #2d3748; }
        
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .info-row { display: flex; justify-content: space-between; margin-bottom: 10px; border-bottom: 1px dashed #eee; padding-bottom: 5px; }
        .info-row strong { color: #555; }

        .items-table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .items-table th { background: #f8f9fa; text-align: left; padding: 10px; }
        .items-table td { border-bottom: 1px solid #eee; padding: 10px; }
        
        .status-badge { padding: 5px 12px; border-radius: 50px; font-size: 14px; color: white; display: inline-block; }
        .status-badge.pending { background: #ffc107; color: #333; }
        .status-badge.shipping { background: #17a2b8; }
        .status-badge.completed { background: #28a745; }
        .status-badge.cancelled { background: #dc3545; }

        .btn-action-group { display: flex; gap: 10px; margin-top: 20px; justify-content: flex-end; }
        .btn-admin { padding: 10px 20px; border-radius: 5px; text-decoration: none; color: white; font-weight: bold; border: none; cursor: pointer; }
        .btn-cancel { background: #dc3545; } .btn-cancel:hover { background: #c82333; }
        .btn-confirm { background: #28a745; } .btn-confirm:hover { background: #218838; }
        .btn-back { color: #555; text-decoration: none; font-weight: bold; display: flex; align-items: center; gap: 5px; }
    </style>
</head>
<body>

    <div class="admin-wrapper">
        
        <jsp:include page="adminNavbar.jsp" />

        <div class="content">
            <nav class="top-navbar">
                <a href="AdminOrders" class="btn-back"><i class="fas fa-arrow-left"></i> ย้อนกลับไปรายการออเดอร์</a>
                <div class="admin-profile">
                    <img src="${pageContext.request.contextPath}/assets/images/icon/admin-avatar.png" onerror="this.src='https://cdn-icons-png.flaticon.com/512/2942/2942813.png'" alt="Admin">
                    <span>Admin</span>
                </div>
            </nav>

            <div class="dashboard-container">
                
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <h2 style="margin: 0; color: #333;">คำสั่งซื้อ #${order.ordersId}</h2>
                    <span class="status-badge 
                        ${order.status == 'Pending Payment' ? 'pending' : ''}
                        ${order.status == 'สินค้าพร้อมรับ' ? 'shipping' : ''}
                        ${order.status == 'Completed' ? 'completed' : ''}
                        ${order.status == 'Cancelled' ? 'cancelled' : ''}
                    ">${order.status}</span>
                </div>

                <div class="info-grid">
                    <div class="detail-card">
                        <div class="detail-header"><i class="fas fa-user"></i> ข้อมูลลูกค้า</div>
                        <div style="text-align: center; margin-bottom: 15px;">
                            <img src="${pageContext.request.contextPath}/displayImage?name=user/${not empty order.member.memberImg ? order.member.memberImg : 'default.png'}" 
                                 style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover; border: 3px solid #eee;"
                                 onerror="this.src='https://cdn-icons-png.flaticon.com/512/149/149071.png'">
                        </div>
                        <div class="info-row"><strong>ชื่อลูกค้า:</strong> <span>${order.member.memberName}</span></div>
                        <div class="info-row"><strong>อีเมล:</strong> <span>${order.member.email}</span></div>
                        <div class="info-row"><strong>เบอร์โทร:</strong> <span>${order.member.phone}</span></div>
                    </div>

                    <div class="detail-card">
                        <div class="detail-header"><i class="fas fa-wallet"></i> การชำระเงิน</div>
                        <c:choose>
                            <c:when test="${not empty order.payment}">
                                <div class="info-row"><strong>วันที่ชำระ:</strong> <span><fmt:formatDate value="${order.payment.uploadDate}" pattern="dd/MM/yyyy HH:mm"/></span></div>
                                <div class="info-row"><strong>ยอดโอน:</strong> <span style="color: green; font-weight: bold;"><fmt:formatNumber value="${order.payment.total}" type="currency" currencySymbol="฿"/></span></div>
                                <div style="margin-top: 15px;">
                                    <strong>หลักฐานการโอน:</strong><br>
                                    <a href="${pageContext.request.contextPath}/displayImage?name=slips/${order.payment.filePath}" target="_blank">
                                        <img src="${pageContext.request.contextPath}/displayImage?name=slips/${order.payment.filePath}" style="max-width: 100%; height: 150px; object-fit: contain; border: 1px solid #ddd; margin-top: 5px; border-radius: 5px;">
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p style="color: #999; text-align: center; margin-top: 40px;">ยังไม่มีการแจ้งชำระเงิน</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="detail-card">
                    <div class="detail-header"><i class="fas fa-box-open"></i> รายการสินค้า</div>
                    <table class="items-table">
                        <thead>
                            <tr>
                                <th>สินค้า</th>
                                <th>ราคา</th>
                                <th>จำนวน</th>
                                <th>รวม</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${order.orderDetails}" var="detail">
                                <tr>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 10px;">
                                            <img src="${pageContext.request.contextPath}/${detail.product.productImg.startsWith('assets') ? '' : 'displayImage?name='}${detail.product.productImg}" 
                                                 style="width: 40px; height: 40px; border-radius: 5px; object-fit: cover;">
                                            ${detail.product.productName}
                                        </div>
                                    </td>
                                    <td><fmt:formatNumber value="${detail.price}" type="currency" currencySymbol="฿"/></td>
                                    <td>x${detail.quantity}</td>
                                    <td><fmt:formatNumber value="${detail.price * detail.quantity}" type="currency" currencySymbol="฿"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>

                            <c:if test="${order.discountAmount > 0}">
                                <tr>
                                    <td colspan="3" style="text-align: right; color: #28a745; font-weight: bold; padding: 10px; border-top: 1px solid #eee;">
                                        <i class="fas fa-tag"></i> ส่วนลด
                                        <c:if test="${not empty order.couponCode}">
                                            (Code: ${order.couponCode})
                                        </c:if>
                                    </td>
                                    <td style="font-weight: bold; color: #28a745; padding: 10px; border-top: 1px solid #eee;">
                                        -<fmt:formatNumber value="${order.discountAmount}" type="currency" currencySymbol="฿"/>
                                    </td>
                                </tr>
                            </c:if>

                            <tr>
                                <td colspan="3" style="text-align: right; font-weight: bold; padding-top: 15px;">ยอดรวมสุทธิ:</td>
                                <td style="font-weight: bold; color: #00571d; font-size: 18px; padding-top: 15px;">
                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="฿"/>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
                <div class="detail-card">
                    <div class="detail-header"><i class="fas fa-cogs"></i> จัดการคำสั่งซื้อ (Admin Override)</div>
                    <div class="btn-action-group">
                        <c:if test="${order.status != 'Cancelled' && order.status != 'Completed'}">
                            <a href="updateOrderStatus?orderId=${order.ordersId}&status=Cancelled" 
                               class="btn-admin btn-cancel" onclick="confirmAction(event, this.href, 'ยืนยันการยกเลิก?', '⚠️ คำเตือน: คุณต้องการยกเลิกออเดอร์นี้ทันทีหรือไม่?')">
                                <i class="fas fa-ban"></i> ยกเลิกออเดอร์ (Force Cancel)
                            </a>
                            
                            <a href="updateOrderStatus?orderId=${order.ordersId}&status=Completed" 
                               class="btn-admin btn-confirm" onclick="confirmAction(event, this.href, 'ออเดอร์เสร็จสมบูรณ์?', 'ยืนยันว่าออเดอร์นี้ดำเนินการเรียบร้อยและลูกค้าได้รับสินค้าแล้ว')">
                                <i class="fas fa-check-circle"></i> ปรับสถานะเป็นสำเร็จ (Force Complete)
                            </a>
                        </c:if>
                        <c:if test="${order.status == 'Cancelled' || order.status == 'Completed'}">
                            <span style="color: #666;">ออเดอร์นี้สิ้นสุดกระบวนการแล้ว</span>
                        </c:if>
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
            title: title,
            text: text,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'ใช่, ยืนยัน',
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