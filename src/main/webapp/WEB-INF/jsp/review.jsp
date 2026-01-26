<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>เขียนรีวิวสินค้า | Fish Online</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/review.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

      <jsp:include page="navbar.jsp" />

    <div class="container main-container">
        <div class="review-card">
            
            <div class="product-info-section">
                <h2>ความรู้สึกของคุณต่อสินค้านี้</h2>
                <div class="product-preview">
                   <c:choose>
                        <c:when test="${product.productImg.startsWith('assets')}">
                            <img src="${pageContext.request.contextPath}/${product.productImg}" alt="${product.productName}">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/displayImage?name=${product.productImg}" alt="${product.productName}">
                        </c:otherwise>
                    </c:choose>
                    <div class="product-text">
                        <h3>${product.productName}</h3>
                        <p>${product.species.speciesName}</p>
                    </div>
                </div>
            </div>

            <form action="saveReview" method="post" class="review-form">
                <input type="hidden" name="productId" value="${product.productId}">

                <div class="rating-box">
                    <label>ให้คะแนนสินค้า</label>
                    <div class="stars">
                        <input type="radio" id="star5" name="rating" value="5" required /><label for="star5" title="ยอดเยี่ยม"></label>
                        <input type="radio" id="star4" name="rating" value="4" /><label for="star4" title="ดีมาก"></label>
                        <input type="radio" id="star3" name="rating" value="3" /><label for="star3" title="ปานกลาง"></label>
                        <input type="radio" id="star2" name="rating" value="2" /><label for="star2" title="พอใช้"></label>
                        <input type="radio" id="star1" name="rating" value="1" /><label for="star1" title="แย่"></label>
                    </div>
                </div>

                <div class="comment-box">
                    <label>ความคิดเห็นเพิ่มเติม</label>
                    <textarea name="comment" rows="5" placeholder="บอกเล่าประสบการณ์ของคุณเกี่ยวกับสินค้าตัวนี้... (เช่น สุขภาพปลา, การแพ็คของ, สีสัน)"></textarea>
                </div>

                <button type="submit" class="btn-submit">ส่งรีวิว</button>
            </form>

        </div>
    </div>

</body>
</html>