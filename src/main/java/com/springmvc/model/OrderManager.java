package com.springmvc.model;

import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import java.util.List;
import java.util.ArrayList;

public class OrderManager {

    public List<Orders> getAllOrders() {
        List<Orders> list = new ArrayList<>();
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            
            String hql = "SELECT DISTINCT o FROM Orders o LEFT JOIN FETCH o.member ORDER BY o.orderDate DESC";
            
            list = session.createQuery(hql, Orders.class).list();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null && session.isOpen()) session.close();
        }
        return list;
    }

   public Orders getOrderById(String orderId) {
        Orders order = null; 
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            
            order = session.get(Orders.class, orderId);
            
            if (order != null) {
                Hibernate.initialize(order.getOrderDetails()); 
                Hibernate.initialize(order.getMember());      
                Hibernate.initialize(order.getPayment());     
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
        return order;
    }

    public boolean saveNewOrder(Orders order, List<OrderDetail> details) {
        boolean success = false;
        Transaction tx = null;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            tx = session.beginTransaction();
            
            session.save(order);
            
            for (OrderDetail detail : details) {
                session.save(detail);
            }
            
            tx.commit();
            success = true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return success;
    }
    
    public List<Orders> getOrdersByMemberId(String memberId) {
        List<Orders> orders = null;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            
            String hql = "SELECT DISTINCT o FROM Orders o " +
                         "LEFT JOIN FETCH o.orderDetails od " + 
                         "LEFT JOIN FETCH od.product " + 
                         "WHERE o.member.memberId = :mId " +
                         "ORDER BY o.orderDate DESC";
            Query<Orders> query = session.createQuery(hql, Orders.class);
            query.setParameter("mId", memberId);
            
            orders = query.getResultList();
            
        } catch (Exception e) {
            e.printStackTrace();
            orders = new ArrayList<>();
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
        return orders;
    }

    public boolean updateOrderStatus(String orderId, String newStatus) {
        boolean success = false;
        Transaction tx = null;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            tx = session.beginTransaction();
            
            Orders orderToUpdate = session.get(Orders.class, orderId);
            
            if (orderToUpdate != null) {
                orderToUpdate.setStatus(newStatus); 
                
                session.update(orderToUpdate); 
                
                tx.commit();
                success = true;
            } else {
                System.err.println("updateOrderStatus: Order not found with ID " + orderId);
            }
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return success;
    }
    
     public Orders getOrderWithDetails(String orderId) {
        Orders order = null;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            
            String hql = "SELECT DISTINCT o FROM Orders o " +
                         "LEFT JOIN FETCH o.orderDetails od " +
                         "LEFT JOIN FETCH od.product " +
                         "LEFT JOIN FETCH o.member " +
                         "LEFT JOIN FETCH o.payment " +
                         "WHERE o.ordersId = :orderId";
            
            Query<Orders> query = session.createQuery(hql, Orders.class);
            query.setParameter("orderId", orderId);
            order = query.uniqueResult();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
        return order;
    }
}