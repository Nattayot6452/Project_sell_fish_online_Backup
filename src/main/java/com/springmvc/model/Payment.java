package com.springmvc.model;

import java.sql.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "payment")
public class Payment {

    @Id
    @Column(name = "slip_id")
    private String slipId;

    @Column(name = "upload_date", nullable = false)
    private Date uploadDate;

    @Column(name = "file_path", length = 255, nullable = false)
    private String filePath;

    @Column(name = "total", precision = 10, scale = 2, nullable = false)
    private Double total;

    @OneToOne
    @JoinColumn(name = "orders_id")
    private Orders orders;

	public Payment() {
		super();
	}

	public Payment(String slipId, Date uploadDate, String filePath, Double total, Orders orders) {
		super();
		this.slipId = slipId;
		this.uploadDate = uploadDate;
		this.filePath = filePath;
		this.total = total;
		this.orders = orders;
	}

	public String getSlipId() {
		return slipId;
	}

	public void setSlipId(String slipId) {
		this.slipId = slipId;
	}

	public Date getUploadDate() {
		return uploadDate;
	}

	public void setUploadDate(Date uploadDate) {
		this.uploadDate = uploadDate;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public Double getTotal() {
		return total;
	}

	public void setTotal(Double total) {
		this.total = total;
	}

	public Orders getOrders() {
		return orders;
	}

	public void setOrders(Orders orders) {
		this.orders = orders;
	}

	
}
