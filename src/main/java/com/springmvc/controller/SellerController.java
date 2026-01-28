package com.springmvc.controller;

import java.io.File;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;
import java.util.Map;
import java.util.regex.Pattern;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.HtmlUtils;
import org.springframework.web.multipart.MultipartFile;

import com.springmvc.model.Admin;
import com.springmvc.model.HibernateConnection;
import com.springmvc.model.OrderManager;
import com.springmvc.model.Orders;
import com.springmvc.model.Product;
import com.springmvc.model.ProductImage;
import com.springmvc.model.ProductManager;
import com.springmvc.model.ReviewManager;
import com.springmvc.model.Seller;
import com.springmvc.model.Species;
import com.springmvc.model.SpeciesManager;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

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
        ReviewManager rm = new ReviewManager(); 

        List<Product> products;
        if ((search != null && !search.isEmpty()) || (category != null && !category.equals("all"))) {
            products = pm.searchProducts(search, category);
        } else {
            products = pm.getListProducts();
        }

        Map<String, Double> productRatings = new HashMap<>();
        if (products != null) {
            for (Product p : products) {
                productRatings.put(p.getProductId(), rm.getAverageRating(p.getProductId()));
            }
        }

        List<Species> speciesList = pm.getAllSpecies();

        ModelAndView mav = new ModelAndView("sellerHomepage");
        mav.addObject("products", products);
        mav.addObject("speciesList", speciesList);
        mav.addObject("paramSearch", search);
        mav.addObject("paramCategory", category);

        mav.addObject("productRatings", productRatings);

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
            @RequestParam("price") Double price,
            @RequestParam("stock") Integer stock,
            @RequestParam("description") String description,
            @RequestParam("size") String size,
            @RequestParam("origin") String origin,
            @RequestParam("lifeSpan") String lifeSpan,
            @RequestParam("temperature") String temperature,
            @RequestParam("waterType") String waterType,
            @RequestParam("careLevel") String careLevel,
            @RequestParam("isAggressive") String isAggressive,
            @RequestParam("productImage") MultipartFile file,
            @RequestParam(value = "extraImages", required = false) MultipartFile[] extraImages, 
            HttpSession session) {

        if (session.getAttribute("seller") == null) { return new ModelAndView("redirect:/Login"); }

        try {

            productName = productName.trim();
            description = description.trim();

            String namePattern = "^[a-zA-Z0-9ก-๙\\s\\-_()]+$";
            if (productName.isEmpty() || !Pattern.matches(namePattern, productName)) {
                return new ModelAndView("redirect:/AddProduct?error=invalidName");
            }

            if (description.length() < 20 || description.length() > 255) {
                return new ModelAndView("redirect:/AddProduct?error=descLength");
            }

            if (price <= 0 || stock < 0) {
                return new ModelAndView("redirect:/AddProduct?error=invalidNumber");
            }

            description = HtmlUtils.htmlEscape(description);

            if (file.isEmpty()) {
                return new ModelAndView("redirect:/AddProduct?error=missingImage");
            }
            if (file.getSize() > 5 * 1024 * 1024) {
                return new ModelAndView("redirect:/AddProduct?error=fileTooLarge");
            }
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                return new ModelAndView("redirect:/AddProduct?error=invalidFileType");
            }

            String baseDir = "/app/images";
            String subDir = "products";
            File uploadPath = new File(baseDir + File.separator + subDir);
            if (!uploadPath.exists()) uploadPath.mkdirs();

            String productId = "P" + UUID.randomUUID().toString().substring(0, 5).toUpperCase();
            String mainImageName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
            File mainFileSave = new File(uploadPath, mainImageName);
            file.transferTo(mainFileSave);

            Product product = new Product();
            product.setProductId(productId);
            product.setProductName(productName);
            product.setPrice(price);
            product.setStock(stock);
            product.setDescription(description);
            product.setProductImg(subDir + "/" + mainImageName);
            
            product.setSize(HtmlUtils.htmlEscape(size));
            product.setOrigin(HtmlUtils.htmlEscape(origin));
            product.setLifeSpan(HtmlUtils.htmlEscape(lifeSpan));
            product.setTemperature(HtmlUtils.htmlEscape(temperature));
            product.setWaterType(HtmlUtils.htmlEscape(waterType));
            product.setCareLevel(careLevel);
            product.setIsAggressive(isAggressive);

            SpeciesManager sm = new SpeciesManager();
            product.setSpecies(sm.getSpecies(speciesId));

            if (extraImages != null && extraImages.length > 0) {
                for (MultipartFile extraFile : extraImages) {
                    if (!extraFile.isEmpty()) {

                        if (extraFile.getSize() > 5 * 1024 * 1024 || !extraFile.getContentType().startsWith("image/")) {
                            continue;
                        }

                        String extraName = UUID.randomUUID().toString() + "_extra_" + extraFile.getOriginalFilename();
                        File extraFileSave = new File(uploadPath, extraName);
                        extraFile.transferTo(extraFileSave);
                        
                        ProductImage pImage = new ProductImage(subDir + "/" + extraName, product);
                        product.addImage(pImage); 
                    }
                }
            }

            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            Session hibernateSession = sessionFactory.openSession();
            hibernateSession.beginTransaction();
            hibernateSession.save(product); 
            hibernateSession.getTransaction().commit();
            hibernateSession.close();

            return new ModelAndView("redirect:/SellerCenter?success=added");

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
    public ModelAndView editProduct(@RequestParam("id") String productId, HttpSession session) {

        if (session.getAttribute("seller") == null) {
            return new ModelAndView("redirect:/Login");
        }

        ModelAndView mav = new ModelAndView("editProduct");

        ProductManager pm = new ProductManager();
        Product product = pm.getProduct(productId);
        mav.addObject("product", product);

        SpeciesManager sm = new SpeciesManager();
        List<Species> speciesList = sm.getAllSpecies(); 
        mav.addObject("speciesList", speciesList); 

        return mav;
    }

    @GetMapping("/displayImage")
    @ResponseBody
    public void displayImage(@RequestParam("name") String imageName, HttpServletRequest request, HttpServletResponse response) {
        try {

            String baseDir = "/app/images";
            
            File file = new File(baseDir + File.separator + imageName);

            if (!file.exists()) {
                System.out.println("❌ Image NOT Found at: " + file.getAbsolutePath());
            }

            if (file.exists()) {
                String contentType = request.getServletContext().getMimeType(file.getAbsolutePath());
                response.setContentType(contentType != null ? contentType : "application/octet-stream");
                Files.copy(file.toPath(), response.getOutputStream());
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
   @RequestMapping(value = "/SellerOrders", method = RequestMethod.GET)
    public ModelAndView showSellerOrders(HttpSession session) {
        
        Seller seller = (Seller) session.getAttribute("seller");
        Admin admin = (Admin) session.getAttribute("admin");   
        
        if (seller == null && admin == null) {
            return new ModelAndView("redirect:/Login");
        }

        OrderManager om = new OrderManager();
        ModelAndView mav = new ModelAndView("sellerOrders");
        List<Orders> orderList = null;

        if (admin != null) {
            orderList = om.getAllOrders(); 
        } else {
            orderList = om.getAllOrders(); 
        }

        mav.addObject("orderList", orderList);
        return mav;
    }

   @RequestMapping(value = "/updateProduct", method = RequestMethod.POST)
    public ModelAndView updateProduct(
            @RequestParam("productId") String productId,
            @RequestParam("oldImage") String oldImage,
            @RequestParam("productName") String productName,
            @RequestParam("speciesId") String speciesId,
            @RequestParam("price") Double price,
            @RequestParam("stock") Integer stock,
            @RequestParam("description") String description,
            @RequestParam("size") String size,
            @RequestParam("origin") String origin,
            @RequestParam("lifeSpan") String lifeSpan,
            @RequestParam("temperature") String temperature,
            @RequestParam("waterType") String waterType,
            @RequestParam("careLevel") String careLevel,
            @RequestParam("isAggressive") String isAggressive,
            @RequestParam(value = "productImage", required = false) MultipartFile file,
            HttpSession session) {

        if (session.getAttribute("seller") == null) {
            return new ModelAndView("redirect:/Login");
        }

        try {

            productName = productName.trim();
            description = description.trim();

            String namePattern = "^[a-zA-Z0-9ก-๙\\s\\-_()]+$";
            if (productName.isEmpty() || !Pattern.matches(namePattern, productName)) {
                return new ModelAndView("redirect:/EditProduct?id=" + productId + "&error=invalidName");
            }

            if (price <= 0 || stock < 0) {
                return new ModelAndView("redirect:/EditProduct?id=" + productId + "&error=invalidNumber");
            }

            if (description.length() < 20 || description.length() > 255) {
                return new ModelAndView("redirect:/EditProduct?id=" + productId + "&error=descLength");
            }

            description = HtmlUtils.htmlEscape(description);
            size = HtmlUtils.htmlEscape(size);
            origin = HtmlUtils.htmlEscape(origin);
            lifeSpan = HtmlUtils.htmlEscape(lifeSpan);
            temperature = HtmlUtils.htmlEscape(temperature);
            waterType = HtmlUtils.htmlEscape(waterType);

            String imagePathToSave = oldImage; 

            if (file != null && !file.isEmpty()) {

                if (file.getSize() > 5 * 1024 * 1024) {
                    return new ModelAndView("redirect:/EditProduct?id=" + productId + "&error=fileTooLarge");
                }
                
                String contentType = file.getContentType();
                if (contentType == null || !contentType.startsWith("image/")) {
                    return new ModelAndView("redirect:/EditProduct?id=" + productId + "&error=invalidFileType");
                }

                String baseDir = "/app/images";
                String subDir = "products";
                File uploadPath = new File(baseDir + File.separator + subDir);
                if (!uploadPath.exists()) uploadPath.mkdirs();

                String newFileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
                File fileSave = new File(uploadPath, newFileName);
                file.transferTo(fileSave);

                imagePathToSave = subDir + "/" + newFileName;
            }

            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            Session hibernateSession = sessionFactory.openSession();
            hibernateSession.beginTransaction();

            Product product = hibernateSession.get(Product.class, productId);
            if (product != null) {
                product.setProductName(productName);
                product.setPrice(price);
                product.setStock(stock);
                product.setDescription(description);
                product.setProductImg(imagePathToSave);
                
                product.setSize(size);
                product.setOrigin(origin);
                product.setLifeSpan(lifeSpan);
                product.setTemperature(temperature);
                product.setWaterType(waterType);
                product.setCareLevel(careLevel);
                product.setIsAggressive(isAggressive);

                SpeciesManager sm = new SpeciesManager();
                product.setSpecies(sm.getSpecies(speciesId)); 

                hibernateSession.update(product);
                hibernateSession.getTransaction().commit();
                hibernateSession.close();
                
                return new ModelAndView("redirect:/SellerCenter?success=updated");
            } else {
                hibernateSession.close();
                return new ModelAndView("redirect:/SellerCenter?error=notFound");
            }

        } catch (Exception e) {
            e.printStackTrace();
            return new ModelAndView("redirect:/EditProduct?id=" + productId + "&error=exception");
        }
    }
}