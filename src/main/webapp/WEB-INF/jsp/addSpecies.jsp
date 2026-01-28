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
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
    <jsp:include page="loading.jsp" />

    <div class="admin-wrapper">
        <jsp:include page="adminNavbar.jsp" />
        <div class="content">
            <nav class="top-navbar">
                <div class="navbar-title">จัดการสายพันธุ์สินค้า (Species)</div>
                <div class="admin-profile">
                    <img src="${pageContext.request.contextPath}/assets/images/icon/admin-avatar.png" onerror="this.src='https://cdn-icons-png.flaticon.com/512/2942/2942813.png'" alt="Admin">
                    <span>Admin</span>
                </div>
            </nav>

            <div class="dashboard-container">
                
                <div class="form-container">
                    <h3><i class="fas fa-plus-circle"></i> เพิ่มสายพันธุ์ใหม่</h3>
                    
                    <form action="saveSpecies" method="post" id="speciesForm">
                        <div class="form-group">
                            <label>ชื่อสายพันธุ์ (Species Name) <span style="color:red;">*</span></label>
                            
                            <input type="text" name="speciesName" id="speciesName"
                                   placeholder="เช่น ปลากัดหม้อ, ปลากัดจีน (2-50 ตัวอักษร)" 
                                   required
                                   minlength="2" 
                                   maxlength="50"
                                   pattern="^[a-zA-Z0-9ก-๙\s\-_()]+$"
                                   title="กรุณากรอกเฉพาะภาษาไทย อังกฤษ ตัวเลข และ - _ ( )"
                                   oninput="sanitizeSpeciesName(this)"
                                   value="<c:out value='${param.speciesName}' />">
                                   
                            <small id="charCount" style="color: #666; font-size: 12px; display: block; margin-top: 5px;">0 / 50</small>
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
                                    <td><c:out value="${s.speciesName}"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>
    </div>

    <script>

        function sanitizeSpeciesName(input) {

                input.value = input.value.replace(/[^a-zA-Z0-9ก-๙\s\-_()]/g, '');
            
            document.getElementById('charCount').innerText = input.value.length + " / 50";
        }

        document.addEventListener("DOMContentLoaded", function() {
            const urlParams = new URLSearchParams(window.location.search);
            const msg = urlParams.get('msg');
            const error = urlParams.get('error');

            if (msg === 'success') {
                Swal.fire({
                    icon: 'success',
                    title: 'บันทึกสำเร็จ!',
                    text: 'เพิ่มสายพันธุ์ใหม่เรียบร้อยแล้ว',
                    confirmButtonColor: '#28a745',
                    timer: 2000
                }).then(() => {

                    window.history.replaceState({}, document.title, window.location.pathname);
                });
            }

            if (error) {
                let title = "บันทึกไม่สำเร็จ";
                let text = "เกิดข้อผิดพลาด กรุณาลองใหม่";

                if (error === 'empty') text = "กรุณากรอกชื่อสายพันธุ์";
                else if (error === 'length') text = "ชื่อสายพันธุ์ต้องมีความยาว 2 - 50 ตัวอักษร";
                else if (error === 'invalidChar') text = "ชื่อสายพันธุ์มีอักขระที่ไม่ได้รับอนุญาต";
                else if (error === 'duplicate') text = "ชื่อสายพันธุ์นี้มีอยู่ในระบบแล้ว";
                else if (error === 'db') text = "ไม่สามารถบันทึกลงฐานข้อมูลได้";

                Swal.fire({
                    icon: 'error',
                    title: title,
                    text: text,
                    confirmButtonColor: '#d33',
                    confirmButtonText: 'แก้ไข'
                });
            }
        });
    </script>
</body>
</html>