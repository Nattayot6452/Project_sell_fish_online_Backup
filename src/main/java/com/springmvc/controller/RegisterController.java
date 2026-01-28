package com.springmvc.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import com.springmvc.model.Member;
import com.springmvc.model.RegisterManager;
import com.springmvc.model.UserManager;

import java.io.File;
import java.util.UUID;
import java.util.regex.Pattern;

@Controller
public class RegisterController {

    @RequestMapping(value = "/Register", method = RequestMethod.GET)
    public ModelAndView openRegisterPage() {
        return new ModelAndView("register");
    }

    @RequestMapping(value = "/saveRegister", method = RequestMethod.POST)
    public ModelAndView saveRegister(
            @RequestParam("email") String email,
            @RequestParam("name") String name,
            @RequestParam("password") String password,
            @RequestParam("confirmPassword") String confirmPassword,
            @RequestParam("tel") String phone,
            @RequestParam("profileImg") MultipartFile profileImg,
            HttpServletRequest request
    ) {
        ModelAndView mv = new ModelAndView("register");
        RegisterManager rm = new RegisterManager();
        UserManager um = new UserManager();

        try {

            name = name.trim();

            String namePattern = "^[a-zA-Z0-9ก-๙\\s]{4,50}$";
            if (name.isEmpty() || !Pattern.matches(namePattern, name)) {
                mv.addObject("add_result", "❌ ชื่อผู้ใช้ไม่ถูกต้อง (ต้องมีตัวอักษร 4-50 ตัว ห้ามเว้นว่างล้วน)");
                return keepFormData(mv, email, name, phone);
            }

            if (!Pattern.matches("^0[689][0-9]{8}$", phone)) {
                mv.addObject("add_result", "❌ เบอร์โทรศัพท์ไม่ถูกต้อง (ต้องขึ้นต้นด้วย 06, 08, 09 และมี 10 หลัก)");
                return keepFormData(mv, email, name, phone);
            }

            String passPattern = "^[a-zA-Z0-9]{8,}$";
            if (!Pattern.matches(passPattern, password)) {
                mv.addObject("add_result", "❌ รหัสผ่านต้องเป็นภาษาอังกฤษและตัวเลขเท่านั้น (ขั้นต่ำ 8 ตัวอักษร)");
                return keepFormData(mv, email, name, phone);
            }

            if (!password.equals(confirmPassword)) {
                mv.addObject("error", "pass_mismatch");
                return keepFormData(mv, email, name, phone);
            }

            if (um.checkEmailExists(email)) {
                mv.addObject("error", "email_duplicate");
                return keepFormData(mv, email, name, phone);
            }

            String memberId = UUID.randomUUID().toString();
            String fileName = "default.png";

            if (!profileImg.isEmpty()) {
                String uploadDir = "/app/images/user/"; 
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();

                fileName = UUID.randomUUID().toString() + "_" + profileImg.getOriginalFilename();
                File serverFile = new File(dir, fileName);
                profileImg.transferTo(serverFile);
            }

            String hashedPassword = PasswordUtil.getInstance().createPassword(password, "itmjusci");

            Member newMember = new Member(memberId, email, name, hashedPassword, phone, fileName);

            boolean result = rm.insertRegister(newMember);

            if (result) {
                return new ModelAndView("redirect:/Login?msg=register_success");
            } else {
                mv.addObject("add_result", "❌ ไม่สามารถบันทึกข้อมูลได้ (Database Error)");
            }

        } catch (Exception e) {
            e.printStackTrace();
            mv.addObject("add_result", "เกิดข้อผิดพลาด: " + e.getMessage());
        }

        return mv;
    }

    private ModelAndView keepFormData(ModelAndView mv, String email, String name, String phone) {
        mv.addObject("email", email);
        mv.addObject("name", name);
        mv.addObject("tel", phone);
        return mv;
    }
}