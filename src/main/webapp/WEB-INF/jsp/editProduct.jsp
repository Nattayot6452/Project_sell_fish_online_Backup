<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>แก้ไขสินค้า | Seller Center</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/addProduct.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
        <jsp:include page="loading.jsp" />

        <jsp:include page="sellerNavbar.jsp" />

    <div class="container main-container">
        
        <div class="form-card">
            <div class="card-header" style="background-color: #ffc107;"> <h1 style="color: #333;"><i class="fas fa-pen"></i> แก้ไขสินค้า</h1>
                <p style="color: #555;">แก้ไขข้อมูลรายละเอียดสินค้า: <c:out value="${product.productName}" /></p>
            </div>

            <form action="updateProduct" method="post" enctype="multipart/form-data" class="product-form">
                
                <%-- ⚠️ สำคัญ: ต้องส่ง ID และ Path รูปเก่าไปด้วย --%>
                <input type="hidden" name="productId" value="${product.productId}">
                <input type="hidden" name="oldImage" value="${product.productImg}">

                <div class="form-section">
                    <h3>📦 ข้อมูลทั่วไป</h3>
                    <div class="form-group">
                        <label>ชื่อสินค้า <span class="required">*</span></label>
                        <input type="text" name="productName" value="<c:out value="${product.productName}" />" required>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>หมวดหมู่ (Species) <span class="required">*</span></label>
                            <select name="speciesId" required>
                                <option value="" disabled>-- เลือกสายพันธุ์ --</option>
                                <c:set var="pid" value="${product.species.speciesId}"/>
                                <option value="SP001" ${pid == 'SP001' ? 'selected' : ''}>ปลากัดไทย (Betta)</option>
                                <option value="SP002" ${pid == 'SP002' ? 'selected' : ''}>ปลาหางนกยูง (Guppy)</option>
                                <option value="SP003" ${pid == 'SP003' ? 'selected' : ''}>ปลาทอง (Goldfish)</option>
                                <option value="SP004" ${pid == 'SP004' ? 'selected' : ''}>ปลาเนออน (Tetra)</option>
                                <option value="SP005" ${pid == 'SP005' ? 'selected' : ''}>ปลาเทวดา (Angelfish)</option>
                                <option value="SP006" ${pid == 'SP006' ? 'selected' : ''}>ปลาดิสคัส (Discus)</option>
                                <option value="SP007" ${pid == 'SP007' ? 'selected' : ''}>ปลาแพะ (Corydoras)</option>
                                <option value="SP008" ${pid == 'SP008' ? 'selected' : ''}>ปลาดูดตะไคร่ (Otocinclus)</option>
                                <option value="SP009" ${pid == 'SP009' ? 'selected' : ''}>ปลามอลลี่ (Molly)</option>
                                <option value="SP010" ${pid == 'SP010' ? 'selected' : ''}>ปลาดาบ (Swordtail)</option>
                                <option value="SP011" ${pid == 'SP011' ? 'selected' : ''}>ปลาม้าลาย (Zebra Danio)</option>
                                <option value="SP012" ${pid == 'SP012' ? 'selected' : ''}>ปลากูรามิแคระ (Dwarf Gourami)</option>
                                <option value="SP013" ${pid == 'SP013' ? 'selected' : ''}>ปลาราสโบรา (Rasbora)</option>
                                <option value="SP014" ${pid == 'SP014' ? 'selected' : ''}>ปลาคาร์ดินัล (Cardinal Tetra)</option>
                                <option value="SP015" ${pid == 'SP015' ? 'selected' : ''}>ปลาตู้น้ำ (Clown Loach)</option>
                                <option value="SP016" ${pid == 'SP016' ? 'selected' : ''}>ปลาสายรุ้ง (Rainbowfish)</option>
                                <option value="SP017" ${pid == 'SP017' ? 'selected' : ''}>ปลาคูห์ลี่ (Kuhli Loach)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>ราคา (บาท) <span class="required">*</span></label>
                            <input type="number" name="price" min="1" value="${product.price}" required>
                        </div>
                        <div class="form-group">
                            <label>จำนวนสต็อก <span class="required">*</span></label>
                            <input type="number" name="stock" min="0" value="${product.stock}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>รายละเอียดสินค้า</label>
                        <textarea name="description" rows="4"><c:out value="${product.description}" /></textarea>
                    </div>
                </div>

                <div class="form-section">
                    <h3>🧬 ข้อมูลจำเพาะ (Specifics)</h3>
                    <div class="form-row">
                        <div class="form-group">
                            <label>ขนาด (Size)</label>
                            <input type="text" name="size" value="<c:out value="${product.size}" />">
                        </div>
                        <div class="form-group">
                            <label>ถิ่นกำเนิด (Origin)</label>
                            <input type="text" name="origin" value="<c:out value="${product.origin}" />">
                        </div>
                        <div class="form-group">
                            <label>อายุขัยเฉลี่ย (ปี)</label>
                            <input type="number" name="lifeSpan" value="${product.lifeSpan}">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>อุณหภูมิน้ำ</label>
                            <input type="text" name="temperature" value="<c:out value="${product.temperature}" />">
                        </div>
                        <div class="form-group">
                            <label>ประเภทน้ำ</label>
                            <input type="text" name="waterType" value="<c:out value="${product.waterType}" />">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>ระดับการดูแล</label>
                            <select name="careLevel">
                                <option value="A" ${product.careLevel == 'A' ? 'selected' : ''}>ง่าย (Easy)</option>
                                <option value="B" ${product.careLevel == 'B' ? 'selected' : ''}>ปานกลาง (Medium)</option>
                                <option value="C" ${product.careLevel == 'C' ? 'selected' : ''}>ยาก (Hard)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>นิสัยก้าวร้าว?</label>
                            <select name="isAggressive">
                                <option value="N" ${product.isAggressive == 'N' ? 'selected' : ''}>ไม่ (No)</option>
                                <option value="Y" ${product.isAggressive == 'Y' ? 'selected' : ''}>ใช่ (Yes)</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <h3>📷 รูปภาพสินค้า (อัปโหลดใหม่เพื่อเปลี่ยน)</h3>
                    <div class="image-upload-box">
                        <input type="file" name="productImage" id="productImage" accept="image/*" onchange="previewImage(event)">
                        
                        <div class="upload-placeholder" id="uploadPlaceholder" style="display: none;">
                            <i class="fas fa-cloud-upload-alt"></i>
                            <p>คลิกเพื่อเปลี่ยนรูปภาพ</p>
                        </div>
                        
                        <c:choose>
                            <c:when test="${product.productImg.startsWith('assets')}">
                                <img id="imagePreview" class="image-preview" src="${pageContext.request.contextPath}/${product.productImg}" style="display: block;">
                            </c:when>
                            <c:otherwise>
                                <img id="imagePreview" class="image-preview" src="${pageContext.request.contextPath}/${product.productImg.startsWith('assets') ? '' : 'displayImage?name='}${product.productImg}" style="display: block;">
                            </c:otherwise>
                        </c:choose>
                        
                        <p style="text-align: center; margin-top: 10px; color: #888; font-size: 13px;">* หากไม่ต้องการเปลี่ยนรูป ให้เว้นว่างไว้</p>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-save" style="background-color: #ffc107; color: #333;"><i class="fas fa-save"></i> บันทึกการแก้ไข</button>
                    <a href="SellerCenter" class="btn-cancel">ยกเลิก</a>
                </div>

            </form>
        </div>
    </div>

    <script>
        function previewImage(event) {
            const reader = new FileReader();
            reader.onload = function(){
                const output = document.getElementById('imagePreview');
                output.src = reader.result;
                output.style.display = 'block';
            };
            if(event.target.files[0]){
                reader.readAsDataURL(event.target.files[0]);
            }
        }
    </script>

</body>
</html>