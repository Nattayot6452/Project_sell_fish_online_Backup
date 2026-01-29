<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>แก้ไขสายพันธุ์ | Admin</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        .form-container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); max-width: 600px; margin: 0 auto; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 8px; color: #333; }
        .form-group input, .form-group textarea { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; font-size: 14px; }
        .btn-submit { background: #ffc107; color: #333; border: none; padding: 12px 25px; border-radius: 5px; cursor: pointer; font-weight: bold; width: 100%; font-size: 16px; }
        .btn-submit:hover { background: #e0a800; }
        .char-count { font-size: 12px; color: #666; display: block; text-align: right; margin-top: 5px; }
    </style>
</head>
<body>
    <jsp:include page="loading.jsp" />

    <div class="admin-wrapper">
        <jsp:include page="adminNavbar.jsp" />
        <div class="content">
            <nav class="top-navbar">
                <div class="navbar-title">แก้ไขข้อมูลสายพันธุ์</div>
                <div class="admin-profile">
                    <img src="${pageContext.request.contextPath}/assets/images/icon/admin-avatar.png" onerror="this.src='https://cdn-icons-png.flaticon.com/512/2942/2942813.png'" alt="Admin">
                    <span>Admin</span>
                </div>
            </nav>

            <div class="dashboard-container">
                <div class="form-container">
                    <div style="margin-bottom: 20px; text-align: center;">
                        <h2 style="margin: 0; color: #333;">แก้ไขข้อมูล</h2>
                        <p style="color: #666;">รหัสสายพันธุ์: <strong>${species.speciesId}</strong></p>
                    </div>

                    <form action="updateSpecies" method="post" id="editForm">
                        <input type="hidden" name="speciesId" value="${species.speciesId}">

                        <div class="form-group">
                            <label>ชื่อสายพันธุ์ (Species Name) <span style="color:red">*</span></label>
                            <input type="text" name="speciesName" id="speciesName"
                                   value="<c:out value='${species.speciesName}' />" 
                                   required
                                   minlength="2" maxlength="50"
                                   pattern="^[a-zA-Z0-9ก-๙\s\-_()]+$"
                                   title="กรอกได้เฉพาะ ไทย, อังกฤษ, ตัวเลข และ - _ ( )"
                                   oninput="sanitizeName(this)">
                            <small class="char-count" id="nameCount">0 / 50</small>
                        </div>

                        <div class="form-group">
                            <label>คำอธิบาย (Description) <span style="color:red">*</span></label>
                            <textarea name="description" id="description" rows="5" 
                                      required
                                      minlength="10" maxlength="255"
                                      placeholder="อธิบายรายละเอียดสายพันธุ์ (ขั้นต่ำ 10 ตัวอักษร)"
                                      oninput="sanitizeDesc(this)"><c:out value="${species.description}" /></textarea>
                            <small class="char-count" id="descCount">0 / 255</small>
                        </div>

                        <div style="display: flex; gap: 10px;">
                            <a href="ViewSpecies?id=${species.speciesId}" style="flex: 1; text-align: center; padding: 12px; background: #ddd; color: #333; text-decoration: none; border-radius: 5px; font-weight: bold;">ยกเลิก</a>
                            <button type="submit" class="btn-submit" style="flex: 2;">บันทึกการแก้ไข</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>

        function sanitizeName(input) {

            input.value = input.value.replace(/[^a-zA-Z0-9ก-๙\s\-_()]/g, '');
            updateCount(input, 'nameCount', 50);
        }

        function sanitizeDesc(input) {

            input.value = input.value.replace(/<[^>]*>?/gm, '');
            updateCount(input, 'descCount', 255);
        }

        function updateCount(input, counterId, max) {
            const current = input.value.length;
            const counter = document.getElementById(counterId);
            counter.innerText = current + " / " + max;
            
            if (current < (input.getAttribute('minlength') || 0)) {
                counter.style.color = "red";
            } else {
                counter.style.color = "#28a745";
            }
        }

        document.addEventListener("DOMContentLoaded", function() {
            updateCount(document.getElementById('speciesName'), 'nameCount', 50);
            updateCount(document.getElementById('description'), 'descCount', 255);

            const urlParams = new URLSearchParams(window.location.search);
            const error = urlParams.get('error');

            if (error) {
                let title = "บันทึกไม่สำเร็จ";
                let text = "เกิดข้อผิดพลาด กรุณาลองใหม่";

                if (error === 'empty') text = "กรุณากรอกข้อมูลให้ครบถ้วน";
                else if (error === 'nameLength') text = "ชื่อสายพันธุ์ต้องยาว 2-50 ตัวอักษร";
                else if (error === 'descLength') text = "คำอธิบายต้องยาว 10-255 ตัวอักษร";
                else if (error === 'invalidChar') text = "ชื่อสายพันธุ์มีอักขระที่ไม่ได้รับอนุญาต";
                else if (error === 'failed') text = "ไม่สามารถอัปเดตข้อมูลลงฐานข้อมูลได้";
                else if (error === 'duplicate') text = "ชื่อสายพันธุ์นี้มีอยู่ในระบบแล้ว (ซ้ำ)"; 

                Swal.fire({
                    icon: 'error',
                    title: title,
                    text: text,
                    confirmButtonText: 'แก้ไข'
                });
            }
        });
    </script>
</body>
</html>