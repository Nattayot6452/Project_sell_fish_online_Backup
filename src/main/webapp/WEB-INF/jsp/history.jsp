<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ประวัติการสั่งซื้อ | Fish Online</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/history.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <jsp:include page="loading.jsp" />

    <jsp:include page="navbar.jsp" />

    <div class="container main-container">
        
        <div class="page-header">
            <h1><i class="fas fa-history"></i> ประวัติการสั่งซื้อ</h1>
            <p>รายการคำสั่งซื้อที่เสร็จสมบูรณ์แล้ว</p>
        </div>

        <c:choose>
            <c:when test="${not empty orderList}">
                <div class="history-list">
                    <c:forEach items="${orderList}" var="order">
                        
                        <div class="order-card">
                            <div class="order-header">
                                <div class="order-info">
                                    <span class="order-id">#${order.ordersId}</span>
                                    <span class="order-date">
                                        <i class="far fa-calendar-alt"></i> 
                                        <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </span>
                                </div>
                                <div class="order-status">
                                    <span class="status-badge ${order.status == 'Completed' ? 'completed' : 'cancelled'}">
                                        ${order.status}
                                    </span>
                                </div>
                            </div>

                            <div class="order-items">
                                <c:forEach items="${order.orderDetails}" var="detail">
                                    <div class="item-row">
                                        <div class="product-col">
                                            <c:choose>
                                                <c:when test="${detail.product.productImg.startsWith('assets')}">
                                                    <img src="${pageContext.request.contextPath}/${detail.product.productImg}" alt="${detail.product.productName}">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/displayImage?name=${detail.product.productImg}" alt="${detail.product.productName}">
                                                </c:otherwise>
                                            </c:choose>
                                            <div class="product-text">
                                                <a href="ProductDetail?pid=${detail.product.productId}" class="product-name">
                                                    <c:out value="${detail.product.productName}" />
                                                </a>
                                                <span class="qty">x${detail.quantity}</span>
                                            </div>
                                        </div>

                                        <div class="action-col">
                                            <span class="price">
                                                <fmt:formatNumber value="${detail.price * detail.quantity}" type="currency" currencySymbol="฿"/>
                                            </span>

                                            <c:if test="${order.status == 'Completed'}">
                                                <a href="WriteReview?productId=${detail.product.productId}" class="btn-review">
                                                    <i class="fas fa-star"></i> เขียนรีวิว
                                                </a>
                                            </c:if>

                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <div class="order-footer">
                                <span class="total-label">ราคารวมทั้งสิ้น:</span>
                                <span class="total-price">
                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="฿"/>
                                </span>
                                <a href="OrderDetail?orderId=${order.ordersId}" class="btn-detail">
                                    ดูรายละเอียด
                                </a>
                            </div>
                        </div>

                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-box-open"></i>
                    <h3>ยังไม่มีประวัติการสั่งซื้อ</h3>
                    <p>เมื่อคุณสั่งซื้อและได้รับสินค้าแล้ว รายการจะปรากฏที่นี่</p>
                    <a href="AllProduct" class="btn-shop-now">เลือกซื้อสินค้า</a>
                </div>
            </c:otherwise>
        </c:choose>

    </div>

    <footer class="site-footer">
        <p>&copy; 2025 Fish Online Shop. All rights reserved.</p>
    </footer>

</body>
</html>