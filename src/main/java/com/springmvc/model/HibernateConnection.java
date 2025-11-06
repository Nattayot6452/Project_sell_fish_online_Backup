package com.springmvc.model;

import java.util.Properties;

import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;

public class HibernateConnection {

	public static SessionFactory sessionFactory;
	static String url = "jdbc:mysql://mysql:3306/fishdatabase?characterEncoding=UTF-8"; // การตั้งชื่อ Schema
	static String uname = "root";
	static String pwd = "1234";

	public static SessionFactory doHibernateConnection() {
		Properties database = new Properties();
		// database.setProperty("hibernate.hbm2ddl.auto", "create");
		// //ต้องใช้อันนี้ก่อนแล้วปิดคอมเม้น update ไว้ แล้วrun จะเป็นการสร้างตาราง
		database.setProperty("hibernate.hbm2ddl.auto", "update"); // หลังจากสร้างตารางแล้วให้เอาออก
		database.setProperty("hibernate.connection.driver_class", "com.mysql.cj.jdbc.Driver");
		database.setProperty("hibernate.connection.username", uname);
		database.setProperty("hibernate.connection.password", pwd);
		database.setProperty("hibernate.connection.url", url);
		database.setProperty("hibernate.dialect", "org.hibernate.dialect.MySQL8Dialect");
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
				.addAnnotatedClass(Admin.class);

		StandardServiceRegistryBuilder ssrb = new StandardServiceRegistryBuilder().applySettings(cfg.getProperties());
		sessionFactory = cfg.buildSessionFactory(ssrb.build());
		return sessionFactory;
	}
}