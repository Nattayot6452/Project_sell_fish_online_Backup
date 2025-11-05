package com.springmvc.model;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query; // Import Query
import java.util.Collections; // Import Collections
import java.util.List;

public class FavoriteManager {

    public List<FavoriteProduct> getFavoritesByMemberId(String memberId) {
        List<FavoriteProduct> favorites = null;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            session.beginTransaction();
            
            Query<FavoriteProduct> query = session.createQuery(
                "FROM FavoriteProduct fp WHERE fp.member.memberId = :mId", FavoriteProduct.class
            );
            query.setParameter("mId", memberId);
            favorites = query.getResultList();

            session.getTransaction().commit();
            
        } catch (Exception e) {
            e.printStackTrace();
            favorites = Collections.emptyList(); 
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
        return favorites;
    }

    public boolean addFavorite(FavoriteProduct favorite) {
        boolean success = false;
        Transaction tx = null;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            tx = session.beginTransaction();

            session.save(favorite);
            tx.commit();
            success = true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
        return success;
    }

    public boolean removeFavorite(String favoriteId) {
        boolean success = false;
        Transaction tx = null;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            tx = session.beginTransaction();

            FavoriteProduct favToDelete = session.get(FavoriteProduct.class, favoriteId);

            if (favToDelete != null) {
                session.delete(favToDelete);
                success = true;
            } else {
                System.out.println("Favorite with ID " + favoriteId + " not found.");
                success = true;
            }

            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
        return success;
    }
    
}