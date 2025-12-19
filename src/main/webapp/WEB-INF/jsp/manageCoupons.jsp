<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>จัดการคูปองส่วนลด | Seller Center</title>
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/seller.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        /* สไตล์สำหรับปุ่ม Edit/Delete เฉพาะหน้านี้ */
        .action-btn {
            display: inline-flex; justify-content: center; align-items: center;
            width: 32px; height: 32px; border-radius: 50%;
            color: white; text-decoration: none; font-size: 14px;
            transition: 0.2s; margin-right: 5px;
            border: none; cursor: pointer;
        }
        .btn-edit { background-color: #ffc107; color: #333; }
        .btn-edit:hover { background-color: #e0a800; transform: scale(1.1); }
        
        .btn-delete { background-color: #dc3545; color: white; }
        .btn-delete:hover { background-color: #c82333; transform: scale(1.1); }
    </style>
</head>
<body style="margin: 0; font-family: sans-serif;">

    <div style="display: flex; min-height: 100vh;">
        
        <nav class="sidebar" style="width: 250px; background: #343a40; min-height: 100vh; color: white; padding: 20px; flex-shrink: 0;">
            <h3 style="text-align: center; margin-bottom: 30px; border-bottom: 1px solid #4b545c; padding-bottom: 15px;">
                Seller Center
            </h3>
            <ul style="list-style: none; padding: 0;">
                <li style="margin-bottom: 15px;">
                    <a href="SellerCenter" style="color: #adb5bd; text-decoration: none; display: block; padding: 10px; border-radius: 5px;">
                        <i class="fas fa-home"></i> หน้าหลัก
                    </a>
                </li>
                <li style="margin-bottom: 15px;">
                    <a href="ManageCoupons" style="color: white; background: #007bff; font-weight: bold; text-decoration: none; display: block; padding: 10px; border-radius: 5px;">
                        <i class="fas fa-tags"></i> จัดการคูปอง
                    </a>
                </li>
            </ul>
        </nav>

        <div class="content" style="flex: 1; padding: 30px; background: #f4f6f9;">
            
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h2 style="color: #333;"><i class="fas fa-ticket-alt"></i> รายการคูปองส่วนลด</h2>
                <a href="CreateCoupon" class="btn-submit" style="background: #28a745; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                    + สร้างคูปองใหม่
                </a>
            </div>

            <c:if test="${param.msg == 'created'}">
                <div style="background: #d4edda; color: #155724; padding: 15px; border-radius: 5px; margin-bottom: 20px; border: 1px solid #c3e6cb;">
                    <i class="fas fa-check-circle"></i> สร้างคูปองสำเร็จพร้อมใช้งาน!
                </div>
            </c:if>
            <c:if test="${param.msg == 'deleted'}">
                <div style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin-bottom: 20px; border: 1px solid #f5c6cb;">
                    <i class="fas fa-trash-alt"></i> ลบคูปองเรียบร้อยแล้ว
                </div>
            </c:if>

            <table class="seller-table">
                <thead>
                    <tr>
                        <th>รหัสคูปอง</th>
                        <th>ส่วนลด</th>
                        <th>ขั้นต่ำ</th>
                        <th>ระยะเวลา</th>
                        <th>สิทธิ์การใช้</th>
                        <th>สถานะ</th>
                        <th style="width: 100px; text-align: center;">จัดการ</th> </tr>
                </thead>
                <tbody>
                    <c:forEach items="${coupons}" var="c">
                        <c:set var="percentUsed" value="${c.usageLimit > 0 ? (c.usageCount * 100) / c.usageLimit : 0}" />

                        <tr>
                            <td><span class="badge-code">${c.couponCode}</span></td>
                            <td>
                                <c:choose>
                                    <c:when test="${c.discountType == 'FIXED'}">
                                        <span style="font-weight:bold; color:#0056b3;">฿${c.discountValue}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="font-weight:bold; color:#e83e8c;">${c.discountValue}%</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${c.minOrderAmount == 0}">ไม่มีขั้นต่ำ</c:if>
                                <c:if test="${c.minOrderAmount > 0}">฿${c.minOrderAmount}</c:if>
                            </td>
                            <td>
                                <small style="color: #666;">
                                    <i class="far fa-calendar-alt"></i> <fmt:formatDate value="${c.startDate}" pattern="dd/MM/yy"/> - 
                                    <fmt:formatDate value="${c.expireDate}" pattern="dd/MM/yy"/>
                                </small>
                            </td>
                            <td>
                                <div style="width: 120px; background: #e9ecef; border-radius: 4px; height: 8px; margin-bottom: 5px; overflow: hidden;">
                                    <div style="background: #17a2b8; height: 100%; width: ${percentUsed}%;"></div>
                                </div>
                                <small style="color: #555;">${c.usageCount} / ${c.usageLimit} สิทธิ์</small>
                            </td>
                            <td>
                                <span class="${c.status == 'ACTIVE' ? 'status-active' : 'status-inactive'}">
                                    ${c.status}
                                </span>
                            </td>
                            
                            <td style="text-align: center;">
                                <a href="EditCoupon?code=${c.couponCode}" class="action-btn btn-edit" title="แก้ไข">
                                    <i class="fas fa-pen"></i>
                                </a>
                                <a href="DeleteCoupon?code=${c.couponCode}" class="action-btn btn-delete" title="ลบ" onclick="return confirm('ยืนยันที่จะลบคูปอง ${c.couponCode} นี้? การกระทำนี้ไม่สามารถย้อนกลับได้');">
                                    <i class="fas fa-trash-alt"></i>
                                </a>
                            </td>
                            
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty coupons}">
                        <tr>
                            <td colspan="7" style="text-align: center; color: #999; padding: 40px; background: white;">
                                <i class="fas fa-box-open" style="font-size: 3em; margin-bottom: 10px; opacity: 0.5;"></i><br>
                                ยังไม่มีคูปองในระบบ กดปุ่ม "สร้างคูปองใหม่" เพื่อเริ่มใช้งาน
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>