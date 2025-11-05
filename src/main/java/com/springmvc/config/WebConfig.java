package com.springmvc.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = "com.springmvc")
public class WebConfig implements WebMvcConfigurer {

    // View Resolver สำหรับ JSP
    @Bean
    public ViewResolver viewResolver() {
        InternalResourceViewResolver viewResolver = new InternalResourceViewResolver();
        viewResolver.setPrefix("/WEB-INF/jsp/");
        viewResolver.setSuffix(".jsp");
        return viewResolver;
    }

    // Resource Handler (สำหรับ assets และ profile uploads)
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        
        // 1. อันเดิมสำหรับ CSS/JS
        registry.addResourceHandler("/assets/**")
                .addResourceLocations("/WEB-INF/assets/");
        
        // 2. อันใหม่สำหรับรูปโปรไฟล์ที่อัปโหลด
        registry.addResourceHandler("/profile-uploads/**") 
                .addResourceLocations("file:///C:/tmp/uploads/"); 
    }

    // Multipart Resolver สำหรับ file upload
    @Bean
    public MultipartResolver multipartResolver() {
        return new StandardServletMultipartResolver();
    }
}