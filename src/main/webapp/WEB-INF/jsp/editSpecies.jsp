<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>แก้ไขสายพันธุ์ | Admin</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .form-container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); max-width: 600px; margin: 0 auto; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 8px; color: #333; }
        .form-group input, .form-group textarea { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; font-size: 14px; }
        .btn-submit { background: #ffc107; color: #333; border: none; padding: 12px 25px; border-radius: 5px; cursor: pointer; font-weight: bold; width: 100%; font-size: 16px; }
        .btn-submit:hover { background: #e0a800; }
    </style>
</head>
<body>
    <div class="admin-wrapper">
        <jsp:include page="adminNavbar.jsp" />
        <div class="content">
            <nav class="top-navbar">
                <div class="navbar-title">แก้ไขข้อมูลสายพันธุ์</div>
                <div class="admin-profile">
                    <img src="${pageContext.request.contextPath}/assets/images/icon/admin-avatar.png" onerror="this.src='https://cdn-icons-png.flaticon.com/512/2942/2942813.png'" alt="Admin">
                    <span>Admin</span>
                </div>
            </nav>

            <div class="dashboard-container">
                <div class="form-container">
                    <div style="margin-bottom: 20px; text-align: center;">
                        <h2 style="margin: 0; color: #333;">แก้ไขข้อมูล</h2>
                        <p style="color: #666;">รหัสสายพันธุ์: <strong>${species.speciesId}</strong></p>
                    </div>

                    <form action="updateSpecies" method="post">
                        <input type="hidden" name="speciesId" value="${species.speciesId}">

                        <div class="form-group">
                            <label>ชื่อสายพันธุ์ (Species Name)</label>
                            <input type="text" name="speciesName" value="${species.speciesName}" required>
                        </div>

                        <div class="form-group">
                            <label>คำอธิบาย (Description)</label>
                            <textarea name="description" rows="5" required>${species.description}</textarea>
                        </div>

                        <div style="display: flex; gap: 10px;">
                            <a href="ViewSpecies?id=${species.speciesId}" style="flex: 1; text-align: center; padding: 12px; background: #ddd; color: #333; text-decoration: none; border-radius: 5px; font-weight: bold;">ยกเลิก</a>
                            <button type="submit" class="btn-submit" style="flex: 2;">บันทึกการแก้ไข</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>