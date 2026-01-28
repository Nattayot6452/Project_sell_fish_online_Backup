<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>รายละเอียดสายพันธุ์ | Admin</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <div class="admin-wrapper">
        <jsp:include page="adminNavbar.jsp" />
        <div class="content">
            <nav class="top-navbar">
                <a href="ManageSpecies" style="text-decoration: none; color: #333; font-weight: bold;">
                    <i class="fas fa-arrow-left"></i> ย้อนกลับ
                </a>
                <div class="admin-profile">
                    <img src="${pageContext.request.contextPath}/assets/images/icon/admin-avatar.png" onerror="this.src='https://cdn-icons-png.flaticon.com/512/2942/2942813.png'" alt="Admin">
                    <span>Admin</span>
                </div>
            </nav>

            <div class="dashboard-container">
                
                <div class="card" style="display: block; margin-bottom: 20px; position: relative;">
                    
                    <div style="position: absolute; top: 20px; right: 20px; display: flex; gap: 10px;">
                        <a href="EditSpecies?id=${species.speciesId}" 
                           style="background: #ffc107; color: #333; padding: 8px 15px; border-radius: 5px; text-decoration: none; font-weight: bold; font-size: 14px;">
                            <i class="fas fa-edit"></i> แก้ไข
                        </a>
                        
                        <a href="RemoveSpecies?id=${species.speciesId}" 
                           onclick="confirmDelete(event, this.href);"
                           style="background: #e53e3e; color: white; padding: 8px 15px; border-radius: 5px; text-decoration: none; font-weight: bold; font-size: 14px;">
                            <i class="fas fa-trash-alt"></i> ลบ
                        </a>
                    </div>

                    <div style="display: flex; align-items: center; gap: 15px; border-bottom: 1px solid #eee; padding-bottom: 15px; margin-bottom: 15px;">
                        <div style="background: #e6fffa; color: #319795; width: 60px; height: 60px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px;">
                            <i class="fas fa-dna"></i>
                        </div>
                        <div>
                            <h2 style="margin: 0; color: #2d3748;">${species.speciesName}</h2>
                            <span style="background: #edf2f7; color: #4a5568; padding: 2px 8px; border-radius: 4px; font-size: 12px; font-weight: bold;">ID: ${species.speciesId}</span>
                        </div>
                    </div>
                    <div>
                        <h4 style="margin-bottom: 5px; color: #4a5568;">คำอธิบาย:</h4>
                        <p style="color: #718096; line-height: 1.6;">${species.description}</p>
                    </div>
                </div>

                <div class="recent-section">
                    <div class="section-header">
                        <h3><i class="fas fa-boxes"></i> สินค้าในหมวดหมู่นี้ (${species.products.size()})</h3>
                    </div>
                    
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>รูปภาพ</th>
                                <th>ชื่อสินค้า</th>
                                <th>ราคา</th>
                                <th>สต็อก</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty species.products}">
                                    <c:forEach items="${species.products}" var="p">
                                        <tr>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.productImg.startsWith('assets')}">
                                                        <img src="${pageContext.request.contextPath}/${p.productImg}" style="width: 50px; height: 50px; object-fit: cover; border-radius: 5px; border: 1px solid #eee;">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/displayImage?name=${p.productImg}" style="width: 50px; height: 50px; object-fit: cover; border-radius: 5px; border: 1px solid #eee;">
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="font-weight: bold;"><c:out value="${p.productName}"/></td>
                                            <td><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="฿"/></td>
                                            <td>
                                                <span class="${p.stock > 0 ? 'text-green' : 'text-red'}" style="font-weight: bold;">
                                                    ${p.stock}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" style="text-align: center; padding: 30px; color: #a0aec0;">
                                            <i class="fas fa-box-open" style="font-size: 30px; margin-bottom: 10px; display: block;"></i>
                                            ยังไม่มีสินค้าในหมวดหมู่นี้
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>
    </div>

     <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>

    function confirmDelete(event, url) {
        event.preventDefault(); 

        Swal.fire({
            title: 'ยืนยันการลบ?',
            text: "สายพันธุ์นี้อาจทำให้สินค้าที่เกี่ยวข้องถูกลบด้วย!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#e53e3e',  
            cancelButtonColor: '#718096',   
            confirmButtonText: 'ใช่, ลบเลย!',
            cancelButtonText: 'ยกเลิก',
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = url; 
            }
        });
    }

    document.addEventListener("DOMContentLoaded", function() {
        const urlParams = new URLSearchParams(window.location.search);
        const msg = urlParams.get('msg');
        const error = urlParams.get('error');

        if (msg === 'deleted') {
            Swal.fire({
                icon: 'success',
                title: 'ลบสินค้าเรียบร้อย!',
                showConfirmButton: false,
                timer: 1500
            });
        } else if (msg === 'saved' || msg === 'success') {
            Swal.fire({
                icon: 'success',
                title: 'บันทึกสำเร็จ!',
                showConfirmButton: false,
                timer: 1500
            });
        }
    });
</script>

</body>
</html>