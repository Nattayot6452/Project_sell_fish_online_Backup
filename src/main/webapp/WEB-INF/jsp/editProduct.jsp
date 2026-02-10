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
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<style>
    .status-active {
        background-color: #e8f5e9 !important;
        color: #2e7d32 !important;
        font-weight: bold !important;
        border: 1px solid #c8e6c9;
    }

    .status-inactive {
        background-color: #ffebee !important;
        color: #c62828 !important;
        font-weight: bold !important;
        border: 1px solid #ffcdd2;
    }
</style>

<body>
    <jsp:include page="loading.jsp" />
    <jsp:include page="sellerNavbar.jsp" />

    <div class="container main-container">
        
        <div class="form-card">
            <div class="card-header" style="background-color: #ffc107;"> 
                <h1 style="color: #333;"><i class="fas fa-pen"></i> แก้ไขสินค้า</h1>
                <p style="color: #555;">แก้ไขข้อมูลรายละเอียดสินค้า: <c:out value="${product.productName}" /></p>
            </div>

            <form action="updateProduct" method="post" enctype="multipart/form-data" class="product-form" id="editProductForm">
                
                <input type="hidden" name="productId" value="${product.productId}">
                <input type="hidden" name="oldImage" value="${product.productImg}">

                <div class="form-section">
                    <h3>📦 ข้อมูลทั่วไป</h3>
                    <div class="form-group">
                        <label>ชื่อสินค้า <span class="required">*</span></label>
                        <input type="text" name="productName" 
                               value="<c:out value="${product.productName}" />" 
                               required
                               pattern="^[a-zA-Z0-9ก-๙\s\-_()]+$"
                               title="กรุณากรอกเฉพาะภาษาไทย อังกฤษ ตัวเลข และ - _ ( )"
                               oninput="sanitizeName(this)">
                    </div>
                    
                    <div class="form-group">
                        <label>หมวดหมู่ (Species) <span class="required">*</span></label>
                        <select name="speciesId" required>
                            <option value="" disabled>-- เลือกสายพันธุ์ --</option>
                            <c:forEach items="${speciesList}" var="spec">
                                <option value="${spec.speciesId}" ${product.species.speciesId == spec.speciesId ? 'selected' : ''}>${spec.speciesName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>ราคา <span class="required">*</span></label>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <input type="number" name="price" min="1" step="0.01" value="${product.price}" required style="flex: 1;">
                                <span style="color: #555; font-weight: bold; min-width: 30px;">บาท</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>จำนวนสต็อก <span class="required">*</span></label>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <input type="number" name="stock" min="0" value="${product.stock}" required style="flex: 1;">
                                <span style="color: #555; font-weight: bold; min-width: 30px;">ตัว</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>สถานะสินค้า (Status)</label>
                        <select name="productStatus" 
                                class="form-control ${product.productStatus == 'Inactive' ? 'status-inactive' : 'status-active'}"
                                onchange="this.className = (this.value == 'Inactive' ? 'status-inactive' : 'status-active')">
                            <option value="Active" ${product.productStatus == 'Active' ? 'selected' : ''}>🟢 เปิดขายปกติ (Active)</option>
                            <option value="Inactive" ${product.productStatus == 'Inactive' ? 'selected' : ''}>🔴 พักการขาย (Inactive)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>รายละเอียดสินค้า <span class="required">*</span></label>
                        <textarea name="description" rows="4" 
                                placeholder="อธิบายจุดเด่น... (ขั้นต่ำ 20 ตัวอักษร)"
                                required
                                minlength="20"
                                maxlength="255"
                                oninput="sanitizeDescription(this); countDescChars(this)"><c:out value="${product.description}" /></textarea>
                        <div style="text-align: right; margin-top: 5px;">
                            <small id="descCharCount" style="color: #666; font-size: 12px;">0 / 255</small>
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <h3>🧬 ข้อมูลจำเพาะ (Specifics)</h3>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>ขนาด (Size)</label>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <input type="text" name="size" value="<c:out value="${product.size}" />" oninput="sanitizeGeneral(this)" style="flex: 1;">
                                <span style="color: #555; font-weight: bold;">เซนติเมตร</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>ถิ่นกำเนิด (Origin)</label>
                            <input type="text" name="origin" value="<c:out value="${product.origin}" />" oninput="sanitizeGeneral(this)">
                        </div>
                        <div class="form-group">
                            <label>อายุขัยเฉลี่ย</label>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <input type="number" name="lifeSpan" value="${product.lifeSpan}" style="flex: 1;">
                                <span style="color: #555; font-weight: bold;">ปี</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>อุณหภูมิน้ำ</label>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <input type="text" name="temperature" value="<c:out value="${product.temperature}" />" oninput="sanitizeGeneral(this)" style="flex: 1;">
                                <span style="color: #555; font-weight: bold;">องศาเซลเซียส</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>ประเภทน้ำ</label>
                            <input type="text" name="waterType" value="<c:out value="${product.waterType}" />" oninput="sanitizeGeneral(this)">
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
                        <input type="file" name="productImage" id="productImage" accept="image/png, image/jpeg, image/jpg" onchange="validateAndPreview(event)">
                        
                        <div class="upload-placeholder" id="uploadPlaceholder" style="display: none;">
                            <i class="fas fa-cloud-upload-alt"></i>
                            <p>คลิกเพื่อเปลี่ยนรูปภาพ (Max 5MB)</p>
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

                    <div class="form-group" style="margin-top: 30px; border-top: 1px solid #eee; padding-top: 20px;">
                        <label style="font-weight: bold; margin-bottom: 10px; display: block; color: #333;">
                            <i class="fas fa-images"></i> รูปภาพประกอบเพิ่มเติม (Gallery)
                        </label>
                        
                        <div class="image-upload-box" style="border-style: dashed; border-color: #cbd5e0; min-height: 120px;">
                            <input type="file" name="extraImages" id="extraImages" accept="image/png, image/jpeg, image/jpg" multiple onchange="validateAndPreviewMultiple(event)">
                            <div class="upload-placeholder" id="extraPlaceholder">
                                <i class="fas fa-plus-square" style="font-size: 30px; color: #a0aec0;"></i>
                                <p style="margin-top: 10px;">คลิกเพื่อเลือกหลายรูป (กด Ctrl ค้างไว้)</p>
                                <span style="font-size: 12px; color: #999;">(รองรับไฟล์รูปภาพ Max 5MB/รูป)</span>
                            </div>
                        </div>
                        
                        <div id="galleryPreview" style="display: flex; gap: 10px; flex-wrap: wrap; margin-top: 15px;"></div>
                        
                        <c:if test="${not empty product.galleryImages}">
                            <div style="margin-top: 20px; background: #f8fafc; padding: 15px; border-radius: 8px; border: 1px solid #edf2f7;">
                                <small style="color: #555; font-weight: bold; display: block; margin-bottom: 10px;">
                                    <i class="fas fa-check-circle" style="color: green;"></i> รูปภาพปัจจุบันที่มีอยู่:
                                </small>
                                <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                                    <c:forEach items="${product.galleryImages}" var="img">
                                        <div style="position: relative;">
                                            <img src="${pageContext.request.contextPath}/${img.imagePath.startsWith('assets') ? '' : 'displayImage?name='}${img.imagePath}" 
                                                style="width: 80px; height: 80px; object-fit: cover; border-radius: 8px; border: 2px solid #fff; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
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

function sanitizeName(input) {
            input.value = input.value.replace(/[^a-zA-Z0-9ก-๙\s\-_()]/g, '');
        }
        function sanitizeDescription(input) {
            input.value = input.value.replace(/<[^>]*>?/gm, '');
        }
        function sanitizeGeneral(input) {
            input.value = input.value.replace(/[<>"']/g, '');
        }

        function validateAndPreview(event) {
            const file = event.target.files[0];
            if (!file) return;

            if (file.size > 5 * 1024 * 1024) {
                Swal.fire('ไฟล์ใหญ่เกินไป', 'กรุณาอัปโหลดรูปภาพขนาดไม่เกิน 5MB', 'warning');
                event.target.value = ""; 
                return;
            }

            if (!['image/jpeg', 'image/png', 'image/jpg'].includes(file.type)) {
                Swal.fire('ไฟล์ไม่ถูกต้อง', 'กรุณาอัปโหลดไฟล์รูปภาพ (JPG, PNG) เท่านั้น', 'warning');
                event.target.value = "";
                return;
            }

            const reader = new FileReader();
            reader.onload = function(){
                const output = document.getElementById('imagePreview');
                output.src = reader.result;
                output.style.display = 'block';
            };
            reader.readAsDataURL(file);
        }

        document.addEventListener("DOMContentLoaded", function() {
            const urlParams = new URLSearchParams(window.location.search);
            const error = urlParams.get('error');

            if (error) {
                let text = "เกิดข้อผิดพลาดในการแก้ไขสินค้า";
                if (error === 'invalidName') text = "ชื่อสินค้ามีอักขระที่ไม่ได้รับอนุญาต";
                else if (error === 'invalidNumber') text = "ราคาหรือจำนวนสต็อกไม่ถูกต้อง";
                else if (error === 'fileTooLarge') text = "รูปภาพมีขนาดใหญ่เกิน 5MB";
                else if (error === 'invalidFileType') text = "ประเภทไฟล์รูปภาพไม่ถูกต้อง";

                Swal.fire({
                    icon: 'error',
                    title: 'บันทึกไม่สำเร็จ',
                    text: text,
                    confirmButtonText: 'แก้ไข'
                });
            }
        });
    </script>

<script>
function countDescChars(input) {
        const maxLength = 255;
        const currentLength = input.value.length;
        const counter = document.getElementById('descCharCount');
        
        counter.innerText = currentLength + " / " + maxLength;

        if (currentLength < 20) {
            counter.style.color = "red";
        } else {
            counter.style.color = "#28a745"; 
        }
    }

    document.addEventListener("DOMContentLoaded", function() {
        const descInput = document.querySelector('textarea[name="description"]');
        if (descInput) {
            countDescChars(descInput);
        }
        
        const urlParams = new URLSearchParams(window.location.search);
        const error = urlParams.get('error');

        if (error === 'descLength') { 
            Swal.fire({
                icon: 'warning',
                title: 'รายละเอียดสั้น/ยาวเกินไป',
                text: 'กรุณากรอกรายละเอียดสินค้าระหว่าง 20 - 255 ตัวอักษร',
                confirmButtonText: 'แก้ไข'
            });
        }
    });

</script>

<script>
        function validateAndPreviewMultiple(event) {
            const files = event.target.files;
            const previewContainer = document.getElementById('galleryPreview');
            previewContainer.innerHTML = ""; 
            
            if (!files) return;

            let hasError = false;
            const validFiles = new DataTransfer();
            const MAX_FILE_SIZE = 5 * 1024 * 1024;

            Array.from(files).forEach(file => {
                if (file.size > MAX_FILE_SIZE) {
                    hasError = true;
                    return;
                }
                if (!['image/jpeg', 'image/png', 'image/jpg'].includes(file.type)) {
                    hasError = true;
                    return;
                }

                validFiles.items.add(file);

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

            if (hasError) {
                Swal.fire('บางไฟล์ไม่ผ่านเกณฑ์', 'ระบบคัดกรองเฉพาะไฟล์รูปภาพขนาดไม่เกิน 5MB', 'warning');
            }
            
            event.target.files = validFiles.files;

            if (validFiles.files.length > 0) {
                document.getElementById('extraPlaceholder').style.display = 'none';
            }
        }

</script>

<script>
    document.getElementById('editProductForm').addEventListener('submit', function(event) {
        event.preventDefault();

        Swal.fire({
            title: 'ยืนยันการแก้ไข?',
            text: "คุณต้องการบันทึกการเปลี่ยนแปลงนี้หรือไม่",
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#00571d',
            cancelButtonColor: '#d33',
            confirmButtonText: 'ใช่, บันทึกเลย',
            cancelButtonText: 'ยกเลิก',
        }).then((result) => {
            if (result.isConfirmed) {
                this.submit();
            }
        });
    });
</script>

</body>
</html>