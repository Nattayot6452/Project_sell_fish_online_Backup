package com.springmvc.model;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

public class RegisterManager {

    public Member getRegisterByEmailAndPassword(String email, String password) {
    	Member user = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            Session session = sessionFactory.openSession();
            session.beginTransaction();
            user = (Member) session.createQuery("FROM Member WHERE email = :email AND password = :password")
                                     .setParameter("email", email)
                                     .setParameter("password", password)
                                     .uniqueResult();
    		
            session.getTransaction().commit();
            session.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }
    
    public boolean insertRegister(Member member) {
        boolean success = false;
        Transaction tx = null;

        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            Session session = sessionFactory.openSession();
            tx = session.beginTransaction();

            session.save(member);

            tx.commit();
            session.close();
            success = true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }

        return success;
    }

    public boolean updateRegister(Member member) {
        boolean success = false;
        Transaction tx = null;

        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            Session session = sessionFactory.openSession();
            tx = session.beginTransaction();
    
            session.update(member); 

            tx.commit();
            session.close();
            success = true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }

        return success;
    }
    
}
    

