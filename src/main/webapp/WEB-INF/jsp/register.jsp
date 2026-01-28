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

            <c:if test="${not empty add_result}">
                <div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-bottom: 15px; text-align: center;">
                    ${add_result}
                </div>
            </c:if>

            <form action="saveRegister" method="post" enctype="multipart/form-data">
                
                <div class="form-grid">
                    <div class="form-group">
                        <label for="memberName"><i class="fas fa-user"></i> ชื่อผู้ใช้งาน</label>
                        <input type="text" id="memberName" name="name" placeholder="ชื่อเล่น หรือ นามแฝง" required value="<c:out value='${param.name}' />">                    
                    </div>
                    <div class="form-group">
                        <label for="phone"><i class="fas fa-phone"></i> เบอร์โทรศัพท์</label>

                        <input type="tel" id="phone" name="tel" placeholder="เบอร์โทรศัพท์" required maxlength="10" value="<c:out value='${param.tel}' />">
                               oninput="this.value=this.value.replace(/[^0-9]/g,'');">
                    </div>
                </div>

                <div class="form-group">
                    <label for="email"><i class="fas fa-envelope"></i> อีเมล</label>
                    <input type="email" id="email" name="email" placeholder="example@email.com" required value="<c:out value='${param.email}' />">
                </div>
                
                <div class="form-group">
                    <label for="password"><i class="fas fa-lock"></i> รหัสผ่าน</label>
                    <input type="password" id="password" name="password" placeholder="กำหนดรหัสผ่านของคุณ" required>
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

</body>
</html>