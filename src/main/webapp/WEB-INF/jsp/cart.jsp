<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>ตะกร้าสินค้า</title>
    <link rel="stylesheet" type="text/css" href="assets/css/cart.css">
</head>
<body>
<div class="header">
        <a href="Home">
            <img src="assets/images/icon/fishTesting.png" alt="โลโก้ปลา" class="logo">
        </a>
        <form action="SearchProducts" method="POST" class="search-box">
            <input type="text" name="searchtext" placeholder="ค้นหาสินค้า...">
            <button type="submit">🔍</button>
        </form>
    </div>
    <div class="nav">
        <a href="Home">หน้าแรก</a>
        <a href="AllProduct">สินค้าทั้งหมด</a>
        <a href="Orders">คำสั่งซื้อ</a>
        <a href="History">ประวัติ</a>
        <a href="Cart" style="font-weight: bold;">ตะกร้าสินค้า</a>
        <c:if test="${not empty sessionScope.user}">
            <a href="Favorites">รายการโปรด</a>
            <a href="Profile">สวัสดี, ${sessionScope.user.memberName}</a>
            <a href="Logout">ออกจากระบบ</a>
        </c:if>
        <c:if test="${empty sessionScope.user}">
            <a href="Login">เข้าสู่ระบบ</a>
        </c:if>
    </div>

    <h1 style="text-align: center; padding-top: 20px;">ตะกร้าสินค้าของคุณ</h1>
    
    <c:choose>
        <c:when test="${not empty cartItems}">

            <form action="updateFullCart" method="post">
                <table class="cart-table">
                    <thead>
                        <tr>
                            <th class="product-col">รูปภาพ</th>
                            <th class="name-col">ชื่อสินค้า</th>
                            <th class="text-right price-col">ราคาต่อหน่วย</th>
                            <th class="qty-col">จำนวน</th>
                            <th class="text-right total-col">ราคารวม</th>
                            <th class="action-col">ลบ</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${cartItems}" var="item">
                            <tr>
                                <td><img src="${item.product.productImg}" alt="${item.product.productName}"></td>
                                <td><span class="item-name">${item.product.productName}</span></td>
                                <td class="text-right"><fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="฿" minFractionDigits="2" maxFractionDigits="2"/></td>
                                <td class="text-center">
                                    <input type="number"
                                           name="quantity_${item.product.productId}"
                                           value="${item.quantity}"
                                           min="1" 
                                           max="${item.product.stock}"
                                           class="quantity-input"
                                           data-product-id="${item.product.productId}">
                                        
                                    <small>(คงเหลือ: ${item.product.stock})</small>
                                </td>
                                <td class="text-right"><fmt:formatNumber value="${item.itemTotal}" type="currency" currencySymbol="฿" minFractionDigits="2" maxFractionDigits="2"/></td>
                                <td>
                                    <a href="removeFromCart?productId=${item.product.productId}" class="remove-btn"
                                       onclick="return confirm('ต้องการลบสินค้านี้ออกจากตะกร้า?');">X</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div class="cart-summary">
                    <h3>ยอดรวมทั้งหมด: <fmt:formatNumber value="${totalCartPrice}" type="currency" currencySymbol="฿" minFractionDigits="2" maxFractionDigits="2"/></h3>
                    <button type="submit" class="update-cart-btn">อัปเดตตะกร้า</button>
                    <a href="checkout" class="checkout-btn">ดำเนินการสั่งซื้อ</a>
                </div>

            </form>
            </c:when>
        <c:otherwise>
            <p class="empty-cart">ตะกร้าสินค้าของคุณว่างเปล่า</p>
        </c:otherwise>
    </c:choose>

</body>
</html>