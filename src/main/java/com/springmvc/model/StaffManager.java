package com.springmvc.model;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;

public class StaffManager {

    public Staff getStaffByEmailAndPassword(String email, String password) {
        Staff staff = null;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            
            // ใช้ HQL ดึงข้อมูลจากตาราง Staff
            // Hibernate จะฉลาดพอที่จะรู้ว่า Staff คนนี้เป็น Admin หรือ Seller โดยอัตโนมัติ
            Query<Staff> query = session.createQuery("FROM Staff WHERE email = :email AND password = :password", Staff.class);
            query.setParameter("email", email);
            query.setParameter("password", password);
            
            staff = query.uniqueResult();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
        return staff;
    }
}