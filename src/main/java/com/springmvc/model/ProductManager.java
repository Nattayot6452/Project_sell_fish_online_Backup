package com.springmvc.model;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;

public class ProductManager {

	public List<Product> getListProducts() {
        List<Product> list = new ArrayList<>();
        try {
            SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
            Session session = sessionfactory.openSession();
            session.beginTransaction();

            list = session.createQuery("FROM Product ORDER BY productId", Product.class).list();

            session.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
	
	public List<Product> getSearchProductsBySpecies(String searchtext) {
		List<Product> list = new ArrayList<>();
		try {
			SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
			Session session = sessionfactory.openSession();
			session.beginTransaction();
            
			Query<Product> query = session.createQuery("FROM Product WHERE species.speciesName like :searchText", Product.class);
            query.setParameter("searchText", "%" + searchtext + "%");
			list = query.list();

			session.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public Product getProduct(String productId) {
	    Product product = null;
	    Session session = null;
	    try {
	        SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
	        session = sessionFactory.openSession();
            
	        product = session.get(Product.class, productId);
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        if (session != null) session.close();
	    }
	    return product;
	}

	public List<Product> getFeaturedProducts(int limit) {
        List<Product> list = new ArrayList<>();
        Session session = null;
        try {
            SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
            session = sessionfactory.openSession();
            
            Query<Product> query = session.createQuery("FROM Product p ORDER BY p.productId DESC", Product.class);
            query.setMaxResults(limit); // 👈 จำกัดจำนวน
            
            list = query.list();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return list;
    }

}