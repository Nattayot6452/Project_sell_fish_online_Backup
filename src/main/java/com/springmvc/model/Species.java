package com.springmvc.model;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name = "species")
public class Species {

    @Id
    @Column(name = "species_id")
    private String speciesId;

    @Column(name = "species_name", length = 50, nullable = false)
    private String speciesName;

    @Column(name = "description", length = 255, nullable = false)
    private String description;

    @OneToMany(mappedBy = "species", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Product> products = new ArrayList<>();

    public Species() {
        super();
    }

    public Species(String speciesId, String speciesName, String description, List<Product> products) {
        super();
        this.speciesId = speciesId;
        this.speciesName = speciesName;
        this.description = description;
        this.products = products;
    }

    public Species(String speciesId, String speciesName) {
        this.speciesId = speciesId;
        this.speciesName = speciesName;
        this.description = "-";
    }

    public String getSpeciesId() { return speciesId; }
    public void setSpeciesId(String speciesId) { this.speciesId = speciesId; }

    public String getSpeciesName() { return speciesName; }
    public void setSpeciesName(String speciesName) { this.speciesName = speciesName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public List<Product> getProducts() { return products; }
    public void setProducts(List<Product> products) { this.products = products; }
}