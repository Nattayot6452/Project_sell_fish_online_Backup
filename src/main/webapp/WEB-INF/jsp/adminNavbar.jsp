<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="currentUri" value="${pageContext.request.requestURI}" />

<nav class="sidebar">
    <div class="sidebar-header">
        <img src="${pageContext.request.contextPath}/assets/images/icon/icon_fishshop.png" alt="Logo">
        </div>
    
    <ul class="list-unstyled components">
        <li class="${currentUri.contains('AdminCenter') ? 'active' : ''}">
            <a href="AdminCenter"><i class="fas fa-chart-line"></i> ภาพรวมระบบ</a>
        </li>

        <li class="${currentUri.contains('ManageUsers') ? 'active' : ''}">
            <a href="ManageUsers"><i class="fas fa-users"></i> จัดการสมาชิก</a>
        </li>

        <li class="${currentUri.contains('AdminOrders') ? 'active' : ''}">
            <a href="AdminOrders"><i class="fas fa-clipboard-list"></i> รายการคำสั่งซื้อ</a>
        </li>
        
        <li class="${currentUri.contains('AddSpecies') ? 'active' : ''}">
            <a href="AddSpecies"><i class="fas fa-plus-circle"></i> เพิ่มสายพันธุ์ปลา</a>
        </li>
        
        <li class="${currentUri.contains('ManageSpecies') ? 'active' : ''}">
            <a href="ManageSpecies"><i class="fas fa-dna"></i> จัดการสายพันธุ์</a>
        </li>

        <li class="${currentUri.contains('AdminAllProducts') ? 'active' : ''}">
            <a href="AdminAllProducts"><i class="fas fa-boxes"></i> สินค้าทั้งหมด</a>
        </li>

        <li>
            <a href="javascript:void(0)" onclick="toggleNotifications()" style="display: flex; justify-content: space-between; align-items: center;">
                
                <div style="display: flex; align-items: center;">
                    <i class="fas fa-bell" style="width: 20px; text-align: center; margin-right: 10px;"></i> 
                    <span>การแจ้งเตือน</span>
                </div>

                <span id="notiBadge" class="badge-noti" style="display: none;">0</span>
            </a>

            <ul id="notiDropdown" class="list-unstyled" style="display: none; background: #34495e; border-left: 3px solid #ffc107;">
                <li style="padding: 10px; color: #ccc; text-align: center;">ไม่มีการแจ้งเตือนใหม่</li>
            </ul>
        </li>

    </ul>
</nav>

<style>
    .badge-noti {
        background-color: #dc3545;
        color: white;
        font-size: 10px;
        font-weight: bold;
        padding: 2px 6px;
        border-radius: 10px;
        margin-left: 5px;
    }
    .noti-item {
        padding: 10px 15px;
        border-bottom: 1px solid #465a6e;
        cursor: pointer;
        display: block;
        color: #ecf0f1 !important;
        font-size: 13px;
        transition: 0.2s;
        text-decoration: none;
    }
    .noti-item:hover {
        background-color: #2c3e50;
        color: #ffc107 !important;
        text-decoration: none;
    }
    .noti-time {
        font-size: 11px;
        color: #bdc3c7;
        display: block;
        margin-top: 3px;
    }
</style>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        fetchNotifications();
        setInterval(fetchNotifications, 3000);
    });

    function toggleNotifications() {
        var dropdown = document.getElementById("notiDropdown");
        if (dropdown.style.display === "none") {
            dropdown.style.display = "block";
        } else {
            dropdown.style.display = "none";
        }
    }

    function fetchNotifications() {
        fetch('getNotifications')
            .then(response => response.json())
            .then(data => {
                const badge = document.getElementById('notiBadge');
                const list = document.getElementById('notiDropdown');

                if (data.length > 0) {
                    badge.innerText = data.length;
                    badge.style.display = 'inline-block';
                    
                    let html = '';
                    data.forEach(n => {
                        let date = new Date(n.createdAt);
                        let timeString = date.toLocaleDateString('th-TH') + ' ' + date.toLocaleTimeString('th-TH', {hour: '2-digit', minute:'2-digit'});

                        html += `
                            <li>
                                <a href="javascript:void(0)" onclick="readAndGo(\${n.notificationId}, '\${n.link}')" class="noti-item">
                                    <div>\${n.message}</div>
                                    <span class="noti-time"><i class="far fa-clock"></i> \${timeString}</span>
                                </a>
                            </li>
                        `;
                    });
                    list.innerHTML = html;
                } else {
                    badge.style.display = 'none';
                    list.innerHTML = '<li style="padding: 10px; color: #ccc; text-align: center; font-size: 12px;">ไม่มีการแจ้งเตือนใหม่</li>';
                }
            })
            .catch(error => console.error('Error fetching notifications:', error));
    }

    function readAndGo(id, link) {
        fetch('markRead?id=' + id, { method: 'POST' })
            .then(() => {
                window.location.href = link;
            });
    }
</script>