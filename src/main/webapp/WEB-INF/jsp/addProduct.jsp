<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>เพิ่มสินค้าใหม่ | Seller Center</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/addProduct.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <jsp:include page="loading.jsp" />
    
    <jsp:include page="sellerNavbar.jsp" />

    <div class="container main-container">
        
        <div class="form-card">
            <div class="card-header">
                <h1><i class="fas fa-plus-circle"></i> เพิ่มสินค้าใหม่</h1>
                <p>กรอกข้อมูลรายละเอียดสินค้าของคุณให้ครบถ้วน</p>
            </div>

            <form action="saveProduct" method="post" enctype="multipart/form-data" class="product-form">
                
                <div class="form-section">
                    <h3>📦 ข้อมูลทั่วไป</h3>
                    <div class="form-group">
                        <label>ชื่อสินค้า <span class="required">*</span></label>
                        <input type="text" name="productName" placeholder="เช่น ปลากัดจีน สีแดงสด" required value="<c:out value='${param.productName}' />">                   
                        </div>
                    <div class="form-row">
                       <div class="form-group">
                            <label>หมวดหมู่ (Species) <span class="required">*</span></label>
                          <select name="speciesId" required>
                                <option value="" disabled selected>-- เลือกสายพันธุ์ --</option>
                                
                                <c:forEach items="${speciesList}" var="spec">
                                    <option value="${spec.speciesId}">
                                        ${spec.speciesName}
                                    </option>
                                </c:forEach>
                                
                            </select>
                        </div>
                        <div class="form-group">
                            <label>ราคา (บาท) <span class="required">*</span></label>
                            <input type="number" name="price" min="1" placeholder="0.00" required>
                        </div>
                        <div class="form-group">
                            <label>จำนวนสต็อก <span class="required">*</span></label>
                            <input type="number" name="stock" min="1" placeholder="จำนวนตัว" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>รายละเอียดสินค้า</label>
                        <textarea name="description" rows="4" placeholder="อธิบายจุดเด่น สีสัน หรือลักษณะพิเศษของปลาตัวนี้..."><c:out value="${param.description}" /></textarea>
                    </div>
                </div>

                <div class="form-section">
                    <h3>🧬 ข้อมูลจำเพาะ (Specifics)</h3>
                    <div class="form-row">
                        <div class="form-group">
                            <label>ขนาด (Size)</label>
                            <input type="text" name="size" placeholder="เช่น 3-4 cm" value="<c:out value='${param.size}' />">
                        </div>
                        <div class="form-group">
                            <label>ถิ่นกำเนิด (Origin)</label>
                            <input type="text" name="origin" placeholder="เช่น Thailand" value="<c:out value='${param.origin}' />">
                        </div>
                        <div class="form-group">
                            <label>อายุขัยเฉลี่ย (ปี)</label>
                            <input type="number" name="lifeSpan" placeholder="เช่น 2">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>อุณหภูมิน้ำ</label>
                                <input type="text" name="temperature" placeholder="เช่น 24-28°C" value="<c:out value='${param.temperature}' default='24-28°C' />">                        </div>
                        <div class="form-group">
                            <label>ประเภทน้ำ</label>
                                <input type="text" name="waterType" value="<c:out value='${param.waterType}' default='Freshwater' />">                        
                            </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>ระดับการดูแล</label>
                            <select name="careLevel">
                                <option value="A">ง่าย (Easy)</option>
                                <option value="B">ปานกลาง (Medium)</option>
                                <option value="C">ยาก (Hard)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>นิสัยก้าวร้าว?</label>
                            <select name="isAggressive">
                                <option value="N">ไม่ (No)</option>
                                <option value="Y">ใช่ (Yes)</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <h3>📷 รูปภาพสินค้า</h3>
                    
                    <div class="form-group">
                        <label>รูปภาพหลัก (รูปปก) <span class="required">*</span></label>
                        <div class="image-upload-box">
                            <input type="file" name="productImage" id="productImage" accept="image/*" required onchange="previewImage(event, 'imagePreview', 'uploadPlaceholder')">
                            <div class="upload-placeholder" id="uploadPlaceholder">
                                <i class="fas fa-cloud-upload-alt"></i>
                                <p>คลิกเพื่ออัปโหลดรูปภาพหลัก</p>
                                <span>รองรับไฟล์ JPG, PNG</span>
                            </div>
                            <img id="imagePreview" class="image-preview" style="display: none;">
                        </div>
                    </div>

                    <div class="form-group" style="margin-top: 20px;">
                        <label>รูปภาพเพิ่มเติม (เลือกได้หลายรูป)</label>
                        <div class="image-upload-box" style="border-style: dashed; border-color: #cbd5e0;">
                            <input type="file" name="extraImages" id="extraImages" accept="image/*" multiple onchange="previewMultipleImages(event)">
                            <div class="upload-placeholder" id="extraPlaceholder">
                                <i class="fas fa-images"></i>
                                <p>กด Ctrl ค้างไว้เพื่อเลือกหลายรูป</p>
                                <span>(Optional)</span>
                            </div>
                        </div>
                        <div id="galleryPreview" style="display: flex; gap: 10px; flex-wrap: wrap; margin-top: 10px;"></div>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-save"><i class="fas fa-check"></i> บันทึกสินค้า</button>
                    <a href="SellerCenter" class="btn-cancel">ยกเลิก</a>
                </div>

            </form>
        </div>
    </div>
    <script>
            function previewImage(event, imgId, placeholderId) {
                const reader = new FileReader();
                reader.onload = function(){
                const output = document.getElementById(imgId);
                const placeholder = document.getElementById(placeholderId);
                output.src = reader.result;
                output.style.display = 'block';
                    placeholder.style.display = 'none';
                };
                    if (event.target.files[0]) {
                            reader.readAsDataURL(event.target.files[0]);
                        }
                    }

                    function previewMultipleImages(event) {
                        const files = event.target.files;
                        const previewContainer = document.getElementById('galleryPreview');
                        previewContainer.innerHTML = ""; 

                        if (files) {

                            document.getElementById('extraPlaceholder').style.display = 'none';

                            Array.from(files).forEach(file => {
                                const reader = new FileReader();
                                reader.onload = function(e) {
                                    const img = document.createElement('img');
                                    img.src = e.target.result;
                                    img.style.width = "80px";
                                    img.style.height = "80px";
                                    img.style.objectFit = "cover";
                                    img.style.borderRadius = "5px";
                                    img.style.border = "1px solid #ddd";
                                    previewContainer.appendChild(img);
                                }
                                reader.readAsDataURL(file);
                            });
                        }
                    }
        </script>

</body>
</html>