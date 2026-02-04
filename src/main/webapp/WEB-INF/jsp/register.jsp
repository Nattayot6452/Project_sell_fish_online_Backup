<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>สมัครสมาชิก | Fish Online</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/register.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <style>
        .password-container {
            position: relative;
            width: 100%;
        }
        .password-container input {
            width: 100%;
            padding-right: 40px;
            box-sizing: border-box;
        }
        .toggle-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #888;
            z-index: 10;
        }
        .toggle-icon:hover {
            color: #333;
        }
    </style>
</head>
<body>
    <jsp:include page="loading.jsp" />
    <jsp:include page="/WEB-INF/jsp/navbar.jsp" />
    <div class="main-container">
        <div class="register-card">
            <div class="register-header">
                <h2>สมัครสมาชิกใหม่</h2>
                <p>เข้าร่วมครอบครัวคนรักปลาสวยงามกับเรา</p>
            </div>

            <form action="saveRegister" method="post" enctype="multipart/form-data" id="registerForm">
    
                <div class="form-grid">
                    <div class="form-group">
                        <label for="memberName"><i class="fas fa-user"></i> ชื่อผู้ใช้งาน</label>
                        <input type="text" id="memberName" name="name" 
                            placeholder="ชื่อเล่น (ไทย/อังกฤษ/ตัวเลข)" 
                            required 
                            minlength="4" maxlength="50"
                            pattern="^(?!\s*$)[a-zA-Z0-9ก-๙\s]+$"
                            title="กรุณากรอกชื่อ 4-50 ตัวอักษร (ห้ามเป็นช่องว่างล้วน)"
                            value="<c:out value='${not empty name ? name : param.name}' />">                    
                    </div>
                   <div class="form-group">
                        <label for="phone"><i class="fas fa-phone"></i> เบอร์โทรศัพท์</label>
                        <input type="tel" id="phone" name="tel" 
                            placeholder="ตัวอย่าง 0812345678" 
                            required 
                            pattern="^0[689][0-9]{8}$"
                            maxlength="10" 
                            title="กรุณากรอกเบอร์มือถือที่ถูกต้อง (ขึ้นต้นด้วย 06, 08 หรือ 09 และครบ 10 หลัก)"
                            value="<c:out value='${not empty tel ? tel : param.tel}' />"
                            oninput="this.value=this.value.replace(/[^0-9]/g,'');">
                    </div>
                </div>

                <div class="form-group">
                    <label for="email"><i class="fas fa-envelope"></i> อีเมล</label>
                    <input type="email" id="email" name="email" 
                        placeholder="example@email.com" 
                        required 
                        value="<c:out value='${not empty email ? email : param.email}' />">
                </div>
                
                <div class="form-group">
                    <label for="password"><i class="fas fa-lock"></i> รหัสผ่าน</label>
                    <div class="password-container">
                        <input type="password" id="password" name="password" 
                            placeholder="กำหนดรหัสผ่าน (ขั้นต่ำ 8 ตัวอักษร)" 
                            required minlength="8">
                        <i class="fas fa-eye toggle-icon" onclick="togglePassword('password', this)"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-lock"></i>ยืนยันรหัสผ่าน</label>
                    <div class="password-container">
                        <input type="password" name="confirmPassword" id="confirmPassword" 
                            required placeholder="กรอกรหัสผ่านอีกครั้ง" minlength="8">
                        <i class="fas fa-eye toggle-icon" onclick="togglePassword('confirmPassword', this)"></i>
                    </div>
                </div>

               <div class="form-group file-group">
                    <label for="profileImg"><i class="fas fa-camera"></i> รูปโปรไฟล์</label>
                    
                    <div style="text-align: center; margin-bottom: 15px;">
                        <img id="imagePreview" src="${pageContext.request.contextPath}/assets/images/default-avatar.png" 
                             style="width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 3px solid #ddd; display: none;">
                    </div>

                    <div class="file-input-wrapper">
                        <input type="file" id="profileImg" name="profileImg" accept="image/*" required onchange="previewProfileImage(this)">
                        <span class="file-hint">รองรับไฟล์ JPG, PNG</span>
                    </div>
                </div>

                <button type="submit" class="btn-register">ยืนยันการสมัคร <i class="fas fa-user-plus"></i></button>
            </form>

            <div class="register-footer">
                <p>มีบัญชีอยู่แล้ว? <a href="Login">เข้าสู่ระบบที่นี่</a></p>
            </div>
        </div>
    </div>

    <script>
    document.addEventListener("DOMContentLoaded", function() {
        
        var serverError = '<c:out value="${error}" />'; 
        var addResult = '<c:out value="${add_result}" />';

        if (serverError === 'email_duplicate') {
            Swal.fire({
                icon: 'error',
                title: 'ขออภัย',
                text: 'บัญชีนี้มีในระบบอยู่แล้ว กรุณาใช้อีเมลอื่น',
                confirmButtonColor: '#d33',
                confirmButtonText: 'ตกลง'
            });
        } else if (serverError === 'pass_mismatch') {
            Swal.fire({
                icon: 'warning',
                title: 'รหัสผ่านไม่ตรงกัน',
                text: 'กรุณากรอกรหัสผ่านยืนยันให้ถูกต้อง',
                confirmButtonColor: '#f9e547',
                confirmButtonText: 'ลองใหม่',
                color: '#333' 
            });
        }

        else if (addResult !== "") {
           Swal.fire({
                icon: 'error',
                title: 'ข้อมูลไม่ถูกต้อง',
                text: addResult,
                confirmButtonColor: '#d33',
                confirmButtonText: 'แก้ไข'
            });
        }

        const form = document.getElementById("registerForm");
        
        form.addEventListener("submit", function(event) {
            var pass = document.getElementById("password").value;
            var confirmPass = document.getElementById("confirmPassword").value;
            
            if (pass !== confirmPass) {
                event.preventDefault();
                
                Swal.fire({
                    icon: 'warning',
                    title: 'รหัสผ่านไม่ตรงกัน',
                    text: 'กรุณากรอกรหัสผ่านให้ตรงกัน',
                    confirmButtonColor: '#00571d',
                    confirmButtonText: 'ตกลง'
                });
            }
        });
    });

    function togglePassword(inputId, icon) {
        const input = document.getElementById(inputId);
        if (input.type === "password") {
            input.type = "text";
            icon.classList.remove("fa-eye");
            icon.classList.add("fa-eye-slash");
        } else {
            input.type = "password";
            icon.classList.remove("fa-eye-slash");
            icon.classList.add("fa-eye");
        }
    }
    </script>

    <script>
    function previewProfileImage(input) {
        var preview = document.getElementById('imagePreview');
        
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            
            reader.onload = function(e) {
                preview.src = e.target.result;
                preview.style.display = 'inline-block';
            }
            
            reader.readAsDataURL(input.files[0]);
        } else {
            preview.style.display = 'none';
        }
    }
    </script>
</body>
</html>