package com.springmvc.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name = "product")
public class Product {

	@OneToMany(mappedBy = "product", fetch = FetchType.EAGER, cascade = CascadeType.ALL)
    private List<ProductImage> galleryImages;

    @Id
    @Column(name = "product_id")
    private String productId;

    @Column(name = "product_name", length = 100, nullable = false)
    private String productName;

    @Column(name = "description", length = 255, nullable = false)
    private String description;

    @Column(name = "price", precision = 10, scale = 2, nullable = false)
    private Double price;

    @Column(name = "stock", nullable = false)
    private Integer stock;

    @Column(name = "product_img", length = 255, nullable = false)
    private String productImg;

    @Column(name = "origin", length = 255, nullable = false)
    private String origin;

    @Column(name = "water_type", length = 150, nullable = false)
    private String waterType;

    @Column(name = "temperature", length = 20, nullable = false)
    private String temperature;

    @Column(name = "size", length = 100, nullable = false)
    private String size;

    @Column(name = "life_span", length = 2, nullable = false)
    private String lifeSpan;

    @Column(name = "is_aggressive", length = 2 , nullable = false)
    private String isAggressive;

    @Column(name = "care_level", length = 1, nullable = false)
    private String careLevel;

	@Column(name = "product_status")
    private String productStatus;

	@Column(name = "create_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createDate = new Date();

    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<FavoriteProduct> favorites = new ArrayList<>();

    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Review> reviews = new ArrayList<>();

    @ManyToOne
    @JoinColumn(name = "species_id")
    private Species species;

	public Product() {
		super();
		this.createDate = new Date();
	}

	public Product(String productId, String productName, String description, Double price, Integer stock,
            String productImg, String origin, String waterType, String temperature, String size, String lifeSpan,
            String isAggressive, String careLevel, List<FavoriteProduct> favorites, List<Review> reviews,
            Species species) {
        super();
        this.productId = productId;
        this.productName = productName;
        this.description = description;
        this.price = price;
        this.stock = stock;
        this.productImg = productImg;
        this.origin = origin;
        this.waterType = waterType;
        this.temperature = temperature;
        this.size = size;
        this.lifeSpan = lifeSpan;
        this.isAggressive = isAggressive;
        this.careLevel = careLevel;
        this.favorites = favorites;
        this.reviews = reviews;
        this.species = species;
        this.createDate = new Date();
    }

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Double getPrice() {
		return price;
	}

	public void setPrice(Double price) {
		this.price = price;
	}

	public Integer getStock() {
		return stock;
	}

	public void setStock(Integer stock) {
		this.stock = stock;
	}

	public String getProductImg() {
		return productImg;
	}

	public void setProductImg(String productImg) {
		this.productImg = productImg;
	}

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getWaterType() {
		return waterType;
	}

	public void setWaterType(String waterType) {
		this.waterType = waterType;
	}

	public String getTemperature() {
		return temperature;
	}

	public void setTemperature(String temperature) {
		this.temperature = temperature;
	}

	public String getSize() {
		return size;
	}

	public void setSize(String size) {
		this.size = size;
	}

	public String getLifeSpan() {
		return lifeSpan;
	}

	public void setLifeSpan(String lifeSpan) {
		this.lifeSpan = lifeSpan;
	}

	public String getIsAggressive() {
		return isAggressive;
	}

	public void setIsAggressive(String isAggressive) {
		this.isAggressive = isAggressive;
	}

	public String getCareLevel() {
		return careLevel;
	}

	public void setCareLevel(String careLevel) {
		this.careLevel = careLevel;
	}

	public List<FavoriteProduct> getFavorites() {
		return favorites;
	}

	public void setFavorites(List<FavoriteProduct> favorites) {
		this.favorites = favorites;
	}

	public List<Review> getReviews() {
		return reviews;
	}

	public void setReviews(List<Review> reviews) {
		this.reviews = reviews;
	}

	public Species getSpecies() {
		return species;
	}

	public void setSpecies(Species species) {
		this.species = species;
	}

	public List<ProductImage> getGalleryImages() { return galleryImages; }
    public void setGalleryImages(List<ProductImage> galleryImages) { this.galleryImages = galleryImages; }
	
    public void addImage(ProductImage image) {
        if (this.galleryImages == null) {
            this.galleryImages = new ArrayList<>();
        }
        this.galleryImages.add(image);
        image.setProduct(this);
    }
    
	public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public boolean isNewProduct() {
        if (this.createDate == null) return false;
        
        long diff = new Date().getTime() - this.createDate.getTime();
        long days = diff / (24 * 60 * 60 * 1000); 
        
        return days <= 7;
    }

	public String getProductStatus() {
        return productStatus;
    }

    public void setProductStatus(String productStatus) {
        this.productStatus = productStatus;
    }
}

