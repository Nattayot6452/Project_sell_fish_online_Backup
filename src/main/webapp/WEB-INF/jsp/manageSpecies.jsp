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
    <div class="admin-wrapper">
        <nav class="sidebar">
            <div class="sidebar-header">
                <img src="${pageContext.request.contextPath}/assets/images/icon/fishTesting.png" alt="Logo">
                <h3>Admin Panel</h3>
            </div>
            <ul class="list-unstyled components">
                <li><a href="AdminCenter"><i class="fas fa-chart-line"></i> ภาพรวมระบบ</a></li>
                <li><a href="ManageUsers"><i class="fas fa-users"></i> จัดการสมาชิก</a></li>
                <li><a href="SellerOrders"><i class="fas fa-clipboard-list"></i> รายการคำสั่งซื้อ</a></li>
                 <li><a href="AddSpecies"><i class="fas fa-dna"></i> เพิ่มสายพันธุ์ปลา</li>
                <li class="active"><a href="ManageSpecies"><i class="fas fa-dna"></i> จัดการสายพันธุ์</a></li>
                <li><a href="AllProduct"><i class="fas fa-boxes"></i> ตรวจสอบสินค้า</a></li>
            </ul>
            <div class="sidebar-footer">
                <a href="Logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> ออกจากระบบ</a>
            </div>
        </nav>

        <div class="content">
            <nav class="top-navbar">
                <div class="navbar-title">จัดการข้อมูลสายพันธุ์</div>
                <div class="admin-profile"><span>Admin</span></div>
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