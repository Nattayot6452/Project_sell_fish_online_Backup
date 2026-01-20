package com.springmvc.model;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.hibernate.Transaction;

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
        List<Product> products = new ArrayList<>();
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            
            Query<Product> query = session.createQuery("FROM Product ORDER BY productId DESC", Product.class);
            query.setMaxResults(limit);
            
            products = query.list();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return products;
    }
	
    public boolean insertProduct(Product product, String speciesId) {
        boolean result = false;
        Session session = null;
        Transaction tx = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            tx = session.beginTransaction();

            Species species = session.get(Species.class, speciesId);
            if (species != null) {
                product.setSpecies(species);
                session.save(product);
                
                session.flush();
                tx.commit();
                result = true;
                System.out.println(">>> Product Saved: " + product.getProductName());
            } else {
                System.err.println(">>> Error: Species ID " + speciesId + " Not Found!");
            }

        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return result;
    }

    public boolean deleteProduct(String productId) {
        boolean result = false;
        Session session = null;
        Transaction tx = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            tx = session.beginTransaction();

            Product product = session.get(Product.class, productId);
            if (product != null) {
                session.remove(product);
                tx.commit();
                result = true;
            }
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return result;
    }

    public List<Species> getAllSpecies() {
        List<Species> list = new ArrayList<>();
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            list = session.createQuery("FROM Species ORDER BY speciesId", Species.class).list();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return list;
    }

    public List<Product> searchProducts(String keyword, String speciesId) {
        List<Product> list = new ArrayList<>();
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            
            StringBuilder hql = new StringBuilder("FROM Product p WHERE 1=1 ");
            
            if (keyword != null && !keyword.isEmpty()) {
                hql.append("AND (p.productName LIKE :keyword OR p.description LIKE :keyword) ");
            }
            if (speciesId != null && !speciesId.isEmpty() && !speciesId.equals("all")) {
                hql.append("AND p.species.speciesId = :speciesId ");
            }
            
            hql.append("ORDER BY p.productId DESC");

            Query<Product> query = session.createQuery(hql.toString(), Product.class);
            
            if (keyword != null && !keyword.isEmpty()) {
                query.setParameter("keyword", "%" + keyword + "%");
            }
            if (speciesId != null && !speciesId.isEmpty() && !speciesId.equals("all")) {
                query.setParameter("speciesId", speciesId);
            }

            list = query.list();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return list;
    }

    public boolean updateProduct(Product product, String speciesId) {
        boolean result = false;
        Session session = null;
        Transaction tx = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            tx = session.beginTransaction();

            Species species = session.get(Species.class, speciesId);
            
            if (species != null) {
                product.setSpecies(species); 
                
                session.merge(product);
                
                session.flush();
                tx.commit();
                result = true;
                System.out.println(">>> Product Updated: " + product.getProductName());
            } else {
                System.err.println(">>> Error: Species ID " + speciesId + " Not Found!");
            }

        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return result;
    }

    public boolean updateProduct(Product product) {
        boolean result = false;
        Session session = null;
        Transaction tx = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            tx = session.beginTransaction();

            session.update(product);

            tx.commit();
            result = true;
            System.out.println(">>> Product Updated (Stock deducted): " + product.getProductName());

        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return result;
    }

    public List<Product> getProductsWithFilter(String category, String sortBy, int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            
            StringBuilder hql = new StringBuilder("FROM Product p");
            boolean hasWhere = false;

            // กรองหมวดหมู่
            if (category != null && !category.equals("all") && !category.isEmpty()) {
                hql.append(" WHERE p.species.speciesName = :category");
                hasWhere = true;
            }

            // จัดเรียงตามเงื่อนไข
            if ("price_asc".equals(sortBy)) {
                hql.append(" ORDER BY p.price ASC");
            } else if ("price_desc".equals(sortBy)) {
                hql.append(" ORDER BY p.price DESC");
            } else if ("name_asc".equals(sortBy)) {
                hql.append(" ORDER BY p.productName ASC");
            } else if ("oldest".equals(sortBy)) {
                hql.append(" ORDER BY p.productId ASC"); // เรียงตาม ID น้อยไปมาก (เก่าสุด)
            } else if ("newest".equals(sortBy)) {
                hql.append(" ORDER BY p.productId DESC"); // เรียงตาม ID มากไปน้อย (ใหม่สุด)
            } else if ("best_selling".equals(sortBy)) {
                // ✅ สูตรลับ: เรียงตามผลรวมจำนวนที่ขายได้ (Subquery)
                hql.append(" ORDER BY (SELECT COALESCE(SUM(od.quantity), 0) FROM OrderDetail od WHERE od.product = p) DESC");
            } else {
                hql.append(" ORDER BY p.productId DESC"); // ค่าเริ่มต้น (สินค้าใหม่สุด)
            }

            Query<Product> query = session.createQuery(hql.toString(), Product.class);
            
            if (hasWhere) {
                query.setParameter("category", category);
            }

            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);

            list = query.list();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return list;
    }

    public long countProducts(String category) {
        long count = 0;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            
            StringBuilder hql = new StringBuilder("SELECT COUNT(p) FROM Product p");
            if (category != null && !category.equals("all") && !category.isEmpty()) {
                hql.append(" WHERE p.species.speciesName = :category");
            }

            Query<Long> query = session.createQuery(hql.toString(), Long.class);
            if (category != null && !category.equals("all") && !category.isEmpty()) {
                query.setParameter("category", category);
            }
            
            count = query.uniqueResult();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return count;
    }

}