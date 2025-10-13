package com.springmvc.config;

import jakarta.servlet.MultipartConfigElement;
import jakarta.servlet.ServletRegistration.Dynamic;
import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;
import jakarta.servlet.Filter;

public class SpringMVCDispatcherServletInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class[0];
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class[]{WebConfig.class};
    }

    @Override
    protected String[] getServletMappings() {
        return new String[]{"/"};
    }

    @Override
    protected Filter[] getServletFilters() {
        CharacterEncodingFilter characterEncodingFilter = new CharacterEncodingFilter();
        characterEncodingFilter.setEncoding("UTF-8");
        characterEncodingFilter.setForceEncoding(true);
        return new Filter[]{characterEncodingFilter};
    }

    @Override
    protected void customizeRegistration(Dynamic registration) {
        String tempDir = "C:/tmp"; // สร้างโฟลเดอร์ C:\tmp ไว้ก่อน
        MultipartConfigElement multipartConfig = new MultipartConfigElement(
                tempDir,               // temporary folder
                5 * 1024 * 1024,       // max file size (5 MB)
                5 * 1024 * 1024,       // max request size (5 MB)
                0                       // file size threshold
        );
        registration.setMultipartConfig(multipartConfig);
    }
}
