package com.springmvc.controller;

import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.springmvc.model.OrderManager;
import com.springmvc.model.Orders;
import com.springmvc.model.Product;
import com.springmvc.model.ProductManager;
import com.springmvc.model.Species;
import com.springmvc.model.SpeciesManager;
import com.springmvc.model.UserManager;
import com.springmvc.model.Member;

import jakarta.servlet.http.HttpSession;

@Controller
public class AdminController {

    @RequestMapping(value = "/AdminCenter", method = RequestMethod.GET)
    public ModelAndView showAdminDashboard(HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return new ModelAndView("redirect:/Login");
        }

        ModelAndView mav = new ModelAndView("adminHomepage");

        try {

            UserManager um = new UserManager();
            long memberCount = um.getMemberCount();
            
            ProductManager pm = new ProductManager();
            List<Product> products = pm.getListProducts();
            int productCount = products.size();
            
            OrderManager om = new OrderManager();
            List<Orders> orders = om.getAllOrders();
            int orderCount = orders.size();
            double totalSales = 0;
            
            for (Orders o : orders) {
                if ("Completed".equalsIgnoreCase(o.getStatus())) {
                    totalSales += o.getTotalAmount();
                }
            }

            mav.addObject("memberCount", memberCount);
            mav.addObject("productCount", productCount);
            mav.addObject("orderCount", orderCount);
            mav.addObject("totalSales", totalSales);
            mav.addObject("recentOrders", orders.subList(0, Math.min(orders.size(), 5)));

        } catch (Exception e) {
            e.printStackTrace();
        }

        return mav;
    }
    
    @RequestMapping(value = "/ManageUsers", method = RequestMethod.GET)
    public ModelAndView manageUsers(HttpSession session) {
        if (session.getAttribute("admin") == null) return new ModelAndView("redirect:/Login");
        
        UserManager um = new UserManager();
        List<Member> allMembers = um.getAllMembers();
        
        ModelAndView mav = new ModelAndView("manageUsers");
        mav.addObject("allMembers", allMembers);
        return mav;
    }

    @RequestMapping(value = "/UserDetail", method = RequestMethod.GET)
    public ModelAndView viewUserDetail(@RequestParam("id") String memberId, HttpSession session) {
        if (session.getAttribute("admin") == null) return new ModelAndView("redirect:/Login");
        
        UserManager um = new UserManager();
        Member member = um.getMemberById(memberId);
        
        OrderManager om = new OrderManager();
        List<Orders> userOrders = om.getOrdersByMemberId(memberId);

        ModelAndView mav = new ModelAndView("userDetail");
        mav.addObject("member", member);
        mav.addObject("userOrders", userOrders);
        return mav;
    }

    @RequestMapping(value = "/BanUser", method = RequestMethod.GET)
    public ModelAndView banUser(@RequestParam("id") String memberId, HttpSession session) {
        if (session.getAttribute("admin") == null) return new ModelAndView("redirect:/Login");
        
        UserManager um = new UserManager();
        boolean success = um.deleteMember(memberId);
        
        if (success) {
            return new ModelAndView("redirect:/ManageUsers?msg=banned");
        } else {
            return new ModelAndView("redirect:/ManageUsers?error=failed");
        }
    }

    @RequestMapping(value = "/AddSpecies", method = RequestMethod.GET)
    public ModelAndView showAddSpeciesPage(HttpSession session) {
        if (session.getAttribute("admin") == null) return new ModelAndView("redirect:/Login");
        
        SpeciesManager sm = new SpeciesManager();
        List<Species> list = sm.getAllSpecies();

        ModelAndView mav = new ModelAndView("addSpecies");
        mav.addObject("speciesList", list);
        return mav;
    }

    @RequestMapping(value = "/saveSpecies", method = RequestMethod.POST)
    public ModelAndView saveSpecies(@RequestParam("speciesName") String speciesName, HttpSession session) {
        if (session.getAttribute("admin") == null) return new ModelAndView("redirect:/Login");

        try {
            SpeciesManager sm = new SpeciesManager();
            
            String newId = "SP" + UUID.randomUUID().toString().substring(0, 4).toUpperCase();
            
            Species newSpecies = new Species(newId, speciesName);
            boolean success = sm.insertSpecies(newSpecies);

            if (success) {
                return new ModelAndView("redirect:/AddSpecies?msg=success");
            } else {
                return new ModelAndView("redirect:/AddSpecies?error=db");
            }

        } catch (Exception e) {
            e.printStackTrace();
            return new ModelAndView("redirect:/AddSpecies?error=exception");
        }
    }
    
    @RequestMapping(value = "/ManageSpecies", method = RequestMethod.GET)
    public ModelAndView listSpecies(HttpSession session) {
        if (session.getAttribute("admin") == null) return new ModelAndView("redirect:/Login");
        
        SpeciesManager sm = new SpeciesManager();
        List<Species> list = sm.getAllSpecies();

        ModelAndView mav = new ModelAndView("manageSpecies");
        mav.addObject("speciesList", list);
        return mav;
    }

    @RequestMapping(value = "/ViewSpecies", method = RequestMethod.GET)
    public ModelAndView viewSpecies(@RequestParam("id") String id, HttpSession session) {
        if (session.getAttribute("admin") == null) return new ModelAndView("redirect:/Login");
        
        SpeciesManager sm = new SpeciesManager();
        Species species = sm.getSpeciesById(id);

        ModelAndView mav = new ModelAndView("viewSpecies");
        mav.addObject("species", species);
        return mav;
    }

    @RequestMapping(value = "/EditSpecies", method = RequestMethod.GET)
    public ModelAndView editSpecies(@RequestParam("id") String id, HttpSession session) {
        if (session.getAttribute("admin") == null) return new ModelAndView("redirect:/Login");
        
        SpeciesManager sm = new SpeciesManager();
        Species species = sm.getSpeciesById(id);

        ModelAndView mav = new ModelAndView("editSpecies");
        mav.addObject("species", species);
        return mav;
    }

    @RequestMapping(value = "/updateSpecies", method = RequestMethod.POST)
    public ModelAndView updateSpecies(
            @RequestParam("speciesId") String speciesId,
            @RequestParam("speciesName") String speciesName,
            @RequestParam("description") String description,
            HttpSession session) {
        
        if (session.getAttribute("admin") == null) return new ModelAndView("redirect:/Login");

        try {
            SpeciesManager sm = new SpeciesManager();
            Species s = new Species(speciesId, speciesName);
            s.setDescription(description);
            
            boolean success = sm.updateSpecies(s);

            if (success) {
                return new ModelAndView("redirect:/ViewSpecies?id=" + speciesId + "&msg=updated");
            } else {
                return new ModelAndView("redirect:/EditSpecies?id=" + speciesId + "&error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ModelAndView("redirect:/ManageSpecies");
        }
    }

    @RequestMapping(value = "/RemoveSpecies", method = RequestMethod.GET)
    public ModelAndView removeSpecies(@RequestParam("id") String id, HttpSession session) {
        if (session.getAttribute("admin") == null) return new ModelAndView("redirect:/Login");
        
        SpeciesManager sm = new SpeciesManager();
        boolean success = sm.deleteSpecies(id);
        
        if (success) {

            return new ModelAndView("redirect:/ManageSpecies?msg=deleted");
        } else {

            return new ModelAndView("redirect:/ViewSpecies?id=" + id + "&error=delete_failed");
        }
    }

}