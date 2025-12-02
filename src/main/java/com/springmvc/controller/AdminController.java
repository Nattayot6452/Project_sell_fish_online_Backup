package com.springmvc.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import jakarta.servlet.http.HttpSession;

@Controller
public class AdminController {
    @RequestMapping(value = "/AdminDashboard", method = RequestMethod.GET)
    public ModelAndView showDashboard(HttpSession session) {
        // เช็คว่าเป็น Admin จริงไหม
        if (session.getAttribute("admin") == null) {
            return new ModelAndView("redirect:/Login");
        }
        return new ModelAndView("adminHomepage"); // ไปที่ adminHomepage.jsp
    }
}
