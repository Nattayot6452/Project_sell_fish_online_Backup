package com.springmvc.controller;

import com.springmvc.model.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import java.util.List;

@Controller
public class OrderDetailController {

    @RequestMapping(value = "/OrderDetail", method = RequestMethod.GET)
    public ModelAndView showOrderDetail(@RequestParam("orderId") String orderId, HttpSession session) {
        boolean isUser = session.getAttribute("user") != null;
        boolean isSeller = session.getAttribute("seller") != null;
        boolean isAdmin = session.getAttribute("admin") != null;

        if (!isUser && !isSeller && !isAdmin) {
            return new ModelAndView("redirect:/Login");
        }

        OrderManager om = new OrderManager();
        Orders order = om.getOrderWithDetails(orderId);

        if (order == null) {
            return new ModelAndView("redirect:/SellerCenter?error=OrderNotFound");
        }

        ModelAndView mav = new ModelAndView("orderDetail");
        mav.addObject("order", order);
        return mav;
    }
    
    @RequestMapping(value = "/updateOrderStatus", method = RequestMethod.GET)
    public ModelAndView updateOrderStatus(
            @RequestParam("orderId") String orderId,
            @RequestParam("status") String status,
            HttpSession session) {
        
        if (session.getAttribute("seller") == null && session.getAttribute("admin") == null) {
            return new ModelAndView("redirect:/Login");
        }

        OrderManager om = new OrderManager();
        Orders order = om.getOrderWithDetails(orderId);
        
        if (order != null) {

            if ("Cancelled".equals(status) || "ยกเลิกคำสั่งซื้อ".equals(status) || "ชำระเงินไม่ผ่าน".equals(status)) {
                restoreStockAndCoupon(order); 
            }

            try {
                java.time.ZonedDateTime nowThai = java.time.ZonedDateTime.now(java.time.ZoneId.of("Asia/Bangkok"));
                java.sql.Timestamp timestamp = java.sql.Timestamp.valueOf(nowThai.toLocalDateTime());

                if ("กำลังจัดเตรียม".equals(status)) order.setPreparingDate(timestamp);
                else if ("สินค้าพร้อมรับ".equals(status)) order.setReadyDate(timestamp);
                else if ("Completed".equals(status) || "สำเร็จ".equals(status)) order.setCompletedDate(timestamp);
            } catch (Exception e) { e.printStackTrace(); }

            order.setStatus(status);
            om.updateOrder(order); 

            sendNotificationToMember(order, status);
        }

        return new ModelAndView("redirect:/OrderDetail?orderId=" + orderId + "&msg=updated");
    }

    @RequestMapping(value = "/Orders", method = RequestMethod.GET)
    public ModelAndView showUserOrders(HttpSession session, HttpServletRequest request) {
        
        Member user = (Member) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/Login");
        }

        OrderManager om = new OrderManager();
        List<Orders> orderList = om.getOrdersByMemberId(user.getMemberId());

        if (orderList != null && !orderList.isEmpty()) {
            java.util.Collections.sort(orderList, new java.util.Comparator<Orders>() {
                @Override
                public int compare(Orders o1, Orders o2) {
                    int s1 = getStatusScore(o1.getStatus());
                    int s2 = getStatusScore(o2.getStatus());

                    if (s1 != s2) {
                        return Integer.compare(s1, s2);
                    } else {

                        if (o1.getOrderDate() == null || o2.getOrderDate() == null) return 0;
                        return o2.getOrderDate().compareTo(o1.getOrderDate());
                    }
                }

                private int getStatusScore(String status) {
                    if (status == null) return 99;
                    
                    if (status.contains("Ready") || status.contains("พร้อมรับ") || status.contains("รอรับสินค้า")) return 0;

                    if (status.contains("Pending") || status.contains("รอดำเนินการ") || status.contains("รอชำระเงิน")) return 1;
                    if (status.contains("รออนุมัติยกเลิก")) return 1; 
                    
                    if (status.contains("Checking") || status.contains("Shipping") || status.contains("ตรวจสอบ") || status.contains("จัดเตรียม")) return 2;

                    if (status.contains("Completed") || status.contains("Cancelled") || status.contains("สำเร็จ") || status.contains("ยกเลิก")) return 3;

                    return 99;
                }
            });
        }

        ModelAndView mav = new ModelAndView("orders");
        mav.addObject("userOrders", orderList); 
        
        if(request.getParameter("msg") != null) mav.addObject("successMessage", request.getParameter("msg"));
        if(request.getParameter("error") != null) mav.addObject("errorMessage", "เกิดข้อผิดพลาด");
        if("success".equals(request.getParameter("upload"))) mav.addObject("successMessage", "อัปโหลดสลิปสำเร็จแล้ว! กำลังรอตรวจสอบ");

        return mav;
    }

    @RequestMapping(value = "/cancelOrder", method = RequestMethod.GET)
    public ModelAndView cancelOrder(@RequestParam("orderId") String orderId, HttpSession session) {
        
        if (session.getAttribute("user") == null) {
            return new ModelAndView("redirect:/Login");
        }

        OrderManager om = new OrderManager();
        Orders order = om.getOrderWithDetails(orderId);

        if (order != null && (
            "Pending Payment".equalsIgnoreCase(order.getStatus()) || 
            "รอดำเนินการชำระเงิน".equals(order.getStatus())
        )) {

            order.setStatus("รออนุมัติยกเลิก"); 
            om.updateOrder(order);

            sendNotificationToSeller(order); 

            return new ModelAndView("redirect:/OrderDetail?orderId=" + orderId + "&msg=request_sent");
        } else {
            return new ModelAndView("redirect:/OrderDetail?orderId=" + orderId + "&error=cannot_cancel");
        }
    }
    
    private void restoreStockAndCoupon(Orders order) {
        if (!"Cancelled".equals(order.getStatus()) && !"ยกเลิกคำสั่งซื้อ".equals(order.getStatus())) {
            ProductManager pm = new ProductManager();
            List<OrderDetail> details = order.getOrderDetails(); 
            if (details != null) {
                for (OrderDetail detail : details) {
                    Product p = detail.getProduct();
                    if (p != null) {
                        int currentStock = p.getStock();
                        int returnQty = detail.getQuantity();
                        p.setStock(currentStock + returnQty);
                        pm.updateProduct(p); 
                    }
                }
            }
            if (order.getCouponCode() != null && !order.getCouponCode().isEmpty()) {
                CouponManager cm = new CouponManager();
                Coupon c = cm.getCouponByCode(order.getCouponCode());
                if (c != null) {
                    c.setUsageCount(c.getUsageCount() - 1);
                    cm.updateCoupon(c);
                }
            }
        }
    }

    private void sendNotificationToMember(Orders order, String status) {
        try {
            if (order.getMember() != null) {
                NotificationManager nm = new NotificationManager();
                String message = "🔔 คำสั่งซื้อ #" + order.getOrdersId() + " ของคุณเปลี่ยนสถานะเป็น: " + status;
                String link = "OrderDetail?orderId=" + order.getOrdersId();
                nm.createNotification(order.getMember().getMemberId(), "MEMBER", message, link);
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    private void sendNotificationToSeller(Orders order) {
        try {
            NotificationManager nm = new NotificationManager();
            String message = "⚠️ มีคำขอยกเลิก: คำสั่งซื้อ #" + order.getOrdersId();
            String link = "OrderDetail?orderId=" + order.getOrdersId();
            nm.createNotification("0", "SELLER", message, link);
        } catch (Exception e) { e.printStackTrace(); }
    }
}