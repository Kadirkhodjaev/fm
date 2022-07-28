package ckb.domains.admin;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

// ����� �����������
@Entity
@Table(name = "Dicts")
public class Dicts extends GenId {

	// ��� �����������
	@Column(length = 256)
	private String typeCode;

	// ������������
	@Column(length = 512)
	private String name;

	public String getTypeCode() {
		return typeCode;
	}

	public void setTypeCode(String typeCode) {
		this.typeCode = typeCode;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
}
