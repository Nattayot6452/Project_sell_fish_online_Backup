<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>แก้ไขคูปอง</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/createCoupon.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body style="background: #f4f6f9;">

    <div class="form-container">
        <h2 style="text-align: center; color: #333; margin-bottom: 30px;">✏️ แก้ไขคูปอง: ${coupon.couponCode}</h2>
        
        <form action="updateCoupon" method="post" id="editForm">
            
            <div class="form-group">
                <label>รหัสคูปอง (Code)</label>
                <input type="text" name="couponCode" value="<c:out value='${coupon.couponCode}' />" readonly 
                       style="background-color: #e9ecef; cursor: not-allowed; font-weight: bold; color: #555; letter-spacing: 2px;">
                <small style="color: #888;">* รหัสคูปองไม่สามารถแก้ไขได้</small>
            </div>

            <div style="display: flex; gap: 20px;">
                <div class="form-group" style="flex: 1;">
                    <label>ประเภทส่วนลด</label>
                    <select name="discountType" id="discountType" onchange="checkPercentLimit()">
                        <option value="FIXED" ${coupon.discountType == 'FIXED' ? 'selected' : ''}>ลดเป็นบาท (฿)</option>
                        <option value="PERCENT" ${coupon.discountType == 'PERCENT' ? 'selected' : ''}>ลดเป็นเปอร์เซ็นต์ (%)</option>
                    </select>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>มูลค่าส่วนลด</label>
                    <input type="number" id="discountValue" name="discountValue" value="${coupon.discountValue}" required min="1" step="0.01" oninput="checkPercentLimit()">
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
                    <input type="date" name="startDate" id="startDate" value="${startFmt}" required onchange="validateDates()">
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>วันหมดอายุ</label>
                    <input type="date" name="expireDate" id="expireDate" value="${expireFmt}" required onchange="validateDates()">
                </div>
            </div>

            <div style="display: flex; gap: 20px;">
                <div class="form-group" style="flex: 1;">
                    <label>จำนวนจำกัด (Quota)</label>
                    <input type="number" name="usageLimit" value="${coupon.usageLimit}" required min="1">
                    <small style="color: #666;">ใช้ไปแล้ว: ${coupon.usageCount} ครั้ง</small>
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
                <button type="submit" class="btn-submit" style="flex: 2; background-color: #ffc107; color: #333; border: none; padding: 14px; border-radius: 6px; cursor: pointer; font-weight: bold;">บันทึกการแก้ไข</button>
            </div>

        </form>
    </div>

    <script>

        function validateDates() {
            const start = document.getElementById('startDate').value;
            const expire = document.getElementById('expireDate').value;
            
            if (start && expire) {
                if (expire < start) {
                    Swal.fire('วันที่ไม่ถูกต้อง', 'วันหมดอายุต้องอยู่หลังวันเริ่มต้น', 'warning');
                    document.getElementById('expireDate').value = ""; 
                }
            }
        }

        function checkPercentLimit() {
            const type = document.getElementById('discountType').value;
            const valueInput = document.getElementById('discountValue');
            const val = parseFloat(valueInput.value);

            if (type === 'PERCENT' && val > 100) {
                Swal.fire('ข้อมูลไม่ถูกต้อง', 'ส่วนลดเปอร์เซ็นต์ต้องไม่เกิน 100%', 'warning');
                valueInput.value = 100;
            }
        }

        document.addEventListener("DOMContentLoaded", function() {
            const urlParams = new URLSearchParams(window.location.search);
            const error = urlParams.get('error');

            if (error) {
                let text = "เกิดข้อผิดพลาดในการบันทึก";
                if (error === 'date_invalid') text = "วันหมดอายุไม่ถูกต้อง";
                else if (error === 'invalidValue') text = "มูลค่าส่วนลดต้องมากกว่า 0";
                else if (error === 'invalidPercent') text = "ส่วนลดเปอร์เซ็นต์ต้องไม่เกิน 100%";
                else if (error === 'invalidNumber') text = "ยอดขั้นต่ำหรือจำนวนโควต้าไม่ถูกต้อง";
                else if (error === 'failed') text = "ไม่สามารถอัปเดตข้อมูลได้";

                Swal.fire({
                    icon: 'error',
                    title: 'บันทึกไม่สำเร็จ',
                    text: text,
                    confirmButtonText: 'แก้ไข'
                });
            }
        });
    </script>

</body>
</html>