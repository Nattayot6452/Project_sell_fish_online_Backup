<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>แจ้งชำระเงิน | Fish Online</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/uploadSlip.css">
    <link rel="stylesheet" type="text/css" href="assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="container main-container">
        
        <div class="upload-card">
            <div class="card-header">
                <h1><i class="fas fa-file-invoice-dollar"></i> แจ้งชำระเงิน</h1>
                <p>คำสั่งซื้อหมายเลข: <span class="order-id">#${orderId}</span></p>
            </div>

            <form action="doUploadSlip" method="post" enctype="multipart/form-data" class="upload-form">
                
                <input type="hidden" name="orderId" value="${orderId}">
                
                <div class="upload-area">
                    <label for="slipImage" class="upload-label">
                        <div class="icon-cloud"><i class="fas fa-cloud-upload-alt"></i></div>
                        <span id="file-name">คลิกเพื่อเลือกรูปภาพสลิป หรือลากไฟล์มาวางที่นี่</span>
                        <small>รองรับไฟล์ JPG, PNG, JPEG</small>
                    </label>
                    <input type="file" name="slipImage" id="slipImage" accept="image/*" required>
                </div>

                <div class="image-preview-container" id="preview-container" style="display: none;">
                    <p>ตัวอย่างรูปภาพ:</p>
                    <img id="image-preview" src="#" alt="Image Preview">
                </div>

                <c:if test="${not empty uploadError}">
                    <div class="error-msg">
                        <i class="fas fa-exclamation-circle"></i> ${uploadError}
                    </div>
                </c:if>

                <div class="action-buttons">
                    <button type="submit" class="btn-confirm">
                        <i class="fas fa-paper-plane"></i> ยืนยันการแจ้งโอน
                    </button>
                    <a href="Orders" class="btn-cancel">ยกเลิก</a>
                </div>
            </form>
        </div>

    </div>

    <footer class="site-footer">
        <p>&copy; 2025 Fish Online Shop. All rights reserved.</p>
    </footer>

    <script>
        const fileInput = document.getElementById('slipImage');
        const fileNameDisplay = document.getElementById('file-name');
        const previewContainer = document.getElementById('preview-container');
        const imagePreview = document.getElementById('image-preview');

        fileInput.addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {

                fileNameDisplay.innerText = "ไฟล์ที่เลือก: " + file.name;
                fileNameDisplay.style.color = "#00571d";
                fileNameDisplay.style.fontWeight = "bold";

                const reader = new FileReader();
                reader.onload = function(e) {
                    imagePreview.src = e.target.result;
                    previewContainer.style.display = "block";
                }
                reader.readAsDataURL(file);
            } else {
                fileNameDisplay.innerText = "คลิกเพื่อเลือกรูปภาพสลิป หรือลากไฟล์มาวางที่นี่";
                fileNameDisplay.style.color = "#666";
                previewContainer.style.display = "none";
            }
        });
    </script>

</body>
</html>