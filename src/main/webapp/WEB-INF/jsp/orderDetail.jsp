<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>รายละเอียดคำสั่งซื้อ #${order.ordersId} | Fish Online</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/orderDetail.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/sellerHomepage.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        .main-container {
            margin-top: 100px;
            padding-bottom: 60px;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
            padding-left: 20px;
            padding-right: 20px;
        }
        .page-header { display: flex; align-items: center; gap: 15px; margin-bottom: 30px; }
        .page-header h1 { margin: 0; font-size: 24px; color: #333; }
        .order-id { color: #00571d; font-weight: bold; }
        .btn-back-link { text-decoration: none; color: #666; font-size: 16px; display: flex; align-items: center; gap: 5px; font-weight: 500; }
        .btn-back-link:hover { color: #00571d; }

        /* Styles ปุ่ม */
        .btn-ready { background-color: #ffc107; color: #333; }
        .btn-shipping { background-color: #17a2b8; color: white; }
        .btn-complete { background-color: #28a745; color: white; }
        .btn-cancel-order { background-color: #dc3545; color: white; }
        .btn-approve-cancel { background-color: #dc3545; color: white; } /* อนุมัติยกเลิก (สีแดงเหมือนเดิม) */
        .btn-reject-cancel { background-color: #6c757d; color: white; } /* ปฏิเสธ (สีเทา) */
        
        .btn-action { display: inline-block; padding: 10px 20px; border-radius: 50px; text-decoration: none; font-weight: bold; margin-right: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); transition: transform 0.2s; }
        .btn-action:hover { transform: translateY(-2px); opacity: 0.9; }

        /* Status Badge พิเศษ */
        .status-badge.waiting-cancel { background: #ffebee; color: #c62828; border: 1px solid #ffcdd2; }
    </style>
</head>
<body>

    <c:choose>
        <c:when test="${not empty sessionScope.seller}">
            <nav class="navbar">
                <div class="nav-container">
                    <a href="SellerCenter" class="brand-logo">
                        <img src="${pageContext.request.contextPath}/assets/images/icon/fishTesting.png" alt="Logo">
                        <span>Seller Center</span>
                    </a>
                    <div style="flex: 1;"></div>
                    <div class="nav-links">
                        <a href="SellerCenter" class="menu-btn" style="color: #333; text-decoration: none;"><i class="fas fa-boxes"></i> สินค้า</a>
                        <a href="SellerOrders" class="menu-btn" style="color: #333; text-decoration: none;"><i class="fas fa-clipboard-list"></i> คำสั่งซื้อ</a>
                        <div class="dropdown">
                            <a href="#" class="menu-btn" style="color: #333; font-weight: bold; text-decoration: none;">
                                <i class="fas fa-user-tie"></i> เจ้าหน้าที่ <span class="seller-badge" style="background:#ffc107; color:#333; padding:2px 8px; border-radius:10px; font-size:11px;">Seller</span>
                            </a>
                            <div class="dropdown-content">
                                <a href="Logout" style="color: #dc3545;"><i class="fas fa-sign-out-alt"></i> ออกจากระบบ</a>
                            </div>
                        </div>
                    </div>
                </div>
            </nav>
        </c:when>
        <c:otherwise>
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
                            <a href="Cart" class="cart-link" title="ตะกร้าสินค้า"><i class="fas fa-shopping-cart"></i></a>
                            <div class="dropdown">
                                <a href="Profile" class="dropbtn user-profile">
                                    <img src="${pageContext.request.contextPath}/profile-uploads/user/${sessionScope.user.memberImg}" class="nav-avatar">
                                    สวัสดี, ${sessionScope.user.memberName}
                                    <i class="fas fa-chevron-down" style="font-size: 10px;"></i>
                                </a>
                                <div class="dropdown-content">
                                    <a href="Favorites"><i class="fas fa-heart"></i> รายการโปรด</a>
                                    <a href="Orders"><i class="fas fa-box-open"></i> คำสั่งซื้อ</a>
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
        </c:otherwise>
    </c:choose>

    <div class="container main-container">
        
        <div class="page-header">
            <c:choose>
                <c:when test="${not empty sessionScope.seller}">
                    <a href="SellerOrders" class="btn-back-link"><i class="fas fa-arrow-left"></i> ย้อนกลับ</a>
                </c:when>
                <c:otherwise>
                    <a href="Orders" class="btn-back-link"><i class="fas fa-arrow-left"></i> ย้อนกลับ</a>
                </c:otherwise>
            </c:choose>
            <h1>รายละเอียดคำสั่งซื้อ <span class="order-id">#${order.ordersId}</span></h1>
        </div>

        <div class="card status-card">
            <h3>สถานะคำสั่งซื้อ</h3>
            <div class="timeline">
                <div class="step active">
                    <div class="icon"><i class="fas fa-shopping-basket"></i></div>
                    <div class="text">สั่งซื้อสำเร็จ</div>
                    <div class="date"><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></div>
                </div>
                <div class="step ${order.status != 'Pending Payment' && order.status != 'รอดำเนินการชำระเงิน' ? 'active' : ''}">
                    <div class="icon"><i class="fas fa-file-invoice-dollar"></i></div>
                    <div class="text">แจ้งชำระเงิน</div>
                </div>
                <div class="step ${order.status == 'กำลังจัดเตรียม' || order.status == 'สินค้าพร้อมรับ' || order.status == 'Completed' ? 'active' : ''}">
                    <div class="icon"><i class="fas fa-box"></i></div>
                    <div class="text">กำลังจัดเตรียม</div>
                </div>
                <div class="step ${order.status == 'สินค้าพร้อมรับ' || order.status == 'Completed' ? 'active' : ''}">
                    <div class="icon"><i class="fas fa-store"></i></div>
                    <div class="text">สินค้าพร้อมรับ</div>
                </div>
                <div class="step ${order.status == 'Completed' ? 'active' : ''}">
                    <div class="icon"><i class="fas fa-check-circle"></i></div>
                    <div class="text">รับสินค้าแล้ว</div>
                </div>
            </div>
            
            <div class="current-status-box">
                สถานะปัจจุบัน: 
                <span class="status-badge 
                    ${order.status == 'Pending Payment' || order.status == 'รอดำเนินการชำระเงิน' ? 'status-pending' : ''}
                    ${order.status == 'กำลังตรวจสอบ' ? 'status-checking' : ''}
                    ${order.status == 'กำลังจัดเตรียม' ? 'status-preparing' : ''}
                    ${order.status == 'สินค้าพร้อมรับ' ? 'status-shipping' : ''}
                    ${order.status == 'Completed' ? 'status-completed' : ''}
                    ${order.status == 'Cancelled' ? 'status-cancelled' : ''}
                    ${order.status == 'รออนุมัติยกเลิก' ? 'waiting-cancel' : ''}
                ">
                    ${order.status}
                </span>
            </div>
        </div>

        <div class="detail-grid">
            <div class="card info-card">
                <h3><i class="fas fa-user"></i> ข้อมูลลูกค้า</h3>
                <div class="info-row">
                    <span class="label">ชื่อผู้สั่ง:</span><span class="value">${order.member.memberName}</span>
                </div>
                <div class="info-row">
                    <span class="label">อีเมล:</span><span class="value">${order.member.email}</span>
                </div>
                <div class="info-row">
                    <span class="label">เบอร์โทร:</span><span class="value">${order.member.phone}</span>
                </div>
            </div>

            <div class="card payment-card">
                <h3><i class="fas fa-wallet"></i> ข้อมูลการชำระเงิน</h3>
                <c:choose>
                    <c:when test="${not empty order.payment}">
                        <div class="info-row">
                            <span class="label">วันที่ชำระ:</span><span class="value"><fmt:formatDate value="${order.payment.uploadDate}" pattern="dd/MM/yyyy HH:mm"/></span>
                        </div>
                        <div class="info-row">
                            <span class="label">ยอดชำระ:</span><span class="value"><fmt:formatNumber value="${order.payment.total}" type="currency" currencySymbol="฿"/></span>
                        </div>
                        <div class="slip-preview">
                            <p>หลักฐานการโอน:</p>
                            <a href="${pageContext.request.contextPath}/profile-uploads/slips/${order.payment.filePath}" target="_blank">
                                <img src="${pageContext.request.contextPath}/profile-uploads/slips/${order.payment.filePath}" alt="Slip">
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="no-payment">
                            <p>ยังไม่มีข้อมูลการชำระเงิน</p>
                            <c:if test="${empty sessionScope.seller}">
                                <c:if test="${order.status == 'Pending Payment' || order.status == 'รอดำเนินการชำระเงิน'}">
                                    <a href="uploadSlip?orderId=${order.ordersId}" class="btn-pay-now">แจ้งชำระเงินทันที</a>
                                </c:if>
                            </c:if>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="card items-card">
            <h3><i class="fas fa-shopping-bag"></i> รายการสินค้า</h3>
            <table class="items-table">
                <thead>
                    <tr>
                        <th>สินค้า</th>
                        <th class="text-right">ราคาต่อหน่วย</th>
                        <th class="text-center">จำนวน</th>
                        <th class="text-right">รวม</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${order.orderDetails}" var="detail">
                        <tr>
                            <td>
                                <div class="product-flex">
                                    <c:choose>
                                        <c:when test="${detail.product.productImg.startsWith('assets')}">
                                            <img src="${pageContext.request.contextPath}/${detail.product.productImg}" alt="${detail.product.productName}">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/profile-uploads/${detail.product.productImg}" alt="${detail.product.productName}">
                                        </c:otherwise>
                                    </c:choose>
                                    <span>${detail.product.productName}</span>
                                </div>
                            </td>
                            <td class="text-right"><fmt:formatNumber value="${detail.price}" type="currency" currencySymbol="฿"/></td>
                            <td class="text-center">x${detail.quantity}</td>
                            <td class="text-right font-bold"><fmt:formatNumber value="${detail.price * detail.quantity}" type="currency" currencySymbol="฿"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
               <tfoot>
                    <c:if test="${order.discountAmount > 0}">
                        <tr>
                            <td colspan="3" class="text-right" style="color: #28a745; border-top: 1px solid #dee2e6;">
                                <i class="fas fa-tag"></i> ส่วนลด 
                                <c:if test="${not empty order.couponCode}">
                                    (Code: ${order.couponCode})
                                </c:if>
                            </td>
                            <td class="text-right" style="color: #28a745; font-weight: bold; border-top: 1px solid #dee2e6;">
                                -<fmt:formatNumber value="${order.discountAmount}" type="currency" currencySymbol="฿"/>
                            </td>
                        </tr>
                    </c:if>

                    <tr>
                        <td colspan="3" class="text-right label-total" style="font-size: 1.1em; font-weight: bold;">ยอดรวมสุทธิ</td>
                        <td class="text-right value-total" style="font-size: 1.1em; font-weight: bold; color: #00571d;">
                            <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="฿"/>
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>

            <c:if test="${empty sessionScope.seller and not empty sessionScope.user}">
            <div style="margin-top: 20px; text-align: right;">

                <c:if test="${order.status != 'Completed' && order.status != 'Cancelled' && order.status != 'รออนุมัติยกเลิก'}">
                    <a href="requestCancellation?orderId=${order.ordersId}" class="btn-action btn-cancel-order"
                       onclick="return confirm('ต้องการขอยกเลิกคำสั่งซื้อใช่หรือไม่? \n(ร้านค้าจะต้องอนุมัติก่อน)');">
                       <i class="fas fa-times-circle"></i> ขอยกเลิกคำสั่งซื้อ
                    </a>
                </c:if>
                
                <c:if test="${order.status == 'รออนุมัติยกเลิก'}">
                    <span style="color: #c62828; font-weight: bold;">
                        <i class="fas fa-clock"></i> กำลังรอร้านค้าอนุมัติการยกเลิก...
                    </span>
                </c:if>
            </div>
        </c:if>

        <c:if test="${not empty sessionScope.seller or not empty sessionScope.admin}">
            <div class="seller-actions">
                <h3><i class="fas fa-user-cog"></i> จัดการสถานะ (สำหรับเจ้าหน้าที่)</h3>
                <div class="action-buttons">
                    
                    <c:if test="${order.status == 'กำลังตรวจสอบ'}">
                        <a href="updateOrderStatus?orderId=${order.ordersId}&status=กำลังจัดเตรียม" 
                           class="btn-action btn-ready" onclick="return confirm('ยืนยันว่าสลิปถูกต้อง? \nเปลี่ยนสถานะเป็น: กำลังจัดเตรียม');">
                            <i class="fas fa-box"></i> ยืนยันสลิป / เริ่มจัดเตรียม
                        </a>
                    </c:if>

                    <c:if test="${order.status == 'กำลังจัดเตรียม'}">
                        <a href="updateOrderStatus?orderId=${order.ordersId}&status=สินค้าพร้อมรับ" 
                           class="btn-action btn-shipping" onclick="return confirm('จัดเตรียมเสร็จแล้ว? \nเปลี่ยนสถานะเป็น: สินค้าพร้อมรับ');">
                            <i class="fas fa-store"></i> จัดเตรียมสินค้าเสร็จสิ้น
                        </a>
                    </c:if>

                    <c:if test="${order.status == 'สินค้าพร้อมรับ'}">
                        <a href="updateOrderStatus?orderId=${order.ordersId}&status=Completed" 
                           class="btn-action btn-complete" onclick="return confirm('ลูกค้าได้รับสินค้าแล้ว?');">
                            <i class="fas fa-hand-holding"></i> ลูกค้ารับสินค้าแล้ว
                        </a>
                    </c:if>
                    
                    <c:if test="${order.status == 'รออนุมัติยกเลิก'}">
                        <a href="updateOrderStatus?orderId=${order.ordersId}&status=Cancelled" 
                           class="btn-action btn-approve-cancel" onclick="return confirm('ยืนยันให้ลูกค้ายกเลิกคำสั่งซื้อนี้?');">
                            <i class="fas fa-check-circle"></i> อนุมัติการยกเลิก
                        </a>
                        <a href="updateOrderStatus?orderId=${order.ordersId}&status=กำลังจัดเตรียม" 
                           class="btn-action btn-reject-cancel" onclick="return confirm('ปฏิเสธการยกเลิก และดำเนินการต่อ?');">
                            <i class="fas fa-undo"></i> ปฏิเสธ (จัดเตรียมต่อ)
                        </a>
                    </c:if>

                    <c:if test="${order.status != 'Completed' && order.status != 'Cancelled' && order.status != 'รออนุมัติยกเลิก'}">
                        <a href="updateOrderStatus?orderId=${order.ordersId}&status=Cancelled" 
                           class="btn-action btn-cancel-order" onclick="return confirm('ต้องการยกเลิกออเดอร์นี้ทันที?');">
                            <i class="fas fa-times"></i> ยกเลิกออเดอร์ (Force Cancel)
                        </a>
                    </c:if>

                </div>
            </div>
        </c:if>

    </div>

    <footer class="site-footer">
        <p>&copy; 2025 Fish Online Shop. All rights reserved.</p>
    </footer>

</body>
</html>