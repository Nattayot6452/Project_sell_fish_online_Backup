package com.springmvc.model;

import javax.persistence.Entity;

@Entity
public class Admin extends Staff {

    public Admin() {
        super();
    }

    public Admin(String email, String password) {
        super(email, password);
    }

    // เมธอดเฉพาะของ Admin
    public void manageUsers() {
        System.out.println("Admin " + getEmail() + " is managing users.");
    }
}
