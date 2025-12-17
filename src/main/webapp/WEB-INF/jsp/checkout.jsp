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
    <title>ชำระเงิน | Fish Online</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/checkout.css">
    <link rel="stylesheet" type="text/css" href="assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

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
                    <a href="Cart" class="cart-link" title="ตะกร้าสินค้า">
                        <i class="fas fa-shopping-cart"></i>
                    </a>

                    <div class="dropdown">
                        <a href="Profile" class="dropbtn user-profile">
                            <img src="${pageContext.request.contextPath}/profile-uploads/user/${sessionScope.user.memberImg}" class="nav-avatar">
                            สวัสดี, ${sessionScope.user.memberName}
                            <i class="fas fa-chevron-down" style="font-size: 10px;"></i>
                        </a>
                        <div class="dropdown-content">
                            <a href="editProfile"><i class="fas fa-user-edit"></i> แก้ไขโปรไฟล์</a>
                            
                            <a href="Favorites"><i class="fas fa-heart"></i> รายการโปรด</a> 
                            <a href="Orders"><i class="fas fa-box-open"></i> คำสั่งซื้อ</a>
                            <a href="History"><i class="fas fa-history"></i> ประวัติการสั่งซื้อ</a>
                            <div style="border-top: 1px solid #eee; margin: 5px 0;"></div>
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

    <div class="container main-container">
        
        <div class="page-header">
            <h1><i class="fas fa-credit-card"></i> ชำระเงิน</h1>
            <p>เลือกช่องทางการชำระเงินและสแกน QR Code</p>
        </div>

        <form action="createOrder" method="post" class="checkout-wrapper" id="checkoutForm" onsubmit="return validatePayment()">
            
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
                                <span class="item-name">${item.product.productName} <small>x${item.quantity}</small></span>
                                <span class="item-price"><fmt:formatNumber value="${item.itemTotal}" type="currency" currencySymbol="฿"/></span>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <div class="summary-divider"></div>
                    
                    <div class="summary-total">
                        <span>ยอดชำระสุทธิ</span>
                        <span class="final-price"><fmt:formatNumber value="${totalCartPrice}" type="currency" currencySymbol="฿"/></span>
                    </div>

                    <button type="submit" class="btn-confirm-order">
                        ยืนยันการแจ้งโอน <i class="fas fa-arrow-right"></i>
                    </button>
                    
                    <a href="Cart" class="btn-back-cart">ย้อนกลับ</a>
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

        function validatePayment() {
            const paymentMethods = document.getElementsByName('paymentMethod');
            let isSelected = false;

            for (let i = 0; i < paymentMethods.length; i++) {
                if (paymentMethods[i].checked) {
                    isSelected = true;
                    break;
                }
            }

            if (!isSelected) {
                alert("กรุณาเลือกธนาคารที่ต้องการชำระเงินก่อนดำเนินการต่อ");
                return false; 
            }
            return true;
        }
    </script>

</body>
</html>