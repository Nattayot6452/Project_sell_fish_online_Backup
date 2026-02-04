<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>โปรโมชั่นและโค้ดส่วนลด | Fish Online</title>
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/promotions.css">
    
    <style>
        .coupon-ticket.disabled {
            filter: grayscale(100%);
            opacity: 0.7;
            pointer-events: none;
            background: #f0f0f0;
        }
        
        .coupon-ticket.disabled .btn-copy {
            display: none;
        }

        .status-alert {
            color: #dc3545;
            font-weight: bold;
            font-size: 0.9em;
            margin-top: 5px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .usage-stat {
            font-size: 0.8em;
            color: #666;
            margin-top: 10px;
            background: #f8f9fa;
            padding: 5px 10px;
            border-radius: 4px;
            display: inline-block;
        }
        .usage-stat i { color: #007bff; margin-right: 3px; }
    </style>
</head>
<body style="background-color: #f4f6f9;">

    <jsp:include page="loading.jsp" />
    <jsp:include page="navbar.jsp" />

    <div class="promo-banner">
        <h1><i class="fas fa-gift"></i> Promotion Center</h1>
        <p>เก็บโค้ดส่วนลดสุดคุ้ม ช้อปเลยที่ Fish Online!</p>
    </div>

    <div class="promo-container">
        
        <div class="coupon-grid">
            <c:choose>
                <c:when test="${empty coupons}">
                    <div class="no-coupon">
                        <i class="far fa-sad-tear" style="font-size: 60px; margin-bottom: 20px;"></i>
                        <h3>ขออภัย ขณะนี้ยังไม่มีโปรโมชั่น</h3>
                        <p>โปรดติดตามอัปเดตเร็วๆ นี้</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${coupons}" var="c">
                        
                        <c:set var="isDisabled" value="${c.expired || c.soldOut}" />
                        
                        <div class="coupon-ticket ${c.displayType} ${isDisabled ? 'disabled' : ''}">
                            
                            <div class="coupon-left">
                                <span class="discount-val">${c.displayDiscount}</span>
                                <span class="discount-label">ส่วนลด</span>
                            </div>

                            <div class="coupon-right">
                                <div class="coupon-title">${c.displayTitle}</div>
                                <div class="coupon-desc">${c.displayDesc}</div>
                                
                                <div class="usage-stat">
                                    <i class="fas fa-users"></i> ใช้แล้ว: ${c.usageCount} / เหลือ: ${c.remainingCount}
                                </div>

                                <div class="copy-section" style="margin-top: 10px;">
                                    <c:choose>
                                        <c:when test="${c.expired}">
                                            <div class="status-alert"><i class="fas fa-exclamation-circle"></i> หมดอายุแล้ว</div>
                                        </c:when>
                                        <c:when test="${c.soldOut}">
                                            <div class="status-alert"><i class="fas fa-times-circle"></i> สิทธิครบแล้ว</div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="coupon-code" id="code-${c.couponCode}">${c.couponCode}</span>
                                            <button class="btn-copy" onclick="copyCode('${c.couponCode}')">
                                                <i class="far fa-copy"></i> คัดลอก
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function copyCode(code) {
            navigator.clipboard.writeText(code).then(() => {
                Swal.fire({
                    icon: 'success',
                    title: 'คัดลอกโค้ดสำเร็จ!',
                    text: 'รหัส: ' + code,
                    showConfirmButton: false,
                    timer: 1500,
                    backdrop: `rgba(0,0,123,0.4)`
                });
            }).catch(err => {
                console.error('Failed to copy: ', err);
            });
        }
    </script>

</body>
</html>