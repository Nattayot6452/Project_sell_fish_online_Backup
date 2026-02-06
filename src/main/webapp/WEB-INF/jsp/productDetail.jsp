<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.springmvc.model.*" %>
<%@ page import="java.util.*"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><c:out value="${not empty product ? product.productName : 'รายละเอียดสินค้า'}" /> | Fish Online</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/productDetail.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/sellerHomepage.css">
    <link rel="stylesheet" type="text/css" href="assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        .seller-badge { background: #ffc107; color: #333; padding: 2px 8px; border-radius: 10px; font-size: 11px; margin-left: 5px; }
        .seller-actions-row { display: flex; gap: 10px; width: 100%; align-items: center; }
        .btn-edit-product {
            background-color: #ffc107; color: #333; border: none; flex: 1;
            padding: 12px; border-radius: 50px; text-decoration: none; font-weight: bold; text-align: center;
            transition: transform 0.2s;
        }
        .btn-edit-product:hover { background-color: #e0a800; transform: translateY(-2px); }
        .btn-delete-product {
            background-color: #dc3545; color: white; border: none; flex: 1;
            padding: 12px; border-radius: 50px; text-decoration: none; font-weight: bold; text-align: center;
            transition: transform 0.2s;
        }
        .btn-delete-product:hover { background-color: #c82333; transform: translateY(-2px); }

        .thumbnail-container {
            display: flex;
            gap: 10px;
            margin-top: 15px;
            overflow-x: auto;
            padding-bottom: 5px;
        }
        .thumb {
            width: 70px;
            height: 70px;
            object-fit: cover;
            border-radius: 8px;
            cursor: pointer;
            border: 2px solid transparent;
            opacity: 0.7;
            transition: 0.3s;
        }
        .thumb:hover { opacity: 1; }
        .thumb.active {
            border-color: #00571d; 
            opacity: 1;
            transform: scale(1.05);
        }
        .main-image-container {
            width: 100%;
            height: 400px; 
            background-color: #ffffff;
            border-radius: 12px;
            border: 1px solid #eee;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden; 
            margin-bottom: 10px;
        }
        #mainImg {
            width: 100%;
            height: 100%;
            object-fit: contain; 
            transition: opacity 0.3s ease;
        }
    </style>
</head>
<body>

    <c:choose>
        <c:when test="${not empty sessionScope.seller}">
            <jsp:include page="sellerNavbar.jsp" />
        </c:when>
        <c:otherwise>
            <jsp:include page="navbar.jsp" />
        </c:otherwise>
    </c:choose>

    <div class="breadcrumb-container">
        <ul class="breadcrumb">
            <c:choose>
                <c:when test="${not empty sessionScope.seller}">
                    <li><a href="SellerCenter">Seller Center</a></li>
                    <li><a href="SellerCenter">รายการสินค้า</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="Home">หน้าแรก</a></li>
                    <li><a href="AllProduct">สินค้าทั้งหมด</a></li>
                </c:otherwise>
            </c:choose>
            <li>${not empty product ? product.productName : 'รายละเอียดสินค้า'}</li>
        </ul>
    </div>

    <div class="container main-container">
        <c:choose>
            <c:when test="${not empty product}">
                
                <div class="product-wrapper">
                    <div class="product-gallery">
                        <div class="main-image-container">
                            <c:choose>
                                <c:when test="${product.productImg.startsWith('assets')}">
                                    <img id="mainImg" src="${pageContext.request.contextPath}/${product.productImg}" alt="${product.productName}">
                                </c:when>
                                <c:otherwise>
                                    <img id="mainImg" src="${pageContext.request.contextPath}/displayImage?name=${product.productImg}" alt="${product.productName}">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <div class="thumbnail-container">
                            <c:choose>
                                <c:when test="${product.productImg.startsWith('assets')}">
                                    <img class="thumb active" src="${pageContext.request.contextPath}/${product.productImg}" 
                                         onclick="changeImage(this.src, this)">
                                </c:when>
                                <c:otherwise>
                                    <img class="thumb active" src="${pageContext.request.contextPath}/displayImage?name=${product.productImg}" 
                                         onclick="changeImage(this.src, this)">
                                </c:otherwise>
                            </c:choose>
                            
                            <c:forEach items="${product.galleryImages}" var="img">
                                <c:choose>
                                    <c:when test="${img.imagePath.startsWith('assets')}">
                                        <img class="thumb" src="${pageContext.request.contextPath}/${img.imagePath}" 
                                             onclick="changeImage(this.src, this)">
                                    </c:when>
                                    <c:otherwise>
                                        <img class="thumb" src="${pageContext.request.contextPath}/displayImage?name=${img.imagePath}" 
                                             onclick="changeImage(this.src, this)">
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="product-details-info">
                        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 15px;">
                            <span class="stock-badge ${product.stock > 0 ? 'in-stock' : 'out-stock'}">
                                ${product.stock > 0 ? 'มีสินค้าพร้อมจำหน่าย' : 'สินค้าหมดชั่วคราว'}
                            </span>
                            <span style="color: #666; font-size: 0.95em; font-weight: 500;">
                                (เหลือ ${product.stock} ชิ้น)
                            </span>
                        </div>

                        <h1 class="product-title"><c:out value="${product.productName}" /></h1>
                        <p class="product-category">รหัสสินค้า: ${product.productId} | หมวดหมู่: ${product.species.speciesName}</p>
                        
                        <div class="price-section">
                            <span class="current-price">
                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="฿"/>
                            </span>
                        </div>

                        <p class="product-desc"><c:out value="${product.description}" /></p>

                        <div class="specs-grid">
                            <div class="spec-item">
                                <i class="fas fa-globe-asia"></i> <span>แหล่งกำเนิด</span> 
                                <strong><c:out value="${product.origin}" /></strong>
                            </div>
                            <div class="spec-item">
                                <i class="fas fa-water"></i> <span>ประเภทน้ำ</span> 
                                <strong><c:out value="${product.waterType}" /></strong>
                            </div>
                            <div class="spec-item">
                                <i class="fas fa-thermometer-half"></i> <span>อุณหภูมิ</span> 
                                <strong>${product.temperature} &deg;C</strong>
                            </div>
                            <div class="spec-item">
                                <i class="fas fa-ruler"></i> <span>ขนาดโตเต็มวัย</span> 
                                <strong>${product.size} ซม.</strong>
                            </div>
                            <div class="spec-item">
                                <i class="fas fa-heartbeat"></i> <span>อายุขัยเฉลี่ย</span> 
                                <strong>${product.lifeSpan} ปี</strong>
                            </div>
                            <div class="spec-item">
                                <i class="fas fa-hand-holding-heart"></i> <span>ระดับการดูแล</span> 
                                <strong>
                                    <c:choose>
                                        <c:when test="${product.careLevel == 'A'}">ง่าย (Easy)</c:when>
                                        <c:when test="${product.careLevel == 'B'}">ปานกลาง (Medium)</c:when>
                                        <c:when test="${product.careLevel == 'C'}">ยาก (Hard)</c:when>
                                        <c:otherwise>${product.careLevel}</c:otherwise>
                                    </c:choose>
                                </strong>
                            </div>
                            <div class="spec-item">
                                <i class="fas fa-paw"></i> <span>นิสัย</span> 
                                <strong>
                                    <c:choose>
                                        <c:when test="${product.isAggressive == 'Y'}">ดุร้าย (Aggressive)</c:when>
                                        <c:when test="${product.isAggressive == 'N'}">ไม่ดุร้าย (Peaceful)</c:when>
                                        <c:otherwise>${product.isAggressive}</c:otherwise>
                                    </c:choose>
                                </strong>
                            </div>
                        </div>

                        <div class="purchase-action">
                            <c:choose>
                                <c:when test="${not empty sessionScope.seller}">
                                    <div class="seller-actions-row">
                                        <a href="EditProduct?id=${product.productId}" class="btn-edit-product">
                                            <i class="fas fa-pen"></i> แก้ไข
                                        </a>
                                        <a href="DeleteProduct?id=${product.productId}" class="btn-delete-product"
                                           onclick="confirmDelete(event, this.href);">
                                            <i class="fas fa-trash-alt"></i> ลบสินค้า
                                        </a>
                                        <a href="SellerCenter" class="btn-fav" title="กลับหลังบ้าน" style="width: auto; padding: 0 20px;">
                                            <i class="fas fa-store"></i>
                                        </a>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <c:if test="${product.stock > 0}">
                                        <div class="quantity-control">
                                            <button type="button" onclick="decreaseQty()">-</button>
                                            <input type="number" id="qtyInput" value="1" min="1" max="${product.stock}" readonly>
                                            <button type="button" onclick="increaseQty()">+</button>
                                        </div>
                                        <a href="javascript:void(0)" onclick="addToCart('${product.productId}')" class="btn-add-cart">
                                            <i class="fas fa-shopping-cart"></i> หยิบใส่ตะกร้า
                                        </a>
                                    </c:if>
                                    <a href="${empty sessionScope.user ? 'Login' : 'addToFavorites?productId='.concat(product.productId)}" 
                                       class="btn-fav" title="เพิ่มรายการโปรด">
                                        <i class="far fa-heart"></i>
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <c:if test="${product.stock == 0}">
                            <p class="out-stock-msg"><i class="fas fa-exclamation-circle"></i> ขออภัย สินค้าหมดชั่วคราว</p>
                        </c:if>
                    </div>
                </div>

                <%-- Review Section --%>
                <div class="reviews-container">
                    <div class="reviews-header">
                        <h3><i class="fas fa-star"></i> รีวิวจากผู้ใช้งาน (${totalReviews})</h3>
                        <div class="rating-summary">
                            <span class="big-score">${avgRating}</span>
                            <div class="stars-display">
                                <c:forEach begin="1" end="5" var="i">
                                    <i class="fas fa-star ${i <= avgRating ? 'filled' : ''}"></i>
                                </c:forEach>
                            </div>
                            <span class="total-text">จาก ${totalReviews} รีวิว</span>
                        </div>
                    </div>

                    <div class="reviews-filter-bar">
                        <form action="ProductDetail" method="get" class="sort-form">
                            <input type="hidden" name="pid" value="${product.productId}">
                            <label><i class="fas fa-filter"></i> เรียงตาม:</label>
                            <select name="sort" onchange="this.form.submit()">
                                <option value="newest" ${currentSort == 'newest' ? 'selected' : ''}>ล่าสุด</option>
                                <option value="oldest" ${currentSort == 'oldest' ? 'selected' : ''}>เก่าที่สุด</option>
                                <option value="rating_desc" ${currentSort == 'rating_desc' ? 'selected' : ''}>คะแนนมากสุด</option>
                                <option value="rating_asc" ${currentSort == 'rating_asc' ? 'selected' : ''}>คะแนนน้อยสุด</option>
                            </select>
                        </form>
                    </div>

                    <div class="reviews-list">
                        <c:choose>
                            <c:when test="${not empty reviews}">
                                <c:forEach items="${reviews}" var="review">
                                    <div class="review-card">
                                        <div class="reviewer-info">
                                            <img src="${pageContext.request.contextPath}/displayImage?name=user/${not empty review.member.memberImg ? review.member.memberImg : 'default.png'}" 
                                                 class="reviewer-img">
                                            <div>
                                                <span class="reviewer-name"><c:out value="${review.member.memberName}" /></span>
                                                <div class="review-meta">
                                                    <div class="mini-stars">
                                                        <c:forEach begin="1" end="5" var="i">
                                                            <i class="fas fa-star ${i <= review.rating ? 'active' : ''}"></i>
                                                        </c:forEach>
                                                    </div>
                                                    <span class="review-date">
                                                        <fmt:formatDate value="${review.reviewDate}" pattern="d MMM yyyy"/>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="review-content">
                                            <p><c:out value="${review.comment}" /></p>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="no-reviews">
                                    <i class="far fa-comment-dots"></i>
                                    <p>สินค้านี้ยังไม่มีรีวิว เป็นคนแรกที่รีวิวเลย!</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-search"></i>
                    <h2>ไม่พบข้อมูลสินค้า</h2>
                    <p>สินค้านี้อาจถูกลบหรือไม่มีอยู่ในระบบ</p>
                    <a href="AllProduct" class="btn-back">กลับไปหน้ารวมสินค้า</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <footer class="site-footer">
        <p>&copy; 2025 Fish Online Shop. All rights reserved.</p>
    </footer>

    <script>
        const maxStock = parseInt('${not empty product ? product.stock : 0}');
        const qtyInput = document.getElementById('qtyInput');

        function increaseQty() {
            if (!qtyInput) return;
            let currentVal = parseInt(qtyInput.value);
            if (!isNaN(maxStock) && currentVal < maxStock) {
                qtyInput.value = currentVal + 1;
            }
        }

        function decreaseQty() {
            if (!qtyInput) return;
            let currentVal = parseInt(qtyInput.value);
            if (currentVal > 1) {
                qtyInput.value = currentVal - 1;
            }
        }

        function addToCart(productId) {
            <c:if test="${empty sessionScope.user}">
                window.location.href = "Login";
                return;
            </c:if>
            
            const qty = qtyInput ? qtyInput.value : 1;
            window.location.href = "addToCart?productId=" + productId + "&quantity=" + qty;
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        function confirmDelete(event, url) {
            event.preventDefault(); 

            Swal.fire({
                title: '⚠️ ยืนยันการลบสินค้า?',
                text: "${product.productName} \nการกระทำนี้ไม่สามารถย้อนกลับได้",
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
    </script>

    <script>

        function changeImage(src, element) {

            document.getElementById("mainImg").src = src;
            
            document.querySelectorAll('.thumb').forEach(el => el.classList.remove('active'));
            element.classList.add('active');
        }
    </script>

</body>
</html>