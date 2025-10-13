package com.springmvc.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "orderdetail")
public class OrderDetail {

    @Id
    @Column(name = "orderdetail_id")
    private String orderDetailId;

    @Column(name = "quantity", length = 5, nullable = false)
    private String quantity;

    @Column(name = "price", precision = 10, scale = 2, nullable = false)
    private Double price;

    @ManyToOne
    @JoinColumn(name = "orders_id")
    private Orders orders;
    
    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product products;

	public OrderDetail() {
		super();
		// TODO Auto-generated constructor stub
	}

	public OrderDetail(String orderDetailId, String quantity, Double price, Orders orders, Product products) {
		super();
		this.orderDetailId = orderDetailId;
		this.quantity = quantity;
		this.price = price;
		this.orders = orders;
		this.products = products;
	}

	public String getOrderDetailId() {
		return orderDetailId;
	}

	public void setOrderDetailId(String orderDetailId) {
		this.orderDetailId = orderDetailId;
	}

	public String getQuantity() {
		return quantity;
	}

	public void setQuantity(String quantity) {
		this.quantity = quantity;
	}

	public Double getPrice() {
		return price;
	}

	public void setPrice(Double price) {
		this.price = price;
	}

	public Orders getOrders() {
		return orders;
	}

	public void setOrders(Orders orders) {
		this.orders = orders;
	}

	public Product getProducts() {
		return products;
	}

	public void setProducts(Product products) {
		this.products = products;
	}

}
