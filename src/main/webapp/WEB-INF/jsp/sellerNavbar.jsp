<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

<style>
    .noti-btn {
        position: relative;
        color: #333;
        font-size: 18px;
        text-decoration: none;
        margin-right: 15px;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        width: 40px;
        height: 40px;
    }
    
    .noti-btn:hover {
        background: #f0f0f0;
        border-radius: 50%;
    }

    .badge-seller {
        position: absolute;
        top: 5px;
        right: 5px;
        background-color: #dc3545;
        color: white;
        border-radius: 50%;
        font-size: 10px;
        font-weight: bold;
        min-width: 16px;
        height: 16px;
        display: flex;
        justify-content: center;
        align-items: center;
        border: 2px solid #fff;
    }

    .noti-dropdown-content {
        display: none;
        position: absolute;
        right: 0;
        top: 50px;
        background-color: #f9f9f9;
        min-width: 320px;
        box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
        z-index: 9999;
        border-radius: 8px;
        overflow: hidden;
        border: 1px solid #ddd;
    }
    
    .dropdown:hover .dropdown-content { display: block; }
</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<nav class="navbar">
    <div class="nav-container">
        <a href="SellerCenter" class="brand-logo">
            <img src="${pageContext.request.contextPath}/assets/images/icon/fishTesting.png" alt="Logo">
            <span>Seller Center</span>
        </a>

        <div class="nav-links">
            <div class="dropdown">
                <a href="SellerCenter" class="menu-btn">
                    <i class="fas fa-boxes"></i> จัดการสินค้า <i class="fas fa-chevron-down" style="font-size: 10px;"></i>
                </a>
                <div class="dropdown-content">
                    <a href="ListProduct"><i class="fas fa-list"></i> รายการสินค้าทั้งหมด</a>
                    <a href="AddProduct"><i class="fas fa-plus-circle"></i> เพิ่มสินค้าใหม่</a>
                </div>
            </div>

            <a href="SellerOrders" class="menu-btn">
                <i class="fas fa-clipboard-list"></i> คำสั่งซื้อลูกค้า
            </a>

            <a href="ManageCoupons" class="menu-btn">
                <i class="fas fa-tags"></i> จัดการคูปอง
            </a>

            <div class="dropdown" style="display: inline-block; position: relative;">
                <a class="noti-btn" onclick="toggleSellerNoti()" title="การแจ้งเตือน">
                    <i class="fas fa-bell"></i>
                    <span id="seller-noti-badge" class="badge-seller" style="display: none;">0</span>
                </a>
                
                <div id="seller-noti-content" class="noti-dropdown-content">
                    <div style="padding: 12px; background: #fff; font-weight: bold; border-bottom: 1px solid #ddd; color: #00571d;">
                        <i class="fas fa-bell"></i> การแจ้งเตือนร้านค้า
                    </div>
                    <div id="seller-noti-list" style="max-height: 300px; overflow-y: auto; background: white;"></div>
                </div>
            </div>
            
            <a href="AddProduct" class="menu-btn add-product-btn">
                <i class="fas fa-plus-circle"></i> เพิ่มสินค้า
            </a>

            <div class="dropdown">
                <a href="#" class="menu-btn">
                    <i class="fas fa-user-tie"></i> เจ้าหน้าที่ <span class="seller-badge">Seller</span>
                    <i class="fas fa-chevron-down" style="font-size: 10px;"></i>
                </a>
                <div class="dropdown-content">
                    <a href="Logout" style="color: #dc3545;"><i class="fas fa-sign-out-alt"></i> ออกจากระบบ</a>
                </div>
            </div>
        </div>
    </div>
</nav>

<script>
    $(document).ready(function() {
        setInterval(fetchSellerNoti, 3000);
        fetchSellerNoti(); 
    });

    function fetchSellerNoti() {
        $.ajax({
            url: "${pageContext.request.contextPath}/getNotifications",
            type: "GET",
            dataType: "json",
            success: function(data) {
                let list = document.getElementById("seller-noti-list");
                let badge = document.getElementById("seller-noti-badge");
                list.innerHTML = ""; 
                
                if (data && data.length > 0) {
                    badge.style.display = "flex";
                    badge.innerText = data.length; 
                    
                    data.forEach(n => {
                        let item = document.createElement("div");
                        item.style.padding = "15px"; item.style.borderBottom = "1px solid #eee";
                        item.style.cursor = "pointer"; item.style.display = "flex"; item.style.gap = "10px";
                        
                        let icon = '<i class="fas fa-file-invoice-dollar" style="color:#28a745; margin-top:3px; font-size:18px;"></i>';

                        item.innerHTML = `<div>\${icon}</div><div><div style="font-size: 14px; font-weight: 500; color: #333; margin-bottom: 4px;">\${n.message}</div><div style="font-size: 11px; color: #888;">\${new Date(n.createdAt).toLocaleString()}</div></div>`;
                        
                        item.onclick = function() {
                            $.post("${pageContext.request.contextPath}/markRead", { id: n.notificationId }, function() {
                                if (n.link) window.location.href = "${pageContext.request.contextPath}/" + n.link;
                                else fetchSellerNoti();
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

    function toggleSellerNoti() {
        let content = document.getElementById("seller-noti-content");
        content.style.display = content.style.display === "none" ? "block" : "none";
    }

    document.addEventListener('click', function(event) {
        if (!event.target.closest('.noti-btn') && !event.target.closest('.noti-dropdown-content')) {
            document.getElementById("seller-noti-content").style.display = "none";
        }
    });
</script>

<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
  AOS.init(); 
</script>