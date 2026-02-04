package com.springmvc.controller;

import com.springmvc.model.*; 
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

// import org.springframework.http.HttpStatus;
// import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
// import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
// import java.sql.Date;
import java.util.UUID;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
// import org.springframework.http.HttpHeaders;
// import java.sql.Timestamp;

@Controller
public class CheckoutController { 

    @RequestMapping(value = "/checkout", method = RequestMethod.GET)
    public ModelAndView showCheckoutPage(
            @RequestParam(value = "coupon", required = false) String couponCode,
            HttpSession session) {
        
        Member user = (Member) session.getAttribute("user");
        if (user == null) return new ModelAndView("redirect:/Login");
        
        Map<String, Integer> cartSessionData = (Map<String, Integer>) session.getAttribute("cart");
        if (cartSessionData == null || cartSessionData.isEmpty()) return new ModelAndView("redirect:/Cart");
        
        List<CartItem> cartItems = new ArrayList<>();
        double totalCartPrice = 0.0;
        ProductManager pm = new ProductManager();

        for (Map.Entry<String, Integer> entry : cartSessionData.entrySet()) {
            Product product = pm.getProduct(entry.getKey());
            if (product != null) {
                CartItem item = new CartItem(product, entry.getValue());
                cartItems.add(item);
                totalCartPrice += item.getItemTotal();
            }
        }

        double discount = 0.0;
        String couponMsg = null; 

        if (couponCode != null && !couponCode.isEmpty()) {
            CouponManager cm = new CouponManager();
            Coupon coupon = cm.getCouponByCode(couponCode);

            if (coupon != null) {
                java.util.Date now = new java.util.Date();
                if (coupon.getExpireDate() != null && coupon.getExpireDate().before(now)) {
                     couponMsg = "คูปองหมดอายุแล้ว";
                     couponCode = null;
                }
                else if (coupon.getUsageLimit() > 0 && coupon.getUsageCount() >= coupon.getUsageLimit()) {
                     couponMsg = "คูปองถูกใช้ครบสิทธิ์แล้ว";
                     couponCode = null;
                }
                else if (totalCartPrice < coupon.getMinOrderAmount()) {
                     couponMsg = "ยอดซื้อไม่ถึงขั้นต่ำ " + coupon.getMinOrderAmount() + " บาท";
                     couponCode = null;
                }
                else {
                    if ("PERCENT".equalsIgnoreCase(coupon.getDiscountType()) || "Percentage".equalsIgnoreCase(coupon.getDiscountType())) {
                         discount = totalCartPrice * (coupon.getDiscountValue() / 100.0);
                     } else {
                         discount = coupon.getDiscountValue();
                     }
                     if (discount > totalCartPrice) discount = totalCartPrice;
                     couponMsg = "ใช้คูปองสำเร็จ! ลด " + discount + " บาท";
                }
            } else {
                couponMsg = "ไม่พบรหัสคูปองนี้";
                couponCode = null;
            }
        }

        double finalPrice = totalCartPrice - discount;
        if (finalPrice < 0) finalPrice = 0;

        ModelAndView mav = new ModelAndView("checkout");
        mav.addObject("cartItems", cartItems);
        mav.addObject("totalCartPrice", totalCartPrice);
        mav.addObject("couponCode", couponCode);
        mav.addObject("discount", discount);
        mav.addObject("finalPrice", finalPrice);
        mav.addObject("couponMsg", couponMsg);
        
        return mav;
    }
    
    @RequestMapping(value = "/createOrder", method = RequestMethod.POST)
    public ModelAndView createOrder(
            @RequestParam("paymentMethod") String paymentMethod,
            @RequestParam(value = "couponCode", required = false) String couponCode, 
            @RequestParam(value = "discountAmount", defaultValue = "0.0") Double discountAmount, 
            HttpSession session) {
        
        Member user = (Member) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/Login");
        }
        Map<String, Integer> cartSessionData = (Map<String, Integer>) session.getAttribute("cart");
        if (cartSessionData == null || cartSessionData.isEmpty()) {
            return new ModelAndView("redirect:/Cart");
        }
        
        List<CartItem> cartItemsForOrder = new ArrayList<>(); 
        double totalCartPriceForOrder = 0.0;
        ProductManager pm = new ProductManager();
        
