package com.springmvc.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.springmvc.model.Coupon;
import com.springmvc.model.CouponManager;

import java.util.List;

@Controller
public class PromotionController {

    @RequestMapping("/Promotions")
    public ModelAndView showPromotions() {
        ModelAndView mav = new ModelAndView("promotions");
        
        CouponManager cm = new CouponManager();
        List<Coupon> coupons = cm.getActiveCoupons();

        mav.addObject("coupons", coupons);
        return mav;
    }
}