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
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            
            String hql = "FROM Product p ORDER BY p.productId DESC";
            
            list = session.createQuery(hql, Product.class).list();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return list;
    }
	
    public List<Product> getSearchProductsBySpecies(String searchtext) {
        List<Product> list = new ArrayList<>();
        try {
            SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
            Session session = sessionfactory.openSession();
            session.beginTransaction();
            
            Query<Product> query = session.createQuery("FROM Product WHERE species.speciesName like :searchText AND productStatus = 'Active'", Product.class);
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
            
            Query<Product> query = session.createQuery("FROM Product WHERE productStatus = 'Active' ORDER BY productId DESC", Product.class);
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

    public int deleteProduct(String productId) {
        int status = 0;
        Transaction tx = null;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            tx = session.beginTransaction();
            
            Product p = session.get(Product.class, productId);
            if (p != null) {
                
                String hql = "SELECT count(od) FROM OrderDetail od WHERE od.product.productId = :pid";
                Long count = (Long) session.createQuery(hql).setParameter("pid", productId).uniqueResult();
                
                if (count != null && count > 0) {
                    p.setProductStatus("Inactive"); 
                    session.update(p);
                    status = 2;
                } else {
                    session.delete(p);
                    status = 1;
                }
                
                tx.commit();
            }
            
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return status;
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
            
            StringBuilder hql = new StringBuilder("FROM Product p WHERE 1=1 AND p.productStatus = 'Active' ");
            
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

    public List<Product> searchProductsForSeller(String keyword, String speciesId) {
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
            
            StringBuilder hql = new StringBuilder("FROM Product p WHERE p.productStatus = 'Active'");

            if (category != null && !category.equals("all") && !category.isEmpty()) {
                hql.append(" AND p.species.speciesName = :category");
            }

            if ("price_asc".equals(sortBy)) {
                hql.append(" ORDER BY p.price ASC");
            } else if ("price_desc".equals(sortBy)) {
                hql.append(" ORDER BY p.price DESC");
            } else if ("name_asc".equals(sortBy)) {
                hql.append(" ORDER BY p.productName ASC");
            } else if ("oldest".equals(sortBy)) {
                hql.append(" ORDER BY p.productId ASC");
            } else if ("newest".equals(sortBy)) {
                hql.append(" ORDER BY p.productId DESC");
            } else if ("best_selling".equals(sortBy)) {
                hql.append(" ORDER BY (SELECT COALESCE(SUM(od.quantity), 0) FROM OrderDetail od WHERE od.product = p) DESC");
            } else {
                hql.append(" ORDER BY p.productId DESC");
            }

            Query<Product> query = session.createQuery(hql.toString(), Product.class);
            
            if (category != null && !category.equals("all") && !category.isEmpty()) {
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
            
            StringBuilder hql = new StringBuilder("SELECT COUNT(p) FROM Product p WHERE p.productStatus = 'Active'");
            
            if (category != null && !category.equals("all") && !category.isEmpty()) {
                hql.append(" AND p.species.speciesName = :category");
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

    public List<Product> getProductsBySpecies(String speciesId) {
        List<Product> list = new ArrayList<>();
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            
            String hql = "FROM Product p WHERE p.species.speciesId = :id AND p.productStatus = 'Active' ORDER BY p.productId DESC";
            
            Query<Product> query = session.createQuery(hql, Product.class);
            query.setParameter("id", speciesId);
            list = query.list();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return list;
    }

}