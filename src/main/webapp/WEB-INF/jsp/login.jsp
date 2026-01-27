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
        <div class="login-card">
            <div class="login-header">
                <img src="${pageContext.request.contextPath}/assets/images/icon/fishTesting.png" alt="Logo">
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
                        <input type="text" id="email" name="email" placeholder="ตัวอย่าง: user@email.com" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password"><i class="fas fa-lock"></i> รหัสผ่าน</label>
                    <div class="input-wrapper">
                        <input type="password" id="password" name="password" placeholder="กรอกรหัสผ่านของคุณ" required>
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
</script>
</body>
</html>