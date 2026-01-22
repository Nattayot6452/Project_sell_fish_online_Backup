package com.springmvc.model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;

public class HibernateConnection {

	public static SessionFactory sessionFactory;
	
	static String url = "jdbc:mysql://mysql:3306/fishdatabase?characterEncoding=UTF-8&autoReconnect=true&useSSL=false&allowPublicKeyRetrieval=true"; 
	static String uname = "root";
	static String pwd = "1234";

	public static SessionFactory doHibernateConnection() {
		Properties database = new Properties();
		
		//database.setProperty("hibernate.hbm2ddl.auto", "create"); 
		database.setProperty("hibernate.hbm2ddl.auto", "update"); 
        
		database.setProperty("hibernate.connection.driver_class", "com.mysql.cj.jdbc.Driver");
		database.setProperty("hibernate.connection.username", uname);
		database.setProperty("hibernate.connection.password", pwd);
		database.setProperty("hibernate.connection.url", url);
		database.setProperty("hibernate.dialect", "org.hibernate.dialect.MySQL8Dialect");
        
        database.setProperty("hibernate.connection.autoReconnect", "true");
        database.setProperty("hibernate.connection.autoReconnectForPools", "true");
        database.setProperty("hibernate.connection.is-connection-validation-required", "true");

		Configuration cfg = new Configuration()
				.setProperties(database)
				.addPackage("com.springmvc.model")
				.addAnnotatedClass(Payment.class)
				.addAnnotatedClass(Species.class)
				.addAnnotatedClass(Staff.class)
				.addAnnotatedClass(Orders.class)
				.addAnnotatedClass(Product.class)
				.addAnnotatedClass(OrderDetail.class)
				.addAnnotatedClass(Review.class)
				.addAnnotatedClass(Member.class)
				.addAnnotatedClass(FavoriteProduct.class)
				.addAnnotatedClass(Seller.class)
				.addAnnotatedClass(Admin.class)
				.addAnnotatedClass(Coupon.class)
				.addAnnotatedClass(Notification.class);

		StandardServiceRegistryBuilder ssrb = new StandardServiceRegistryBuilder().applySettings(cfg.getProperties());
		sessionFactory = cfg.buildSessionFactory(ssrb.build());
		return sessionFactory;
	}

	public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, uname, pwd);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}