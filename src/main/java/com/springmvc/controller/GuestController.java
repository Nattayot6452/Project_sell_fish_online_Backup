package com.springmvc.controller;

import com.springmvc.model.Product;
import com.springmvc.model.ProductManager;
import java.util.List;
import java.util.ArrayList;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class GuestController {

    @RequestMapping(value = {"/", "/Home"}, method = RequestMethod.GET)
    public ModelAndView openHomePage() {
        
        ModelAndView mav = new ModelAndView("home");
        
        List<Product> productList = new ArrayList<>();
        
        try {
            ProductManager pm = new ProductManager(); 
            productList = pm.getFeaturedProducts(8);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        mav.addObject("featuredProducts", productList);
        
        return mav;
    }

}