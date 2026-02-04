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
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
                        <h3><c:out value="${product.productName}" /></h3>
                        <p><c:out value="${product.species.speciesName}" /></p>
                    </div>
                </div>
            </div>

            <form action="saveReview" method="post" class="review-form" id="reviewForm">
                <input type="hidden" name="productId" value="${product.productId}">
                
                <input type="hidden" name="orderId" value="${orderId}">

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
                    <textarea name="comment" id="comment" rows="5" 
                              placeholder="บอกเล่าประสบการณ์ของคุณ... (ขั้นต่ำ 10 ตัวอักษร)"
                              required
                              minlength="10"
                              maxlength="200"
                              oninput="sanitizeComment(this); countChars(this);"></textarea>
                    
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <small style="color: gray;">* ห้ามใช้คำหยาบคาย</small>
                        <small id="charCount" style="color: #666;">0 / 200</small>
                    </div>
                </div>

                <button type="submit" class="btn-submit">ส่งรีวิว</button>
            </form>

        </div>
    </div>

    <script>

        function sanitizeComment(input) {
            input.value = input.value.replace(/[<>"']/g, '');
        }

        function countChars(input) {
            var maxLength = 200;
            var currentLength = input.value.length;
            document.getElementById("charCount").innerText = currentLength + " / " + maxLength;
            
            if (currentLength >= maxLength) {
                document.getElementById("charCount").style.color = "red";
            } else {
                document.getElementById("charCount").style.color = "#666";
            }
        }

        document.addEventListener("DOMContentLoaded", function() {
            const urlParams = new URLSearchParams(window.location.search);
            const error = urlParams.get('error');

            if (error === 'profanity') {
                Swal.fire({
                    icon: 'warning',
                    title: 'พบคำไม่เหมาะสม',
                    text: 'กรุณาใช้ถ้อยคำสุภาพในการรีวิวสินค้า',
                    confirmButtonColor: '#f27474',
                    confirmButtonText: 'แก้ไข'
                });
            } else if (error === 'length') { 
                Swal.fire({
                    icon: 'info',
                    title: 'ข้อความสั้น/ยาวเกินไป',
                    text: 'กรุณาเขียนรีวิวระหว่าง 10 - 200 ตัวอักษร',
                    confirmButtonColor: '#3182ce',
                    confirmButtonText: 'ตกลง'
                });
            } else if (error === 'server') {
                Swal.fire({
                    icon: 'error',
                    title: 'เกิดข้อผิดพลาด',
                    text: 'ไม่สามารถบันทึกรีวิวได้ กรุณาลองใหม่อีกครั้ง',
                    confirmButtonColor: '#d33'
                });
            } else if (error === 'empty') {
                 Swal.fire({
                    icon: 'warning',
                    title: 'ข้อมูลไม่ครบถ้วน',
                    text: 'กรุณากรอกความคิดเห็น',
                    confirmButtonColor: '#f9e547',
                     color: '#333'
                });
            }
        });
    </script>

</body>
</html>