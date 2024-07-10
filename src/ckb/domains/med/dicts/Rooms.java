package ckb.domains.med.dicts;

import ckb.domains.GenId;
import ckb.domains.admin.Depts;
import ckb.domains.admin.Dicts;

import javax.persistence.*;

// Справочник комнаты
@Entity
@Table(name = "Rooms")
public class Rooms extends GenId {

	// Наименование
	@Column(length = 512, nullable = false)
	private String name;

	// Тип комната
	@OneToOne
	@JoinColumn(name = "roomType")
	private Dicts roomType;

	// Этаж комната
	@OneToOne
	@JoinColumn(name = "floor")
	private Dicts floor;

	@Column private Long koykoLimit;

	@Column private Double price;
	@Column private Double for_price;

	@Column private Double extra_price;
	@Column private Double for_extra_price;

	@Column private Double bron_price;
	@Column private Double for_bron_price;

	@Column private String access = "N";
	@Column private String state = "A";

	@OneToOne @JoinColumn private Depts dept;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Dicts getRoomType() {
		return roomType;
	}

	public void setRoomType(Dicts roomType) {
		this.roomType = roomType;
	}

	public Dicts getFloor() {
		return floor;
	}

	public void setFloor(Dicts floor) {
		this.floor = floor;
	}

	public String getAccess() {
		return access;
	}

	public void setAccess(String access) {
		this.access = access;
	}

	public Long getKoykoLimit() {
		return koykoLimit;
	}

	public void setKoykoLimit(Long koykoLimit) {
		this.koykoLimit = koykoLimit;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public Depts getDept() {
		return dept;
	}

	public void setDept(Depts dept) {
		this.dept = dept;
	}

	public Double getPrice() {
		return price;
	}

	public void setPrice(Double price) {
		this.price = price;
	}

	public Double getFor_price() {
		return for_price;
	}

	public void setFor_price(Double for_price) {
		this.for_price = for_price;
	}

	public Double getExtra_price() {
		return extra_price;
	}

	public void setExtra_price(Double extra_price) {
		this.extra_price = extra_price;
	}

	public Double getFor_extra_price() {
		return for_extra_price;
	}

	public void setFor_extra_price(Double for_extra_price) {
		this.for_extra_price = for_extra_price;
	}

	public Double getBron_price() {
		return bron_price;
	}

	public void setBron_price(Double bron_price) {
		this.bron_price = bron_price;
	}

	public Double getFor_bron_price() {
		return for_bron_price;
	}

	public void setFor_bron_price(Double for_bron_price) {
		this.for_bron_price = for_bron_price;
	}
}
