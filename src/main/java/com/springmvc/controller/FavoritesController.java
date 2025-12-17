package com.springmvc.controller;

import com.springmvc.model.FavoriteManager;
import com.springmvc.model.FavoriteProduct;
import com.springmvc.model.Member;
import com.springmvc.model.Product;
import com.springmvc.model.ProductManager;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.Collections;
import java.util.List;
import java.util.UUID;

@Controller
public class FavoritesController {

	@RequestMapping(value = "/Favorites", method = RequestMethod.GET)
    public ModelAndView showFavoritesPage(HttpSession session) {

        Member user = (Member) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/Login");
        }

        ModelAndView mav = new ModelAndView("favorites");

        List<FavoriteProduct> userFavorites = Collections.emptyList(); 
        try {
            FavoriteManager fm = new FavoriteManager();
            userFavorites = fm.getFavoritesByMemberId(user.getMemberId()); 
        } catch (Exception e) {
            System.err.println("Error fetching favorites for page: " + e.getMessage());
        }
        mav.addObject("favoriteList", userFavorites);

        return mav;
    }

    @RequestMapping(value="/addToFavorites", method=RequestMethod.GET)
    public ModelAndView addToFavorites(@RequestParam("productId") String productId, HttpSession session) {
        Member user = (Member) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/Login");
        }

        try {
            ProductManager pm = new ProductManager();
            Product product = pm.getProduct(productId);
            if (product == null) {
                System.err.println("Product not found with ID: " + productId);
                return new ModelAndView("redirect:/AllProduct?error=product_not_found");
            }

            FavoriteProduct newFavorite = new FavoriteProduct();
            newFavorite.setFavoriteId(UUID.randomUUID().toString());
            newFavorite.setMember(user);
            newFavorite.setProduct(product);

            FavoriteManager fm = new FavoriteManager();
            boolean success = fm.addFavorite(newFavorite);

            if (success) {
                System.out.println("Added product " + productId + " to favorites for user " + user.getMemberId());
            } else {
                System.out.println("Failed to add favorite.");
            }

        } catch (Exception e) {
            System.err.println("Error adding favorite: " + e.getMessage());
            e.printStackTrace();
        }

        return new ModelAndView("redirect:/AllProduct");
    }

    @RequestMapping(value = "/RemoveFavorite", method = RequestMethod.GET)
    public ModelAndView removeFavoriteItem(@RequestParam("favId") String favoriteId, HttpSession session) {

         Member user = (Member) session.getAttribute("user");
         if (user == null) {
             return new ModelAndView("redirect:/Login");
         }

         try {
             FavoriteManager fm = new FavoriteManager();
             boolean success = fm.removeFavorite(favoriteId);

             if (success) {
                 System.out.println("Removed favorite with ID: " + favoriteId);
             } else {
                 System.out.println("Failed to remove favorite with ID: " + favoriteId + " (maybe not found?)");
              
             }

         } catch (Exception e) {
             System.err.println("Error removing favorite: " + e.getMessage());
             e.printStackTrace();
         }

         return new ModelAndView("redirect:/Favorites");
    }
    
}