package com.springmvc.controller;
import com.springmvc.model.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Controller
public class NotificationController {

    @RequestMapping(value = "/getNotifications", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public List<Notification> getNotifications(HttpSession session) {
        NotificationManager nm = new NotificationManager();
        if (session.getAttribute("seller") != null) {

            return nm.getUnreadNotifications("0", "SELLER");
        } else if (session.getAttribute("user") != null) {
            Member user = (Member) session.getAttribute("user");
            
            return nm.getUnreadNotifications(user.getMemberId(), "MEMBER");
        }
        return null;
    }

    @RequestMapping(value = "/markRead", method = RequestMethod.POST)
    @ResponseBody
    public String markRead(@RequestParam("id") int id) {
        new NotificationManager().markAsRead(id);
        return "OK";
    }
}