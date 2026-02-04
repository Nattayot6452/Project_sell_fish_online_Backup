package com.springmvc.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;
import com.springmvc.model.Member;
import com.springmvc.model.UserManager;

public class UserStatusInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            Member sessionUser = (Member) session.getAttribute("user");
            
            UserManager um = new UserManager();
            Member dbUser = um.getMemberById(sessionUser.getMemberId());

            if (dbUser == null || "Banned".equalsIgnoreCase(dbUser.getStatus())) {
                
                session.invalidate();
                
                response.sendRedirect(request.getContextPath() + "/Login?error=banned_session");
                
                return false; 
            }
        }
        
        return true;
    }
}