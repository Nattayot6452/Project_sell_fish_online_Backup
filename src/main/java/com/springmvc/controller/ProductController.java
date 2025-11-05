package com.springmvc.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.springmvc.model.Product;
import com.springmvc.model.ProductManager;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ProductController {
	
	 @RequestMapping(value="/AllProduct", method=RequestMethod.GET)
	    public ModelAndView productPage(HttpServletRequest request) {

	        ProductManager pm = new ProductManager();
	        List<Product> products = pm.getListProducts();

	        ModelAndView mav = new ModelAndView("allProduct");
	        mav.addObject("Product", products);
	        return mav;
	    }
	 
	 @RequestMapping(value="/SearchProducts", method=RequestMethod.POST) 
		public ModelAndView searchProducts(HttpServletRequest request) {
			String searchtext = request.getParameter("searchtext");
			
			ModelAndView mav = new ModelAndView("products");
			ProductManager pm = new ProductManager();
			List<Product> products = pm.getSearchProductsBySpecies(searchtext);
			mav.addObject("Product", products);
			return mav;
		}
	 
	 @RequestMapping(value="/ProductDetail", method=RequestMethod.GET)
	 public ModelAndView openProductDetail(HttpServletRequest request) {
	     String pid = request.getParameter("pid");
	     
	     ProductManager pm = new ProductManager();
	     Product p = pm.getProduct(pid);
	     
	     ModelAndView mav = new ModelAndView("productDetail");
	     mav.addObject("product", p);
	     return mav;
	 }

}
