package com.springmvc.model;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import java.sql.Timestamp;

@Entity
@Table(name = "orders")
public class Orders {

    @Id
    @Column(name = "orders_id")
    private String ordersId;

    @Column(name = "orderdate", nullable = false)
    private Timestamp orderDate;

    @Column(name = "status", length = 50, nullable = false)
    private String status;

    @Column(name = "total_amount", precision = 10, scale = 2, nullable = false)
    private Double totalAmount;

	@Column(name = "discount_amount")
    private Double discountAmount = 0.0;

    @Column(name = "coupon_code")
    private String couponCode;

	@Column(name = "preparing_date")
	private Timestamp preparingDate;

	@Column(name = "ready_date")
    private Timestamp readyDate;

	@Column(name = "completed_date")
    private Timestamp completedDate;

    @OneToMany(mappedBy = "orders", cascade = CascadeType.ALL)
    private List<OrderDetail> orderDetails = new ArrayList<>();

    @OneToOne(mappedBy = "orders", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Payment payment;

    @ManyToOne
    @JoinColumn(name = "member_id")
    private Member member;

	public Orders() {
		super();
	}

	public Orders(String ordersId, Timestamp orderDate, String status, Double totalAmount, List<OrderDetail> orderDetails,
			Payment payment, Member member) {
		super();
		this.ordersId = ordersId;
		this.orderDate = orderDate;
		this.status = status;
		this.totalAmount = totalAmount;
		this.orderDetails = orderDetails;
		this.payment = payment;
		this.member = member;
	}

	public String getOrdersId() {
		return ordersId;
	}

	public void setOrdersId(String ordersId) {
		this.ordersId = ordersId;
	}

	public Timestamp getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(Timestamp orderDate) {
		this.orderDate = orderDate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Double getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(Double totalAmount) {
		this.totalAmount = totalAmount;
	}

	public List<OrderDetail> getOrderDetails() {
		return orderDetails;
	}

	public void setOrderDetails(List<OrderDetail> orderDetails) {
		this.orderDetails = orderDetails;
	}

	public Payment getPayment() {
		return payment;
	}

	public void setPayment(Payment payment) {
		this.payment = payment;
	}

	public Member getMember() {
		return member;
	}

	public void setMember(Member member) {
		this.member = member;
	}

	public Double getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(Double discountAmount) {
        this.discountAmount = discountAmount;
    }

    public String getCouponCode() {
        return couponCode;
    }

    public void setCouponCode(String couponCode) {
        this.couponCode = couponCode;
    }

	public Timestamp getPreparingDate() { 
		return preparingDate; 
	}

    public void setPreparingDate(Timestamp preparingDate) { 
		this.preparingDate = preparingDate; 
	}

    public Timestamp getReadyDate() { 
		return readyDate; 
	}
	
    public void setReadyDate(Timestamp readyDate) { 
		this.readyDate = readyDate; 
	}

    public Timestamp getCompletedDate() { 
		return completedDate; 
	}

    public void setCompletedDate(Timestamp completedDate) { 
		this.completedDate = completedDate;
	}
}
