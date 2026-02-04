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
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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

            <form action="saveProduct" method="post" enctype="multipart/form-data" class="product-form" id="addProductForm" novalidate>
                
                <div class="form-section">
                    <h3>📦 ข้อมูลทั่วไป</h3>
                    <div class="form-group">
                        <label>ชื่อสินค้า <span class="required">*</span></label>
                        <input type="text" name="productName" id="productName"
                               placeholder="เช่น ปลากัดจีน สีแดงสด (ต้องยาว 4 ตัวอักษรขึ้นไป)" 
                               required 
                               minlength="4" maxlength="100"
                               oninput="sanitizeName(this)">
                        <small style="color: #888; font-size: 12px;">* ความยาว 4-100 ตัวอักษร ห้ามใช้อักขระพิเศษ</small>
                    </div>
                    
                    <div class="form-group">
                        <label>หมวดหมู่ (Species) <span class="required">*</span></label>
                        <select name="speciesId" id="speciesId" required>
                            <option value="" disabled selected>-- เลือกสายพันธุ์ --</option>
                            <c:forEach items="${speciesList}" var="spec">
                                <option value="${spec.speciesId}">${spec.speciesName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>ราคา <span class="required">*</span></label>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <input type="number" name="price" id="price" min="1" step="0.01" placeholder="0.00" required style="flex: 1;">
                                <span style="color: #555; font-weight: bold; min-width: 30px;">บาท</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>จำนวนสต็อก <span class="required">*</span></label>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <input type="number" name="stock" id="stock" min="1" placeholder="จำนวน" required style="flex: 1;">
                                <span style="color: #555; font-weight: bold; min-width: 30px;">ตัว</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>รายละเอียดสินค้า <span class="required">*</span></label> 
                        <textarea name="description" id="description" rows="4" 
                                placeholder="อธิบายจุดเด่น... (ห้ามเว้นว่าง)"
                                required 
                                oninput="sanitizeDescription(this)"></textarea>
                    </div>
                </div>

                <div class="form-section">
                    <h3>🧬 ข้อมูลจำเพาะ (Specifics)</h3>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>ขนาด (Size)</label>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <input type="text" name="size" placeholder="เช่น 3-4" oninput="sanitizeGeneral(this)" style="flex: 1;">
                                <span style="color: #555; font-weight: bold;">ซม.</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>ถิ่นกำเนิด (Origin)</label>
                            <input type="text" name="origin" placeholder="เช่น Thailand" oninput="sanitizeGeneral(this)">
                        </div>
                        <div class="form-group">
                            <label>อายุขัยเฉลี่ย</label>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <input type="number" name="lifeSpan" min="0" max="100" placeholder="เช่น 2" style="flex: 1;">
                                <span style="color: #555; font-weight: bold;">ปี</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>อุณหภูมิน้ำ</label>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <input type="text" name="temperature" placeholder="เช่น 24-28" oninput="sanitizeGeneral(this)" style="flex: 1;">
                                <span style="color: #555; font-weight: bold;">°C</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>ประเภทน้ำ</label>
                            <input type="text" name="waterType" placeholder="Freshwater" oninput="sanitizeGeneral(this)">                        
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
                            <input type="file" name="productImage" id="productImage" accept="image/png, image/jpeg, image/jpg" required onchange="validateAndPreview(event, 'imagePreview', 'uploadPlaceholder')">
                            <div class="upload-placeholder" id="uploadPlaceholder">
                                <i class="fas fa-cloud-upload-alt"></i>
                                <p>คลิกเพื่ออัปโหลดรูปภาพหลัก</p>
                                <span>รองรับไฟล์ JPG, PNG (Max 5MB)</span>
                            </div>
                            <img id="imagePreview" class="image-preview" style="display: none;">
                        </div>
                    </div>

                    <div class="form-group" style="margin-top: 20px;">
                        <label>รูปภาพเพิ่มเติม</label>
                        <div class="image-upload-box" style="border-style: dashed; border-color: #cbd5e0;">
                            <input type="file" name="extraImages" id="extraImages" accept="image/png, image/jpeg, image/jpg" multiple onchange="validateAndPreviewMultiple(event)">
                            <div class="upload-placeholder" id="extraPlaceholder">
                                <i class="fas fa-images"></i>
                                <p>กด Ctrl ค้างไว้เพื่อเลือกหลายรูป</p>
                                <span>(Max 5MB per file)</span>
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
        function sanitizeName(input) {
            input.value = input.value.replace(/[^a-zA-Z0-9ก-๙\s\-_()]/g, '');
        }

        function sanitizeDescription(input) {
            input.value = input.value.replace(/<[^>]*>?/gm, '');
        }

        function sanitizeGeneral(input) {
            input.value = input.value.replace(/[<>"']/g, '');
        }

        const MAX_FILE_SIZE = 5 * 1024 * 1024; 

        function validateAndPreview(event, imgId, placeholderId) {
            const file = event.target.files[0];
            if (!file) return;

            if (file.size > MAX_FILE_SIZE) {
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
                const output = document.getElementById(imgId);
                const placeholder = document.getElementById(placeholderId);
                output.src = reader.result;
                output.style.display = 'block';
                placeholder.style.display = 'none';
            };
            reader.readAsDataURL(file);
        }

        function validateAndPreviewMultiple(event) {
            const files = event.target.files;
            const previewContainer = document.getElementById('galleryPreview');
            previewContainer.innerHTML = ""; 
            
            if (!files) return;

            let hasError = false;
            const validFiles = new DataTransfer();

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

        document.getElementById('addProductForm').addEventListener('submit', function(event) {
            event.preventDefault();

            const productName = document.getElementById('productName').value.trim();
            if (!productName) {
                showWarning('ลืมกรอกชื่อสินค้า!', 'กรุณากรอกชื่อสินค้าให้ครบถ้วน');
                return;
            }
            if (productName.length < 4) {
                showWarning('ชื่อสินค้าสั้นเกินไป', 'ชื่อสินค้าต้องมีความยาวอย่างน้อย 4 ตัวอักษร');
                return;
            }

            const species = document.getElementById('speciesId').value;
            if (!species) {
                showWarning('ลืมเลือกหมวดหมู่!', 'กรุณาระบุสายพันธุ์ของปลา');
                return;
            }

            const price = parseFloat(document.getElementById('price').value);
            if (isNaN(price)) {
                showWarning('ราคาไม่ถูกต้อง', 'กรุณากรอกราคาเป็นตัวเลข');
                return;
            }
            if (price <= 0) {
                showWarning('ราคาห้ามเป็น 0 หรือติดลบ', 'กรุณาระบุราคาขายที่ถูกต้อง');
                return;
            }

            const stock = document.getElementById('stock').value;
            if (stock === "" || isNaN(stock)) {
                showWarning('กรุณากรอกจำนวนสต็อก', 'สต็อกสินค้าห้ามเว้นว่าง');
                return;
            }
            if (parseInt(stock) <= 0) {
                showWarning('สต็อกสินค้าไม่ถูกต้อง', 'จำนวนสต็อกต้องมีอย่างน้อย 1 ตัว');
                return;
            }

            const description = document.getElementById('description').value.trim();
            if (!description) {
                showWarning('ลืมใส่รายละเอียด!', 'กรุณาอธิบายจุดเด่นของสินค้า');
                return;
            }

            const imageInput = document.getElementById('productImage');
            if (imageInput.files.length === 0) {
                showWarning('ไม่มีรูปภาพสินค้า', 'กรุณาอัปโหลดรูปภาพหลักอย่างน้อย 1 รูป');
                return;
            }

            Swal.fire({
                title: 'ยืนยันการบันทึก?',
                text: "ตรวจสอบข้อมูลให้ถูกต้องก่อนกดบันทึก",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#00571d',
                cancelButtonColor: '#d33',
                confirmButtonText: 'ใช่, บันทึกเลย',
                cancelButtonText: 'กลับไปแก้ไข'
            }).then((result) => {
                if (result.isConfirmed) {
                    this.submit();
                }
            });
        });

        function showWarning(title, text) {
            Swal.fire({
                icon: 'warning',
                title: title,
                text: text,
                confirmButtonColor: '#ffc107',
                confirmButtonText: 'ตกลง, ฉันจะแก้ไข'
            });
        }

       document.addEventListener("DOMContentLoaded", function() {
            const urlParams = new URLSearchParams(window.location.search);
            const error = urlParams.get('error');

            if (error) {
                let title = "บันทึกไม่สำเร็จ";
                let text = "เกิดข้อผิดพลาดไม่ทราบสาเหตุ";
                let icon = "error";

                if (error === 'invalidName') {
                    text = "ชื่อสินค้าผิดรูปแบบ! (ห้ามใช้อักขระพิเศษบางตัว)";
                    icon = "warning";
                } 
                else if (error === 'descLength') {
                    text = "รายละเอียดสินค้าต้องมีความยาวระหว่าง 20 - 255 ตัวอักษร";
                    icon = "warning";
                }
                else if (error === 'invalidNumber') {
                    text = "ราคา หรือ สต็อกสินค้า ไม่ถูกต้อง (ห้ามติดลบ)";
                    icon = "warning";
                }
                else if (error === 'fileTooLarge') {
                    text = "ไฟล์รูปภาพมีขนาดใหญ่เกิน 5MB";
                }
                else if (error === 'invalidFileType') {
                    text = "อัปโหลดได้เฉพาะไฟล์รูปภาพ (JPG, PNG) เท่านั้น";
                    icon = "warning";
                }
                else if (error === 'missingImage') {
                    text = "คุณลืมอัปโหลดรูปภาพหลักของสินค้า";
                    icon = "warning";
                }
                else if (error === 'exception') {

                    title = "เกิดข้อผิดพลาดของระบบ";
                    text = "ไม่สามารถบันทึกไฟล์หรือฐานข้อมูลได้ (กรุณาเช็ค Log ฝั่ง Server)";
                }

                Swal.fire({
                    icon: icon,
                    title: title,
                    text: text,
                    confirmButtonColor: '#d33',
                    confirmButtonText: 'กลับไปแก้ไข'
                });
            }
        });
    </script>
</body>
</html>