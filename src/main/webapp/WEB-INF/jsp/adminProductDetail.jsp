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
        .main-img { width: 100%; max-width: 400px; border-radius: 10px; border: 1px solid #eee; box-shadow: 0 2px 5px rgba(0,0,0,0.05); margin-bottom: 15px; }
        
        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(70px, 1fr));
            gap: 10px;
            margin-top: 10px;
        }
        .gallery-img {
            width: 100%;
            height: 70px;
            object-fit: cover;
            border-radius: 5px;
            border: 1px solid #ddd;
            cursor: pointer;
            transition: all 0.2s;
        }
        .gallery-img:hover {
            transform: scale(1.05);
            border-color: #3182ce;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .product-info-box { flex: 2; }
        .info-header { border-bottom: 2px solid #edf2f7; padding-bottom: 15px; margin-bottom: 20px; }
        
        .info-group { margin-bottom: 20px; }
        .info-label { font-weight: bold; color: #555; display: block; margin-bottom: 5px; font-size: 14px; }
        .info-value { font-size: 16px; color: #333; line-height: 1.6; }
        
        .price-tag { font-size: 28px; color: #00571d; font-weight: bold; }
        
        .badge-group { display: flex; gap: 10px; align-items: center; margin-top: 10px; }
        .stock-tag { background: #edf2f7; padding: 6px 15px; border-radius: 20px; font-size: 14px; font-weight: bold; color: #2d3748; }
        
        .status-badge { padding: 6px 15px; border-radius: 20px; font-size: 14px; font-weight: bold; }
        .status-active { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .status-suspended { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

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
                             class="main-img"
                             id="mainImage"
                             onerror="this.src='https://cdn-icons-png.flaticon.com/512/1156/1156477.png'">
                        
                        <c:if test="${not empty product.galleryImages}">
                            <div class="gallery-grid">
                                <c:forEach items="${product.galleryImages}" var="img">
                                    <img src="${pageContext.request.contextPath}/displayImage?name=${img.imagePath}" 
                                         class="gallery-img"
                                         onclick="changeMainImage(this.src)">
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>

                    <div class="product-info-box">
                        <div class="info-header">
                            <h2 style="margin: 0; color: #2d3748;">${product.productName}</h2>
                            
                            <div class="badge-group">
                                <span class="stock-tag">
                                    <i class="fas fa-boxes"></i> คงเหลือ: ${product.stock} ตัว
                                </span>

                                <c:choose>
                                    <c:when test="${product.productStatus == 'Suspended' || product.productStatus == 'Inactive'}">
                                        <span class="status-badge status-suspended">
                                            <i class="fas fa-pause-circle"></i> พักการขาย
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-active">
                                            <i class="fas fa-check-circle"></i> ขายปกติ
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
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

    <script>
        function changeMainImage(src) {
            document.getElementById('mainImage').src = src;
        }
    </script>
</body>
</html>