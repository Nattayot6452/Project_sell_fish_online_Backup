package com.springmvc.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.springmvc.model.Coupon;
import com.springmvc.model.CouponManager;

import jakarta.servlet.http.HttpSession;

@Controller
public class CouponController {

    @RequestMapping(value = "/ManageCoupons", method = RequestMethod.GET)
    public ModelAndView manageCoupons(HttpSession session) {

        if (session.getAttribute("seller") == null) {
            return new ModelAndView("redirect:/Login"); 
        }

        CouponManager cm = new CouponManager();
        List<Coupon> list = cm.getAllCoupons();

        ModelAndView mav = new ModelAndView("manageCoupons");
        mav.addObject("coupons", list);
        return mav;
    }

    @RequestMapping(value = "/CreateCoupon", method = RequestMethod.GET)
    public ModelAndView showCreateCouponForm(HttpSession session) {
        if (session.getAttribute("seller") == null) {
            return new ModelAndView("redirect:/Login");
        }
        return new ModelAndView("createCoupon");
    }

    @RequestMapping(value = "/saveCoupon", method = RequestMethod.POST)
    public ModelAndView saveCoupon(
            @RequestParam("couponCode") String code,
            @RequestParam("discountType") String type,
            @RequestParam("discountValue") double value,
            @RequestParam("minOrder") double minOrder,
            @RequestParam("startDate") String startDateStr,
            @RequestParam("expireDate") String expireDateStr,
            @RequestParam("usageLimit") int limit,
            HttpSession session) {

        if (session.getAttribute("seller") == null) {
            return new ModelAndView("redirect:/Login");
        }

        try {

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date start = sdf.parse(startDateStr);
            Date expire = sdf.parse(expireDateStr);

            if (expire.before(start)) {
                return new ModelAndView("redirect:/CreateCoupon?error=date_invalid");
            }

            Coupon c = new Coupon(code.toUpperCase(), type, value, minOrder, start, expire, limit, "ACTIVE");
            
            CouponManager cm = new CouponManager();
            boolean success = cm.saveCoupon(c);

            if (success) {
                return new ModelAndView("redirect:/ManageCoupons?msg=created");
            } else {
                return new ModelAndView("redirect:/CreateCoupon?error=duplicate");
            }

        } catch (Exception e) {
            e.printStackTrace();
            return new ModelAndView("redirect:/CreateCoupon?error=exception");
        }
    }

    @RequestMapping(value = "/checkCoupon", method = RequestMethod.POST)
    @org.springframework.web.bind.annotation.ResponseBody
    public String checkCoupon(
            @RequestParam("code") String code, 
            @RequestParam("totalAmount") double totalAmount) {
        
        CouponManager cm = new CouponManager();
        Coupon c = cm.getCouponByCode(code.toUpperCase());

        if (c == null) {
            return "INVALID:ไม่พบรหัสคูปองนี้";
        }

        if (!"ACTIVE".equals(c.getStatus())) {
            return "INVALID:คูปองนี้ถูกยกเลิกแล้ว";
        }

        Date now = new Date();
        if (now.before(c.getStartDate())) {
            return "INVALID:คูปองยังไม่ถึงเวลาเริ่มใช้";
        }
        if (now.after(c.getExpireDate())) {
            return "INVALID:คูปองหมดอายุแล้ว";
        }

        if (c.getUsageCount() >= c.getUsageLimit()) {
            return "INVALID:สิทธิ์คูปองเต็มแล้ว";
        }

        if (totalAmount < c.getMinOrderAmount()) {
            return "INVALID:ยอดซื้อต้องครบ " + c.getMinOrderAmount() + " บาท ถึงจะใช้ได้";
        }

        double discount = 0;
        if ("FIXED".equals(c.getDiscountType())) {
            discount = c.getDiscountValue();
        } else {

            discount = totalAmount * (c.getDiscountValue() / 100);
        }

        if (discount > totalAmount) {
            discount = totalAmount;
        }

        return String.valueOf(discount);
    }

    @RequestMapping(value = "/DeleteCoupon", method = RequestMethod.GET)
public ModelAndView deleteCoupon(@RequestParam("code") String code, HttpSession session) {
    if (session.getAttribute("seller") == null) {
        return new ModelAndView("redirect:/Login");
    }
    CouponManager cm = new CouponManager();
    cm.deleteCoupon(code);
    return new ModelAndView("redirect:/ManageCoupons?msg=deleted");
}

@RequestMapping(value = "/EditCoupon", method = RequestMethod.GET)
    public ModelAndView showEditCouponForm(@RequestParam("code") String code, HttpSession session) {
        if (session.getAttribute("seller") == null) {
            return new ModelAndView("redirect:/Login");
        }

        CouponManager cm = new CouponManager();
        Coupon coupon = cm.getCouponByCode(code);

        ModelAndView mav = new ModelAndView("editCoupon"); 
        mav.addObject("coupon", coupon);
        return mav;
    }

    @RequestMapping(value = "/updateCoupon", method = RequestMethod.POST)
    public ModelAndView updateCoupon(
            @RequestParam("couponCode") String code,
            @RequestParam("discountType") String type,
            @RequestParam("discountValue") double value,
            @RequestParam("minOrder") double minOrder,
            @RequestParam("startDate") String startDateStr,
            @RequestParam("expireDate") String expireDateStr,
            @RequestParam("usageLimit") int limit,
            @RequestParam("status") String status,
            HttpSession session) {

        if (session.getAttribute("seller") == null) {
            return new ModelAndView("redirect:/Login");
        }

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date start = sdf.parse(startDateStr);
            Date expire = sdf.parse(expireDateStr);

            if (expire.before(start)) {
                return new ModelAndView("redirect:/EditCoupon?code=" + code + "&error=date_invalid");
            }

            CouponManager cm = new CouponManager();
            Coupon c = cm.getCouponByCode(code);
            
            c.setDiscountType(type);
            c.setDiscountValue(value);
            c.setMinOrderAmount(minOrder);
            c.setStartDate(start);
            c.setExpireDate(expire);
            c.setUsageLimit(limit);
            c.setStatus(status);

            boolean success = cm.updateCoupon(c); 

            if (success) {
                return new ModelAndView("redirect:/ManageCoupons?msg=updated");
            } else {
                return new ModelAndView("redirect:/EditCoupon?code=" + code + "&error=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            return new ModelAndView("redirect:/EditCoupon?code=" + code + "&error=exception");
        }
    }

}