<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>ยืนยันการสั่งซื้อ</title>
    <link rel="stylesheet" type="text/css" href="assets/css/checkout.css">
</head>
<body>
 <div class="header">
        <a href="Home"><img src="assets/images/icon/fishTesting.png" alt="โลโก้ปลา" class="logo"></a>
        <form action="SearchProducts" method="POST" class="search-box">
            <input type="text" name="searchtext" placeholder="ปลาหางนกยูง">
            <button type="submit">🔍</button>
        </form>
    </div>

    <div class="nav">
        <a href="Home">หน้าแรก</a>
        <a href="AllProduct">สินค้าทั้งหมด</a>
        <a href="Orders">คำสั่งซื้อ</a>
        <a href="History">ประวัติ</a>
        <a href="Cart">ตะกร้าสินค้า</a>
        <c:if test="${not empty sessionScope.user}">
            <a href="Favorites">รายการโปรด</a>
            <a href="Profile">สวัสดี, ${sessionScope.user.memberName}</a>
            <a href="Logout">ออกจากระบบ</a>
        </c:if>
        <c:if test="${empty sessionScope.user}">
            <a href="Login">เข้าสู่ระบบ</a>
        </c:if>
    </div>

    <h1 style="text-align: center; padding-top: 20px;">ยืนยันการสั่งซื้อและชำระเงิน</h1>

    <div class="checkout-container">
        
        <div class="order-summary">
            <h2>สรุปรายการสั่งซื้อ</h2>
            <c:forEach items="${cartItems}" var="item">
                <div class="summary-item">
                    <span>
                        <img src="${item.product.productImg}" alt="">
                        ${item.product.productName} (x${item.quantity})
                    </span>
                    <strong><fmt:formatNumber value="${item.itemTotal}" type="currency" currencySymbol="฿" maxFractionDigits="2"/></strong>
                </div>
            </c:forEach>
            <div class="summary-total">
                ยอดรวมทั้งหมด: <fmt:formatNumber value="${totalCartPrice}" type="currency" currencySymbol="฿" maxFractionDigits="2"/>
            </div>
        </div>

        <div class="payment-selection">
            <h2>เลือกช่องทางการชำระเงิน</h2>
            
            <form action="createOrder" method="POST" id="checkoutForm">
            
                <div class="bank-option">
                    <input type="radio" name="paymentMethod" value="kbank" id="kbank" required 
                           onclick="showQr('kbank-qr')">
                    <label for="kbank">ธนาคารกสิกรไทย</label>
                    <div id="kbank-qr" class="qr-code">
                        <p>สแกน QR Code (กสิกรไทย)</p>
                        <img src="assets/images/qr/kbank_qr_placeholder.jpg" alt="QR กสิกร">
                    </div>
                </div>

                <div class="bank-option">
                    <input type="radio" name="paymentMethod" value="scb" id="scb" 
                           onclick="showQr('scb-qr')">
                    <label for="scb">ธนาคารไทยพาณิชย์</label>
                    <div id="scb-qr" class="qr-code">
                        <p>สแกน QR Code (ไทยพาณิชย์)</p>
                        <img src="assets/images/qr/scb_qr_placeholder.jpg" alt="QR ไทยพาณิชย์">
                    </div>
                </div>
                
                <div class="checkout-form-submit">
                    <button type="submit" class="next-btn">ถัดไป (ยืนยันการสั่งซื้อ)</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function showQr(selectedQrId) {
            // 1. ซ่อน QR Code ทั้งหมดก่อน
            var allQrCodes = document.querySelectorAll('.qr-code');
            allQrCodes.forEach(function(qrDiv) {
                qrDiv.style.display = 'none';
            });
            
            // 2. แสดงเฉพาะ QR Code ที่ถูกเลือก
            var selectedDiv = document.getElementById(selectedQrId);
            if (selectedDiv) {
                selectedDiv.style.display = 'block';
            }
        }
    </script>
    </body>
</html>