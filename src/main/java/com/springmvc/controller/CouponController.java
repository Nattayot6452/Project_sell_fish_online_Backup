package com.springmvc.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import java.util.regex.Pattern;

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

            code = code.trim().toUpperCase();

            if (code.isEmpty() || code.contains(" ")) {
                return new ModelAndView("redirect:/CreateCoupon?error=invalidCode");
            }

            if (code.length() < 3 || code.length() > 20) {
                return new ModelAndView("redirect:/CreateCoupon?error=codeLength");
            }

            if (!Pattern.matches("^[A-Z0-9]+$", code)) {
                return new ModelAndView("redirect:/CreateCoupon?error=invalidChar");
            }

            if (value <= 0) {
                return new ModelAndView("redirect:/CreateCoupon?error=invalidValue");
            }
            if ("PERCENT".equals(type) && value > 100) {
                return new ModelAndView("redirect:/CreateCoupon?error=invalidPercent");
            }

            if (minOrder < 0 || limit <= 0) {
                return new ModelAndView("redirect:/CreateCoupon?error=invalidNumber");
            }

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date start = sdf.parse(startDateStr);
            Date expire = sdf.parse(expireDateStr);

            if (expire.before(start)) {
                return new ModelAndView("redirect:/CreateCoupon?error=date_invalid");
            }

            Coupon c = new Coupon(code, type, value, minOrder, start, expire, limit, "ACTIVE");
            
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

            if (value <= 0) {
                return new ModelAndView("redirect:/EditCoupon?code=" + code + "&error=invalidValue");
            }
            if ("PERCENT".equals(type) && value > 100) {
                return new ModelAndView("redirect:/EditCoupon?code=" + code + "&error=invalidPercent");
            }

            if (minOrder < 0 || limit <= 0) {
                return new ModelAndView("redirect:/EditCoupon?code=" + code + "&error=invalidNumber");
            }

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date start = sdf.parse(startDateStr);
            Date expire = sdf.parse(expireDateStr);

            if (expire.before(start)) {
                return new ModelAndView("redirect:/EditCoupon?code=" + code + "&error=date_invalid");
            }

            CouponManager cm = new CouponManager();
            Coupon c = cm.getCouponByCode(code);
            
            if (c == null) {
                return new ModelAndView("redirect:/ManageCoupons?error=notFound");
            }
            
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