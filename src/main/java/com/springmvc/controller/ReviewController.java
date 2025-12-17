package com.springmvc.controller;

import java.util.Date;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.springmvc.model.Member;
import com.springmvc.model.Product;
import com.springmvc.model.ProductManager;
import com.springmvc.model.Review;
import com.springmvc.model.ReviewManager;

import jakarta.servlet.http.HttpSession;

@Controller
public class ReviewController {

    @RequestMapping(value = "/WriteReview", method = RequestMethod.GET)
    public ModelAndView showReviewPage(@RequestParam("productId") String productId, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return new ModelAndView("redirect:/Login");
        }

        ProductManager pm = new ProductManager();
        Product product = pm.getProduct(productId);

        ModelAndView mav = new ModelAndView("review");
        mav.addObject("product", product);
        return mav;
    }

    @RequestMapping(value = "/saveReview", method = RequestMethod.POST)
    public ModelAndView saveReview(
            @RequestParam("productId") String productId,
            @RequestParam("rating") int rating,
            @RequestParam("comment") String comment,
            HttpSession session) {

        Member user = (Member) session.getAttribute("user");
        if (user == null) {
            return new ModelAndView("redirect:/Login");
        }

        try {
            Review review = new Review();
            review.setReviewId(UUID.randomUUID().toString());
            review.setRating(rating);
            review.setComment(comment);
            review.setReviewDate(new Date());
            review.setMember(user);

            ProductManager pm = new ProductManager();
            Product product = pm.getProduct(productId);
            review.setProduct(product);

            ReviewManager rm = new ReviewManager();
            rm.insertReview(review);

            return new ModelAndView("redirect:/History?msg=reviewSuccess");

        } catch (Exception e) {
            e.printStackTrace();
            return new ModelAndView("redirect:/WriteReview?productId=" + productId + "&error=true");
        }
    }
}