        for (Map.Entry<String, Integer> entry : cartSessionData.entrySet()) {
            Product product = pm.getProduct(entry.getKey());
            if (product != null) {
                if(product.getStock() < entry.getValue()) {

                    ModelAndView mavError = new ModelAndView("checkout");
                    List<CartItem> currentCartItems = new ArrayList<>();
                    double currentTotal = 0.0;
                    ProductManager pmForError = new ProductManager();
                    for (Map.Entry<String, Integer> e : cartSessionData.entrySet()) {
                         Product p = pmForError.getProduct(e.getKey());
                         if(p != null) {
                             CartItem i = new CartItem(p, e.getValue());
                             currentCartItems.add(i);
                             currentTotal += i.getItemTotal();
                         }
                    }
                    mavError.addObject("cartItems", currentCartItems); 
                    mavError.addObject("totalCartPrice", currentTotal);
                    mavError.addObject("finalPrice", currentTotal - discountAmount);
                    mavError.addObject("couponCode", couponCode);
                    mavError.addObject("discount", discountAmount);
                    mavError.addObject("checkoutError", "ขออภัย, สินค้า '" + product.getProductName() + "' มีไม่พอในสต็อก!");
                    return mavError;
                }
                CartItem item = new CartItem(product, entry.getValue());
                cartItemsForOrder.add(item);
                totalCartPriceForOrder += item.getItemTotal();
            }
        }
        
        double finalTotal = totalCartPriceForOrder - discountAmount;
        if (finalTotal < 0) finalTotal = 0;

        String newOrderId = "ORD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        Orders newOrder = new Orders();
        newOrder.setOrdersId(newOrderId);
        newOrder.setMember(user);

        java.time.ZonedDateTime nowThai = java.time.ZonedDateTime.now(java.time.ZoneId.of("Asia/Bangkok"));
        newOrder.setOrderDate(java.sql.Timestamp.valueOf(nowThai.toLocalDateTime()));
        
        newOrder.setStatus("รอดำเนินการชำระเงิน");
        newOrder.setTotalAmount(finalTotal);
        newOrder.setDiscountAmount(discountAmount);
        newOrder.setCouponCode(couponCode);

        List<OrderDetail> orderDetails = new ArrayList<>();
        for (CartItem item : cartItemsForOrder) {
            OrderDetail detail = new OrderDetail();
            detail.setOrderDetailId(UUID.randomUUID().toString());
            detail.setOrders(newOrder); 
            detail.setProduct(item.getProduct()); 
            detail.setQuantity(item.getQuantity()); 
            detail.setPrice(item.getProduct().getPrice());
            orderDetails.add(detail);
        }

        newOrder.setOrderDetails(orderDetails);
        
        OrderManager om = new OrderManager();
        boolean saved = om.saveNewOrder(newOrder, orderDetails);

        if (!saved) {
            ModelAndView mavError = new ModelAndView("checkout");
            mavError.addObject("cartItems", cartItemsForOrder);
            mavError.addObject("totalCartPrice", totalCartPriceForOrder);
            mavError.addObject("checkoutError", "เกิดข้อผิดพลาดในการสร้างคำสั่งซื้อ!");
            return mavError;
        }

        NotificationManager nm = new NotificationManager();
        nm.createNotification("0", "SELLER", "📦 มีคำสั่งซื้อใหม่เข้ามา! รหัส #" + newOrderId, "SellerOrders");

        for (CartItem item : cartItemsForOrder) {
            Product p = item.getProduct();
            int newStock = p.getStock() - item.getQuantity();
            if (newStock < 0) newStock = 0;
            
            p.setStock(newStock);
            pm.updateProduct(p); 
        }

        if (couponCode != null && !couponCode.isEmpty()) {
            CouponManager cm = new CouponManager();
            Coupon c = cm.getCouponByCode(couponCode);
            if (c != null) {
                c.setUsageCount(c.getUsageCount() + 1);
                cm.updateCoupon(c);
            }
        }

        session.removeAttribute("cart");
        
