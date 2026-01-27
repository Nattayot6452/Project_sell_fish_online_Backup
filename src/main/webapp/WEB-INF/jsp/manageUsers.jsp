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
                                <tr>
                                    <td>#${m.memberId}</td>
                                    <td>
                                        <img src="${pageContext.request.contextPath}/profile-uploads/user/${m.memberImg}" 
                                             style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover; border: 1px solid #ddd;" 
                                             onerror="this.src='https://cdn-icons-png.flaticon.com/512/149/149071.png'">
                                    </td>
                                    <td style="font-weight: bold;">${m.memberName}</td>
                                    <td>${m.email}</td>
                                    <td>${m.phone}</td>
                                    <td>
                                        <a href="UserDetail?id=${m.memberId}" class="btn-small" title="ดูรายละเอียด">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="BanUser?id=${m.memberId}" class="btn-small" style="background: #fed7d7; color: #c53030;" 
                                           onclick="return confirm('⚠️ ยืนยันการลบสมาชิกคนนี้? \nการกระทำนี้ไม่สามารถย้อนกลับได้');" title="Ban User">
                                            <i class="fas fa-ban"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>