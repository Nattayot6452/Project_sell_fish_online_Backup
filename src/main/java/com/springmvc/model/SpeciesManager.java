package com.springmvc.model;

import java.util.List;
import java.util.ArrayList;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

public class SpeciesManager {

    public boolean insertSpecies(Species species) {
        boolean result = false;
        Transaction tx = null;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            tx = session.beginTransaction();
            session.save(species);
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

    public List<Species> getAllSpecies() {
        List<Species> list = new ArrayList<>();
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            list = session.createQuery("FROM Species", Species.class).list();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return list;
    }

    public Species getSpeciesById(String speciesId) {
        Species species = null;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            
            String hql = "SELECT DISTINCT s FROM Species s LEFT JOIN FETCH s.products WHERE s.speciesId = :id";
            Query<Species> query = session.createQuery(hql, Species.class);
            query.setParameter("id", speciesId);
            
            species = query.uniqueResult();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return species;
    }

    public boolean updateSpecies(Species bean) {
        boolean result = false;
        Transaction tx = null;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            tx = session.beginTransaction();
            
            Species dbSpecies = session.get(Species.class, bean.getSpeciesId());
            if (dbSpecies != null) {
                dbSpecies.setSpeciesName(bean.getSpeciesName());
                dbSpecies.setDescription(bean.getDescription());
                session.update(dbSpecies);
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

    public boolean deleteSpecies(String speciesId) {
        boolean result = false;
        Transaction tx = null;
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
            session = sessionFactory.openSession();
            tx = session.beginTransaction();
            
            Species s = session.get(Species.class, speciesId);
            if (s != null) {
                session.delete(s);
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