        return new ModelAndView("redirect:/uploadSlip?orderId=" + newOrderId); 
    }
    
    @RequestMapping(value = "/uploadSlip", method = RequestMethod.GET)
    public ModelAndView showUploadSlipPage(
            @RequestParam("orderId") String orderId,
            HttpSession session) {
        
        Member user = (Member) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/Login");
        }
        
        OrderManager om = new OrderManager();
        Orders order = om.getOrderById(orderId);
        
        if(order == null) {
             return new ModelAndView("redirect:/Orders?error=OrderNotFound");
        }
        
        ModelAndView mav = new ModelAndView("uploadSlip"); 
        mav.addObject("orderId", orderId);
        mav.addObject("order", order);

        return mav;
    }
    
    @RequestMapping(value = "/doUploadSlip", method = RequestMethod.POST)
    public ModelAndView doUploadSlip(
            @RequestParam("orderId") String orderId,
            @RequestParam("slipImage") MultipartFile slipImage,
            HttpSession session) {
        
        Member user = (Member) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/Login");
        }

        OrderManager om = new OrderManager();
        Orders order = om.getOrderById(orderId);
        String savedFileName = null;
        ModelAndView mavError = null;

        if (order == null) {
            return new ModelAndView("redirect:/Orders?error=OrderNotFound"); 
        }

        if (slipImage != null && !slipImage.isEmpty()) {
            try {
                String uploadDir = "/app/images/slips/"; 
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs(); 
                
                String originalFileName = slipImage.getOriginalFilename();
                String fileExtension = "";
                if (originalFileName != null && originalFileName.contains(".")) {
                    fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
                }
                savedFileName = UUID.randomUUID().toString() + fileExtension;
                File serverFile = new File(dir, savedFileName);
                slipImage.transferTo(serverFile); 
            } catch (Exception e) {
                e.printStackTrace();
                mavError = new ModelAndView("uploadSlip");
                mavError.addObject("orderId", orderId);
                mavError.addObject("order", order);
                mavError.addObject("uploadError", "ไม่สามารถบันทึกไฟล์สลิปได้: " + e.getMessage());
                return mavError;
            }
        } else {
            mavError = new ModelAndView("uploadSlip");
            mavError.addObject("orderId", orderId);
            mavError.addObject("order", order);
            mavError.addObject("uploadError", "กรุณาเลือกไฟล์สลิปที่ต้องการอัปโหลด");
            return mavError;
        }

        Payment payment = new Payment();
        payment.setSlipId(UUID.randomUUID().toString());
        
        java.time.ZonedDateTime nowThai = java.time.ZonedDateTime.now(java.time.ZoneId.of("Asia/Bangkok"));
        payment.setUploadDate(java.sql.Timestamp.valueOf(nowThai.toLocalDateTime()));
        
        payment.setFilePath(savedFileName);
        payment.setTotal(order.getTotalAmount());
        payment.setOrders(order);

        PaymentManager pm = new PaymentManager();
        boolean success = pm.savePayment(payment); 

        if (success) {
            om.updateOrderStatus(orderId, "กำลังตรวจสอบ");
            NotificationManager nm = new NotificationManager();
            nm.createNotification("0", "SELLER", "💰 ลูกค้าแจ้งโอนเงินสำหรับออเดอร์ #" + orderId, "SellerOrders");
            return new ModelAndView("redirect:/Orders?upload=success");
        } else {
            mavError = new ModelAndView("uploadSlip");
            mavError.addObject("orderId", orderId);
            mavError.addObject("order", order);
            mavError.addObject("uploadError", "ไม่สามารถบันทึกข้อมูลการชำระเงินลงฐานข้อมูลได้");
            return mavError;
        }
    }
   
    @RequestMapping(value = "/History", method = RequestMethod.GET)
    public ModelAndView showHistoryPage(HttpSession session, HttpServletRequest request) { 
        Member user = (Member) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/Login");
        }
        OrderManager om = new OrderManager();
        List<Orders> allOrders = om.getOrdersByMemberId(user.getMemberId());
        List<Orders> historyList = new ArrayList<>();
        if (allOrders != null) {
            for (Orders order : allOrders) {
                String status = order.getStatus();
                if ("Completed".equalsIgnoreCase(status) || "Cancelled".equalsIgnoreCase(status) ||
                    "สำเร็จ".equals(status) || "ยกเลิก".equals(status) || 
                    "รับสินค้าแล้ว".equals(status) || "ยกเลิกออเดอร์".equals(status)) {
                    historyList.add(order);
}
            }
        }
        ModelAndView mav = new ModelAndView("history");
        mav.addObject("orderList", historyList); 
        return mav;
    }
}