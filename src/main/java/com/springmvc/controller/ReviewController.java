package com.springmvc.controller;

import java.util.Date;
import java.util.UUID;
import java.util.Arrays;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.HtmlUtils;

import com.springmvc.model.Member;
import com.springmvc.model.Product;
import com.springmvc.model.ProductManager;
import com.springmvc.model.Review;
import com.springmvc.model.ReviewManager;


import jakarta.servlet.http.HttpSession;

@Controller
public class ReviewController {

    private static final List<String> BAD_WORDS = Arrays.asList(
        "กู", "มึง", "สัส", "เหี้ย", "ควย", "เย็ด", "fuck", "shit", "bitch", "asshole", 
        "เลว", "โง่", "ควาย", "ตาย", "ฆ่า"
    );

    private static final int MIN_LENGTH = 10;
    private static final int MAX_LENGTH = 200;

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

            comment = comment.trim();

            if (comment.length() < MIN_LENGTH || comment.length() > MAX_LENGTH) {
                return new ModelAndView("redirect:/WriteReview?productId=" + productId + "&error=length");
            }

            String safeComment = HtmlUtils.htmlEscape(comment);

            for (String badWord : BAD_WORDS) {
                if (safeComment.contains(badWord)) {
                    return new ModelAndView("redirect:/WriteReview?productId=" + productId + "&error=profanity");
                }
            }

            if (safeComment.isEmpty()) {
                 return new ModelAndView("redirect:/WriteReview?productId=" + productId + "&error=empty");
            }

            Review review = new Review();
            review.setReviewId(UUID.randomUUID().toString());
            review.setRating(rating);
            review.setComment(safeComment);
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
            return new ModelAndView("redirect:/WriteReview?productId=" + productId + "&error=server");
        }
    }
}