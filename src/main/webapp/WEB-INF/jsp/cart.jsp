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

         <jsp:include page="navbar.jsp" />

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
                                                        <img src="${pageContext.request.contextPath}/${item.product.productImg}" alt="${item.product.productName}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/displayImage?name=${item.product.productImg}" alt="${item.product.productName}">
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
                                               onclick="confirmDeleteCartItem(event, this.href);">
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
                                    <button type="button" onclick="checkCoupon()" style="padding: 8px 12px; background: #6f42c1; color: white; border: none; border-radius: 4px; cursor: pointer;">
                                            ใช้
                                    </button>
                                </div>
                                <small id="couponMsg" style="display: block; margin-top: 5px; font-size: 13px; min-height: 20px;"></small>                            </div>

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

        let currentTotal = parseFloat("${totalCartPrice != null ? totalCartPrice : 0}");

        function checkCoupon() {
            let code = document.getElementById("couponCode").value;
            let msg = document.getElementById("couponMsg");

            if (code.trim() === "") {
                msg.innerHTML = "<span style='color:red;'>กรุณากรอกรหัสคูปอง</span>";
                return;
            }

            $.ajax({
                type: "GET",
                url: "checkCoupon",
                data: { code: code },
                success: function(response) {

                    if (!response.startsWith("VALID")) {
                        msg.innerHTML = "<span style='color:red;'>" + response + "</span>";
                        resetCoupon();
                    } else {

                        let parts = response.split("|");
                        let discount = parseFloat(parts[1]);
                        let finalPrice = parseFloat(parts[2]);

                        msg.innerHTML = "<span style='color:green;'>ใช้คูปองสำเร็จ! ลด " + discount.toLocaleString() + " บาท</span>";
                        
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

            document.getElementById("total-display").innerText = "฿" + currentTotal.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});
            document.getElementById("appliedCouponCode").value = "";
            document.getElementById("discountAmount").value = "0";
        }

        function goToCheckout() {
            let code = document.getElementById("appliedCouponCode").value;
            let discount = document.getElementById("discountAmount").value;
            
            window.location.href = "checkout?coupon=" + encodeURIComponent(code) + "&discount=" + discount;
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>

    function confirmDeleteCartItem(event, url) {
        event.preventDefault(); 

        Swal.fire({
            title: 'ต้องการลบสินค้านี้?',
            text: "สินค้านี้จะถูกนำออกจากตะกร้าของคุณ",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#e53e3e',  
            cancelButtonColor: '#718096',  
            confirmButtonText: 'ใช่, ลบเลย!',
            cancelButtonText: 'ยกเลิก',
            reverseButtons: true 
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = url; 
            }
        });
    }
</script>

</body>
</html>