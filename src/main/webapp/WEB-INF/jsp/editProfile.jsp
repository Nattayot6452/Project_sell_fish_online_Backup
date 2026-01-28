<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>แก้ไขข้อมูลส่วนตัว | Fish Online</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/editProfile.css">
    <link rel="stylesheet" type="text/css" href="assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <script>
        function sanitizeInput(input) {
            input.value = input.value.replace(/[<>"']/g, '');
        }
    </script>
</head>
<body>
    
   <jsp:include page="navbar.jsp" />
    
    <div class="container main-container">
        <div class="edit-card">
            
            <div class="card-header">
                <h1><i class="fas fa-user-edit"></i> แก้ไขข้อมูลส่วนตัว</h1>
                <p>อัปเดตข้อมูลของคุณให้เป็นปัจจุบัน</p>
            </div>

            <div class="card-body">
                <div class="current-img-wrapper">
                    <img src="${pageContext.request.contextPath}/displayImage?name=user/${sessionScope.user.memberImg}" 
                         alt="Profile Image" class="profile-img-preview" id="previewImg">
                    <div class="edit-icon-overlay"><i class="fas fa-camera"></i></div>
                </div>

                <form action="updateProfile" method="post" enctype="multipart/form-data" class="edit-form" id="editForm">
                    <input type="hidden" name="memberId" value="${sessionScope.user.memberId}">

                    <div class="form-group">
                        <label for="memberName">ชื่อผู้ใช้งาน</label>
                        <div class="input-with-icon">
                            <i class="fas fa-user"></i>
                            <input type="text" id="memberName" name="memberName" 
                                   value="<c:out value='${sessionScope.user.memberName}' />" 
                                   required
                                   minlength="4" maxlength="50"
                                   pattern="^(?!\s*$)[a-zA-Z0-9ก-๙\s]+$"
                                   title="กรุณากรอกชื่อ 4-50 ตัวอักษร (ไทย/อังกฤษ/ตัวเลข)"
                                   oninput="sanitizeInput(this)">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="email">อีเมล</label>
                        <div class="input-with-icon">
                            <i class="fas fa-envelope"></i>
                            <input type="email" id="email" name="email" 
                                   value="<c:out value='${sessionScope.user.email}' />" 
                                   required
                                   pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"
                                   oninput="sanitizeInput(this)">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">เบอร์โทรศัพท์</label>
                        <div class="input-with-icon">
                            <i class="fas fa-phone"></i>
                            <input type="tel" id="phone" name="phone" 
                                   value="<c:out value='${sessionScope.user.phone}' />" 
                                   required
                                   maxlength="10" 
                                   pattern="^0[689][0-9]{8}$"
                                   title="เบอร์โทรศัพท์ต้องขึ้นต้นด้วย 06, 08, 09 และมี 10 หลัก"
                                   oninput="this.value=this.value.replace(/[^0-9]/g,'');">
                        </div>
                    </div>

                    <div class="form-group file-group">
                        <label for="profileImg">เปลี่ยนรูปโปรไฟล์</label>
                        <input type="file" id="profileImg" name="profileImg" accept="image/*" class="file-input" onchange="previewFile()">
                        <small class="file-hint">รองรับไฟล์ JPG, PNG (อัปโหลดเฉพาะเมื่อต้องการเปลี่ยน)</small>
                    </div>
                    
                    <div class="btn-group">
                        <button type="submit" class="save-btn">
                            <i class="fas fa-save"></i> บันทึก
                        </button>
                        <a href="Profile" class="cancel-link">ยกเลิก</a>
                    </div>
                </form>

            </div>
        </div>	
    </div>
    
    <script>

        function previewFile() {
            const preview = document.getElementById('previewImg');
            const file = document.querySelector('input[type=file]').files[0];
            const reader = new FileReader();

            reader.addEventListener("load", function () {
                preview.src = reader.result;
            }, false);

            if (file) {
                reader.readAsDataURL(file);
            }
        }

        document.addEventListener("DOMContentLoaded", function() {
            var serverError = "${error}";
            if (serverError && serverError.trim() !== "") {
                Swal.fire({
                    icon: 'error',
                    title: 'บันทึกไม่สำเร็จ',
                    text: serverError,
                    confirmButtonColor: '#d33',
                    confirmButtonText: 'แก้ไข'
                });
            }
        });
    </script>
    
 </body>
 </html>