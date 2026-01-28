<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>สร้างคูปองใหม่</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/createCoupon.css">
</head>

<body style="background: #f4f6f9;">

    <div class="form-container">
        <h2 style="text-align: center; color: #333; margin-bottom: 30px;">🎫 สร้างคูปองส่วนลดใหม่</h2>
        
        <% if(request.getParameter("error") != null) { %>
            <div style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin-bottom: 20px; text-align: center;">
                ⚠️ 
                <% if(request.getParameter("error").equals("duplicate")) { %>
                    รหัสคูปองนี้มีอยู่แล้ว โปรดใช้ชื่ออื่น
                <% } else if(request.getParameter("error").equals("date_invalid")) { %>
                    วันหมดอายุต้องมาหลังวันเริ่มเสมอ
                <% } else { %>
                    เกิดข้อผิดพลาดในการบันทึก
                <% } %>
            </div>
        <% } %>

        <form action="saveCoupon" method="post">
            
            <div class="form-group">
                <label>รหัสคูปอง (Code) *</label>
               <input type="text"
                    name="couponCode"
                    placeholder="เช่น SUMMER2025"
                    pattern="[A-Z0-9]+"
                    title="กรอกได้เฉพาะภาษาอังกฤษตัวพิมพ์ใหญ่และตัวเลข"
                    style="text-transform: uppercase; letter-spacing: 2px; font-weight: bold;"
                    value="${param.couponCode}">
                <small style="color: grey;">เฉพาะภาษาอังกฤษตัวพิมพ์ใหญ่และตัวเลขเท่านั้น</small>
            </div>

            <div style="display: flex; gap: 20px;">
                <div class="form-group" style="flex: 1;">
                    <label>ประเภทส่วนลด</label>
                    <select name="discountType">
                        <option value="FIXED">ลดเป็นบาท (฿)</option>
                        <option value="PERCENT">ลดเป็นเปอร์เซ็นต์ (%)</option>
                    </select>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>มูลค่าส่วนลด</label>
                    <input type="number" name="discountValue" required min="1" step="0.01" placeholder="0.00">
                </div>
            </div>

            <div class="form-group">
                <label>ยอดสั่งซื้อขั้นต่ำ (บาท)</label>
                <input type="number" name="minOrder" required min="0" value="0" step="0.01">
                <small style="color: grey;">ลูกค้าต้องซึ้อครบยอดนี้ถึงจะใช้โค้ดได้ (ใส่ 0 หากไม่มีขั้นต่ำ)</small>
            </div>

            <div style="display: flex; gap: 20px;">
                <div class="form-group" style="flex: 1;">
                    <label>วันเริ่มต้นใช้งาน</label>
                    <input type="date" name="startDate" required>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>วันหมดอายุ</label>
                    <input type="date" name="expireDate" required>
                </div>
            </div>

            <div class="form-group">
                <label>จำนวนจำกัด (Quota)</label>
                <input type="number" name="usageLimit" required min="1" value="100">
                <small style="color: grey;">จำนวนครั้งที่คูปองนี้สามารถใช้ได้ทั้งหมด</small>
            </div>

            <div style="display: flex; gap: 10px; margin-top: 30px;">
                <a href="ManageCoupons" style="flex: 1; padding: 14px; text-align: center; background: #6c757d; color: white; text-decoration: none; border-radius: 6px;">ยกเลิก</a>
                <button type="submit" class="btn-submit" style="flex: 2;">ยืนยันสร้างคูปอง</button>
            </div>

        </form>
    </div>

</body>
</html>