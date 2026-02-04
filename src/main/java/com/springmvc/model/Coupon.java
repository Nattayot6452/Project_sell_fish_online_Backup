package com.springmvc.model;

import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

@Entity
@Table(name = "coupon")
public class Coupon {

    @Id
    @Column(name = "coupon_code", length = 20)
    private String couponCode;

    @Column(name = "discount_type", nullable = false)
    private String discountType;

    @Column(name = "discount_value", nullable = false)
    private Double discountValue;

    @Column(name = "min_order_amount")
    private Double minOrderAmount;

    @Column(name = "start_date")
    @Temporal(TemporalType.DATE)
    private Date startDate;

    @Column(name = "expire_date")
    @Temporal(TemporalType.DATE)
    private Date expireDate;

    @Column(name = "usage_limit")
    private int usageLimit;

    @Column(name = "usage_count")
    private int usageCount;

    @Column(name = "status")
    private String status;

    public Coupon() {}

    public Coupon(String couponCode, String discountType, double discountValue, double minOrderAmount, 
                  Date startDate, Date expireDate, int usageLimit, String status) {
        this.couponCode = couponCode;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.minOrderAmount = minOrderAmount;
        this.startDate = startDate;
        this.expireDate = expireDate;
        this.usageLimit = usageLimit;
        this.usageCount = 0; 
        this.status = status;
    }

    public String getCouponCode() { return couponCode; }
    public void setCouponCode(String couponCode) { this.couponCode = couponCode; }

    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }

    public double getDiscountValue() { return discountValue; }
    public void setDiscountValue(double discountValue) { this.discountValue = discountValue; }

    public double getMinOrderAmount() { return minOrderAmount; }
    public void setMinOrderAmount(double minOrderAmount) { this.minOrderAmount = minOrderAmount; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getExpireDate() { return expireDate; }
    public void setExpireDate(Date expireDate) { this.expireDate = expireDate; }

    public int getUsageLimit() { return usageLimit; }
    public void setUsageLimit(int usageLimit) { this.usageLimit = usageLimit; }

    public int getUsageCount() { return usageCount; }
    public void setUsageCount(int usageCount) { this.usageCount = usageCount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    @Transient
    public String getDisplayDiscount() {
        if ("percent".equalsIgnoreCase(discountType)) {
            return String.valueOf(discountValue.intValue()) + "%";
        } else {
            return String.valueOf(discountValue.intValue()) + "฿";
        }
    }

    @Transient
    public String getDisplayTitle() {
        if ("percent".equalsIgnoreCase(discountType)) {
            return "ลดคุ้มๆ " + discountValue.intValue() + "%";
        } else {
            return "ส่วนลด " + discountValue.intValue() + " บาท";
        }
    }

    @Transient
    public String getDisplayDesc() {
        if (minOrderAmount != null && minOrderAmount > 0) {
            return "เมื่อช้อปครบ " + minOrderAmount.intValue() + " บาท";
        } else {
            return "ไม่มีขั้นต่ำ ช้อปได้เลย!";
        }
    }
    
    @Transient
    public String getDisplayType() {
        if ("percent".equalsIgnoreCase(discountType) && discountValue >= 50) return "hot";
        if (minOrderAmount == null || minOrderAmount == 0) return "new";
        return "normal";
    }

    @Transient
    public boolean isExpired() {
        if (expireDate == null) return false;
        return new Date().after(expireDate);
    }

    @Transient
    public boolean isSoldOut() {
        if (usageLimit <= 0) return false;
        return usageCount >= usageLimit;
    }

    @Transient
    public int getRemainingCount() {
        if (usageLimit <= 0) return 9999;
        return usageLimit - usageCount;
    }
}