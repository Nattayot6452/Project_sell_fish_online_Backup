package com.springmvc.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping; 
import org.springframework.web.bind.annotation.RequestMethod; 
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.springmvc.model.CartItem;
import com.springmvc.model.Product;
import com.springmvc.model.ProductManager;

import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@Controller
public class CartController {

    @RequestMapping(value = "/addToCart", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView addToCart(
            @RequestParam("productId") String productId,
            @RequestParam(value = "quantity", defaultValue = "1") int quantity, 
            HttpSession session,
            HttpServletRequest request) { 
        
        if (session.getAttribute("user") == null) { 
            return new ModelAndView("redirect:/Login");
        }
        
        ProductManager pm = new ProductManager();
        Product product = pm.getProduct(productId);
        
        if (product == null) {
             return new ModelAndView("redirect:/AllProduct");
        }

        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
        if (cart == null) { cart = new HashMap<>(); }
        
        int currentQuantityInCart = cart.getOrDefault(productId, 0);
        int totalWanted = currentQuantityInCart + quantity;

        if (product.getStock() <= 0 || product.getStock() < totalWanted) {
            System.out.println("❌ ใส่ตะกร้าไม่ได้! สต็อกมี: " + product.getStock() + ", ขอ: " + totalWanted);
            
            String referer = request.getHeader("Referer");
            return new ModelAndView("redirect:" + (referer != null ? referer : "/AllProduct") + "?error=outOfStock");
        }
        
        cart.put(productId, totalWanted);
        session.setAttribute("cart", cart);
        System.out.println("✅ Added to cart: " + product.getProductName() + " (Qty: " + totalWanted + ")");
        
        String referer = request.getHeader("Referer");
        return new ModelAndView("redirect:" + (referer != null ? referer : "/AllProduct"));
    }

    @RequestMapping(value = "/Cart", method = RequestMethod.GET)
    public ModelAndView showCart(HttpSession session) {

        if (session.getAttribute("user") == null) {
            return new ModelAndView("redirect:/Login");
        }

        ModelAndView mav = new ModelAndView("cart");
        Map<String, Integer> cartSessionData = (Map<String, Integer>) session.getAttribute("cart");
        List<CartItem> cartItems = new ArrayList<>();
        double totalCartPrice = 0.0;
        ProductManager pm = new ProductManager();
        if (cartSessionData != null && !cartSessionData.isEmpty()) {
            for (Map.Entry<String, Integer> entry : cartSessionData.entrySet()) {
                Product product = pm.getProduct(entry.getKey());
                if (product != null) {
                    CartItem item = new CartItem(product, entry.getValue());
                    cartItems.add(item);
                    totalCartPrice += item.getItemTotal();
                }
            }
        }
        mav.addObject("cartItems", cartItems);
        mav.addObject("totalCartPrice", totalCartPrice);
        return mav;
    }

    @RequestMapping(value = "/removeFromCart", method = RequestMethod.GET)
    public ModelAndView removeFromCart(@RequestParam("productId") String productId, HttpSession session) {
        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
        if (cart != null && cart.containsKey(productId)) {
            cart.remove(productId);
            session.setAttribute("cart", cart);
        }
        return new ModelAndView("redirect:/Cart");
    }

    @RequestMapping(value = "/updateFullCart", method = RequestMethod.POST)
    public ModelAndView updateFullCart(HttpServletRequest request, HttpSession session) {

        if (session.getAttribute("user") == null) {
            return new ModelAndView("redirect:/Login");
        }

        Map<String, Integer> updatedCart = new HashMap<>();
        Map<String, String[]> parameterMap = request.getParameterMap();
        
        ProductManager pm = new ProductManager(); 

        for (Map.Entry<String, String[]> entry : parameterMap.entrySet()) {
            String paramName = entry.getKey();
            String[] paramValues = entry.getValue();

            if (paramName.startsWith("quantity_") && paramValues != null && paramValues.length > 0) {
                try {
                    String productId = paramName.substring("quantity_".length());
                    int newQuantity = Integer.parseInt(paramValues[0]);
                    
                    Product p = pm.getProduct(productId);
                    if (p != null && newQuantity > 0) {
                        if (newQuantity <= p.getStock()) {
                             updatedCart.put(productId, newQuantity); 
                        } else {
                             updatedCart.put(productId, p.getStock()); 
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        session.setAttribute("cart", updatedCart);
        return new ModelAndView("redirect:/Cart");
    }
}