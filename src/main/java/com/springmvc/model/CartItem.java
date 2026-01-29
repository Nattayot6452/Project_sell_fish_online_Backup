package com.springmvc.model;

public class CartItem {
    private Product product;
    private int quantity;
    private double itemTotal;

    public CartItem() {}

    public CartItem(Product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
        if (product != null) {
            this.itemTotal = product.getPrice() * quantity;
        } else {
            this.itemTotal = 0.0;
        }
    }

    public Product getProduct() {
        return product;
    }

    public int getQuantity() {
        return quantity;
    }

    public double getItemTotal() {
        return itemTotal;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
        if (this.product != null) {
            this.itemTotal = this.product.getPrice() * quantity;
        }
    }

    public void setItemTotal(double itemTotal) {
        this.itemTotal = itemTotal;
    }
}