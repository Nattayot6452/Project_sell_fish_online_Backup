<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <title>หน้าแรก</title>
    
    <script>
    function setRole(role, btn) {
        // ตั้งค่า hidden input
        document.getElementById("role").value = role;

        // รีเซ็ตปุ่มทั้งหมด
        const buttons = btn.parentNode.querySelectorAll("button");
        buttons.forEach(b => {
            b.classList.remove("active");
            b.classList.add("inactive");
        });

        // ทำปุ่มที่เลือกเป็น active
        btn.classList.remove("inactive");
        btn.classList.add("active");
    }
</script>
    
   <style>
    :root {
        --mj-green: #00571d;
        --mj-yellow: #f9e547;
        --mj-white: #fffef9;
    }

    body {
        margin: 0;
        font-family: "Sarabun", sans-serif;
        background-color: var(--mj-white);
    }

    /* Header */
    .header {
        display: flex;
        align-items: center;
        padding: 10px 20px;
        background-color: var(--mj-yellow);
    }

    .logo {
        width: 60px;
        height: 60px;
        transform: scale(1.5); /* ขยายรูป 1.5 เท่า */
    	transform-origin: center; /* ขยายจากตรงกลาง */
    }

    .search-box {
        margin-left: 20px;
        flex: 1;
        display: flex;
        align-items: center;
    }

    .search-box input[type="text"] {
        width: 100%;
        padding: 10px;
        font-size: 16px;
        border: none;
        border-radius: 5px 0 0 5px;
    }

    .search-box button {
        padding: 10px;
        background-color: var(--mj-green);
        color: white;
        border: none;
        border-radius: 0 5px 5px 0;
        cursor: pointer;
    }

    /* Menu */
    .nav {
        display: flex;
        justify-content: center;
        background-color: var(--mj-green);
    }

    .nav a {
        padding: 14px 20px;
        text-decoration: none;
        color: white;
        border-right: 1px solid #ccc;
    }

    .nav a:hover {
        background-color: #004414;
    }

    /* Product Section */
    .product-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
        gap: 20px;
        padding: 30px;
    }

    .product-card {
        background-color: #ffffff;
        border: 1px solid #ddd;
        border-radius: 10px;
        padding: 15px;
        text-align: center;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        transition: transform 0.2s ease-in-out;
    }

    .product-card:hover {
        transform: scale(1.03);
    }

    .product-card img {
        width: 100%;
        height: 180px;
        object-fit: cover;
        border-radius: 8px;
        margin-bottom: 10px;
    }

    .product-name {
        font-size: 16px;
        font-weight: bold;
        color: #333;
        margin-bottom: 10px;
    }
    
    .login-container {
		display: flex;
	    justify-content: center;
	    align-items: center;
	    width: 100%;
	    height: 100%;
	}
	
 	.login-box {
		width: 350px;
	    max-width: 90%;
	    max-height: 80%;          /* สูงสุดไม่เกิน 80% ของพื้นที่ container */
	    padding: 30px 25px;
	    text-align: center;
	    border-radius: 12px;
	    box-shadow: 0px 4px 15px rgba(0,0,0,0.15);
	    border: 1px solid #ddd;
	    overflow-y: auto;         /* ถ้าเนื้อหาฟอร์มเยอะ จะมี scroll ภายใน box */
	    margin: 20px 0;    
	}

	.login-box img {
    	width: 80px;
    	margin-bottom: 20px;
	}

	.form-group {
	    text-align: left;
	    margin-bottom: 15px;
	}

	.form-group label {
	    font-weight: bold;
	}

	.form-group input {
	    width: 100%;
	    padding: 10px;
	    margin-top: 5px;
	    border: 1px solid #ccc;
	    background: #fafafa;
	    border-radius: 6px;
	}

	.fill-box {
	    display: flex;
	    align-items: center;
	}
	
	.password-box input {
	    flex: 1;
	}
	
	.password-box span {
	    background: #e0e0e0;
	    padding: 10px;
	    cursor: pointer;
	    border-radius: 0 6px 6px 0;
	}

	/* ลิงก์สมัครสมาชิก */
	.register-link {
	    text-align: right;
	    margin: 10px 0;
	}
	
	.register-link a {
	    text-decoration: none;
	    color: #007bff;
	}
	
	.register-link a:hover {
	    text-decoration: underline;
	}

	/* ปุ่มเข้าสู่ระบบ */
	.register-btn {
	    width: 100%;
	    padding: 12px;
	    border: none;
	    background: #4cd137;
	    color: white;
	    font-size: 16px;
	    border-radius: 8px;
	    cursor: pointer;
	    font-weight: bold;
	}
	
	.register-btn:hover {
	    background: #44bd32;
	}
	
	.main-content {
		display: flex;
	    justify-content: center;  /* กึ่งกลางแนวนอน */
	    align-items: center;      /* กึ่งกลางแนวตั้ง */
	    min-height: calc(100vh - 120px); /* ลบความสูง header + menu bar */
	    background-color: #f7f7f7;
	    padding: 0 20px;          /* เว้นด้านซ้ายขวา */
	    box-sizing: border-box;
	}
  
</style>
  
<body>

	<div class="header">
    <a href="gHome">
        <img src="assets/images/icon/fishTesting.png" alt="โลโก้ปลา" class="logo">
    </a>      
    <form action="gSearchProducts" method="POST" class="search-box">
        <input type="text" name="searchtext" placeholder="ปลาหางนกยูง">
        <button type="submit">🔍</button>
    </form>
</div>

    <!-- Menu -->
    <div class="nav">
        <a href="gHome">หน้าแรก</a>
        <a href="gAllProduct">สินค้าทั้งหมด</a>
        <a href="#">รายการโปรด</a>
        <a href="#">คำสั่งซื้อ</a>
        <a href="#">ประวัติ</a>
        <a href="#">ตะกร้าสินค้า</a>
        <a href="gLogin">เข้าสู่ระบบ</a>
    </div>
    
   <!-- Main Content -->
<div class="main-content">
    <div class="login-container">
        <div class="login-box">
            <img src="assets/images/icon/fishTesting.png" alt="Fish Logo">

            <!-- ฟอร์ม -->
            <form action="saveRegister" method="post" enctype="multipart/form-data">
                <!-- hidden field เก็บค่า role -->
                <input type="hidden" id="role" name="role" value="user">

                <div class="form-group">
                    <label for="name">ชื่อผู้ใช้งาน</label>
                    <div class="fill-box">
                        <input type="text" id="name" name="name" placeholder="กรอกชื่อผู้ใช้งานของท่าน" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="tel">เบอร์โทร</label>
                    <div class="fill-box">
                        <input type="tel" id="tel" name="tel" placeholder="กรอกเบอร์โทรติดต่อของท่าน" required
                               maxlength="10" oninput="this.value=this.value.replace(/[^0-9]/g,'');">
                    </div>
                </div>

                <div class="form-group">
                    <label for="profileImg">รูปภาพโปรไฟล์</label>
                    <div class="fill-box">
                        <input type="file" id="profileImg" name="profileImg" accept="image/*" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="email">อีเมล</label>
                    <div class="fill-box">
                        <input type="email" id="email" name="email" placeholder="กรอกอีเมลของท่าน" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password">รหัสผ่าน</label>
                    <div class="fill-box">
                        <input type="password" id="password" name="password" placeholder="กรอกรหัสผ่าน" required>
                    </div>
                </div>

                <button type="submit" class="register-btn">สมัครสมาชิก</button>
            </form>
        </div>	
    </div>
</div>
    
 </body>
 </html>