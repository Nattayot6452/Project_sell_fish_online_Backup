<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>สร้างคูปองใหม่</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/createCoupon.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body style="background: #f4f6f9;">

    <div class="form-container">
        <h2 style="text-align: center; color: #333; margin-bottom: 30px;">🎫 สร้างคูปองส่วนลดใหม่</h2>
        
        <form action="saveCoupon" method="post" id="couponForm" onsubmit="return validateForm(event)">
            
            <div class="form-group">
                <label>รหัสคูปอง (Code) <span style="color:red">*</span></label>
                <input type="text"
                    id="couponCode"
                    name="couponCode"
                    placeholder="เช่น SUMMER2025"
                    required
                    minlength="3"
                    maxlength="20"
                    style="text-transform: uppercase; letter-spacing: 2px; font-weight: bold; font-family: monospace;"
                    oninput="sanitizeCouponCode(this)">
                <small style="color: #666; font-size: 12px;">* เฉพาะภาษาอังกฤษตัวพิมพ์ใหญ่ (A-Z) และตัวเลข (0-9) เท่านั้น</small>
            </div>

            <div style="display: flex; gap: 20px;">
                <div class="form-group" style="flex: 1;">
                    <label>ประเภทส่วนลด</label>
                    <select name="discountType" id="discountType" onchange="checkPercentLimit()">
                        <option value="FIXED">ลดเป็นบาท (฿)</option>
                        <option value="PERCENT">ลดเป็นเปอร์เซ็นต์ (%)</option>
                    </select>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>มูลค่าส่วนลด</label>
                    <input type="number" id="discountValue" name="discountValue" required min="1" step="0.01" placeholder="0.00" oninput="checkPercentLimit()">
                </div>
            </div>

            <div class="form-group">
                <label>ยอดสั่งซื้อขั้นต่ำ (บาท)</label>
                <input type="number" name="minOrder" required min="0" value="0" step="0.01">
            </div>

            <div style="display: flex; gap: 20px;">
                <div class="form-group" style="flex: 1;">
                    <label>วันเริ่มต้นใช้งาน</label>
                    <input type="date" name="startDate" id="startDate" required onchange="validateDates()">
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>วันหมดอายุ</label>
                    <input type="date" name="expireDate" id="expireDate" required onchange="validateDates()">
                </div>
            </div>

            <div class="form-group">
                <label>จำนวนจำกัด (Quota)</label>
                <input type="number" name="usageLimit" required min="1" value="100">
            </div>

            <div style="display: flex; gap: 10px; margin-top: 30px;">
                <a href="ManageCoupons" style="flex: 1; padding: 14px; text-align: center; background: #6c757d; color: white; text-decoration: none; border-radius: 6px;">ยกเลิก</a>
                <button type="submit" class="btn-submit" style="flex: 2; background-color: #28a745; color: white; border: none; padding: 14px; border-radius: 6px; cursor: pointer; font-weight: bold;">ยืนยันสร้างคูปอง</button>
            </div>

        </form>
    </div>

    <script>

        function sanitizeCouponCode(input) {
            let val = input.value.toUpperCase();

            input.value = val.replace(/[^A-Z0-9]/g, '');
        }

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
                let text = "เกิดข้อผิดพลาด";
                if (error === 'duplicate') text = "รหัสคูปองนี้มีอยู่แล้วในระบบ";
                else if (error === 'date_invalid') text = "วันหมดอายุไม่ถูกต้อง";
                else if (error === 'invalidCode') text = "รหัสคูปองห้ามเว้นว่างหรือมีช่องว่าง";
                else if (error === 'codeLength') text = "รหัสคูปองต้องยาว 3 - 20 ตัวอักษร";
                else if (error === 'invalidChar') text = "รหัสคูปองมีอักขระที่ไม่ได้รับอนุญาต";
                else if (error === 'invalidValue') text = "มูลค่าส่วนลดต้องมากกว่า 0";
                else if (error === 'invalidPercent') text = "ส่วนลดเปอร์เซ็นต์ต้องไม่เกิน 100%";
                
                Swal.fire({
                    icon: 'error',
                    title: 'บันทึกไม่สำเร็จ',
                    text: text,
                    confirmButtonText: 'ตกลง'
                });
            }
        });
    </script>

</body>
</html>