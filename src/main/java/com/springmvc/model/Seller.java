package com.springmvc.model;

import javax.persistence.Entity;

@Entity
public class Seller extends Staff {

    public Seller() {
        super();
    }

    public Seller(String email, String password) {
        super(email, password);
    }

    // เมธอดเฉพาะของ Seller
    public void sellProduct() {
        System.out.println("Seller " + getEmail() + " is selling products.");
    }
}
