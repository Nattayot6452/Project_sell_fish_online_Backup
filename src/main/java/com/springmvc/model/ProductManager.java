package com.springmvc.model;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

public class ProductManager {

	public List<Product> getListProducts() {
        List<Product> list = new ArrayList<>();
        try {
            SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
            Session session = sessionfactory.openSession();
            session.beginTransaction();

            list = session.createQuery("FROM Product ORDER BY productId").list();

            session.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
	
	public List<Product> getSearchProducts(String searchtext) {
		List<Product> list = new ArrayList<>();
		try {
			SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
			Session session = sessionfactory.openSession();
			session.beginTransaction();
			list = session.createQuery("FROM Product WHERE productName like '%" + searchtext + "%'").list();

			session.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	 
}