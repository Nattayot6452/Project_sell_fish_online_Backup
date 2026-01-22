package com.springmvc.controller;

import com.springmvc.model.*;
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
        
        // 1. ตรวจสอบสิทธิ์ (ต้องเป็น Seller หรือ Admin)
        if (session.getAttribute("seller") == null && session.getAttribute("admin") == null) {
            return new ModelAndView("redirect:/Login");
        }

        OrderManager om = new OrderManager();
        
        // 2. Logic คืนสต็อกและคูปอง (กรณีไดยกเลิก)
        if ("Cancelled".equals(status) || "ยกเลิกคำสั่งซื้อ".equals(status) || "ชำระเงินไม่ผ่าน".equals(status)) {
            
            Orders order = om.getOrderWithDetails(orderId);
            
            if (order != null && !"Cancelled".equals(order.getStatus()) && !"ยกเลิกคำสั่งซื้อ".equals(order.getStatus())) {
                
                ProductManager pm = new ProductManager();
                List<OrderDetail> details = order.getOrderDetails(); 
                
                // คืนสต็อกสินค้า
                if (details != null) {
                    for (OrderDetail detail : details) {
                        Product p = detail.getProduct();
                        if (p != null) {
                            int currentStock = p.getStock();
                            int returnQty = detail.getQuantity();
                            p.setStock(currentStock + returnQty);
                            
                            pm.updateProduct(p); 
                            System.out.println(">>> Restored Stock for " + p.getProductName() + ": " + p.getStock());
                        }
                    }
                }

                // คืนสิทธิ์คูปอง
                if (order.getCouponCode() != null && !order.getCouponCode().isEmpty()) {
                    CouponManager cm = new CouponManager();
                    Coupon c = cm.getCouponByCode(order.getCouponCode());
                    if (c != null) {
                        c.setUsageCount(c.getUsageCount() - 1);
                        cm.updateCoupon(c);
                        System.out.println(">>> Restored Coupon Usage: " + c.getCouponCode());
                    }
                }
            }
        }

        om.updateOrderStatus(orderId, status);

        try {
            // ดึงข้อมูลออเดอร์อีกครั้งเพื่อให้แน่ใจว่าได้ข้อมูลล่าสุดและ Member ID
            Orders orderForNoti = om.getOrderById(orderId); 
            
            if (orderForNoti != null && orderForNoti.getMember() != null) {
                NotificationManager nm = new NotificationManager();
                
                String message = "🔔 คำสั่งซื้อ #" + orderId + " ของคุณเปลี่ยนสถานะเป็น: " + status;
                String link = "OrderDetail?orderId=" + orderId; // ลิงก์ไปดูรายละเอียด
                
                // ส่งแจ้งเตือนหา Member (ใช้ ID แบบ String ตามที่คุณแก้ไปแล้ว)
                nm.createNotification(orderForNoti.getMember().getMemberId(), "MEMBER", message, link);
                
                System.out.println(">>> Notification sent to Member: " + orderForNoti.getMember().getMemberId());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ModelAndView("redirect:/OrderDetail?orderId=" + orderId);
    }
    
    @RequestMapping(value = "/requestCancellation", method = RequestMethod.GET)
    public ModelAndView requestCancellation(@RequestParam("orderId") String orderId, HttpSession session) {
        
        if (session.getAttribute("user") == null) {
            return new ModelAndView("redirect:/Login");
        }

        OrderManager om = new OrderManager();
        om.updateOrderStatus(orderId, "รออนุมัติยกเลิก");

        return new ModelAndView("redirect:/OrderDetail?orderId=" + orderId);
    }
}