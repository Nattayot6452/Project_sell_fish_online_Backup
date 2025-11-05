package com.springmvc.controller;

import com.springmvc.model.Product;
import com.springmvc.model.ProductManager; 
import java.util.List;
import java.util.ArrayList;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.springmvc.model.Member;
import com.springmvc.model.RegisterManager;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {
	
    @RequestMapping(value="/Login", method=RequestMethod.GET)
    public ModelAndView openLoginPage() {
        return new ModelAndView("login");
    }
    
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public ModelAndView login(HttpServletRequest request, HttpSession session) {
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		System.out.println("Logs 1: User: " + email + " Password: " + password);
	    
	    try {
	    	password = PasswordUtil.getInstance().createPassword(password , "itmjusci");
	    } catch (Exception e ) {
	    	e.printStackTrace();
	    }
    
		RegisterManager rm = new RegisterManager();
		Member user = rm.getRegisterByEmailAndPassword(email, password);

		if (user != null) {
		    session.setAttribute("user", user);
		    
		    ModelAndView mav = new ModelAndView("main");
		    
            List<Product> productList = new ArrayList<>();
            try {
                // 2. ดึงข้อมูลสินค้า (เหมือน GuestController)
                ProductManager pm = new ProductManager();
                // (ต้องมี Method นี้ใน ProductManager.java)
                productList = pm.getFeaturedProducts(8);
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            mav.addObject("featuredProducts", productList);
            
		    return mav; 
            
		} else {
		    ModelAndView mav = new ModelAndView("login");
		    mav.addObject("error", "อีเมล หรือ รหัสผ่าน ไม่ถูกต้อง");
		    return mav;
		}
	}
    
    @RequestMapping(value="/Logout", method=RequestMethod.GET)
    public ModelAndView logout(HttpSession session) {
        session.removeAttribute("user"); 
        session.invalidate();
        return new ModelAndView("redirect:/Home");
    }
}