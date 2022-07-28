package ckb.services.med.rep;

import org.springframework.ui.Model;

import javax.servlet.http.HttpServletRequest;

public interface SRep {

	// Генерация отчета
	void gRep(HttpServletRequest req, Model m);

}