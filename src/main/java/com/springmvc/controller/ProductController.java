package com.springmvc.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.HtmlUtils;

import com.springmvc.model.HibernateConnection;
import com.springmvc.model.Product;
import com.springmvc.model.ProductManager;
import com.springmvc.model.Review;
import com.springmvc.model.ReviewManager;
import com.springmvc.model.Species;
import com.springmvc.model.SpeciesManager;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import org.hibernate.Session;
import org.hibernate.SessionFactory;

@Controller
public class ProductController {
	
    @RequestMapping(value="/AllProduct", method=RequestMethod.GET)
    public ModelAndView productPage(
            @RequestParam(value = "category", defaultValue = "all") String category,
            @RequestParam(value = "sortBy", defaultValue = "default") String sortBy,
            @RequestParam(value = "page", defaultValue = "1") int page,
            HttpServletRequest request) {

        int pageSize = 15;
        ProductManager pm = new ProductManager();
        SpeciesManager sm = new SpeciesManager();

        ReviewManager rm = new ReviewManager(); 

        List<Product> products = pm.getProductsWithFilter(category, sortBy, page, pageSize);

        Map<String, Double> productRatings = new HashMap<>();
        for (Product p : products) {
            productRatings.put(p.getProductId(), rm.getAverageRating(p.getProductId()));
        }

        long totalProducts = pm.countProducts(category);
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        List<Species> speciesList = sm.getAllSpecies(); 

        ModelAndView mav = new ModelAndView("allProduct"); 

        mav.addObject("Product", products);
        mav.addObject("speciesList", speciesList);
        mav.addObject("currentPage", page);
        mav.addObject("totalPages", totalPages);

        mav.addObject("productRatings", productRatings);

        return mav;
    }
	 
    @RequestMapping(value="/SearchProducts", method=RequestMethod.GET) 
    public ModelAndView searchProducts(HttpServletRequest request) {
        
        String rawSearchText = request.getParameter("searchtext");
        
        String searchtext = (rawSearchText != null) ? HtmlUtils.htmlEscape(rawSearchText) : "";

        ModelAndView mav = new ModelAndView("products"); 

        ProductManager pm = new ProductManager();
        SpeciesManager sm = new SpeciesManager();
        ReviewManager rm = new ReviewManager(); 

        List<Product> products = pm.getSearchProductsBySpecies(searchtext);

        Map<String, Double> productRatings = new HashMap<>();
        for (Product p : products) {
            productRatings.put(p.getProductId(), rm.getAverageRating(p.getProductId()));
        }

        List<Species> speciesList = sm.getAllSpecies();
        
        mav.addObject("Product", products);
        mav.addObject("speciesList", speciesList);
        mav.addObject("productRatings", productRatings);
        
        mav.addObject("searchQuery", searchtext); 

        return mav;
    }
	 
	@RequestMapping(value="/ProductDetail", method=RequestMethod.GET)
    public ModelAndView openProductDetail(
            @RequestParam("pid") String pid,
            @RequestParam(value = "sort", defaultValue = "newest") String sort, 
            HttpServletRequest request) {
        
        ProductManager pm = new ProductManager();
        Product p = pm.getProduct(pid);
        
        ReviewManager rm = new ReviewManager();
        List<Review> reviews = rm.getReviewsByProductId(pid, sort);
        double avgRating = rm.getAverageRating(pid);
        
        ModelAndView mav = new ModelAndView("productDetail");
        mav.addObject("product", p);
        mav.addObject("reviews", reviews);         
        mav.addObject("avgRating", avgRating);      
        mav.addObject("totalReviews", reviews.size()); 
        mav.addObject("currentSort", sort);      
        
        return mav;
    }

	public boolean deleteProduct(String productId) {
        boolean result = false;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            session.beginTransaction();

            Product product = session.get(Product.class, productId);
            
            if (product != null) {
                session.remove(product);
                session.getTransaction().commit();
                result = true;
            }

        } catch (Exception e) {
            if (session != null && session.getTransaction().isActive()) {
                session.getTransaction().rollback();
            }
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return result;
    }
}