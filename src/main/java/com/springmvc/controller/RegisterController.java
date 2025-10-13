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

import java.io.File;
import java.util.UUID;

@Controller
public class RegisterController {

    @RequestMapping(value = "/gRegister", method = RequestMethod.GET)
    public ModelAndView openRegisterPage() {
        return new ModelAndView("register");
    }

//    @RequestMapping(value = "/saveRegister", method = RequestMethod.POST)
//    public ModelAndView saveRegister(
//            @RequestParam("email") String email,
//            @RequestParam("name") String name,
//            @RequestParam("password") String password,
//            @RequestParam("tel") String phone,
//            @RequestParam("profileImg") MultipartFile profileImg
//    ) {
//        ModelAndView mv = new ModelAndView("register");
//        RegisterManager rm = new RegisterManager();
//
//        try {
//            String memberId = UUID.randomUUID().toString();
//            String memberImg = profileImg.getOriginalFilename(); // หรือ save ลง server
//            Member newMember = new Member(memberId, email, name, password, phone, memberImg);
//
//            boolean result = rm.insertRegister(newMember);
//
//            if(result) {
//                mv.setViewName("login");
//                mv.addObject("message", "✅ สมัครสมาชิกสำเร็จแล้ว!");
//            } else {
//                mv.addObject("add_result", "❌ ไม่สามารถบันทึกข้อมูลได้");
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            mv.addObject("add_result", "เกิดข้อผิดพลาด: " + e.getMessage());
//        }
//
//        return mv;
//    }

    @RequestMapping(value = "/saveRegister", method = RequestMethod.POST)
    public ModelAndView saveRegister(
            @RequestParam("email") String email,
            @RequestParam("name") String name,
            @RequestParam("password") String password,
            @RequestParam("tel") String phone,
            @RequestParam("profileImg") MultipartFile profileImg,
            HttpServletRequest request
    ) {
        ModelAndView mv = new ModelAndView("register");
        RegisterManager rm = new RegisterManager();

        try {
            // 🔹 Log ตรวจสอบ
            System.out.println("Email: " + email);
            System.out.println("Name: " + name);
            System.out.println("Tel: " + phone);
            System.out.println("ProfileImg: " + profileImg.getOriginalFilename());

            String memberId = UUID.randomUUID().toString();
            String fileName = profileImg.getOriginalFilename();

            // 🔹 บันทึกไฟล์ไปที่ folder ใน server (เช่น C:/tmp/uploads/)
            if (!profileImg.isEmpty()) {
                String uploadDir = "C:/tmp/uploads/";
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();

                File serverFile = new File(dir, fileName);
                profileImg.transferTo(serverFile);
            }

            // 🔹 สร้าง Member object
            Member newMember = new Member(memberId, email, name, password, phone, fileName);

            boolean result = rm.insertRegister(newMember);

            if (result) {
                mv.setViewName("login");
                mv.addObject("message", "✅ สมัครสมาชิกสำเร็จแล้ว!");
            } else {
                mv.addObject("add_result", "❌ ไม่สามารถบันทึกข้อมูลได้");
            }

        } catch (Exception e) {
            e.printStackTrace();
            mv.addObject("add_result", "เกิดข้อผิดพลาด: " + e.getMessage());
        }

        return mv;
    }

}
