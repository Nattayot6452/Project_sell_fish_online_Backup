<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>เข้าสู่ระบบ | Fish Online</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/login.css">
    <link rel="stylesheet" type="text/css" href="assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
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

    <script>
        function setRole(role, btn) {
            document.getElementById("role").value = role;
            
            const buttons = document.querySelectorAll(".role-btn");
            buttons.forEach(b => b.classList.remove("active"));
            btn.classList.add("active");
            
            const welcomeText = document.getElementById("welcome-text");
            if(role === 'staff') {
                welcomeText.innerText = "เข้าสู่ระบบสำหรับเจ้าหน้าที่";
            } else {
                welcomeText.innerText = "ยินดีต้อนรับสมาชิก";
            }
        }
    </script>
</head>
<body>
    <jsp:include page="/WEB-INF/jsp/navbar.jsp" />
    <div class="main-container">
        <div class="login-card">
            <div class="login-header">
                <img src="${pageContext.request.contextPath}/assets/images/icon/icon_fishshop.png" alt="Logo">
                <h2 id="welcome-text">ยินดีต้อนรับสมาชิก</h2>
                <p>กรุณาเข้าสู่ระบบเพื่อดำเนินการต่อ</p>
            </div>

            <div class="role-selector">
                <button type="button" class="role-btn active" onclick="setRole('user', this)">
                    <i class="fas fa-user"></i> สมาชิกทั่วไป
                </button>
                <button type="button" class="role-btn" onclick="setRole('staff', this)">
                    <i class="fas fa-user-shield"></i> เจ้าหน้าที่
                </button>
            </div>

            <form action="login" method="post" class="login-form">
                <input type="hidden" id="role" name="role" value="user">

                <div class="form-group">
                    <label for="email"><i class="fas fa-envelope"></i> อีเมล</label>
                    <div class="input-wrapper">
                    <input type="email" id="email" name="email" 
                        placeholder="example@email.com" 
                        required 
                        pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"
                        title="กรุณากรอกรูปแบบอีเมลให้ถูกต้อง"
                        value="<c:out value='${param.email}' />"
                        oninput="sanitizeEmail(this)"> 
                    </div>
                </div>

                <div class="form-group">
                    <label for="password"><i class="fas fa-lock"></i> รหัสผ่าน</label>
                    <div class="input-wrapper password-container">
                        <input type="password" id="password" name="password" placeholder="กรอกรหัสผ่านของคุณ" required>
                        <i class="fas fa-eye toggle-icon" onclick="togglePassword('password', this)"></i>
                    </div>
                </div>

                <button type="submit" class="btn-submit">เข้าสู่ระบบ <i class="fas fa-sign-in-alt"></i></button>
            </form>

            <c:if test="${not empty error}">
                <div class="error-msg">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>

            <div class="login-footer">
                <p>ยังไม่มีบัญชีใช่ไหม? <a href="Register">สมัครสมาชิกที่นี่</a></p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const urlParams = new URLSearchParams(window.location.search);
            const msg = urlParams.get('msg');

            const serverError = "${error}";
            if (serverError && serverError.trim() !== "") {
                Swal.fire({
                    icon: 'error',
                    title: 'เข้าสู่ระบบไม่สำเร็จ',
                    text: serverError,
                    confirmButtonColor: '#d33',
                    confirmButtonText: 'ลองใหม่'
                });
            }

            if (msg === 'register_success') {
                Swal.fire({
                    icon: 'success',
                    title: 'สมัครสมาชิกสำเร็จ!',
                    text: 'กรุณาเข้าสู่ระบบด้วยบัญชีใหม่ของคุณ',
                    confirmButtonColor: '#3182ce',
                    confirmButtonText: 'ตกลง'
                }).then(() => {
                    window.history.replaceState({}, document.title, window.location.pathname);
                });
            }
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
    function sanitizeEmail(input) {
        input.value = input.value.replace(/[<>"']/g, '');
    }

</script>

</body>
</html>