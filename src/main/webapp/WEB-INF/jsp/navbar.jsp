<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

<style>
    .nav-promo {
        color: #ff4757 !important;
        font-weight: bold;
        position: relative;
        transition: all 0.3s ease;
    }

    .nav-promo i {
        margin-right: 5px;
        animation: fire-flicker 1.5s infinite alternate;
    }

    .nav-promo:hover {
        color: #e84118 !important;
        text-shadow: 0 0 8px rgba(255, 71, 87, 0.4);
        transform: scale(1.05);
    }

    .promo-badge {
        position: absolute;
        top: -8px;
        right: -12px;
        background: linear-gradient(45deg, #ff0000, #ff6b6b);
        color: white;
        font-size: 8px;
        padding: 2px 5px;
        border-radius: 4px;
        box-shadow: 0 2px 5px rgba(255,0,0,0.3);
        animation: bounce 2s infinite;
    }

    @keyframes fire-flicker {
        0% { opacity: 1; transform: scale(1); }
        50% { opacity: 0.8; transform: scale(1.1); }
        100% { opacity: 1; transform: scale(1); }
    }
    
    @keyframes bounce {
        0%, 20%, 50%, 80%, 100% {transform: translateY(0);}
        40% {transform: translateY(-3px);}
        60% {transform: translateY(-1.5px);}
    }

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

    .dropdown {
        position: relative;
        display: inline-block;
        margin-left: 15px;
    }

    .dropbtn {
        display: flex;
        align-items: center;
        gap: 8px;
        color: #333;
        text-decoration: none;
        font-weight: 500;
        cursor: pointer;
        padding: 5px 10px;
        border-radius: 20px;
        transition: background 0.2s;
        border: 1px solid transparent;
    }

    .dropbtn:hover {
        background-color: #f0f0f0;
    }

    .nav-avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #eee;
    }

    .dropdown-content {
        display: none;
        position: absolute;
        
        left: 50%;
        transform: translate(-50%, -10px);
        
        background-color: #fff;
        min-width: 180px;
        box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.1);
        z-index: 1001;
        border-radius: 8px;
        border: 1px solid #eee;
        top: 100%;
        margin-top: 10px; 
        overflow: visible; 

        opacity: 0;
        transition: opacity 0.2s ease, transform 0.2s ease;
    }

    .dropdown-content::after {
        content: "";
        position: absolute;
        top: -6px;
        left: 50%;
        margin-left: -6px;
        border-width: 6px;
        border-style: solid;
        border-color: transparent transparent #fff transparent;
    }

    .dropdown-content::before {
        content: "";
        position: absolute;
        top: -15px; 
        left: 0;
        width: 100%;
        height: 20px;
        background: transparent;
        display: block;
    }

    .dropdown:hover .dropdown-content {
        display: block;
        opacity: 1;
        
        transform: translate(-50%, 0); 
    }

    .dropdown-content a:first-child { border-top-left-radius: 8px; border-top-right-radius: 8px; }
    .dropdown-content a:last-child { border-bottom-left-radius: 8px; border-bottom-right-radius: 8px; }

    .dropdown-content a {
        color: #333;
        padding: 12px 16px;
        text-decoration: none;
        display: block;
        font-size: 14px;
        transition: background 0.2s;
    }

    .dropdown-content a:hover {
        background-color: #f8f9fa;
        color: #00571d;
    }

    .dropdown-content a i {
        width: 20px;
        text-align: center;
        margin-right: 8px;
    }

    .menu-logout {
        color: #dc3545 !important;
    }
    .menu-logout:hover {
        background-color: #fff5f5 !important;
        color: #c0392b !important;
    }
</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<nav class="navbar">
    <div class="nav-container">
        <a href="Home" class="brand-logo">
            <img src="${pageContext.request.contextPath}/assets/images/icon/icon_fishshop.png" alt="Logo">
        </a>
        
        <form action="SearchProducts" method="get" class="search-wrapper">
            <input type="text" name="searchtext" value="<c:out value='${param.searchtext}' />" placeholder="ค้นหาปลาที่คุณชอบ...">
            <button type="submit"><i class="fas fa-search"></i></button>
        </form>

        <div class="nav-links">
            <a href="Home"><i class="fas fa-home"></i> หน้าแรก</a>
            <a href="AllProduct"><i class="fas fa-fish"></i> สินค้าทั้งหมด</a>
            
            <a href="Promotions" class="nav-promo">
                <i class="fas fa-fire-alt"></i> โปรโมชั่น
                <span class="promo-badge">HOT</span>
            </a>
            
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
                            <img src="${pageContext.request.contextPath}/displayImage?name=user/${sessionScope.user.memberImg}" class="nav-avatar" 
                                 onerror="this.src='https://cdn-icons-png.flaticon.com/512/149/149071.png'">
                            <span style="max-width: 100px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                ${sessionScope.user.memberName}
                            </span>
                            <i class="fas fa-chevron-down" style="font-size: 10px; margin-left: 3px;"></i>
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

<button onclick="topFunction()" id="myBtn" title="Go to top" style="
    display: none;
    position: fixed;
    bottom: 20px;
    right: 30px;
    z-index: 99;
    font-size: 18px;
    border: none;
    outline: none;
    background-color: #00571d;
    color: white;
    cursor: pointer;
    padding: 15px;
    border-radius: 50%;
    box-shadow: 0 4px 10px rgba(0,0,0,0.2);
    transition: 0.3s;
">
    <i class="fas fa-arrow-up"></i>
</button>

<script>
    let mybutton = document.getElementById("myBtn");

    window.onscroll = function() {scrollFunction()};

    function scrollFunction() {
        if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
            mybutton.style.display = "block";
        } else {
            mybutton.style.display = "none";
        }
    }

    function topFunction() {
        window.scrollTo({top: 0, behavior: 'smooth'}); 
    }
</script>

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

<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
  AOS.init();
</script>