package com.springmvc.model;

import org.hibernate.SessionFactory;

public class Run {

    public static void main(String[] args) {
        SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
        System.out.println(sessionfactory);

    }

}
