<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ตะกร้าสินค้า | Fish Online</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/cart.css">
    <link rel="stylesheet" type="text/css" href="assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
            <h1><i class="fas fa-shopping-basket"></i> ตะกร้าสินค้าของคุณ</h1>
        </div>

        <c:choose>
            <c:when test="${not empty cartItems}">
                
                <form action="updateFullCart" method="post" class="cart-wrapper">
                    
                    <div class="cart-items-section">
                        <table class="cart-table">
                            <thead>
                                <tr>
                                    <th>สินค้า</th>
                                    <th>ราคาต่อหน่วย</th>
                                    <th>จำนวน</th>
                                    <th>รวม</th>
                                    <th>ลบ</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${cartItems}" var="item">
                                    <tr>
                                        <td class="product-col">
                                            <div class="product-detail-flex">
                                                <c:choose>
                                                    <c:when test="${item.product.productImg.startsWith('assets')}">
                                                        <img src="${pageContext.request.contextPath}/${item.product.productImg}" 
                                                             alt="${item.product.productName}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/profile-uploads/${item.product.productImg}" 
                                                             alt="${item.product.productName}">
                                                    </c:otherwise>
                                                </c:choose>

                                                <div class="product-text">
                                                    <a href="ProductDetail?pid=${item.product.productId}" class="product-title">
                                                        ${item.product.productName}
                                                    </a>
                                                    <span class="stock-status">คงเหลือ: ${item.product.stock} ตัว</span>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="price-col">
                                            <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="฿"/>
                                        </td>
                                        <td class="qty-col">
                                            <div class="quantity-control">
                                                <button type="button" onclick="adjustQty(this, -1)">-</button>
                                                <input type="number" name="quantity_${item.product.productId}" 
                                                       value="${item.quantity}" min="1" max="${item.product.stock}" 
                                                       class="qty-input" readonly>
                                                <button type="button" onclick="adjustQty(this, 1)">+</button>
                                            </div>
                                        </td>
                                        <td class="total-col">
                                            <fmt:formatNumber value="${item.itemTotal}" type="currency" currencySymbol="฿"/>
                                        </td>
                                        <td class="action-col">
                                            <a href="removeFromCart?productId=${item.product.productId}" class="btn-remove"
                                               onclick="return confirm('ต้องการลบสินค้านี้ออกจากตะกร้า?');">
                                                <i class="fas fa-trash-alt"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        
                        <div class="cart-actions-row">
                            <a href="AllProduct" class="btn-continue"><i class="fas fa-arrow-left"></i> เลือกซื้อสินค้าต่อ</a>
                            <button type="submit" class="btn-update"><i class="fas fa-sync-alt"></i> อัปเดตตะกร้า</button>
                        </div>
                    </div>

                    <div class="cart-summary-section">
                        <div class="summary-card">
                            <h3>สรุปคำสั่งซื้อ</h3>
                            
                            <div class="summary-row">
                                <span>ยอดรวมสินค้า</span>
                                <span id="subtotal-display"><fmt:formatNumber value="${totalCartPrice}" type="currency" currencySymbol="฿"/></span>
                            </div>

                            <div class="coupon-section" style="margin: 15px 0; padding-top: 15px; border-top: 1px dashed #ddd;">
                                <label style="font-size: 14px; font-weight: bold; color: #555; display: block; margin-bottom: 5px;">
                                    <i class="fas fa-ticket-alt"></i> มีคูปองส่วนลดไหม?
                                </label>
                                <div style="display: flex; gap: 5px;">
                                    <input type="text" id="couponCode" placeholder="กรอกรหัสคูปอง" 
                                           style="flex: 1; padding: 8px; border: 1px solid #ccc; border-radius: 4px; text-transform: uppercase;">
                                    <button type="button" onclick="applyCoupon()" 
                                            style="padding: 8px 12px; background: #6f42c1; color: white; border: none; border-radius: 4px; cursor: pointer;">
                                        ใช้
                                    </button>
                                </div>
                                <small id="couponMessage" style="display: block; margin-top: 5px; font-size: 13px; min-height: 20px;"></small>
                            </div>

                            <div class="summary-row discount-row" style="display: none; color: #28a745; margin-bottom: 10px;">
                                <span>ส่วนลดคูปอง</span>
                                <span id="discount-display">-฿0.00</span>
                            </div>
                            
                            <div class="summary-divider" style="border-top: 2px solid #eee; margin: 10px 0;"></div>
                            
                            <div class="summary-total" style="font-size: 1.2em; font-weight: bold; display: flex; justify-content: space-between; margin-bottom: 20px;">
                                <span>ยอดสุทธิ</span>
                                <span class="final-price" id="total-display">
                                    <fmt:formatNumber value="${totalCartPrice}" type="currency" currencySymbol="฿"/>
                                </span>
                            </div>
                            
                            <input type="hidden" name="appliedCouponCode" id="appliedCouponCode">
                            <input type="hidden" name="discountAmount" id="discountAmount" value="0">
                            
                            <button type="button" onclick="goToCheckout()" class="btn-checkout" 
                                    style="width: 100%; padding: 15px; background: #00571d; color: white; border: none; border-radius: 8px; font-size: 18px; cursor: pointer;">
                                ดำเนินการสั่งซื้อ <i class="fas fa-arrow-right"></i>
                            </button>
                        </div>
                    </div>

                </form>

            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-shopping-cart"></i>
                    <h2>ตะกร้าสินค้าของคุณว่างเปล่า</h2>
                    <p>ดูเหมือนคุณจะยังไม่ได้เลือกปลาตัวโปรดลงในตะกร้าเลย</p>
                    <a href="AllProduct" class="btn-shop-now">ไปเลือกซื้อสินค้า</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <footer class="site-footer">
        <p>&copy; 2025 Fish Online Shop. All rights reserved.</p>
    </footer>

    <script>
        function adjustQty(btn, change) {
            const input = btn.parentElement.querySelector('input');
            let newVal = parseInt(input.value) + change;
            const max = parseInt(input.getAttribute('max'));
            if (newVal >= 1 && (isNaN(max) || newVal <= max)) {
                input.value = newVal;
            }
        }
    </script>

    <script>

            let currentTotal = parseFloat('${totalCartPrice != null ? totalCartPrice : 0}');
        function applyCoupon() {
            let code = document.getElementById("couponCode").value.trim();
            let msg = document.getElementById("couponMessage");
            
            if(code === "") {
                msg.innerHTML = "<span style='color:red;'>กรุณากรอกรหัสคูปอง</span>";
                return;
            }

            $.ajax({
                url: "checkCoupon", 
                type: "POST",
                data: { 
                    code: code,
                    totalAmount: currentTotal 
                },
                success: function(response) {
                    if (response.startsWith("INVALID")) {

                        let errorText = response.split(":")[1];
                        msg.innerHTML = "<span style='color:red;'><i class='fas fa-times-circle'></i> " + errorText + "</span>";
                        resetCoupon();
                    } else {

                        let discount = parseFloat(response);
                        let finalPrice = currentTotal - discount;
                        
                        msg.innerHTML = "<span style='color:green;'><i class='fas fa-check-circle'></i> ใช้คูปองสำเร็จ! ลดไป " + discount.toLocaleString() + " บาท</span>";
                        
                        document.querySelector(".discount-row").style.display = "flex";
                        document.getElementById("discount-display").innerText = "-฿" + discount.toLocaleString();
                        document.getElementById("total-display").innerText = "฿" + finalPrice.toLocaleString();
                        
                        document.getElementById("appliedCouponCode").value = code;
                        document.getElementById("discountAmount").value = discount;
                    }
                },
                error: function() {
                    msg.innerHTML = "<span style='color:red;'>เกิดข้อผิดพลาดในการเชื่อมต่อ Server</span>";
                }
            });
        }

        function resetCoupon() {
            document.querySelector(".discount-row").style.display = "none";
            document.getElementById("total-display").innerText = "฿" + currentTotal.toLocaleString();
            document.getElementById("appliedCouponCode").value = "";
            document.getElementById("discountAmount").value = "0";
        }

        function goToCheckout() {

            let code = document.getElementById("appliedCouponCode").value;
            let discount = document.getElementById("discountAmount").value;
            
            window.location.href = "checkout?coupon=" + encodeURIComponent(code) + "&discount=" + discount;
        }
    </script>

</body>
</html>