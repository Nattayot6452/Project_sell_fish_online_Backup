package com.springmvc.model;

import java.util.List;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

public class CouponManager {

    public boolean saveCoupon(Coupon coupon) {
        boolean result = false;
        Transaction tx = null;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            tx = session.beginTransaction();
            
            session.save(coupon);
            
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

    public List<Coupon> getAllCoupons() {
        List<Coupon> list = null;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            list = session.createQuery("FROM Coupon", Coupon.class).list();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return list;
    }

    // public Coupon getCouponByCode(String code) {
    //     Coupon coupon = null;
    //     Session session = null;
    //     try {
    //         SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
    //         session = sessionFactory.openSession();
            
    //         coupon = session.get(Coupon.class, code);
            
    //     } catch (Exception e) {
    //         e.printStackTrace();
    //     } finally {
    //         if (session != null) session.close();
    //     }
    //     return coupon;
    // }

    public Coupon getCouponByCode(String code) {
        Session session = null;
        try {
            session = HibernateConnection.doHibernateConnection().openSession();
            // ค้นหาคูปองจาก Code (สมมติชื่อ field คือ couponCode)
            Query<Coupon> query = session.createQuery("FROM Coupon WHERE couponCode = :code", Coupon.class);
            query.setParameter("code", code);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return null;
    }

    public boolean updateCoupon(Coupon coupon) {
        boolean result = false;
        Transaction tx = null;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            tx = session.beginTransaction();
            
            session.update(coupon);
            
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

    public void deleteCoupon(String code) {
    Transaction tx = null;
    Session session = null;
    try {
        SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
        session = sessionFactory.openSession();
        tx = session.beginTransaction();
        Coupon c = session.get(Coupon.class, code);
        if (c != null) {
            session.delete(c);
        }
        tx.commit();
    } catch (Exception e) {
        if (tx != null) tx.rollback();
        e.printStackTrace();
    } finally {
        if (session != null) session.close();
    }
}
}