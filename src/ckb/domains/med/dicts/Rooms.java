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
}
