package com.springmvc.controller;

import java.io.File;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.multipart.MultipartFile;

import com.springmvc.model.HibernateConnection;
import com.springmvc.model.OrderManager;
import com.springmvc.model.Orders;
import com.springmvc.model.Product;
import com.springmvc.model.ProductImage;
import com.springmvc.model.ProductManager;
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
    public String saveProduct(
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
            @RequestParam(value = "galleryFiles", required = false) MultipartFile[] galleryFiles, 
            HttpSession session) {

        if (session.getAttribute("seller") == null) { return "redirect:/Login"; }

        Session hibernateSession = null;
        try {

            String baseDir = "/app/images";
            
            String subDir = "products";
            File uploadPath = new File(baseDir + File.separator + subDir);
            if (!uploadPath.exists()) uploadPath.mkdirs();

            String productId = "P" + UUID.randomUUID().toString().substring(0, 5).toUpperCase();

            String originalName = file.getOriginalFilename();
            String extension = "";
            if (originalName != null && originalName.contains(".")) {
                extension = originalName.substring(originalName.lastIndexOf("."));
            }
            String mainImageName = UUID.randomUUID().toString() + extension;
            
            File mainFileSave = new File(uploadPath, mainImageName);
            file.transferTo(mainFileSave);

            Product product = new Product();
            product.setProductId(productId);
            product.setProductName(productName);
            product.setPrice(price);
            product.setStock(stock);
            product.setDescription(description);
            
            product.setProductImg(subDir + "/" + mainImageName);
            
            product.setSize(size);
            product.setOrigin(origin);
            product.setLifeSpan(lifeSpan);
            product.setTemperature(temperature);
            product.setWaterType(waterType);
            product.setCareLevel(careLevel);
            product.setIsAggressive(isAggressive);

            SpeciesManager sm = new SpeciesManager();
            product.setSpecies(sm.getSpecies(speciesId));

            List<ProductImage> galleryList = new ArrayList<>();
            if (galleryFiles != null && galleryFiles.length > 0) {
                for (MultipartFile gFile : galleryFiles) {
                    if (!gFile.isEmpty()) {
                        String gName = gFile.getOriginalFilename();
                        String gExt = "";
                        if (gName != null && gName.contains(".")) {
                            gExt = gName.substring(gName.lastIndexOf("."));
                        }
                        String gFileName = UUID.randomUUID().toString() + "_gallery" + gExt;
                        
                        File gFileSave = new File(uploadPath, gFileName);
                        gFile.transferTo(gFileSave);

                        ProductImage pi = new ProductImage();

                        pi.setImagePath(subDir + "/" + gFileName);
                        pi.setProduct(product);
                        galleryList.add(pi);
                    }
                }
            }
            product.setGalleryImages(galleryList);

            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            hibernateSession = sessionFactory.openSession();
            hibernateSession.beginTransaction();
            hibernateSession.save(product);
            hibernateSession.getTransaction().commit();

            return "redirect:/SellerCenter?success=added";

        } catch (Exception e) {
            e.printStackTrace();
            if (hibernateSession != null) hibernateSession.getTransaction().rollback();
            return "redirect:/AddProduct?error=exception";
        } finally {
            if (hibernateSession != null) hibernateSession.close();
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
        if (session.getAttribute("seller") == null) {
            return new ModelAndView("redirect:/Login");
        }
        OrderManager om = new OrderManager();
        List<Orders> orderList = om.getAllOrders();
        ModelAndView mav = new ModelAndView("sellerOrders");
        mav.addObject("orderList", orderList);
        return mav;
    }

    @RequestMapping(value = "/updateProduct", method = RequestMethod.POST)
    public String updateProduct(
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
            return "redirect:/Login";
        }

        Session hibernateSession = null;
        try {

            String imagePathToSave = oldImage; 

            if (file != null && !file.isEmpty()) {

                String baseDir = "/app/images";
                String subDir = "products";
                File uploadPath = new File(baseDir + File.separator + subDir);
                if (!uploadPath.exists()) uploadPath.mkdirs();

                String originalName = file.getOriginalFilename();
                String extension = "";
                if (originalName != null && originalName.contains(".")) {
                    extension = originalName.substring(originalName.lastIndexOf("."));
                }

                String newFileName = UUID.randomUUID().toString() + extension;
                
                File fileSave = new File(uploadPath, newFileName);
                file.transferTo(fileSave);

                imagePathToSave = subDir + "/" + newFileName;
            }

            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            hibernateSession = sessionFactory.openSession();
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
            }

            return "redirect:/SellerCenter?success=updated";

        } catch (Exception e) {
            e.printStackTrace();
            if (hibernateSession != null) hibernateSession.getTransaction().rollback();
            return "redirect:/EditProduct?id=" + productId + "&error=exception";
        } finally {
            if (hibernateSession != null) hibernateSession.close();
        }
    }
}