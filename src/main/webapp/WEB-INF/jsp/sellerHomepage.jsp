<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Seller Center | Fish Online</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/sellerHomepage.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <jsp:include page="sellerNavbar.jsp" />

    <div class="hero-section">
        <div class="slider-container">
            <div class="slide active">
                <img src="${pageContext.request.contextPath}/assets/images/slider/slide1.jpg" alt="Slide 1">
                <div class="hero-content">
                    <h1>ยินดีต้อนรับสู่ระบบหลังบ้าน</h1>
                    <p>จัดการสินค้า สต็อก และคำสั่งซื้อได้อย่างมีประสิทธิภาพ</p>
                </div>
            </div>
            <div class="slide">
                <img src="${pageContext.request.contextPath}/assets/images/slider/slide2.jpg" alt="Slide 2">
                <div class="hero-content">
                    <h1>ตรวจสอบยอดขาย</h1>
                    <p>ติดตามสถานะการโอนและจัดเตรียมสินค้าเพื่อลูกค้าของคุณ</p>
                </div>
            </div>
        </div>
    </div>

    <div class="dashboard-actions">
        <a href="AddProduct" class="action-card add">
            <i class="fas fa-plus-circle action-icon"></i>
            <span class="action-title">ลงขายสินค้า</span>
            <span class="action-desc">เพิ่มปลาสายพันธุ์ใหม่</span>
        </a>
        <a href="SellerOrders" class="action-card orders">
            <i class="fas fa-box-open action-icon"></i>
            <span class="action-title">รายการคำสั่งซื้อ</span>
            <span class="action-desc">ตรวจสอบออเดอร์ใหม่</span>
        </a>
        <a href="#" class="action-card slips">
            <i class="fas fa-file-invoice-dollar action-icon"></i>
            <span class="action-title">ตรวจสอบสลิป</span>
            <span class="action-desc">ยืนยันการชำระเงิน</span>
        </a>
        
        <a href="ManageCoupons" class="action-card coupons">
            <i class="fas fa-tags action-icon"></i>
            <span class="action-title">จัดการคูปอง</span>
            <span class="action-desc">สร้างส่วนลด/โปรโมชั่น</span>
        </a>
    </div>

    <div class="container">
        <div class="section-header">
            <div>
                <h2 class="section-title"><i class="fas fa-store-alt"></i> สินค้าในร้านของคุณ</h2>
                <span class="section-subtitle">จัดการรายการสินค้า ตรวจสอบสต็อก และแก้ไขข้อมูล</span>
            </div>
            <a href="AddProduct" class="menu-btn add-product-btn">
                <i class="fas fa-plus-circle"></i> เพิ่มสินค้า
            </a>
        </div>

        <div class="filter-container" style="background: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); margin-bottom: 25px; display: flex; flex-wrap: wrap; gap: 15px; align-items: center;">
            <form action="SellerCenter" method="get" style="display: flex; gap: 15px; width: 100%; flex-wrap: wrap;">
                
                <div style="flex: 1; min-width: 200px; position: relative;">
                    <i class="fas fa-search" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #888;"></i>
                    <input type="text" name="search" placeholder="ค้นหาชื่อสินค้า..." value="<c:out value='${paramSearch}' />"
                           style="width: 100%; padding: 10px 10px 10px 40px; border: 1px solid #ddd; border-radius: 50px; outline: none; box-sizing: border-box;">
                </div>

                <div style="min-width: 180px;">
                    <select name="category" onchange="this.form.submit()" 
                            style="width: 100%; padding: 10px 20px; border: 1px solid #ddd; border-radius: 50px; outline: none; cursor: pointer; background: white;">
                        <option value="all">📁 หมวดหมู่ทั้งหมด</option>
                        <c:forEach items="${speciesList}" var="sp">
                            <option value="<c:out value="${sp.speciesId}" />"${paramCategory == sp.speciesId ? 'selected' : ''}>
                                <c:out value="${sp.speciesName}" />
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <button type="submit" style="background: #00571d; color: white; border: none; padding: 10px 25px; border-radius: 50px; cursor: pointer; font-weight: bold; transition: 0.3s;">
                    ค้นหา
                </button>
                
                <c:if test="${not empty paramSearch or (not empty paramCategory and paramCategory != 'all')}">
                    <a href="SellerCenter" style="padding: 10px 15px; color: #dc3545; text-decoration: none; display: flex; align-items: center;">
                        <i class="fas fa-times-circle"></i> ล้างค่า
                    </a>
                </c:if>
            </form>
        </div>

        <div class="product-grid">
            <c:choose>
                <c:when test="${not empty products}">
                    <c:forEach items="${products}" var="p">
                        <div class="product-card" data-aos="fade-up" data-aos-duration="1000">
                            <div class="product-img-box">
                                <c:choose>
                                    <c:when test="${p.productImg.startsWith('assets')}">
                                        <img src="${pageContext.request.contextPath}/${p.productImg}" alt="${p.productName}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/displayImage?name=${p.productImg}" alt="${p.productName}">
                                    </c:otherwise>
                                </c:choose>

                                <c:if test="${p.newProduct && p.stock > 0 && p.productStatus != 'Inactive'}">
                                    <div class="new-badge">สินค้าใหม่</div>
                                </c:if>

                                <c:if test="${p.productStatus == 'Inactive'}">
                                    <div style="position: absolute; top: 10px; left: 10px; background: rgba(108, 117, 125, 0.9); color: white; padding: 4px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; z-index: 5;">
                                        <i class="fas fa-pause-circle"></i> พักการขาย
                                    </div>
                                </c:if>

                                <c:if test="${p.stock <= 0}">
                                    <div style="position: absolute; top: 10px; left: 10px; background: rgba(220, 53, 69, 0.9); color: white; padding: 4px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; z-index: 5;">
                                        <i class="fas fa-times-circle"></i> สินค้าหมด
                                    </div>
                                </c:if>

                                <div class="card-actions">
                                    <a href="ProductDetail?pid=${p.productId}" class="btn-circle" title="ดูรายละเอียด" style="background-color: #17a2b8; color: white;">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="EditProduct?id=${p.productId}" class="btn-circle btn-edit" title="แก้ไข">
                                        <i class="fas fa-pen"></i>
                                    </a>
                                    <a href="DeleteProduct?id=${p.productId}" class="btn-circle btn-delete" title="ลบ" onclick="confirmDelete(event, this.href);">
                                        <i class="fas fa-trash-alt"></i>
                                    </a>
                                </div>
                                <div class="stock-tag"><i class="fas fa-box"></i> เหลือ ${p.stock}</div>
                            </div>

                            <div class="product-info">
                                <h3 class="product-name"><c:out value="${p.productName}" /></h3>
                                <small style="color: #999; font-size: 12px; display: block; margin-bottom: 5px;">
                                   <div class="rating-container" style="margin-bottom: 8px;">
                                        <c:set var="rating" value="${productRatings[p.productId]}" />
                                        <span style="color: #ffc107; font-size: 13px;">
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${rating >= i}">
                                                        <i class="fas fa-star"></i>
                                                    </c:when>
                                                    <c:when test="${rating >= i - 0.5}">
                                                        <i class="fas fa-star-half-alt"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="far fa-star"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </span>
                                        <span style="font-size: 11px; color: #777; margin-left: 3px;">(${rating})</span>
                                    </div>
                                    ID: ${p.productId}
                                </small>
                                <div class="price">
                                    <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="฿"/>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-box-open empty-icon"></i>
                        <h2>ไม่พบสินค้า</h2>
                        <p>ลองเปลี่ยนคำค้นหา หรือเลือกหมวดหมู่อื่นดูนะครับ</p>
                        <a href="SellerCenter" style="color: #00571d; margin-top: 10px; display: inline-block;">ดูสินค้าทั้งหมด</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <footer class="site-footer">
        <p>&copy; 2025 Fish Online Shop. All rights reserved.</p>
    </footer>

    <script>
      document.addEventListener("DOMContentLoaded", () => {
        const slides = document.querySelectorAll(".slide");
        let current = 0;
        if(slides.length > 0) {
            setInterval(() => {
              slides[current].classList.remove("active");
              current = (current + 1) % slides.length;
              slides[current].classList.add("active");
            }, 5000);
        }
      });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
    function confirmDelete(event, url) {
        event.preventDefault(); 

        Swal.fire({
            title: 'ยืนยันการลบ?',
            text: "สินค้านี้จะถูกลบออกจากร้านของคุณและไม่สามารถกู้คืนได้!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#e53e3e',  
            cancelButtonColor: '#718096',   
            confirmButtonText: 'ใช่, ลบเลย!',
            cancelButtonText: 'ยกเลิก',
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
                text: 'สินค้านี้ไม่มีประวัติการซื้อขาย จึงถูกลบออกจากระบบ',
                showConfirmButton: false,
                timer: 2000
            });
        } 
        else if (msg === 'archived') {
            Swal.fire({
                icon: 'info',
                title: 'พักการขายสินค้าแล้ว',
                text: 'สินค้านี้มีประวัติการสั่งซื้อ ไม่สามารถลบถาวรได้ ระบบได้เปลี่ยนสถานะเป็น "พักการขาย" แทน',
                confirmButtonColor: '#3085d6'
            });
        } 
        else if (msg === 'saved' || msg === 'success') {
            Swal.fire({
                icon: 'success',
                title: 'บันทึกสำเร็จ!',
                showConfirmButton: false,
                timer: 1500
            });
        }
        else if (msg === 'login_success') {
            Swal.fire({
                icon: 'success',
                title: 'เข้าสู่ระบบสำเร็จ!',
                text: 'ยินดีต้อนรับเข้าสู่ระบบ',
                showConfirmButton: false,
                timer: 1500, 
                position: 'center'
            }).then(() => {
                const newUrl = window.location.pathname;
                window.history.replaceState({}, document.title, newUrl);
            });
        }
        else if (error === 'deleteFailed') {
            Swal.fire({
                icon: 'error',
                title: 'เกิดข้อผิดพลาด',
                text: 'ไม่สามารถลบสินค้าได้ กรุณาลองใหม่',
                confirmButtonColor: '#d33'
            });
        }
    });
    </script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const urlParams = new URLSearchParams(window.location.search);
            const success = urlParams.get('success');

            if (success === 'added') {
                Swal.fire({
                    icon: 'success',
                    title: 'เพิ่มสินค้าสำเร็จ! 🎉',
                    text: 'สินค้าของคุณพร้อมวางจำหน่ายแล้ว',
                    confirmButtonColor: '#00571d',
                    confirmButtonText: 'ยอดเยี่ยม!',
                    timer: 3000,
                    timerProgressBar: true
                }).then(() => {
                    window.history.replaceState({}, document.title, window.location.pathname);
                });
            }
        });
    </script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const urlParams = new URLSearchParams(window.location.search);
            const success = urlParams.get('success');

            if (success === 'added') {
                Swal.fire({
                    icon: 'success',
                    title: 'เพิ่มสินค้าสำเร็จ! 🎉',
                    text: 'สินค้าของคุณพร้อมวางจำหน่ายแล้ว',
                    confirmButtonColor: '#00571d',
                    confirmButtonText: 'ยอดเยี่ยม!',
                    timer: 3000,
                    timerProgressBar: true
                }).then(() => {
                    window.history.replaceState({}, document.title, window.location.pathname);
                });
            } 
            else if (success === 'updated') {
                Swal.fire({
                    icon: 'success',
                    title: 'แก้ไขข้อมูลสำเร็จ! 📝',
                    text: 'ข้อมูลสินค้าได้รับการอัปเดตเรียบร้อยแล้ว',
                    confirmButtonColor: '#00571d',
                    confirmButtonText: 'ตกลง',
                    timer: 2000,
                    timerProgressBar: true
                }).then(() => {
                    window.history.replaceState({}, document.title, window.location.pathname);
                });
            }
        });
    </script>

</body>
</html>