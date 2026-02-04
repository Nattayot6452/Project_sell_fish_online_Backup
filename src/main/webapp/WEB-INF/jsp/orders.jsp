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
    
    <style>
        .action-group {
            display: flex;
            gap: 5px;
            align-items: center;
        }

        .btn-detail {
            background-color: #6c757d;
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 14px;
        }
        .btn-detail:hover { background-color: #5a6268; }

        .btn-pay {
            background-color: #28a745;
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 14px;
        }
        .btn-pay:hover { background-color: #218838; }

        .status-badge {
            padding: 6px 15px;
            border-radius: 50px;
            color: white;
            font-size: 13px;
            font-weight: 600;
            display: inline-block;
            min-width: 100px;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .status-pending { background-color: #ffc107; color: #333; }
        .status-checking { background-color: #17a2b8; }
        .status-ready { background-color: #fd7e14; }
        .status-completed { background-color: #28a745; }
        .status-cancelled { background-color: #dc3545; }
        .status-waiting-cancel { background-color: #e83e8c; }
        
    </style>
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
                <div class="alert alert-success" style="padding: 10px; background: #d4edda; color: #155724; border-radius: 5px; margin-bottom: 10px;">
                    <i class="fas fa-check-circle"></i> ${successMessage}
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error" style="padding: 10px; background: #f8d7da; color: #721c24; border-radius: 5px; margin-bottom: 10px;">
                    <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                </div>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${not empty userOrders}">
                <div class="orders-table-wrapper">
                    <table class="orders-table">
                        <thead>
                            <tr>
                                <th>รหัสคำสั่งซื้อ</th>
                                <th>วันที่สั่งซื้อ</th>
                                <th>ยอดรวม</th>
                                <th>สถานะ</th>
                                <th>ดำเนินการ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${userOrders}">
                                <tr>
                                    <td>#${order.ordersId}</td>
                                    <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="฿"/></td>
                                    <td>
                                        <c:set var="statusClass" value="status-checking" />
                                        <c:set var="statusText" value="${order.status}" />

                                        <c:choose>
                                            <c:when test="${order.status == 'Pending Payment' || order.status == 'รอดำเนินการชำระเงิน'}">
                                                <c:set var="statusClass" value="status-pending" />
                                                <c:set var="statusText" value="รอชำระเงิน" />
                                            </c:when>

                                            <c:when test="${order.status == 'Checking' || order.status == 'กำลังตรวจสอบ' || order.status == 'กำลังจัดเตรียม'}">
                                                <c:set var="statusClass" value="status-checking" />
                                                <c:set var="statusText" value="กำลังดำเนินการ" />
                                            </c:when>

                                            <c:when test="${order.status == 'Ready for Pickup' || order.status == 'สินค้าพร้อมรับ' || order.status == 'รอรับสินค้า'}">
                                                <c:set var="statusClass" value="status-ready" />
                                                <c:set var="statusText" value="สินค้าพร้อมรับ" />
                                            </c:when>

                                            <c:when test="${order.status == 'Completed' || order.status == 'สำเร็จ' || order.status == 'รับสินค้าแล้ว'}">
                                                <c:set var="statusClass" value="status-completed" />
                                                <c:set var="statusText" value="สำเร็จ" />
                                            </c:when>

                                            <c:when test="${order.status == 'Cancelled' || order.status == 'ยกเลิก' || order.status == 'ยกเลิกคำสั่งซื้อ'}">
                                                <c:set var="statusClass" value="status-cancelled" />
                                                <c:set var="statusText" value="ยกเลิก" />
                                            </c:when>

                                            <c:when test="${order.status == 'รออนุมัติยกเลิก'}">
                                                <c:set var="statusClass" value="status-waiting-cancel" />
                                                <c:set var="statusText" value="รออนุมัติยกเลิก" />
                                            </c:when>
                                        </c:choose>

                                        <span class="status-badge ${statusClass}">
                                            ${statusText}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-group">
                                            
                                            <a href="OrderDetail?orderId=${order.ordersId}" class="btn-detail" title="ดูรายละเอียด">
                                                <i class="fas fa-eye"></i> รายละเอียด
                                            </a>

                                            <c:if test="${order.status == 'Pending Payment' || order.status == 'รอดำเนินการชำระเงิน'}">
                                                <a href="uploadSlip?orderId=${order.ordersId}" class="btn-pay" title="แจ้งโอนเงิน">
                                                    <i class="fas fa-file-invoice-dollar"></i> แจ้งโอน
                                                </a>
                                            </c:if>

                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state" style="text-align: center; padding: 50px;">
                    <h2>คุณยังไม่มีคำสั่งซื้อ</h2>
                    <a href="AllProduct" class="btn-shop-now">
                        <i class="fas fa-shopping-cart"></i> ไปเลือกซื้อสินค้า
                    </a>
                </div>
            </c:otherwise>
        </c:choose>

    </div>

    <footer class="site-footer">
        <p>&copy; 2025 Fish Online Shop. All rights reserved.</p>
    </footer>

</body>
</html>