package com.springmvc.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import jakarta.servlet.http.HttpSession;

@Controller
public class SellerController {

    // (ใช้ ProductManager ดึงสินค้าของผู้ขายคนนี้)

    @RequestMapping(value = "/ListProducts", method = RequestMethod.GET)
    public ModelAndView showSellerProducts(HttpSession session) {
        // เช็คว่าเป็น Seller จริงไหม
        if (session.getAttribute("seller") == null) {
            return new ModelAndView("redirect:/Login");
        }

        ModelAndView mav = new ModelAndView("sellerHomepage"); // ไปที่ sellerHomepage.jsp
        // mav.addObject("products", ...);
        return mav;
    }
}
