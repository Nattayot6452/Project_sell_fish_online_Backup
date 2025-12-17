package com.springmvc.model;

import java.util.ArrayList;
import java.util.List;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

public class UserManager {

    public List<Member> getAllMembers() {
        List<Member> list = new ArrayList<>();
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            
            list = session.createQuery("FROM Member ORDER BY memberId DESC", Member.class).list();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return list;
    }

    public long getMemberCount() {
        long count = 0;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            
            Query<Long> query = session.createQuery("SELECT COUNT(m) FROM Member m", Long.class);
            count = query.uniqueResult();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return count;
    }

    public Member getMemberById(String memberId) {
        Member member = null;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            member = session.get(Member.class, memberId);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return member;
    }
    
    public boolean deleteMember(String memberId) {
        boolean result = false;
        Transaction tx = null;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            tx = session.beginTransaction();
            
            Member m = session.get(Member.class, memberId);
            if(m != null) {
                session.delete(m);
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
}