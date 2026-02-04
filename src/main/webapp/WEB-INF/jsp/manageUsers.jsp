<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>จัดการสมาชิก | Admin</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <jsp:include page="loading.jsp" />

    <div class="admin-wrapper">
        <jsp:include page="adminNavbar.jsp" />
        <div class="content">
            <nav class="top-navbar">
                <div class="navbar-title">จัดการข้อมูลสมาชิก</div>
                <div class="admin-profile">
                    <img src="${pageContext.request.contextPath}/assets/images/icon/admin-avatar.png" onerror="this.src='https://cdn-icons-png.flaticon.com/512/2942/2942813.png'" alt="Admin">
                    <span>Admin</span>
                </div>
            </nav>

            <div class="dashboard-container">
                <div class="recent-section">
                    <div class="section-header">
                        <h3><i class="fas fa-users"></i> รายชื่อสมาชิกทั้งหมด (${allMembers.size()})</h3>
                    </div>
                    
                    <c:if test="${param.msg == 'banned'}">
                        <div style="background: #fed7d7; color: #c53030; padding: 10px; margin-bottom: 15px; border-radius: 5px;">
                            <i class="fas fa-check-circle"></i> ลบสมาชิกเรียบร้อยแล้ว
                        </div>
                    </c:if>

                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>รูปโปรไฟล์</th>
                                <th>ชื่อ-นามสกุล</th>
                                <th>อีเมล</th>
                                <th>เบอร์โทร</th>
                                <th>จัดการ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${allMembers}" var="m">
                                <tr class="${m.status == 'Banned' ? 'row-banned' : ''}">
                                    <td>#${m.memberId}</td>
                                    <td>
                                        <img src="${pageContext.request.contextPath}/displayImage?name=user/${not empty m.memberImg ? m.memberImg : 'default.png'}" 
                                             class="user-avatar ${m.status == 'Banned' ? 'banned' : ''}"
                                             onerror="this.src='https://cdn-icons-png.flaticon.com/512/149/149071.png'">
                                    </td>
                                    <td style="font-weight: bold;">
                                        <c:out value="${m.memberName}" />
                                        <c:if test="${m.status == 'Banned'}">
                                            <span style="background: #dc3545; color: white; padding: 2px 6px; border-radius: 4px; font-size: 10px; margin-left: 5px;">BANNED</span>
                                        </c:if>
                                    </td>
                                    <td><c:out value="${m.email}" /></td>
                                    <td><c:out value="${m.phone}" /></td>
                                    <td>
                                        <a href="UserDetail?id=${m.memberId}" class="btn-small" title="ดูรายละเอียด">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        
                                        <c:choose>
                                            <c:when test="${m.status == 'Banned'}">
                                                <a href="BanUser?id=${m.memberId}" class="btn-small" style="background: #28a745; color: white;" 
                                                   onclick="confirmAction(event, this.href, 'ยืนยันการปลดแบน?', 'สมาชิกจะกลับมาใช้งานได้ปกติ')">
                                                    <i class="fas fa-unlock"></i>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="BanUser?id=${m.memberId}" class="btn-small" style="background: #dc3545; color: white;" 
                                                   onclick="confirmAction(event, this.href, 'ยืนยันการระงับผู้ใช้?', 'สมาชิกคนนี้จะไม่สามารถเข้าสู่ระบบได้')">
                                                    <i class="fas fa-ban"></i>
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const urlParams = new URLSearchParams(window.location.search);
        const msg = urlParams.get('msg');
        const error = urlParams.get('error');

        if (msg === 'success' || msg === 'saved' || msg === 'updated' || msg === 'deleted' || msg === 'banned') {
            Swal.fire({
                icon: 'success',
                title: 'ดำเนินการสำเร็จ!',
                showConfirmButton: false,
                timer: 1500
            });
        } else if (error) {
            Swal.fire({
                icon: 'error',
                title: 'เกิดข้อผิดพลาด',
                text: 'ไม่สามารถทำรายการได้ในขณะนี้',
                confirmButtonColor: '#e53e3e'
            });
        }
    });

    function confirmAction(event, url, title, text) {
        event.preventDefault(); 
        
        Swal.fire({
            title: title || 'คุณแน่ใจไหม?',
            text: text || "การกระทำนี้ไม่สามารถย้อนกลับได้!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#e53e3e', 
            cancelButtonColor: '#888',
            confirmButtonText: 'ใช่, ยืนยันเลย!',
            cancelButtonText: 'ยกเลิก'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = url;
            }
        });
    }
</script>

<script>
    if (msg === 'status_changed') {
            Swal.fire({
                icon: 'success',
                title: 'อัปเดตสถานะเรียบร้อย!',
                showConfirmButton: false,
                timer: 1500
            });
        }
</script>

</body>
</html>