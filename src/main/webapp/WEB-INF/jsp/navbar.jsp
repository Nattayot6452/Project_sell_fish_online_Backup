<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>

    .cart-link {
        position: relative !important;
        display: inline-flex !important;
        justify-content: center;
        align-items: center;
        width: 40px;
        height: 40px;
        color: #333;
        text-decoration: none;
        font-size: 18px;
    }

    .cart-link i {
        transform: none !important;
        line-height: 1 !important;
    }

    .badge {
        position: absolute;
        top: 2px;     
        right: 0px;  
        
        width: 18px !important;
        height: 18px !important;
        
        background-color: #dc3545;
        color: white;
        border-radius: 50%; 
        
        display: flex;
        justify-content: center;
        align-items: center;
        
        font-size: 10px;
        font-weight: bold;
        border: 2px solid #fff; 
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        z-index: 10;
    }

</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

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
            
            <c:if test="${empty user}">
                    <a href="Login" class="btn-login"><i class="fas fa-user"></i> เข้าสู่ระบบ</a>
            </c:if>
            
            <c:if test="${not empty user}">

            <a href="Cart" class="cart-link" title="ตะกร้าสินค้า">
                    <i class="fas fa-shopping-cart"></i>
                    <c:if test="${not empty sessionScope.cart && sessionScope.cart.size() > 0}">
                         <span class="badge">${sessionScope.cart.size()}</span>
                    </c:if>
                </a>

                <div class="notification-dropdown" style="position: relative; margin-left: 10px; margin-right: 10px; display: inline-block;">
                    <a href="javascript:void(0)" onclick="toggleNoti()" style="color: #333; font-size: 20px; text-decoration: none; position: relative;">
                        <i class="fas fa-bell"></i>
                        <span id="noti-badge" style="display: none; position: absolute; top: -5px; right: -5px; background: #dc3545; color: white; border-radius: 50%; padding: 2px 5px; font-size: 10px; font-weight: bold;">0</span>
                    </a>
                    <div id="noti-content" style="display: none; position: absolute; right: 0; top: 35px; background: white; width: 320px; box-shadow: 0 5px 20px rgba(0,0,0,0.15); border-radius: 8px; z-index: 9999; border: 1px solid #eee; overflow: hidden;">
                        <div style="padding: 12px; background: #f8f9fa; font-weight: bold; border-bottom: 1px solid #ddd; color: #333;">
                            <i class="fas fa-bell"></i> การแจ้งเตือน
                        </div>
                        <div id="noti-list" style="max-height: 300px; overflow-y: auto;"></div>
                    </div>
                </div>

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
        </div>
    </div>
</nav>

<script>
    $(document).ready(function() {
        setInterval(fetchNotifications, 5000);
        fetchNotifications(); 
    });

    function fetchNotifications() {
        $.ajax({
            url: "${pageContext.request.contextPath}/getNotifications",
            type: "GET",
            dataType: "json",
            success: function(data) {
                let list = document.getElementById("noti-list");
                let badge = document.getElementById("noti-badge");
                list.innerHTML = ""; 
                if (data && data.length > 0) {
                    badge.style.display = "block";
                    badge.innerText = data.length; 
                    data.forEach(n => {
                        let item = document.createElement("div");
                        item.style.padding = "15px"; item.style.borderBottom = "1px solid #eee";
                        item.style.cursor = "pointer"; item.style.display = "flex"; item.style.gap = "10px";
                        let icon = '<i class="fas fa-box-open" style="color:#007bff; margin-top:3px;"></i>';
                        item.innerHTML = `<div>\${icon}</div><div><div style="font-size: 14px; font-weight: 500; color: #333; margin-bottom: 4px;">\${n.message}</div><div style="font-size: 11px; color: #888;">\${new Date(n.createdAt).toLocaleString()}</div></div>`;
                        item.onclick = function() {
                            $.post("${pageContext.request.contextPath}/markRead", { id: n.notificationId }, function() {
                                if (n.link) window.location.href = "${pageContext.request.contextPath}/" + n.link;
                                else fetchNotifications();
                            });
                        };
                        item.onmouseover = function() { this.style.backgroundColor = "#f0fdf4"; };
                        item.onmouseout = function() { this.style.backgroundColor = "white"; };
                        list.appendChild(item);
                    });
                } else {
                    badge.style.display = "none";
                    list.innerHTML = "<div style='padding:30px; text-align:center; color:#999;'><i class='far fa-bell-slash' style='font-size:24px; margin-bottom:10px;'></i><br>ไม่มีการแจ้งเตือนใหม่</div>";
                }
            }
        });
    }
    function toggleNoti() {
        let content = document.getElementById("noti-content");
        content.style.display = content.style.display === "none" ? "block" : "none";
    }
    document.addEventListener('click', function(event) {
        const dropdown = document.querySelector('.notification-dropdown');
        if (dropdown && !dropdown.contains(event.target)) {
            document.getElementById("noti-content").style.display = "none";
        }
    });
</script>