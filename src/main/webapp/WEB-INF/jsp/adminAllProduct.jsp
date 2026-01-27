<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>คลังสินค้าทั้งหมด | Admin</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <jsp:include page="loading.jsp" />
    
    <div class="admin-wrapper">
        <jsp:include page="adminNavbar.jsp" />

        <div class="content">
            <nav class="top-navbar">
                <div class="navbar-title">คลังสินค้าทั้งหมด</div>
                <div class="admin-profile">
                    <img src="${pageContext.request.contextPath}/assets/images/icon/admin-avatar.png" onerror="this.src='https://cdn-icons-png.flaticon.com/512/2942/2942813.png'" alt="Admin">
                    <span>Admin</span>
                </div>
            </nav>

            <div class="dashboard-container">
                <div class="recent-section">
                    <div class="section-header">
                        <h3><i class="fas fa-boxes"></i> รายการสินค้า (${productList.size()})</h3>
                    </div>

                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>รหัสสินค้า</th>
                                <th>รูปภาพ</th>
                                <th>ชื่อสินค้า</th>
                                <th>หมวดหมู่/สายพันธุ์</th>
                                <th>ราคา</th>
                                <th>คงเหลือ</th>
                                <th>จัดการ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${productList}" var="p">
                                <tr>
                                    <td>#${p.productId}</td>
                                    <td>
                                        <img src="${pageContext.request.contextPath}/${p.productImg.startsWith('assets') ? '' : 'displayImage?name='}${p.productImg}" 
                                             style="width: 50px; height: 50px; object-fit: cover; border-radius: 5px; border: 1px solid #ddd;"
                                             onerror="this.src='https://cdn-icons-png.flaticon.com/512/1156/1156477.png'">
                                    </td>
                                    <td>${p.productName}</td>
                                    <td><span class="badge" style="background: #e2e8f0; color: #4a5568;">${p.species.speciesName}</span></td>
                                    <td style="color: #28a745; font-weight: bold;">
                                        <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="฿"/>
                                    </td>
                                    <td>
                                        <span class="status-dot ${p.stock > 0 ? 'dot-green' : 'dot-red'}"></span>
                                        ${p.stock}
                                    </td>
                                    <td>
                                        <a href="AdminProductDetail?pid=${p.productId}" class="btn-small" title="ดูรายละเอียด">
                                            <i class="fas fa-eye"></i> ดูข้อมูล
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>