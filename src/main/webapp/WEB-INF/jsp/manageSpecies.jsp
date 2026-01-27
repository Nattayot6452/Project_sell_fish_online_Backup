<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>จัดการสายพันธุ์ | Admin</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <jsp:include page="loading.jsp" />

    <div class="admin-wrapper">
        <jsp:include page="adminNavbar.jsp" />
        <div class="content">
            <nav class="top-navbar">
                <div class="navbar-title">จัดการข้อมูลสายพันธุ์</div>
                <div class="admin-profile">
                    <img src="${pageContext.request.contextPath}/assets/images/icon/admin-avatar.png" onerror="this.src='https://cdn-icons-png.flaticon.com/512/2942/2942813.png'" alt="Admin">
                    <span>Admin</span>
                </div>
            </nav>

            <div class="dashboard-container">
                <div class="recent-section">
                    <div class="section-header">
                        <h3><i class="fas fa-list"></i> รายชื่อสายพันธุ์ทั้งหมด (${speciesList.size()})</h3>
                        <a href="AddSpecies" class="btn-view-all" style="background: #00571d; color: white; padding: 8px 15px; border-radius: 5px; text-decoration: none;">
                            <i class="fas fa-plus"></i> เพิ่มสายพันธุ์ใหม่
                        </a>
                    </div>
                    
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>รหัส (ID)</th>
                                <th>ชื่อสายพันธุ์</th>
                                <th>คำอธิบาย</th>
                                <th>จัดการ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${speciesList}" var="s">
                                <tr>
                                    <td><span style="background: #edf2f7; padding: 4px 8px; border-radius: 4px; font-family: monospace; font-weight: bold;">${s.speciesId}</span></td>
                                    <td style="font-weight: bold; color: #2d3748;">${s.speciesName}</td>
                                    <td style="color: #718096; max-width: 300px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${s.description}</td>
                                    <td>
                                        <a href="ViewSpecies?id=${s.speciesId}" class="btn-small" title="ดูรายละเอียดและสินค้า">
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