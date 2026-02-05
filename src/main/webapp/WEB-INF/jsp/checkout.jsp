<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ชำระเงิน | Fish Online</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/checkout.css">
    <link rel="stylesheet" type="text/css" href="assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="container main-container">
        
        <div class="page-header">
            <h1><i class="fas fa-credit-card"></i> ชำระเงิน</h1>
            <p>เลือกช่องทางการชำระเงินและสแกน QR Code</p>
        </div>

        <form action="createOrder" method="post" class="checkout-wrapper" id="checkoutForm" onsubmit="return validatePayment(event)">
            
            <div class="payment-section">
                <h2><i class="fas fa-wallet"></i> เลือกธนาคารที่ต้องการโอน</h2>
                
                <div class="payment-options">
                    <label class="payment-card">
                        <input type="radio" name="paymentMethod" value="kbank" onclick="showQr('kbank-qr')">
                        <div class="card-content">
                            <div class="bank-icon kbank"><i class="fas fa-university"></i></div>
                            <div class="bank-info">
                                <strong>ธนาคารกสิกรไทย</strong>
                                <span>Fish Online Shop (123-4-56789-0)</span>
                            </div>
                            <div class="check-icon"><i class="fas fa-check-circle"></i></div>
                        </div>
                    </label>
                    <div id="kbank-qr" class="qr-box">
                        <img src="${pageContext.request.contextPath}/assets/images/qr/kbank_qr_placeholder.jpg" alt="QR กสิกร">
                        <p>กรุณาสแกนเพื่อชำระเงิน</p>
                    </div>

                    <label class="payment-card">
                        <input type="radio" name="paymentMethod" value="scb" onclick="showQr('scb-qr')">
                        <div class="card-content">
                            <div class="bank-icon scb"><i class="fas fa-university"></i></div>
                            <div class="bank-info">
                                <strong>ธนาคารไทยพาณิชย์</strong>
                                <span>Fish Online Shop (987-6-54321-0)</span>
                            </div>
                            <div class="check-icon"><i class="fas fa-check-circle"></i></div>
                        </div>
                    </label>
                    <div id="scb-qr" class="qr-box">
                        <img src="${pageContext.request.contextPath}/assets/images/qr/scb_qr_placeholder.jpg" alt="QR ไทยพาณิชย์">
                        <p>กรุณาสแกนเพื่อชำระเงิน</p>
                    </div>
                </div>
            </div>

            <div class="summary-section">
                <div class="summary-card sticky-card">
                    <h3>สรุปรายการสินค้า</h3>
                    <div class="order-items">
                        <c:forEach items="${cartItems}" var="item">
                            <div class="summary-item">
                                <span class="item-name"><c:out value="${item.product.productName}" /> <small>x${item.quantity}</small></span>
                                <span class="item-price"><fmt:formatNumber value="${item.itemTotal}" type="currency" currencySymbol="฿"/></span>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <div class="summary-divider"></div>

                    <div class="summary-item" style="color: #666; margin-top: 10px;">
                        <span class="item-name">ยอดรวมสินค้า</span>
                        <span class="item-price"><fmt:formatNumber value="${totalCartPrice}" type="currency" currencySymbol="฿"/></span>
                    </div>

                    <c:if test="${discount > 0}">
                        <div class="summary-item" style="color: #28a745; font-weight: bold;">
                            <span class="item-name"><i class="fas fa-ticket-alt"></i> ส่วนลด (${couponCode})</span>
                            <span class="item-price">-<fmt:formatNumber value="${discount}" type="currency" currencySymbol="฿"/></span>
                        </div>
                    </c:if>
                    
                    <div class="summary-divider"></div>
                    
                    <div class="summary-total">
                        <span>ยอดชำระสุทธิ</span>
                        <span class="final-price">
                            <fmt:formatNumber value="${finalPrice}" type="currency" currencySymbol="฿"/>
                        </span>
                    </div>

                    <input type="hidden" name="couponCode" value="${couponCode}">
                    <input type="hidden" name="discountAmount" value="${discount}">

                    <button type="submit" class="btn-confirm-order">
                        ยืนยันการแจ้งโอน <i class="fas fa-arrow-right"></i>
                    </button>
                    
                    <a href="Cart" class="btn-back-cart">ย้อนกลับ</a>
                    
                    <c:if test="${not empty checkoutError}">
                        <div style="background: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-top: 15px; font-size: 0.9em; text-align: center;">
                            <i class="fas fa-exclamation-circle"></i> ${checkoutError}
                        </div>
                    </c:if>
                </div>
            </div>

        </form>
    </div>

    <footer class="site-footer">
        <p>&copy; 2025 Fish Online Shop. All rights reserved.</p>
    </footer>

    <script>
        function showQr(qrId) {
            document.querySelectorAll('.qr-box').forEach(el => el.classList.remove('active'));
            document.querySelectorAll('.payment-card').forEach(el => el.classList.remove('selected'));
            
            const qr = document.getElementById(qrId);
            if(qr) qr.classList.add('active');
            
            const radio = document.querySelector(`input[value="${qrId.replace('-qr','')}"]`);
            if(radio) radio.closest('.payment-card').classList.add('selected');
        }

        function validatePayment(event) {

            event.preventDefault();

            const paymentMethods = document.getElementsByName('paymentMethod');
            let isSelected = false;

            for (let i = 0; i < paymentMethods.length; i++) {
                if (paymentMethods[i].checked) {
                    isSelected = true;
                    break;
                }
            }

            if (!isSelected) {
                Swal.fire({
                    title: 'ลืมอะไรไปหรือเปล่า?',
                    text: 'กรุณาเลือกธนาคารที่ต้องการชำระเงินก่อนดำเนินการต่อ',
                    icon: 'warning',
                    confirmButtonText: 'ตกลง',
                    confirmButtonColor: '#00571d'
                });
                return false; 
            }

            Swal.fire({
                title: 'คุณโอนเงินแล้วใช่มั้ย?',
                text: "กรุณาตรวจสอบการโอนเงินให้เรียบร้อยก่อนยืนยัน",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#28a745',
                cancelButtonColor: '#d33',
                confirmButtonText: 'ใช่, โอนแล้ว',
                cancelButtonText: 'ยังไม่โอน'
            }).then((result) => {

                if (result.isConfirmed) {
                    document.getElementById('checkoutForm').submit();
                }

            });
        }
    </script>

</body>
</html>