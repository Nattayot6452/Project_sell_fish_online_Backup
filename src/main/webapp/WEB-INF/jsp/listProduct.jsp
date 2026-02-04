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
    
    <style>
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            display: inline-block;
        }
        .status-active {
            background-color: #e8f5e9;
            color: #2e7d32;
            border: 1px solid #c8e6c9;
        }
        .status-inactive {
            background-color: #ffebee;
            color: #c62828;
            border: 1px solid #ffcdd2;
        }
    </style>
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
                        <h3>ยังไม่มีสินค้าในร้าน</h3>
                        <p>เริ่มลงขายสินค้าชิ้นแรกของคุณเลย!</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="product-table">
                        <thead>
                            <tr>
                                <th>รูปภาพ</th>
                                <th>ชื่อสินค้า</th>
                                <th>หมวดหมู่</th>
                                <th>ราคา</th>
                                <th>สต็อก</th>
                                <th>สถานะ</th>
                                <th>จัดการ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${products}" var="p">
                                <tr>
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
                                    <td>
                                        <div class="product-name">${p.productName}</div>
                                        <small style="color: #888;">ID: ${p.productId}</small>
                                    </td>
                                    <td><span class="category-badge">${p.species.speciesName}</span></td>
                                    <td><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="฿"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.stock <= 5}">
                                                <span class="status-low">เหลือ ${p.stock}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-ok">${p.stock}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.productStatus == 'Inactive'}">
                                                <span class="status-badge status-inactive">
                                                    <i class="fas fa-pause-circle"></i> พักการขาย
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-active">
                                                    <i class="fas fa-check-circle"></i> เปิดขายปกติ
                                                </span>
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