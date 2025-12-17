<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>จัดการสายพันธุ์สินค้า | Admin</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/addSpecies.css">
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
                <li class="active"><a href="AddSpecies"><i class="fas fa-dna"></i> เพิ่มสายพันธุ์ปลา</li>
                <li><a href="ManageSpecies"><i class="fas fa-dna"></i> จัดการสายพันธุ์</a>
                <li><a href="AllProduct"><i class="fas fa-boxes"></i> ตรวจสอบสินค้า</a></li>
            </ul>
            <div class="sidebar-footer">
                <a href="Logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> ออกจากระบบ</a>
            </div>
        </nav>

        <div class="content">
            <nav class="top-navbar">
                <div class="navbar-title">จัดการสายพันธุ์สินค้า (Species)</div>
                <div class="admin-profile"><span>Admin</span></div>
            </nav>

            <div class="dashboard-container">
                
                <div class="form-container">
                    <h3><i class="fas fa-plus-circle"></i> เพิ่มสายพันธุ์ใหม่</h3>
                    
                    <c:if test="${param.msg == 'success'}">
                        <div style="background: #c6f6d5; color: #22543d; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
                            <i class="fas fa-check"></i> เพิ่มข้อมูลสำเร็จ!
                        </div>
                    </c:if>

                    <form action="saveSpecies" method="post">
                        <div class="form-group">
                            <label>ชื่อสายพันธุ์ (Species Name)</label>
                            <input type="text" name="speciesName" placeholder="เช่น ปลากัดหม้อ, ปลากัดจีน, Betta Splendens" required>
                        </div>
                        <button type="submit" class="btn-submit">บันทึกข้อมูล</button>
                    </form>
                </div>

                <div class="species-list-container">
                    <h3><i class="fas fa-list"></i> รายการสายพันธุ์ในระบบ (${speciesList.size()})</h3>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th style="width: 30%;">รหัสสายพันธุ์ (ID)</th>
                                <th>ชื่อสายพันธุ์</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${speciesList}" var="s">
                                <tr>
                                    <td><span style="background: #eee; padding: 3px 8px; border-radius: 4px; font-family: monospace;">${s.speciesId}</span></td>
                                    <td>${s.speciesName}</td>
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