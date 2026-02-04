package com.springmvc.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;


@Entity
@Table(name = "review")
public class Review {

    @Id
    @Column(name = "review_id")
    private String reviewId;

    @Column(name = "rating", nullable = false)
    private Integer rating;

    @Column(name = "comment", length = 255, nullable = false)
    private String comment;

    @Column(name = "review_date", nullable = false)
    private Date reviewDate;

	@Column(name = "order_id", length = 50)
    private String orderId;

    @ManyToOne
    @JoinColumn(name = "member_id")
    private Member member;

    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;

	public Review() {
		super();
	}

	public Review(String reviewId, Integer rating, String comment, Date reviewDate, Member member, Product product) {
		super();
		this.reviewId = reviewId;
		this.rating = rating;
		this.comment = comment;
		this.reviewDate = reviewDate;
		this.member = member;
		this.product = product;
	}

	public String getReviewId() {
		return reviewId;
	}

	public void setReviewId(String reviewId) {
		this.reviewId = reviewId;
	}

	public Integer getRating() {
		return rating;
	}

	public void setRating(Integer rating) {
		this.rating = rating;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public Date getReviewDate() {
		return reviewDate;
	}

	public void setReviewDate(Date reviewDate) {
		this.reviewDate = reviewDate;
	}

	public Member getMember() {
		return member;
	}

	public void setMember(Member member) {
		this.member = member;
	}

	public Product getProduct() {
		return product;
	}

	public void setProduct(Product product) {
		this.product = product;
	}
	
	public String getOrderId() { 
		return orderId; 
	}

    public void setOrderId(String orderId) { 
		this.orderId = orderId; 
	}
	
}

