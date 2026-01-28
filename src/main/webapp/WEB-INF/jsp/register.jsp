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

    <nav class="navbar">
        <div class="nav-container">
            <a href="Home" class="brand-logo">
                <img src="${pageContext.request.contextPath}/assets/images/icon/fishTesting.png" alt="Logo">
                <span>Fish Online</span>
            </a>
            
            <form action="SearchProducts" method="POST" class="search-wrapper">
                <input type="text" name="searchtext" placeholder="ค้นหาปลาที่คุณชอบ...">
                <button type="submit"><i class="fas fa-search"></i></button>
            </form>

            <div class="nav-links">
                <a href="Home"><i class="fas fa-home"></i> หน้าแรก</a>
                <a href="AllProduct"><i class="fas fa-fish"></i> สินค้าทั้งหมด</a>
                
                <c:if test="${not empty sessionScope.user}">
                    <a href="Cart" class="cart-link" title="ตะกร้าสินค้า">
                        <i class="fas fa-shopping-cart"></i>
                    </a>

                    <div class="dropdown">
                        <a href="Profile" class="dropbtn user-profile">
                            <img src="${pageContext.request.contextPath}/profile-uploads/user/${sessionScope.user.memberImg}" class="nav-avatar">
                            สวัสดี, ${sessionScope.user.memberName}
                            <i class="fas fa-chevron-down" style="font-size: 10px;"></i>
                        </a>
                        <div class="dropdown-content">
                            <a href="editProfile"><i class="fas fa-user-edit"></i> แก้ไขโปรไฟล์</a>
                            <a href="Favorites"><i class="fas fa-heart"></i> รายการโปรด</a> 
                            <a href="Orders"><i class="fas fa-box-open"></i> คำสั่งซื้อ</a>
                            <a href="History"><i class="fas fa-history"></i> ประวัติการสั่งซื้อ</a>
                            <div style="border-top: 1px solid #eee; margin: 5px 0;"></div>
                            <a href="Logout" class="menu-logout"><i class="fas fa-sign-out-alt"></i> ออกจากระบบ</a>
                        </div>
                    </div>
                </c:if>
                
                <c:if test="${empty sessionScope.user}">
                    <a href="Login" class="btn-login"><i class="fas fa-user"></i> เข้าสู่ระบบ</a>
                </c:if>
            </div>
        </div>
    </nav>

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
                        <input type="text" id="memberName" name="name" placeholder="ชื่อเล่น หรือ นามแฝง" required 
                               value="<c:out value='${not empty name ? name : param.name}' />">                    
                    </div>
                    <div class="form-group">
                        <label for="phone"><i class="fas fa-phone"></i> เบอร์โทรศัพท์</label>
                        <input type="tel" id="phone" name="tel" placeholder="เบอร์โทรศัพท์" required maxlength="10" 
                               value="<c:out value='${not empty tel ? tel : param.tel}' />"
                               oninput="this.value=this.value.replace(/[^0-9]/g,'');">
                    </div>
                </div>

                <div class="form-group">
                    <label for="email"><i class="fas fa-envelope"></i> อีเมล</label>
                    <input type="email" id="email" name="email" placeholder="example@email.com" required 
                           value="<c:out value='${not empty email ? email : param.email}' />">
                </div>
                
                <div class="form-group">
                    <label for="password"><i class="fas fa-lock"></i> รหัสผ่าน</label>
                    <div class="password-container">
                        <input type="password" id="password" name="password" placeholder="กำหนดรหัสผ่านของคุณ" required>
                        <i class="fas fa-eye toggle-icon" onclick="togglePassword('password', this)"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-lock"></i>ยืนยันรหัสผ่าน</label>
                    <div class="password-container">
                        <input type="password" name="confirmPassword" id="confirmPassword" required placeholder="กรอกรหัสผ่านอีกครั้ง">
                        <i class="fas fa-eye toggle-icon" onclick="togglePassword('confirmPassword', this)"></i>
                    </div>
                </div>

                <div class="form-group file-group">
                    <label for="profileImg"><i class="fas fa-camera"></i> รูปโปรไฟล์</label>
                    <div class="file-input-wrapper">
                        <input type="file" id="profileImg" name="profileImg" accept="image/*" required>
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
        
        var serverError = "${error}"; 

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

</body>
</html>