package com.springmvc.controller;

import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.HtmlUtils;

import com.springmvc.model.OrderManager;
import com.springmvc.model.Orders;
import com.springmvc.model.Product;
import com.springmvc.model.ProductManager;
import com.springmvc.model.Species;
import com.springmvc.model.SpeciesManager;
import com.springmvc.model.UserManager;
import com.springmvc.model.Member;
import java.util.regex.Pattern;

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
        boolean success = um.toggleMemberStatus(memberId);
        
        if (success) {
            return new ModelAndView("redirect:/ManageUsers?msg=status_changed");
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

            speciesName = speciesName.trim();

            if (speciesName.isEmpty()) {
                return new ModelAndView("redirect:/AddSpecies?error=empty");
            }

            if (speciesName.length() < 2 || speciesName.length() > 50) {
                return new ModelAndView("redirect:/AddSpecies?error=length");
            }

            String pattern = "^[a-zA-Z0-9ก-๙\\s\\-_()]+$";
            if (!Pattern.matches(pattern, speciesName)) {
                return new ModelAndView("redirect:/AddSpecies?error=invalidChar");
            }

            speciesName = HtmlUtils.htmlEscape(speciesName);

            SpeciesManager sm = new SpeciesManager();

            List<Species> existingList = sm.getAllSpecies();

            for (Species s : existingList) {

                if (s.getSpeciesName().equalsIgnoreCase(speciesName)) {

                    return new ModelAndView("redirect:/AddSpecies?error=duplicate");
                }
            }
            
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

            speciesName = speciesName.trim();
            description = description.trim();

            if (speciesName.isEmpty() || description.isEmpty()) {
                return new ModelAndView("redirect:/EditSpecies?id=" + speciesId + "&error=empty");
            }

            if (speciesName.length() < 2 || speciesName.length() > 50) {
                return new ModelAndView("redirect:/EditSpecies?id=" + speciesId + "&error=nameLength");
            }

            if (description.length() < 10 || description.length() > 255) {
                return new ModelAndView("redirect:/EditSpecies?id=" + speciesId + "&error=descLength");
            }

            String namePattern = "^[a-zA-Z0-9ก-๙\\s\\-_()]+$";
            if (!Pattern.matches(namePattern, speciesName)) {
                return new ModelAndView("redirect:/EditSpecies?id=" + speciesId + "&error=invalidChar");
            }

            speciesName = HtmlUtils.htmlEscape(speciesName);
            description = HtmlUtils.htmlEscape(description);

            SpeciesManager sm = new SpeciesManager();

            List<Species> existingList = sm.getAllSpecies();
            for (Species s : existingList) {

                if (s.getSpeciesName().equalsIgnoreCase(speciesName)) {

                    if (!s.getSpeciesId().equals(speciesId)) {
                        return new ModelAndView("redirect:/EditSpecies?id=" + speciesId + "&error=duplicate");
                    }
                }
            }

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

    @RequestMapping(value = "/AdminOrders", method = RequestMethod.GET)
    public ModelAndView showAdminOrders(HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return new ModelAndView("redirect:/Login");
        }

        OrderManager om = new OrderManager();
        List<Orders> allOrders = om.getAllOrders();

        ModelAndView mav = new ModelAndView("adminOrders");
        mav.addObject("orderList", allOrders);
        return mav;
    }
    @RequestMapping(value = "/AdminOrderDetail", method = RequestMethod.GET)
    public ModelAndView showAdminOrderDetail(@RequestParam("orderId") String orderId, HttpSession session) {

        if (session.getAttribute("admin") == null) {
            return new ModelAndView("redirect:/Login");
        }

        OrderManager om = new OrderManager();
        Orders order = om.getOrderById(orderId);

        ModelAndView mav = new ModelAndView("adminOrderDetail");
        mav.addObject("order", order);
        return mav;
    }

    @RequestMapping(value = "/AdminAllProducts", method = RequestMethod.GET)
    public ModelAndView showAdminAllProducts(HttpSession session) {
        if (session.getAttribute("admin") == null) return new ModelAndView("redirect:/Login");

        ProductManager pm = new ProductManager();
        List<Product> productList = pm.getListProducts();

        ModelAndView mav = new ModelAndView("adminAllProduct"); 
        mav.addObject("productList", productList);
        return mav;
    }

    @RequestMapping(value = "/AdminProductDetail", method = RequestMethod.GET)
    public ModelAndView showAdminProductDetail(@RequestParam("pid") String productId, HttpSession session) {
        if (session.getAttribute("admin") == null) return new ModelAndView("redirect:/Login");

        ProductManager pm = new ProductManager();

        Product product = pm.getProduct(productId); 

        ModelAndView mav = new ModelAndView("adminProductDetail");
        mav.addObject("product", product);
        return mav;
    }
    
}