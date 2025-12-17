package com.springmvc.controller;

import java.io.File;
import java.util.UUID;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.multipart.MultipartFile;

import com.springmvc.model.OrderManager;
import com.springmvc.model.Orders;
import com.springmvc.model.Product;
import com.springmvc.model.ProductManager;
import com.springmvc.model.Species;
import com.springmvc.model.SpeciesManager;

import jakarta.servlet.http.HttpSession;

@Controller
public class SellerController {

    @RequestMapping(value = "/SellerCenter", method = RequestMethod.GET)
    public ModelAndView showSellerHomepage(
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "category", required = false) String category,
            HttpSession session) {
        
        if (session.getAttribute("seller") == null) {
            return new ModelAndView("redirect:/Login");
        }

        ProductManager pm = new ProductManager();
        
        List<Product> products;
        if ((search != null && !search.isEmpty()) || (category != null && !category.equals("all"))) {
            products = pm.searchProducts(search, category);
        } else {
            products = pm.getListProducts();
        }

        List<Species> speciesList = pm.getAllSpecies();

        ModelAndView mav = new ModelAndView("sellerHomepage");
        mav.addObject("products", products);
        mav.addObject("speciesList", speciesList);
        
        mav.addObject("paramSearch", search);
        mav.addObject("paramCategory", category);
        
        return mav;
    }

    @RequestMapping(value = "/AddProduct", method = RequestMethod.GET)
    public ModelAndView showAddProductPage(HttpSession session) {

        if (session.getAttribute("seller") == null) {
            return new ModelAndView("redirect:/Login");
        }

        SpeciesManager sm = new SpeciesManager();
        List<Species> list = sm.getAllSpecies();

        ModelAndView mav = new ModelAndView("addProduct");

        mav.addObject("speciesList", list); 
        return mav;
    }

    @RequestMapping(value = "/saveProduct", method = RequestMethod.POST)
    public ModelAndView saveProduct(
            @RequestParam("productName") String productName,
            @RequestParam("speciesId") String speciesId,
            @RequestParam("price") double price,
            @RequestParam("stock") int stock,
            @RequestParam("description") String description,
            @RequestParam("size") String size,
            @RequestParam("origin") String origin,
            @RequestParam("lifeSpan") String lifeSpan,
            @RequestParam("temperature") String temperature,
            @RequestParam("waterType") String waterType,
            @RequestParam("careLevel") String careLevel,
            @RequestParam("isAggressive") String isAggressive,
            @RequestParam("productImage") MultipartFile productImage,
            HttpSession session) {

        if (session.getAttribute("seller") == null) { return new ModelAndView("redirect:/Login"); }

        try {
            String productId = "P" + UUID.randomUUID().toString().substring(0, 5).toUpperCase();
            
            String imagePath = "products/default.jpg"; 
            
            if (productImage != null && !productImage.isEmpty()) {
                String fileName = productId + "_" + productImage.getOriginalFilename();
                
                String uploadDir = "/app/uploads/products/"; 
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();

                File serverFile = new File(dir, fileName);
                productImage.transferTo(serverFile);
                
                imagePath = "products/" + fileName; 
            }

            Product newProduct = new Product();
            newProduct.setProductId(productId);
            newProduct.setProductName(productName);
            newProduct.setPrice(price);
            newProduct.setStock(stock);
            newProduct.setDescription(description);
            newProduct.setProductImg(imagePath);
            
            newProduct.setSize(size);
            newProduct.setOrigin(origin);
            newProduct.setLifeSpan(lifeSpan);
            newProduct.setTemperature(temperature);
            newProduct.setWaterType(waterType);
            newProduct.setCareLevel(careLevel);
            newProduct.setIsAggressive(isAggressive);
            
            ProductManager pm = new ProductManager();
            boolean success = pm.insertProduct(newProduct, speciesId); 

            if (success) {
                return new ModelAndView("redirect:/SellerCenter?success=added");
            } else {
                return new ModelAndView("redirect:/AddProduct?error=db");
            }

        } catch (Exception e) {
            e.printStackTrace();
            return new ModelAndView("redirect:/AddProduct?error=exception");
        }
    }

    @RequestMapping(value = "/DeleteProduct", method = RequestMethod.GET)
    public ModelAndView deleteProduct(@RequestParam("id") String productId, HttpSession session) {
        if (session.getAttribute("seller") == null) { return new ModelAndView("redirect:/Login"); }

        ProductManager pm = new ProductManager();
        boolean deleted = pm.deleteProduct(productId);

        if (deleted) {
            return new ModelAndView("redirect:/SellerCenter?msg=deleted");
        } else {
            return new ModelAndView("redirect:/SellerCenter?error=deleteFailed");
        }
    }

    @RequestMapping(value = "/EditProduct", method = RequestMethod.GET)
    public ModelAndView showEditProductPage(@RequestParam("id") String productId, HttpSession session) {

        if (session.getAttribute("seller") == null) { return new ModelAndView("redirect:/Login"); }

        ProductManager pm = new ProductManager();
        Product product = pm.getProduct(productId);

        if (product == null) {
            return new ModelAndView("redirect:/SellerCenter?error=notFound");
        }

        ModelAndView mav = new ModelAndView("editProduct");
        mav.addObject("product", product);
        return mav;
    }

    @RequestMapping(value = "/updateProduct", method = RequestMethod.POST)
    public ModelAndView updateProduct(
            @RequestParam("productId") String productId,
            @RequestParam("productName") String productName,
            @RequestParam("speciesId") String speciesId,
            @RequestParam("price") double price,
            @RequestParam("stock") int stock,
            @RequestParam("description") String description,
            @RequestParam("size") String size,
            @RequestParam("origin") String origin,
            @RequestParam("lifeSpan") String lifeSpan,
            @RequestParam("temperature") String temperature,
            @RequestParam("waterType") String waterType,
            @RequestParam("careLevel") String careLevel,
            @RequestParam("isAggressive") String isAggressive,
            @RequestParam("oldImage") String oldImage,
            @RequestParam(value = "productImage", required = false) MultipartFile productImage,
            HttpSession session) {

        if (session.getAttribute("seller") == null) { return new ModelAndView("redirect:/Login"); }

        try {

            String imagePath = oldImage;

            if (productImage != null && !productImage.isEmpty()) {
                String fileName = productId + "_" + productImage.getOriginalFilename();
                
                String uploadDir = "/app/uploads/products/"; 
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();

                File serverFile = new File(dir, fileName);
                productImage.transferTo(serverFile);
                
                imagePath = "products/" + fileName;
                System.out.println(">>> New Image Uploaded: " + imagePath);
            }

            Product product = new Product();
            product.setProductId(productId);
            product.setProductName(productName);
            product.setPrice(price);
            product.setStock(stock);
            product.setDescription(description);
            product.setProductImg(imagePath);
            
            product.setSize(size);
            product.setOrigin(origin);
            product.setLifeSpan(lifeSpan);
            product.setTemperature(temperature);
            product.setWaterType(waterType);
            product.setCareLevel(careLevel);
            product.setIsAggressive(isAggressive);

            ProductManager pm = new ProductManager();
            boolean success = pm.updateProduct(product, speciesId);

            if (success) {
                return new ModelAndView("redirect:/SellerCenter?success=updated");
            } else {
                return new ModelAndView("redirect:/EditProduct?id=" + productId + "&error=db");
            }

        } catch (Exception e) {
            e.printStackTrace();
            return new ModelAndView("redirect:/EditProduct?id=" + productId + "&error=exception");
        }
    }
    
    @RequestMapping(value = "/SellerOrders", method = RequestMethod.GET)
    public ModelAndView showSellerOrders(HttpSession session) {
        if (session.getAttribute("seller") == null) {
            return new ModelAndView("redirect:/Login");
        }

        OrderManager om = new OrderManager();
        List<Orders> orderList = om.getAllOrders();

        ModelAndView mav = new ModelAndView("sellerOrders");
        mav.addObject("orderList", orderList);
        return mav;
    }
    
}
