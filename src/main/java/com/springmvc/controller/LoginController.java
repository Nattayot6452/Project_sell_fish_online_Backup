package com.springmvc.controller;

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
	
	// Login
    @RequestMapping(value="/gLogin", method=RequestMethod.GET)
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
		    return new ModelAndView("main"); // main.jsp ต้องมีจริง
		} else {
		    ModelAndView mav = new ModelAndView("login");
		    mav.addObject("error", "อีเมล หรือ รหัสผ่าน ไม่ถูกต้อง");
		    return mav;
		}

	}
}
