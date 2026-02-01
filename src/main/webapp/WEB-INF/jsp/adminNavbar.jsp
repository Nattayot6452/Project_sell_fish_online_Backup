<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="currentUri" value="${pageContext.request.requestURI}" />

<nav class="sidebar">
    <div class="sidebar-header">
        <img src="${pageContext.request.contextPath}/assets/images/icon/icon_fishshop.png" alt="Logo">
        <!-- <h3>Admin Panel</h3> -->
    </div>
    
    <ul class="list-unstyled components">
        <li class="${currentUri.contains('AdminCenter') ? 'active' : ''}">
            <a href="AdminCenter"><i class="fas fa-chart-line"></i> ภาพรวมระบบ</a>
        </li>

        <li class="${currentUri.contains('ManageUsers') ? 'active' : ''}">
            <a href="ManageUsers"><i class="fas fa-users"></i> จัดการสมาชิก</a>
        </li>

        <li class="${currentUri.contains('AdminOrders') ? 'active' : ''}">
            <a href="AdminOrders"><i class="fas fa-clipboard-list"></i> รายการคำสั่งซื้อ</a>
        </li>
        
        <li class="${currentUri.contains('AddSpecies') ? 'active' : ''}">
            <a href="AddSpecies"><i class="fas fa-plus-circle"></i> เพิ่มสายพันธุ์ปลา</a>
        </li>
        
        <li class="${currentUri.contains('ManageSpecies') ? 'active' : ''}">
            <a href="ManageSpecies"><i class="fas fa-dna"></i> จัดการสายพันธุ์</a>
        </li>

        <li class="${currentUri.contains('AdminAllProducts') ? 'active' : ''}">
            <a href="AdminAllProducts"><i class="fas fa-boxes"></i> ตรวจสอบสินค้า</a>
        </li>
    </ul>

    <div class="sidebar-footer">
        <a href="Logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> ออกจากระบบ</a>
    </div>
</nav>