package ckb.services.med.rep;

import org.springframework.ui.Model;

import javax.servlet.http.HttpServletRequest;

public interface SRep {

	// ��������� ������
	void gRep(HttpServletRequest req, Model m);

}