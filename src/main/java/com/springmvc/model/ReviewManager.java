package com.springmvc.model;

import java.util.ArrayList;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import java.util.List;

public class ReviewManager {

    public boolean insertReview(Review review) {
        boolean result = false;
        Transaction tx = null;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            tx = session.beginTransaction();

            session.save(review);
            
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

    public List<Review> getReviewsByProductId(String productId, String sortType) {
        List<Review> list = new ArrayList<>();
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();

            String orderBy = "ORDER BY r.reviewDate DESC";

            if ("oldest".equals(sortType)) {
                orderBy = "ORDER BY r.reviewDate ASC";
            } else if ("rating_desc".equals(sortType)) {
                orderBy = "ORDER BY r.rating DESC";
            } else if ("rating_asc".equals(sortType)) {
                orderBy = "ORDER BY r.rating ASC";
            }

            String hql = "SELECT r FROM Review r LEFT JOIN FETCH r.member WHERE r.product.productId = :pid " + orderBy;
            
            Query<Review> query = session.createQuery(hql, Review.class);
            query.setParameter("pid", productId);
            
            list = query.list();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return list;
    }

    public double getAverageRating(String productId) {
        double avg = 0.0;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();

            String hql = "SELECT AVG(r.rating) FROM Review r WHERE r.product.productId = :pid";
            Query<Double> query = session.createQuery(hql, Double.class);
            query.setParameter("pid", productId);
            
            Double result = query.uniqueResult();
            if (result != null) {
                avg = result;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return Math.round(avg * 10.0) / 10.0;
    }
}