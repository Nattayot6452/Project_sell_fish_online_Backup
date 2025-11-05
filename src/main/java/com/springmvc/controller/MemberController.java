package com.springmvc.controller;

import java.io.File;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.springmvc.model.Member;
import com.springmvc.model.RegisterManager;

import jakarta.servlet.http.HttpSession;

@Controller
public class MemberController {

	@RequestMapping(value = "/Profile", method = RequestMethod.GET) 
	public ModelAndView showProfilePage(HttpSession session) {
	    
	    Member userInSession = (Member) session.getAttribute("user");
	    
	    if (userInSession == null) {
	        return new ModelAndView("redirect:/Login");
	    }
	    
	    ModelAndView mav = new ModelAndView("profile"); 
	    return mav;
	}
	
	@RequestMapping(value = "/Editprofile", method = RequestMethod.GET) 
	public ModelAndView EditprofilePage(HttpSession session) {
	    
	    Member userInSession = (Member) session.getAttribute("user");
	    
	    if (userInSession == null) {
	        return new ModelAndView("redirect:/Login");
	    }
	    
	    ModelAndView mav = new ModelAndView("editProfile"); 
	    return mav;
	}
	
	@RequestMapping(value = "/editProfile", method = RequestMethod.GET)
    public ModelAndView showEditProfilePage(HttpSession session) {
        
        Member user = (Member) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/Login");
        }
        
        return new ModelAndView("editProfile"); 
    }
	
	@RequestMapping(value = "/updateProfile", method = RequestMethod.POST)
    public ModelAndView updateProfile(
            // รับค่าจากฟอร์ม
            @RequestParam("memberId") String memberId,
            @RequestParam("memberName") String memberName,
            @RequestParam("phone") String phone,
            @RequestParam("email") String email,
            @RequestParam("profileImg") MultipartFile profileImg,
            HttpSession session
    ) {
        
        Member currentUser = (Member) session.getAttribute("user");
        if (currentUser == null || !currentUser.getMemberId().equals(memberId)) {
            return new ModelAndView("redirect:/Login"); 
        }

        RegisterManager rm = new RegisterManager();
        
        try {
            String fileName = currentUser.getMemberImg();

            if (profileImg != null && !profileImg.isEmpty()) {
                fileName = profileImg.getOriginalFilename();
                String uploadDir = "C:/tmp/uploads/";
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();
                
                File serverFile = new File(dir, fileName);
                profileImg.transferTo(serverFile);
            }

            Member updatedMember = new Member(
                memberId,
                email, 
                memberName,
                currentUser.getPassword(),
                phone,
                fileName
            );

            boolean result = rm.updateRegister(updatedMember);
            if (result) {
                session.setAttribute("user", updatedMember); 
                
                return new ModelAndView("redirect:/Profile"); 
            } else {
                ModelAndView mav = new ModelAndView("editProfile");
                mav.addObject("error", "❌ อัปเดตข้อมูลไม่สำเร็จ");
                return mav;
            }

        } catch (Exception e) {
            e.printStackTrace();
            ModelAndView mav = new ModelAndView("editProfile");
            mav.addObject("error", "เกิดข้อผิดพลาด: " + e.getMessage());
            return mav;
        }
    }
	
}
