<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>แก้ไขคูปอง</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/createCoupon.css">
</head>
<body style="background: #f4f6f9;">

    <div class="form-container">
        <h2 style="text-align: center; color: #333; margin-bottom: 30px;">✏️ แก้ไขคูปอง: ${coupon.couponCode}</h2>
        
        <% if(request.getParameter("error") != null) { %>
            <div style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin-bottom: 20px; text-align: center;">
                ⚠️ เกิดข้อผิดพลาดในการบันทึก (ตรวจสอบวันที่ให้ถูกต้อง)
            </div>
        <% } %>

        <form action="updateCoupon" method="post">
            
            <div class="form-group">
                <label>รหัสคูปอง (Code)</label>
                <input type="text" name="couponCode" value="${coupon.couponCode}" readonly 
                       style="background-color: #e9ecef; cursor: not-allowed; font-weight: bold; color: #555;">
                <small>รหัสคูปองไม่สามารถแก้ไขได้</small>
            </div>

            <div style="display: flex; gap: 20px;">
                <div class="form-group" style="flex: 1;">
                    <label>ประเภทส่วนลด</label>
                    <select name="discountType">
                        <option value="FIXED" ${coupon.discountType == 'FIXED' ? 'selected' : ''}>ลดเป็นบาท (฿)</option>
                        <option value="PERCENT" ${coupon.discountType == 'PERCENT' ? 'selected' : ''}>ลดเป็นเปอร์เซ็นต์ (%)</option>
                    </select>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>มูลค่าส่วนลด</label>
                    <input type="number" name="discountValue" value="${coupon.discountValue}" required min="1" step="0.01">
                </div>
            </div>

            <div class="form-group">
                <label>ยอดสั่งซื้อขั้นต่ำ (บาท)</label>
                <input type="number" name="minOrder" value="${coupon.minOrderAmount}" required min="0" step="0.01">
            </div>

            <fmt:formatDate value="${coupon.startDate}" pattern="yyyy-MM-dd" var="startFmt"/>
            <fmt:formatDate value="${coupon.expireDate}" pattern="yyyy-MM-dd" var="expireFmt"/>

            <div style="display: flex; gap: 20px;">
                <div class="form-group" style="flex: 1;">
                    <label>วันเริ่มต้นใช้งาน</label>
                    <input type="date" name="startDate" value="${startFmt}" required>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>วันหมดอายุ</label>
                    <input type="date" name="expireDate" value="${expireFmt}" required>
                </div>
            </div>

            <div style="display: flex; gap: 20px;">
                <div class="form-group" style="flex: 1;">
                    <label>จำนวนจำกัด (Quota)</label>
                    <input type="number" name="usageLimit" value="${coupon.usageLimit}" required min="1">
                    <small>ใช้ไปแล้ว: ${coupon.usageCount} ครั้ง</small>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>สถานะ</label>
                    <select name="status">
                        <option value="ACTIVE" ${coupon.status == 'ACTIVE' ? 'selected' : ''}>✅ ใช้งานได้ปกติ</option>
                        <option value="INACTIVE" ${coupon.status == 'INACTIVE' ? 'selected' : ''}>⛔ ปิดการใช้งาน</option>
                    </select>
                </div>
            </div>

            <div style="display: flex; gap: 10px; margin-top: 30px;">
                <a href="ManageCoupons" style="flex: 1; padding: 14px; text-align: center; background: #6c757d; color: white; text-decoration: none; border-radius: 6px;">ยกเลิก</a>
                <button type="submit" class="btn-submit" style="flex: 2; background-color: #ffc107; color: #333;">บันทึกการแก้ไข</button>
            </div>

        </form>
    </div>

</body>
</html>