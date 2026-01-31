<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>รายการสินค้าทั้งหมด | Seller Center</title>
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/listProduct.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <jsp:include page="loading.jsp" />
    <jsp:include page="sellerNavbar.jsp" />

    <div class="main-content">
        <div class="header-section">
            <h1><i class="fas fa-boxes"></i> รายการสินค้าทั้งหมด</h1>
            <a href="AddProduct" class="btn-add">
                <i class="fas fa-plus"></i> เพิ่มสินค้าใหม่
            </a>
        </div>

        <div class="table-container">
            <c:choose>
                <c:when test="${empty products}">
                    <div class="empty-state">
                        <i class="fas fa-box-open"></i>
                        <p>คุณยังไม่มีสินค้าในร้านค้า</p>
                        <a href="AddProduct">เริ่มลงขายสินค้าชิ้นแรก</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="product-table">
                        <thead>
                            <tr>
                                <th style="width: 50px;">#</th>
                                <th style="width: 100px;">รูปภาพ</th>
                                <th>ชื่อสินค้า</th>
                                <th>หมวดหมู่</th>
                                <th>ราคา</th>
                                <th>สต็อก</th>
                                <th style="width: 200px;">จัดการ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${products}" var="p" varStatus="loop">
                                <tr>
                                    <td>${loop.index + 1}</td>
                                    <td>
                                        <div class="img-wrapper">
                                            <c:choose>
                                                <c:when test="${p.productImg.startsWith('assets')}">
                                                    <img src="${pageContext.request.contextPath}/${p.productImg}" alt="${p.productName}">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/displayImage?name=${p.productImg}" alt="${p.productName}">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td class="product-name">${p.productName}</td>
                                    <td><span class="badge-species">${p.species.speciesName}</span></td>
                                    <td class="price">฿<fmt:formatNumber value="${p.price}" pattern="#,##0.00" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.stock == 0}">
                                                <span class="status-out">สินค้าหมด</span>
                                            </c:when>
                                            <c:when test="${p.stock < 5}">
                                                <span class="status-low">เหลือ ${p.stock}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-ok">${p.stock}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="EditProduct?id=${p.productId}" class="btn-action btn-edit" title="แก้ไข">
                                                <i class="fas fa-edit"></i> แก้ไข
                                            </a>
                                            
                                            <a href="ProductDetail?pid=${p.productId}" class="btn-action btn-view" title="ดูรายละเอียด" target="_blank">
                                                <i class="fas fa-eye"></i> ดูสินค้า
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</body>
</html>