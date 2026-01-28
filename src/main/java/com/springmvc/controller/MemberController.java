package com.springmvc.controller;

import java.io.File;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.springmvc.model.Member;
import com.springmvc.model.RegisterManager;
import com.springmvc.model.UserManager;
import java.util.regex.Pattern;

import jakarta.servlet.http.HttpSession;

@Controller
public class MemberController {

	@RequestMapping(value = "/Profile", method = RequestMethod.GET) 
	public ModelAndView showProfilePage(HttpSession session) {
	    Member userInSession = (Member) session.getAttribute("user");
	    if (userInSession == null) {
	        return new ModelAndView("redirect:/Login");
	    }
	    return new ModelAndView("profile"); 
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
            @RequestParam("memberId") String memberId,
            @RequestParam("memberName") String memberName,
            @RequestParam("phone") String phone,
            @RequestParam("email") String email,
            @RequestParam("profileImg") MultipartFile profileImg,
            HttpSession session
    ) {

        Member currentUser = (Member) session.getAttribute("user");
        if (currentUser == null) {
            return new ModelAndView("redirect:/Login"); 
        }
        
        if (!currentUser.getMemberId().equals(memberId)) {
            return new ModelAndView("redirect:/Logout"); 
        }

        ModelAndView mav = new ModelAndView("editProfile");
        RegisterManager rm = new RegisterManager();
        UserManager um = new UserManager();

        try {

            memberName = memberName.trim();
            phone = phone.trim();
            email = email.trim();

            if (memberName.isEmpty() || !Pattern.matches("^[a-zA-Z0-9ก-๙\\s]{4,50}$", memberName)) {
                mav.addObject("error", "❌ ชื่อผู้ใช้ไม่ถูกต้อง (4-50 ตัวอักษร, ห้ามอักขระพิเศษ)");
                return mav;
            }

            if (!Pattern.matches("^0[689][0-9]{8}$", phone)) {
                mav.addObject("error", "❌ เบอร์โทรศัพท์ไม่ถูกต้อง (ต้องขึ้นต้นด้วย 06, 08, 09)");
                return mav;
            }

            if (!Pattern.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email)) {
                mav.addObject("error", "❌ รูปแบบอีเมลไม่ถูกต้อง");
                return mav;
            }

            if (!email.equals(currentUser.getEmail()) && um.checkEmailExists(email)) {
                mav.addObject("error", "❌ อีเมลนี้ถูกใช้งานแล้ว กรุณาใช้อีเมลอื่น");
                return mav;
            }

            String fileName = currentUser.getMemberImg();

            if (profileImg != null && !profileImg.isEmpty()) {

                String uploadDir = "/app/images/user/"; 
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();
                
                fileName = UUID.randomUUID().toString() + "_" + profileImg.getOriginalFilename();
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
                return new ModelAndView("redirect:/Profile?msg=update_success"); 
            } else {
                mav.addObject("error", "❌ บันทึกข้อมูลไม่สำเร็จ");
                return mav;
            }

        } catch (Exception e) {
            e.printStackTrace();
            mav.addObject("error", "เกิดข้อผิดพลาด: " + e.getMessage());
            return mav;
        }
    }
}
	
