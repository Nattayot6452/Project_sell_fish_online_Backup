package com.springmvc.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class GuestController {

    // Start page
    @RequestMapping(value="/", method=RequestMethod.GET)
    public String defaultIndexPage() {
        return "home";
    }

    // หน้าแรก
    @RequestMapping(value="/gHome", method=RequestMethod.GET)
    public ModelAndView openHomePage() {
        return new ModelAndView("home");
    }

    
}

