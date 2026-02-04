package com.springmvc.controller;

import com.springmvc.model.Product;
import com.springmvc.model.ProductManager; 
import com.springmvc.model.Staff;
import com.springmvc.model.StaffManager;
import com.springmvc.model.Member;
import com.springmvc.model.RegisterManager;

import java.util.List;
import java.util.ArrayList;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {
	
    @RequestMapping(value="/Login", method=RequestMethod.GET)
    public ModelAndView openLoginPage() {
        return new ModelAndView("login");
    }

    @RequestMapping(value="/Main", method=RequestMethod.GET)
    public ModelAndView showMainPage(HttpSession session) {
        if (session.getAttribute("user") == null) {
            return new ModelAndView("redirect:/Login");
        }

        ModelAndView mav = new ModelAndView("main");
        
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
    
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public ModelAndView login(HttpServletRequest request, HttpSession session) {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        ModelAndView mav = new ModelAndView("login");

        if (email == null || password == null || email.trim().isEmpty() || password.isEmpty()) {
            mav.addObject("error", "❌ กรุณากรอกอีเมลและรหัสผ่านให้ครบถ้วน");
            return mav;
        }

        email = email.trim();

        String emailPattern = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        if (!java.util.regex.Pattern.matches(emailPattern, email)) {
            mav.addObject("error", "❌ รูปแบบอีเมลไม่ถูกต้อง");
            mav.addObject("email", email);
            return mav;
        }

        System.out.println("Login Attempt: User=" + email + " Role=" + role);
        
        if ("user".equals(role)) {
            String hashedPassword = password;
            try {
                hashedPassword = PasswordUtil.getInstance().createPassword(password , "itmjusci");
            } catch (Exception e ) {
                e.printStackTrace();
            }
            
            RegisterManager rm = new RegisterManager();

            Member user = rm.getRegisterByEmailAndPassword(email, hashedPassword);

            if (user != null) {

                if ("Banned".equalsIgnoreCase(user.getStatus())) {
                    mav.addObject("error", "⛔ บัญชีนี้ถูกระงับการใช้งาน กรุณาติดต่อ Admin");
                    mav.addObject("email", email);
                    return mav;
                }

                session.setAttribute("user", user);
                return new ModelAndView("redirect:/Main?msg=login_success"); 
            }
        }

        else if ("staff".equals(role)) {
            
            String hashedPassword = password;
            try {
                hashedPassword = PasswordUtil.getInstance().createPassword(password, "itmjusci");
            } catch (Exception e) {
                e.printStackTrace();
            }

            StaffManager sm = new StaffManager();
            Staff staff = sm.getStaffByEmailAndPassword(email, hashedPassword); 

            if (staff != null) {
                if (staff.getId() == 1) { 
                    session.setAttribute("admin", staff);
                    return new ModelAndView("redirect:/AdminCenter?msg=login_success");
                } else {
                    session.setAttribute("seller", staff);
                    System.out.println("Seller Login Success: " + staff.getEmail());
                    return new ModelAndView("redirect:/SellerCenter?msg=login_success");
                }
            }
        }

        mav.addObject("error", "❌ อีเมล หรือ รหัสผ่าน ไม่ถูกต้อง");
        mav.addObject("email", email); 
        return mav;
    }
    
    @RequestMapping(value="/Logout", method=RequestMethod.GET)
    public ModelAndView logout(HttpSession session) {
        session.invalidate(); 
        return new ModelAndView("redirect:/Home");
    }
}