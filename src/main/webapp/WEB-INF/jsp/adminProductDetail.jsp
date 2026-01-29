<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>รายละเอียดสินค้า #${product.productId} | Admin</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .product-card { background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); display: flex; gap: 30px; align-items: flex-start; }
        .product-img-box { flex: 1; text-align: center; position: sticky; top: 20px; }
        .product-img-box img { width: 100%; max-width: 400px; border-radius: 10px; border: 1px solid #eee; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        
        .product-info-box { flex: 2; }
        .info-header { border-bottom: 2px solid #edf2f7; padding-bottom: 15px; margin-bottom: 20px; }
        
        .info-group { margin-bottom: 20px; }
        .info-label { font-weight: bold; color: #555; display: block; margin-bottom: 5px; font-size: 14px; }
        .info-value { font-size: 16px; color: #333; line-height: 1.6; }
        
        .price-tag { font-size: 28px; color: #00571d; font-weight: bold; }
        .stock-tag { background: #edf2f7; padding: 6px 15px; border-radius: 20px; font-size: 14px; font-weight: bold; color: #2d3748; display: inline-block; margin-top: 10px;}
        
        .specs-grid { 
            display: grid; 
            grid-template-columns: repeat(2, 1fr); 
            gap: 15px; 
            background: #f8fafc; 
            padding: 20px; 
            border-radius: 10px; 
            margin-top: 20px;
            border: 1px solid #edf2f7;
        }
        .spec-item { display: flex; flex-direction: column; }
        .spec-label { font-size: 13px; color: #718096; font-weight: 600; margin-bottom: 3px; }
        .spec-value { font-size: 15px; color: #2d3748; font-weight: 500; }
        .spec-icon { margin-right: 5px; color: #4a5568; }

        .btn-action-group { margin-top: 30px; display: flex; gap: 10px; border-top: 1px solid #eee; padding-top: 20px; }
        .btn-edit { background: #3182ce; color: white; padding: 10px 20px; border-radius: 5px; text-decoration: none; font-weight: bold; transition: 0.2s; }
        .btn-delete { background: #e53e3e; color: white; padding: 10px 20px; border-radius: 5px; text-decoration: none; font-weight: bold; transition: 0.2s; }
        .btn-edit:hover { background: #2b6cb0; } .btn-delete:hover { background: #c53030; }
    </style>
</head>
<body>

    <div class="admin-wrapper">
        <jsp:include page="adminNavbar.jsp" />

        <div class="content">
            <nav class="top-navbar">
                <a href="AdminAllProducts" style="text-decoration: none; color: #555; font-weight: bold;">
                    <i class="fas fa-arrow-left"></i> ย้อนกลับไปหน้ารวม
                </a>
                <div class="admin-profile">
                    <img src="${pageContext.request.contextPath}/assets/images/icon/admin-avatar.png" onerror="this.src='https://cdn-icons-png.flaticon.com/512/2942/2942813.png'" alt="Admin">
                    <span>Admin</span>
                </div>
            </nav>

            <div class="dashboard-container">
                <div class="product-card">
                    <div class="product-img-box">
                        <img src="${pageContext.request.contextPath}/${product.productImg.startsWith('assets') ? '' : 'displayImage?name='}${product.productImg}" 
                             onerror="this.src='https://cdn-icons-png.flaticon.com/512/1156/1156477.png'">
                    </div>

                    <div class="product-info-box">
                        <div class="info-header">
                            <h2 style="margin: 0; color: #2d3748;">${product.productName}</h2>
                            <span class="stock-tag">
                                <i class="fas fa-boxes"></i> สินค้าคงเหลือ: ${product.stock} ตัว
                            </span>
                        </div>

                        <div class="info-group">
                            <span class="info-label">ราคาขาย</span>
                            <span class="price-tag"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="฿"/></span>
                        </div>

                        <div class="info-group">
                            <span class="info-label">วันที่ลงสินค้า</span>
                            <span class="info-value" style="color: #666; font-size: 15px;">
                                <i class="far fa-calendar-alt"></i> 
                                <fmt:formatDate value="${product.createDate}" pattern="d MMMM yyyy (HH:mm น.)" />
                            </span>
                        </div>

                        <div class="info-group">
                            <span class="info-label">รายละเอียดสินค้า</span>
                            <div class="info-value">
                                ${not empty product.description ? product.description : 'ไม่มีรายละเอียด'}
                            </div>
                        </div>

                        <div class="info-group">
                            <span class="info-label" style="font-size: 16px; margin-bottom: 10px;">
                                <i class="fas fa-info-circle"></i> ข้อมูลจำเพาะ
                            </span>
                            <div class="specs-grid">
                                <div class="spec-item">
                                    <span class="spec-label"><i class="fas fa-dna spec-icon"></i> สายพันธุ์</span>
                                    <span class="spec-value">${product.species.speciesName}</span>
                                </div>
                                <div class="spec-item">
                                    <span class="spec-label"><i class="fas fa-globe-asia spec-icon"></i> แหล่งกำเนิด</span>
                                    <span class="spec-value">${not empty product.origin ? product.origin : '-'}</span>
                                </div>
                                <div class="spec-item">
                                    <span class="spec-label"><i class="fas fa-ruler-horizontal spec-icon"></i> ขนาดโตเต็มวัย</span>
                                    <span class="spec-value">${not empty product.size ? product.size : '-'}</span>
                                </div>
                                <div class="spec-item">
                                    <span class="spec-label"><i class="fas fa-tint spec-icon"></i> ประเภทน้ำ</span>
                                    <span class="spec-value">${not empty product.waterType ? product.waterType : '-'}</span>
                                </div>
                                <div class="spec-item">
                                    <span class="spec-label"><i class="fas fa-thermometer-half spec-icon"></i> อุณหภูมิ</span>
                                    <span class="spec-value">${not empty product.temperature ? product.temperature : '-'}</span>
                                </div>
                                <div class="spec-item">
                                    <span class="spec-label"><i class="fas fa-hourglass-half spec-icon"></i> อายุขัย</span>
                                    <span class="spec-value">${not empty product.lifeSpan ? product.lifeSpan : '-'}</span>
                                </div>
                                <div class="spec-item">
                                    <span class="spec-label"><i class="fas fa-fist-raised spec-icon"></i> นิสัย/ความดุร้าย</span>
                                    <span class="spec-value">${not empty product.isAggressive ? product.isAggressive : '-'}</span>
                                </div>
                                <div class="spec-item">
                                    <span class="spec-label"><i class="fas fa-heart spec-icon"></i> ระดับการดูแล</span>
                                    <span class="spec-value">${not empty product.careLevel ? product.careLevel : '-'}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>