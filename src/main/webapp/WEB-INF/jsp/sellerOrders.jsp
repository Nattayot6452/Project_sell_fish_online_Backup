<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>รายการคำสั่งซื้อ | Seller Center</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/sellerOrders.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/sellerHomepage.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <jsp:include page="loading.jsp" />

    <jsp:include page="sellerNavbar.jsp" />

    <div class="container main-container">
        
        <div class="page-header">
            <div>
                <h1><i class="fas fa-clipboard-list"></i> รายการคำสั่งซื้อ</h1>
                <p>ตรวจสอบและจัดการสถานะออเดอร์ทั้งหมดจากลูกค้า</p>
            </div>
        </div>

        <div class="orders-table-container">
            <c:choose>
                <c:when test="${not empty orderList}">
                    <table class="orders-table">
                        <thead>
                            <tr>
                                <th># รหัสคำสั่งซื้อ</th>
                                <th>ลูกค้า</th>
                                <th>วันที่สั่งซื้อ</th>
                                <th>ยอดรวม</th>
                                <th>สถานะ</th>
                                <th>จัดการ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${orderList}" var="order">
                                <tr>
                                    <td class="order-id">
                                        <i class="fas fa-hashtag"></i> ${order.ordersId}
                                    </td>
                                    <td>
                                        <div class="customer-info">
                                            <span class="name"><c:out value="${order.member.memberName}" /></span>
                                            <span class="email"><c:out value="${order.member.email}" /></span>
                                        </div>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td class="amount">
                                        <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="฿"/>
                                    </td>
                                    <td>
                                        <c:set var="statusLabel" value="${order.status}" />
                                        <c:set var="statusClass" value="" />

                                        <c:choose>
                                            <c:when test="${order.status == 'Pending Payment' || order.status == 'รอดำเนินการชำระเงิน'}">
                                                <c:set var="statusLabel" value="รอดำเนินการชำระเงิน" />
                                                <c:set var="statusClass" value="pending" />
                                            </c:when>
                                            
                                            <c:when test="${order.status == 'Checking' || order.status == 'กำลังตรวจสอบ' || order.status == 'กำลังจัดเตรียม'}">
                                                <c:if test="${order.status == 'กำลังจัดเตรียม'}">
                                                    <c:set var="statusLabel" value="กำลังจัดเตรียม" />
                                                </c:if>
                                                <c:if test="${order.status != 'กำลังจัดเตรียม'}">
                                                    <c:set var="statusLabel" value="กำลังตรวจสอบ" />
                                                </c:if>
                                                <c:set var="statusClass" value="checking" />
                                            </c:when>

                                            <c:when test="${order.status == 'Ready for Pickup' || order.status == 'รอรับสินค้า' || order.status == 'Shipping' || order.status == 'ยืนยันสลิป'}">
                                                <c:set var="statusLabel" value="รอรับสินค้า" />
                                                <c:set var="statusClass" value="shipping" />
                                            </c:when>

                                            <c:when test="${order.status == 'Completed' || order.status == 'สำเร็จ' || order.status == 'รับสินค้าแล้ว'}">
                                                <c:set var="statusLabel" value="สำเร็จ" />
                                                <c:set var="statusClass" value="completed" />
                                            </c:when>

                                            <c:when test="${order.status == 'Cancelled' || order.status == 'ยกเลิก' || order.status == 'ยกเลิกออเดอร์'}">
                                                <c:set var="statusLabel" value="ยกเลิก" />
                                                <c:set var="statusClass" value="cancelled" />
                                            </c:when>
                                        </c:choose>

                                        <span class="status-badge ${statusClass}">
                                            ${statusLabel}
                                        </span>
                                    </td>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 15px;">
                                            
                                            <a href="OrderDetail?orderId=${order.ordersId}" class="btn-view" style="margin-right: 0; white-space: nowrap;">
                                                <i class="fas fa-eye"></i> ตรวจสอบ
                                            </a>

                                            <button type="button" onclick="openReportModal('${order.member.memberId}', '${order.member.memberName}')" 
                                                    style="width: 32px; height: 32px; border: 1px solid #ffc107; background: #fff3cd; color: #856404; border-radius: 4px; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: 0.2s;"
                                                    title="แจ้งปัญหา / รายงานพฤติกรรม"
                                                    onmouseover="this.style.background='#ffecb5'"
                                                    onmouseout="this.style.background='#fff3cd'">
                                                <i class="fas fa-flag"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-inbox"></i>
                        <h3>ยังไม่มีคำสั่งซื้อเข้ามา</h3>
                        <p>รายการสั่งซื้อใหม่จะปรากฏที่นี่เมื่อลูกค้าทำการสั่งซื้อ</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    function openReportModal(memberId, memberName) {
        Swal.fire({
            title: 'รายงานพฤติกรรมผู้ซื้อ',
            html: `
                <div style="text-align: left;">
                    <p style="font-size: 14px; color: #555;">คุณกำลังรายงานผู้ใช้: <b>` + memberName + `</b></p>
                    <p style="font-size: 13px; color: #666; margin-bottom: 15px;">ข้อมูลนี้จะถูกส่งไปยัง <b>ผู้ดูแลระบบ (Admin)</b> เพื่อพิจารณา</p>
                    
                    <label style="font-weight: bold; font-size: 14px;">หัวข้อการรายงาน:</label>
                    <select id="reportReason" class="swal2-input" style="margin-top: 5px;">
                        <option value="สั่งเล่น/ก่อกวน">👻 สั่งเล่น / ก่อกวน</option>
                        <option value="ไม่ชำระเงิน">💸 ไม่ชำระเงิน / ทิ้งออเดอร์</option>
                        <option value="ใช้ถ้อยคำไม่สุภาพ">🤬 ใช้ถ้อยคำไม่สุภาพ</option>
                        <option value="หลักฐานปลอม">🚫 เจตนาฉ้อโกง / หลักฐานปลอม</option>
                        <option value="อื่นๆ">📝 อื่นๆ</option>
                    </select>
                    
                    <label style="font-weight: bold; font-size: 14px; margin-top: 10px; display: block;">รายละเอียดเพิ่มเติม:</label>
                    <textarea id="reportNote" class="swal2-textarea" placeholder="ระบุรายละเอียด..." style="margin-top: 5px; height: 100px;"></textarea>
                </div>
            `,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#ffc107',
            confirmButtonText: 'ส่งรายงานให้ Admin',
            cancelButtonText: 'ยกเลิก',
            cancelButtonColor: '#6c757d',
            focusConfirm: false,
            preConfirm: () => {
                const reason = document.getElementById('reportReason').value;
                const note = document.getElementById('reportNote').value;
                return { memberId: memberId, reason: reason, note: note };
            }
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = "SellerReportUser?id=" + result.value.memberId + 
                                       "&reason=" + encodeURIComponent(result.value.reason) +
                                       "&note=" + encodeURIComponent(result.value.note);
            }
        });
    }

    document.addEventListener("DOMContentLoaded", function() {
        const urlParams = new URLSearchParams(window.location.search);
        const msg = urlParams.get('msg');

        if (msg === 'report_sent') {
            Swal.fire({
                icon: 'success',
                title: 'ส่งรายงานเรียบร้อย',
                text: 'ระบบได้ส่งข้อมูลพฤติกรรมผู้ใช้นี้ให้ผู้ดูแลระบบตรวจสอบแล้ว',
                confirmButtonColor: '#00571d',
                timer: 3000
            }).then(() => {
                window.history.replaceState({}, document.title, window.location.pathname);
            });
        }
    });
</script>

</body>
</html>