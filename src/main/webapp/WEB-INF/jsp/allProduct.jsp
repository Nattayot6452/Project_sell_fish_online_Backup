<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <title>สินค้าทั้งหมด</title>
    <link rel="stylesheet" type="text/css" href="assets/css/allProduct.css">
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

    <h1 style="text-align: center; padding-top: 20px;">สินค้าทั้งหมด</h1>

    <form action="AllProduct" method="get" class="filter-bar">
        
        <div class="filter-group">
            <label for="category">หมวดหมู่ปลา:</label>
            <select name="category" id="category">
                <option value="all" ${param.category == 'all' || empty param.category ? 'selected' : ''}>ทั้งหมด</option>
                <c:forEach items="${speciesList}" var="species">
                    <option value="${species.speciesName}" ${param.category == species.speciesName ? 'selected' : ''}>
                        ${species.speciesName}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="filter-group">
            <label for="sortBy">เรียงลำดับตาม:</label>
            <select name="sortBy" id="sortBy">
                <option value="default" ${param.sortBy == 'default' ? 'selected' : ''}>ค่าเริ่มต้น</option>
                <option value="price_asc" ${param.sortBy == 'price_asc' ? 'selected' : ''}>ราคา: น้อยไปมาก</option>
                <option value="price_desc" ${param.sortBy == 'price_desc' ? 'selected' : ''}>ราคา: มากไปน้อย</option>
                <option value="name_asc" ${param.sortBy == 'name_asc' ? 'selected' : ''}>ชื่อ: A-Z</option>
            </select>
        </div>

        <div class="filter-group">
            <label>&nbsp;</label>
            <button type="submit">กรอง</button>
        </div>
    </form>


    <div class="product-grid">
        <c:forEach items="${Product}" var="products">
            <div class="product-card">

                <div class="card-buttons">
                   <a href="${empty sessionScope.user ? 'Login' : 'addToFavorites?productId='.concat(products.productId)}"
					   class="card-icon-btn add-to-favorite-btn"
					   title="เพิ่มเข้ารายการโปรด">
					   ❤️
					</a>
                   <a href="${empty sessionScope.user ? 'Login' : 'addToCart?productId='.concat(products.productId)}"
                      class="card-icon-btn add-to-cart-btn"
                      title="หยิบใส่ตะกร้า">
                       🛒
                   </a>
                </div>

               <img src="${products.productImg}" alt="รูปภาพของ ${products.productName}">

               <div class="product-info">
                   <div class="product-name">${products.productName}</div>
                   <div class="product-price">ราคา: ${products.price} บาท</div>
                   <div class="product-price">จำนวน: ${products.stock} ตัว</div>
                   	<a href="ProductDetail?pid=${products.productId}" class="btn">ดูรายละเอียดสินค้า</a>
               </div>

            </div>
        </c:forEach>
    </div>

    <c:if test="${totalPages > 1}">
        <div class="pagination">
            
            <a href="AllProduct?page=${currentPage - 1}&sortBy=${param.sortBy}&category=${param.category}"
               class="${currentPage == 1 ? 'disabled' : ''}">
               &laquo; ก่อนหน้า
            </a>

            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="AllProduct?page=${i}&sortBy=${param.sortBy}&category=${param.category}"
                   class="${i == currentPage ? 'active' : ''}">
                   ${i}
                </a>
            </c:forEach>

            <a href="AllProduct?page=${currentPage + 1}&sortBy=${param.sortBy}&category=${param.category}"
               class="${currentPage == totalPages ? 'disabled' : ''}">
               ถัดไป &raquo;
            </a>
        </div>
    </c:if>

</body>
</html>