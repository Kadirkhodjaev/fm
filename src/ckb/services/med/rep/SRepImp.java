package ckb.services.med.rep;

import ckb.dao.admin.countery.DCountery;
import ckb.dao.admin.depts.DDept;
import ckb.dao.admin.dicts.DLvPartner;
import ckb.dao.admin.reports.DReport;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.amb.DAmbGroups;
import ckb.dao.med.amb.DAmbPatientServices;
import ckb.dao.med.amb.DAmbPatients;
import ckb.dao.med.drug.dict.manufacturer.DDrugManufacturer;
import ckb.dao.med.eat.dict.menuTypes.DEatMenuType;
import ckb.dao.med.head_nurse.patient.DHNPatient;
import ckb.dao.med.lv.bio.DLvBio;
import ckb.dao.med.lv.coul.DLvCoul;
import ckb.dao.med.lv.fizio.DLvFizio;
import ckb.dao.med.lv.fizio.DLvFizioDate;
import ckb.dao.med.lv.garmon.DLvGarmon;
import ckb.dao.med.lv.plan.DLvPlan;
import ckb.dao.med.lv.torch.DLvTorch;
import ckb.dao.med.patient.DPatient;
import ckb.dao.med.patient.DPatientWatchers;
import ckb.domains.admin.Counteries;
import ckb.domains.admin.Depts;
import ckb.domains.admin.LvPartners;
import ckb.domains.admin.Users;
import ckb.domains.med.amb.AmbGroups;
import ckb.domains.med.amb.AmbPatients;
import ckb.domains.med.drug.dict.DrugManufacturers;
import ckb.domains.med.eat.dict.EatMenuTypes;
import ckb.domains.med.head_nurse.HNPatients;
import ckb.domains.med.lv.*;
import ckb.domains.med.patient.PatientWatchers;
import ckb.domains.med.patient.Patients;
import ckb.models.Obj;
import ckb.models.ObjList;
import ckb.models.reports.Rep1;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.DB;
import ckb.utils.Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

public class SRepImp implements SRep {

	@Autowired DAmbGroups dAmbGroup;
	@Autowired DReport dReport;
	@Autowired DUser dUser;
	@Autowired DCountery dCountery;
	//
	@Autowired private DPatientWatchers dPatientWatchers;
	@Autowired private DLvFizio dLvFizio;
	@Autowired private DLvFizioDate dLvFizioDate;
	@Autowired private DLvPlan dLvPlan;
	@Autowired private DPatient dPatient;
	@Autowired private DAmbPatients dAmbPatient;
	@Autowired private DAmbPatientServices dAmbPatientService;
	@Autowired private DLvBio dLvBio;
	@Autowired private DLvCoul dLvCoul;
	@Autowired private DLvGarmon dLvGarmon;
	@Autowired private DLvTorch dLvTorch;
	@Autowired private DDept dDept;
	@Autowired private DHNPatient dhnPatient;
	@Autowired private DLvPartner dLvPartner;
	@Autowired private DDrugManufacturer dDrugManufacturer;
	@Autowired private DEatMenuType dEatMenuType;

	@Override
	public void gRep(HttpServletRequest req, Model m) {
		Integer id = Util.getInt(req, "repId");
		m.addAttribute("rep", dReport.get(id));
		// Амбулаторные услуги - По категориям
		if(id == 1) { // Амбулаторные услуги - По категориям
			rep1(req, m);
		} else if (id == 2) { // Койка день
			rep2(req, m);
		} else if (id == 3) { // Амбулатория журнал
			rep3(req, m);
		} else if (id == 4) { // Расчет бонусов(амбулатория)
			rep4(req, m);
		} else if (id == 5) { // Количество пациентов по регионым
			rep5(req, m);
    } else if (id == 6) { // Гинеколог муолажалари (стац, амб)
      rep6(req, m);
    } else if (id == 7) { // ЭХО КГ
      rep7(req, m);
    } else if (id == 8) { // УЗИ Амбулатория
      rep8(req, m);
    } else if (id == 9) { // Гинеколог Амбулатория
      rep9(req, m);
    } else if (id == 10) { // ЭКГ Амбулатория
      rep10(req, m);
    } else if (id == 11) { // Окулист Амбулатория
      rep11(req, m);
    } else if (id == 12) { // УЗИ стационар
      rep12(req, m);
    } else if(id == 13) { // Амб рег журнал
      rep13(req, m);
    } else if(id == 14) { // Консультация (Стационар)
      rep14(req, m);
    } else if(id == 15) { // Оториноларинголог (Амбулатория)
      rep15(req, m);
    } else if(id == 16) { // Биохимия (Стационар)
      rep16(req, m);
    } else if(id == 17) { // Умумий кон тахлили (Стационар)
      rep17(req, m);
    } else if(id == 18) { // Все консультации (Стационар)
      rep18(req, m);
    } else if(id == 19) { // Пешобда суткалик канд микдорини аниклаш
      rep19(req, m);
    } else if(id == 20) { // Анти - ТРО
      rep20(req, m);
    } else if(id == 21) { // Кондаги гормонларни текшириш
      rep21(req, m);
    } else if(id == 22) { // TORCH инфекцияси текшируви
      rep22(req, m);
    } else if(id == 23) { // Умумий пешоб тахлили
      rep23(req, m);
    } else if(id == 24) { // Коагулограмма
      rep24(req, m);
    } else if(id == 25) { // Гликимик профил
      rep25(req, m);
    } else if(id == 26) { // Ничепоренко буйича пешоб тахлили
      rep26(req, m);
    } else if(id == 27) { // Зимницкий буйича пешоб тахлили
      rep27(req, m);
    } else if(id == 28) { // Кон зардобида липопротеидлар тахлили
      rep28(req, m);
    } else if(id == 29) { // Окулист муолажалари (Стац, Амб)
      rep29(req, m);
    } else if(id == 30) { // ЛОР муолажалари (Стац, Амб)
      rep30(req, m);
    } else if(id == 31) { // Холтер муолажалари (Стац, Амб)
      rep31(req, m);
    } else if(id == 32) { // Консультация (Амб)
      rep32(req, m);
    } else if(id == 33) { // Все консультации (Амб)
      rep33(req, m);
    } else if(id == 34) { // Все консультации (Амб)
			rep34(req, m);
		} else if(id == 35) { // Детализация Кассы
			rep35(req, m);
		} else if(id == 36) { // Биохимия (Амбулатория)
			rep36(req, m);
		} else if(id == 37) { // Кондаги гормонларни текшириш (Амбулатория)
			rep37(req, m);
		} else if(id == 38) { // TORCH инфекцияси текшируви (Амбулатория)
			rep38(req, m);
		} else if(id == 39) { // Коагулограмма (Амбулатория)
			rep39(req, m);
		} else if(id == 41) { // Кон зардобида липопротеидлар тахлили
			rep41(req, m);
		} else if(id == 42) { // Общий анализ крови 21 параметр
			rep42(req, m);
		} else if(id == 43) { // Пешобда суткалик канд микдорини аниклаш
			rep43(req, m);
		} else if(id == 44) { // Ничепоренко буйича пешоб тахлили
			rep44(req, m);
		} else if(id == 45) { // Зимницкий буйича пешоб тахлили
			rep45(req, m);
		} else if(id == 46) { // Анализ гинекологического мазка
			rep46(req, m);
		} else if(id == 47) { // Общий анализ мочи
			rep47(req, m);
		} else if(id == 48) { // Анализ гинекологического мазка (Стационар)
			rep48(req, m);
		} else if(id == 49) { // Сводный отчет по текущим пациентам (Стационар)
			rep49(req, m);
		} else if(id == 50) { // План обследования на след день
			rep50(req, m);
		} else if(id == 51) { // Телефонные номера клиентов
			rep51(req, m);
		} else if(id == 52) { // Отчет по пациентам
			rep52(req, m);
		} else if(id == 53) { // Расчет по партнерам
			rep53(req, m);
		} else if(id == 54) { // Скидки по услугам
			rep54(req, m);
		} else if(id == 55) { // Скидки по услугам
			rep55(req, m);
		} else if(id == 56) { // Сводный отчет (Питание)
			rep56(req, m);
		} else if(id == 57) { // Отчет по пациентам (Амбулатория)
			rep57(req, m);
		} else if(id == 58) { // Отчет по пациентам (Амбулатория)
			rep57(req, m);
		} else if(id == 59) { // Отчет по RW
			rep59(req, m);
		} else if(id == 60) { // Приемный (Годовой)
			rep60(req, m);
		} else if(id == 61) { // Детальный отчет по услугам
			rep61(req, m);
		} else if(id == 62) { // Отчет по МКБ 10 за период
			rep62(req, m);
		}
	}
	// Амбулаторные услуги - По категориям
	private void rep1(HttpServletRequest req, Model m) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<Rep1> rows = new ArrayList<Rep1>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		try {
			conn = DB.getConnection();
			List<AmbGroups> groups = dAmbGroup.getAll();
			Integer counter = 0;

			for (AmbGroups group : groups) {
				Rep1 r = new Rep1();
				r.setGroupName(group.getName());
				ps = conn.prepareStatement(
					"SELECT s.name, COUNT(*) counter, " +
						"				 (Select u.Fio From Users u Where u.Id = c.Worker_Id) Worker_Name " +
						"FROM Amb_Patients t, Amb_Patient_Services c, Amb_Services s " +
						"Where t.id = c.patient " +
						"  And c.service_id = s.id " +
						"  And s.group_id = ? " +
						"  And date(t.cron) Between ? And ? " +
						"GROUP BY s.Name, c.Worker_Id " +
						"Order By c.Worker_id"
				);
				ps.setInt(1, group.getId());
				ps.setString(2, Util.dateDB(Util.get(req, "period_start")));
				ps.setString(3, Util.dateDB(Util.get(req, "period_end")));
				rs = ps.executeQuery();
				List<ObjList> services = new ArrayList<ObjList>();
				Integer groupCounter = 0;
				while(rs.next()) {
					ObjList service = new ObjList();
					Integer serCount = rs.getInt(2);
					service.setC1(rs.getString(1));
					service.setC2("" + serCount);
					service.setC3(rs.getString(3));
					groupCounter += serCount;
					services.add(service);
				}
				counter += groupCounter;
				r.setServices(services);
				r.setCounter(groupCounter);
				if(services.size() > 0)
					rows.add(r);
			}
			Rep1 total = new Rep1();
			total.setGroupName("ИТОГО ПО ВСЕМ");
			total.setCounter(counter);
			rows.add(total);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(ps);
			DB.done(rs);
			DB.done(conn);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Койка день
	private void rep2(HttpServletRequest req, Model m) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<Rep1> rows = new ArrayList<Rep1>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		String dateBegin = Util.dateDB(Util.get(req, "period_start"));
		String dateEnd = Util.dateDB(Util.get(req, "period_end"));
		Integer deptId = !req.getParameter("dept").equals("") ? Util.getInt(req, "dept") : null;
		params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		Integer total = 0;
		// Если выбран врач
		if (!req.getParameter("doctor").equals("")) {
			Integer doctorId = Util.getInt(req, "doctor");
			Users user = dUser.get(doctorId);
			List<ObjList> patients = new ArrayList<ObjList>();
			Rep1 r = new Rep1();
			r.setGroupName(user.getFio());
			try {
				conn = DB.getConnection();
				ps = conn.prepareStatement(
					"Select Concat(t.surname, ' ',  t.name, ' ', t.middlename) Fio , " +
						"				 (Select dept.name From Depts dept Where dept.Id = t.Dept_Id) depName, " +
						"				 t.Palata, " +
						"				 Date_Format(t.Date_Begin, '%d.%m.%Y') dateBegin, " +
						"				 Date_Format(t.Date_End, '%d.%m.%Y') dateEnd, " +
						"				 Datediff(t.Date_End, t.Date_Begin) bunkDay " +
						"   From Patients t" +
						"  Where t.Date_End Is Not Null" +
            "    AND t.lv_id != 1 " +
						"    And t.Date_End Between '" + dateBegin + "' And '" + dateEnd + "'" +
						(deptId != null ? " And t.Dept_Id = " + deptId : "") +
						(doctorId != null ? " And t.Lv_Id = " + doctorId : "") +
						" Union " +
						"Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio , " +
						"				 (Select dept.name From Depts dept Where dept.Id = p.Dept_Id) depName, " +
						"				 p.Palata, " +
						"				 (Case When e.dateBegin Is Not Null Then DATE_FORMAT(e.dateBegin, '%d.%m.%Y') Else Date_Format(p.Start_Epic_Date, '%d.%m.%Y') End) dateBegin, " +
						"				 Date_Format(e.dateEnd, '%d.%m.%Y') dateEnd, " +
						"				 (Case When e.dateBegin Is Not Null Then Datediff(e.dateEnd, e.dateBegin) + 1 Else Datediff(e.dateEnd, p.Start_Epic_Date) + 1 End) bunkDay " +
						"   From Lv_Epics e, Patients p" +
						"  Where e.dateEnd Between '" + dateBegin + "' And '" + dateEnd + "'" +
            "    AND p.lv_id != 1 " +
						" 	 And e.patientId = p.Id " +
						(deptId != null ? " And e.DeptId = " + deptId : "") +
						(doctorId != null ? " And e.LvId = " + doctorId : "")
				);
				rs = ps.executeQuery();
				while (rs.next()) {
					ObjList service = new ObjList();
					service.setC1(rs.getString(1));
					service.setC2(rs.getString(2));
					service.setC3(rs.getString(3));
					service.setC4(rs.getString(4));
					service.setC5(rs.getString(5));
					service.setC6(rs.getString(6));
					patients.add(service);
				}
				r.setServices(patients);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DB.done(ps);
				DB.done(rs);
				DB.done(conn);
			}
			rows.add(r);
		} else {
			try {
				conn = DB.getConnection();
				List<Users> users = dUser.getLvs();
				for (Users user : users) {
					Rep1 r = new Rep1();
					r.setGroupName(user.getFio());
					ps = conn.prepareStatement(
						"Select Concat(t.surname, ' ',  t.name, ' ', t.middlename) Fio , " +
							"				 (Select dept.name From Depts dept Where dept.Id = t.Dept_Id) depName, " +
							"				 t.Palata, " +
							"				 Date_Format(t.Date_Begin, '%d.%m.%Y') dateBegin, " +
							"				 Date_Format(t.Date_End, '%d.%m.%Y') dateEnd, " +
							"				 Datediff(t.Date_End, t.Date_Begin) bunkDay " +
							"   From Patients t" +
							"  Where t.Date_End Is Not Null" +
              "    AND t.lv_id != 1 " +
							"    And t.Date_End Between '" + dateBegin + "' And '" + dateEnd + "'" +
							(deptId != null ? " And t.Dept_Id = " + deptId : "") +
							" And t.Lv_Id = " + user.getId() +
							" Union " +
							"Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio , " +
							"				 (Select dept.name From Depts dept Where dept.Id = p.Dept_Id) depName, " +
							"				 p.Palata, " +
							"				 (Case When e.dateBegin Is Not Null Then DATE_FORMAT(e.dateBegin, '%d.%m.%Y') Else Date_Format(p.Start_Epic_Date, '%d.%m.%Y') End) dateBegin, " +
							"				 Date_Format(e.dateEnd, '%d.%m.%Y') dateEnd, " +
							"				 (Case When e.dateBegin Is Not Null Then Datediff(e.dateEnd, e.dateBegin) Else Datediff(e.dateEnd, p.Start_Epic_Date) End) bunkDay " +
							"   From Lv_Epics e, Patients p" +
							"  Where e.dateEnd Between '" + dateBegin + "' And '" + dateEnd + "'" +
              "    AND p.lv_id != 1 " +
							" 	 And e.patientId = p.Id " +
							(deptId != null ? " And e.DeptId = " + deptId : "")
					);
					rs = ps.executeQuery();
					List<ObjList> services = new ArrayList<ObjList>();
					Integer diff = 0, counter = 0;
					while(rs.next()) {
						ObjList service = new ObjList();
						service.setC1(rs.getString(1));
						service.setC2(rs.getString(2));
						service.setC3(rs.getString(3));
						service.setC4(rs.getString(4));
						service.setC5(rs.getString(5));
						service.setC6(rs.getString(6));
						counter++;
						diff += rs.getInt(6) + 1;
						services.add(service);
					}
					// Если есть запись
					if(services.size() > 0) {
						ObjList service = new ObjList();
						service.setC1("Кол-во по врачу " + counter);
						service.setC2("");
						service.setC3("");
						service.setC4("");
						service.setC5("");
						service.setC6("" + diff);
						service.setC7("TOTAL");
						total += diff;
						services.add(service);
						r.setServices(services);
						rows.add(r);
					}
				}
				if(rows.size() > 0) {
					List<ObjList> services = new ArrayList<ObjList>();
					ObjList service = new ObjList();
					Rep1 r = new Rep1();
					service.setC1("ИТОГО ПО КЛИНИКЕ");
					service.setC2("");
					service.setC3("");
					service.setC4("");
					service.setC5("");
					service.setC6("" + total);
					service.setC7("ITOGO");
					services.add(service);
					r.setServices(services);
					rows.add(r);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DB.done(ps);
				DB.done(rs);
				DB.done(conn);
			}
		}
		m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
	}
  // Третый отчеть - Амбулатория журнал
  private void rep3(HttpServletRequest req, Model m) {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<Rep1>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<AmbGroups> groups = new ArrayList<AmbGroups>();
    if (!req.getParameter("group").equals("")) {
      Integer groupId = Util.getInt(req, "group");
      AmbGroups group = dAmbGroup.get(groupId);
      groups.add(group);
    } else
      groups = dAmbGroup.getAll();
    for (AmbGroups group : groups) {
      List<ObjList> patients = new ArrayList<ObjList>();
      Rep1 r = new Rep1();
      r.setGroupName(group.getName());
      try {
				conn = DB.getConnection();
        ps = conn.prepareStatement(
          "Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
            "				 ser.Name Service_Name, " +
            "  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
            "				 'Амб' Type " +
            "   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p " +
            "  Where ser.Id = t.Service_Id " +
            "    And p.Id = t.Patient " +
            "		 And ser.Group_Id = " + group.getId() +
            " 	 And date(t.confDate) Between ? And ?" +
            "   Order By ser.group_id, p.cron "
        );
        ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
        ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
        rs = ps.executeQuery();
        Integer counter = 0;
        String fio = "";
        while (rs.next()) {
          if (!rs.getString("fio").equals(fio))
            counter++;
          ObjList service = new ObjList();
          service.setC1(rs.getString("fio"));
          service.setC2(rs.getString("service_name"));
          service.setC3(rs.getString("type"));
          service.setC5(rs.getString("cr_on"));
          service.setC4("" + counter);
          fio = rs.getString("fio");
          patients.add(service);
        }
        r.setServices(patients);
      } catch (Exception e) {
        e.printStackTrace();
      } finally {
        DB.done(ps);
				DB.done(rs);
				DB.done(conn);
			}
      if(r.getServices() != null && r.getServices().size() > 0)
        rows.add(r);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Расчет бонусов(амбулатория)
  private void rep4(HttpServletRequest req, Model m) {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<Rep1>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<Users> doctors = new ArrayList<Users>();
    if (!req.getParameter("doctor").equals("")) {
      Integer doctorId = Util.getInt(req, "doctor");
      Users doctor = dUser.get(doctorId);
      doctors.add(doctor);
    } else
      doctors = dUser.getList(
        "Select t From Users t, AmbServiceUsers s, AmbServices c " +
          "	Where t.id = s.user " +
          "	  And s.service = c.id " +
          "		And c.consul = 'Y'");
    try {
			Double total = 0D;
			for (Users doctor : doctors) {
        List<ObjList> patients = new ArrayList<ObjList>();
        Rep1 r = new Rep1();
        r.setGroupName(doctor.getFio());
        ps = conn.prepareStatement(
          "Select Date_Format(t.confDate, '%d.%m.%Y') CrOn," +
            "				 Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio , " +
            "				 ser.Name Service_Name, " +
            "				 ser.Price Price, " +
            "				 gr.Name Group_Name" +
            "   From Amb_Patient_Services t, Amb_Services ser, Amb_Groups gr, Amb_Patients p " +
            "  Where ser.Id = t.Service_Id " +
            "    And p.Id = t.Patient " +
            "		 And gr.Id = ser.Group_Id " +
            "		 And t.crBy = " + doctor.getId() +
            " 	 And date (t.confDate) Between ? AND ? " +
            "  Order By t.confDate "
        );
        ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
        ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
        rs = ps.executeQuery();
        Integer counter = 0;
        Double summ = 0D;
        while (rs.next()) {
          counter++;
          ObjList service = new ObjList();
          service.setC1(rs.getString(1));
          service.setC2(rs.getString(2));
          service.setC3(rs.getString(3));
          service.setC4("" + rs.getDouble(4));
          summ += rs.getDouble(4);
          service.setC5(rs.getString(5));
          patients.add(service);
        }
        // Итого по врачу
        ObjList service = new ObjList();
        service.setC1("Кол-во направлении: " + counter);
        service.setC2("" + summ);
        total += summ;
        service.setC6("TOTAL");
        patients.add(service);
        r.setServices(patients);
        if(r.getServices() != null && r.getServices().size() > 1)
          rows.add(r);
      }
      if(rows.size() > 0) {
				List<ObjList> patients = new ArrayList<ObjList>();
				Rep1 r = new Rep1();
				ObjList service = new ObjList();
				service.setC1("Итого по клинике");
				service.setC2("" + total);
				service.setC6("ITOGO");
				patients.add(service);
				r.setServices(patients);
				rows.add(r);
			}
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Количество пациентов по регионым
  private void rep5(HttpServletRequest req, Model m) {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<Rep1>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<Counteries> counteries = dCountery.getCounteries();
    for (Counteries country : counteries) {
      List<ObjList> patients = new ArrayList<ObjList>();
      Rep1 r = new Rep1();
      r.setGroupName(country.getName());
      try {
        ps = conn.prepareStatement(
          "Select Count(*)," +
            "				 (Select reg.Name From Regions reg Where reg.Id = t.RegionId) Region_Name " +
            "   From Amb_Patients t" +
            "  Where t.CounteryId = " + country.getId() +
            " 	 And date (t.reg_date) Between ? AND ? " +
            " Group By t.RegionId"
        );
        ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
        ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
        rs = ps.executeQuery();
        while (rs.next()) {
          ObjList service = new ObjList();
          service.setC1(rs.getString(2));
          service.setC2(rs.getString(1));
          patients.add(service);
        }
        r.setServices(patients);
      } catch (Exception e) {
        e.printStackTrace();
      } finally {
        DB.done(conn);
        DB.done(ps);
        DB.done(rs);
      }
      rows.add(r);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Гинеколог муолажалари (стац, амб)
  private void rep6(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<ObjList> rows = new ArrayList<ObjList>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		try {
			ps = conn.prepareStatement(
				"Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
					"         p.birthyear, " +
					"         Date_Format(t.Result_Date, '%d.%m.%Y') cr_on, " +
					"         f.c1 diagnoz, " +
					"         c.Name Service_Name, " +
					"         'Стац.' service_Type," +
          "         t.result_date " +
					" From Lv_Plans t, Kdos c, Patients p, Users u, F999 f  " +
					" Where t.Kdo_Id = c.id " +
					"   And t.patientId = p.id " +
					"   And f.plan_id = t.id" +
					"   And c.kdo_type = 12 " +
					"   And u.id = p.lv_id " +
					"   And date (t.Result_Date) Between ? and ? " +
          " UNION ALL " +
          " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "        p.birthyear, " +
          "  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
          "        t.diagnoz, " +
          "				 ser.Name Service_Name, " +
          "				 'Амб' Service_Type, " +
          "        t.confDate " +
          "   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p " +
          "  Where ser.Id = t.Service_Id " +
          "    And p.Id = t.Patient " +
          "		 And ser.Group_Id = 11 " +
          " 	 And date (t.confDate) Between ? and ? "+
          " Order By 7 "
			);
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      ps.setString(3, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(4, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
			int counter = 0; String fio = "";
			while (rs.next()) {
        if (!rs.getString("fio").equals(fio))
          counter++;
				ObjList service = new ObjList();
				service.setFio(rs.getString("fio"));
				service.setBirthyear(rs.getString("BirthYear"));
				service.setDate(rs.getString("cr_on"));
				//
				service.setC1(rs.getString("diagnoz"));
				service.setC2(rs.getString("service_name"));
				service.setC3(rs.getString("service_Type"));
				//
        service.setC4("" + counter);
        fio = rs.getString("fio");
				//
				rows.add(service);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
  }
  // ЭХО, РЕГ, ЭЭГ
  private void rep7(HttpServletRequest req, Model m) {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<Rep1>();
    //
		String catStat = Util.get(req, "cat_stat");
		String catAmb = Util.get(req, "cat_amb");
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<ObjList>();
    Rep1 r = new Rep1();
    try {
      ps = conn.prepareStatement(
        "Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
          "         c.Name Service_Name, " +
          "         Date_Format(t.Result_Date, '%d.%m.%Y') cr_on, " +
          "         'Стац' Type, " +
          "         t.Result_Date " +
          " From Lv_Plans t, Kdos c, Patients p " +
          " Where t.Kdo_Id = c.id " +
          "   And t.patientId = p.id " +
          "   And c.Kdo_Type = 10 " + (catStat.equals("") ? "" : " And c.id = " + catStat) +
          "   And date (t.Result_Date) Between ? AND ? " +
          " Union All " +
          " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "				 ser.Name Service_Name, " +
          "  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
          "				 'Амб' Type, " +
          "        t.confDate " +
          "   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p " +
          "  Where ser.Id = t.Service_Id " +
          "    And p.Id = t.Patient " +
          "		 And ser.Group_Id = 8 " + (catAmb.equals("") ? "" : " And ser.id = " + catAmb) +
          " 	 And date (t.confDate) Between ? and ? "+
          " Order By 5 "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      ps.setString(3, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(4, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      Integer counter = 0;
      String fio = "";
      while (rs.next()) {
        if (!rs.getString("fio").equals(fio))
          counter++;
        ObjList service = new ObjList();
        service.setC1(rs.getString("fio"));
        service.setC2(rs.getString("service_name"));
        service.setC3(rs.getString("type"));
        service.setC5(rs.getString("cr_on"));
        service.setC4("" + counter);
        fio = rs.getString("fio");
        patients.add(service);
      }
      r.setServices(patients);
      if(r.getServices() != null && r.getServices().size() > 0)
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // УЗИ амбулатория
  private void rep8(HttpServletRequest req, Model m) {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<ObjList> rows = new ArrayList<ObjList>();
    //
		String cat = Util.get(req, "cat");
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    try {
      ps = conn.prepareStatement(
        "Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "				 ser.Name Service_Name, " +
          "  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
          "        p.BirthYear, " +
          "        t.diagnoz, " +
          "        u.fio doc, " +
          "        (Select con.Name From counteries con WHERE con.id = p.counteryId) Country, " +
          "        (Select reg.Name From Regions reg WHERE reg.id = p.regionId) Region, " +
          "        p.Address " +
          "   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p, Users u " +
          "  Where ser.Id = t.Service_Id " +
          "    And p.Id = t.Patient " +
					"    And t.State = 'DONE' " +
          "    And u.id = t.worker_id " +
          "		 And ser.Group_Id = 2 " + (cat.equals("") ? "" : " And ser.id = " + cat) +
          " 	 And date (t.confDate) Between ? and ? " +
          "   Order By t.confDate "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      Integer counter = 0;
      String fio = "";
      while (rs.next()) {
        if (!rs.getString("fio").equals(fio))
          counter++;
        ObjList service = new ObjList();
        service.setC1(rs.getString("fio"));
        service.setC2(rs.getString("service_name"));
        service.setC3(rs.getString("cr_on"));
        service.setC4(rs.getString("BirthYear"));
        service.setC5(rs.getString("diagnoz"));
        service.setC6(rs.getString("doc"));
        service.setC7("");
        if(rs.getString("country") != null)
          service.setC7(service.getC7() + rs.getString("country") + ", ");
        if(rs.getString("region") != null)
          service.setC7(service.getC7() + rs.getString("region") + ", ");
        if(rs.getString("address") != null)
          service.setC7(service.getC7() + rs.getString("address"));
        //
        service.setC10("" + counter);
        fio = rs.getString("fio");
        rows.add(service);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Гинеколог амбулатория
  private void rep9(HttpServletRequest req, Model m) {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<ObjList> rows = new ArrayList<ObjList>();
    //
		String catStat = Util.get(req, "cat_stat");
		String catAmb = Util.get(req, "cat_amb");
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
		String cat = Util.get(req, "cat");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    try {
      ps = conn.prepareStatement(
          " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "				 ser.Name Service_Name, " +
          "  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
          "        p.BirthYear, " +
          "        t.diagnoz, " +
          "        u.fio doc, " +
          "        (Select con.Name From counteries con WHERE con.id = p.counteryId) Country, " +
          "        (Select reg.Name From Regions reg WHERE reg.id = p.regionId) Region, " +
          "        p.Address, " +
					"				 'Амб' type_name, " +
					"				 t.confDate " +
          "   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p, Users u " +
          "  Where ser.Id = t.Service_Id " +
          "    And p.Id = t.Patient " +
          "    And u.id = t.worker_id " + ("2".equals(cat) ? " And 1 = 0 " : "") +
          "		 And ser.id in (98, 99) " + (catAmb.equals("") ? "" : " And ser.id = " + catAmb) +
          " 	 And date(t.confDate) Between ? and ? " +
					" Union All " +
					" Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
					"        c.Name, " +
					"        Date_Format(t.Result_Date, '%d.%m.%Y') cr_on, " +
					"        p.birthyear, " +
					"        p.Start_Diagnoz diagnoz, " +
					"				 u.fio doc, " +
					"        (Select con.Name From counteries con WHERE con.id = p.counteryId) Country, " +
					"        (Select reg.Name From Regions reg WHERE reg.id = p.regionId) Region, " +
					"				 p.address, " +
					"        'Стац' type_name, " +
					"        t.Result_Date " +
					" From Lv_Plans t, Kdos c, Patients p, Users u " +
					" Where t.Kdo_Id = c.id " +
					"   And t.patientId = p.id " + ("1".equals(cat) ? " And 1 = 0 " : "") +
					"   And c.kdo_type = 12 " + (catStat.equals("") ? "" : " And c.id = " + catStat) +
					"   And u.id = p.lv_id " +
					"   And date (t.Result_Date) Between ? and ? " +
					" Order By 11 "
      );
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			ps.setString(3, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(4, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      Integer counter = 0;
      String fio = "";
      while (rs.next()) {
        if (!rs.getString("fio").equals(fio))
          counter++;
        ObjList service = new ObjList();
        service.setC1(rs.getString("fio"));
        service.setC2(rs.getString("service_name"));
        service.setC3(rs.getString("cr_on"));
        service.setC4(rs.getString("BirthYear"));
        service.setC5(rs.getString("diagnoz"));
        service.setC6(rs.getString("doc"));
        service.setC7("");
        if(rs.getString("country") != null)
          service.setC7(service.getC7() + rs.getString("country") + ", ");
        if(rs.getString("region") != null)
          service.setC7(service.getC7() + rs.getString("region") + ", ");
        if(rs.getString("address") != null)
          service.setC7(service.getC7() + rs.getString("address"));
        //
        service.setC10("" + counter);
				service.setC11(rs.getString("type_name"));
        fio = rs.getString("fio");
        rows.add(service);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // ЭКГ амбулатория
  private void rep10(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<ObjList> rows = new ArrayList<ObjList>();
    //
		String cat = Util.get(req, "cat");
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    try {
      ps = conn.prepareStatement(
        "Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
          "         Date_Format(t.Result_Date, '%d.%m.%Y') cr_on, " +
          "         p.birthyear, " +
          "         u.fio doc, " +
          "         p.yearNum reg_num, " +
          "        (Select sex.Name From Sel_Opts sex WHERE sex.id = p.sex_id) Sex_Name, " +
          "         'Стац' type_name, " +
          "         p.Start_Diagnoz diagnoz, " +
          "         t.Result_Date " +
          " From Lv_Plans t, Kdos c, Patients p, Users u " +
          " Where t.Kdo_Id = c.id " +
          "   And t.patientId = p.id " +
          "   And c.id = 50 " + (cat != null && cat.equals("1") ? " And 1=0 " : "") +
          "   And u.id = p.lv_id " +
          "   And date (t.Result_Date) Between ? and ? " +
          " Union All " +
          " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
          "        p.BirthYear, " +
          "        u.fio doc, " +
          "        p.id reg_num, " +
          "        (Select sex.Name From Sel_Opts sex WHERE sex.id = p.sex) Sex_Name, " +
          "        'Амб' type_name, " +
          "        'Текшириш' diagnoz, " +
          "        t.confDate " +
          "   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p, Users u " +
          "  Where ser.Id = t.Service_Id " +
          "    And p.Id = t.Patient " +
          "    And u.id = t.worker_id " +
          "		 And ser.id in (44) " + (cat != null && cat.equals("2") ? " And 1=0 " : "") +
          " 	 And date(t.confDate) Between ? and ? " +
          " Order By 9 "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      ps.setString(3, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(4, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList service = new ObjList();
        service.setC1(rs.getString("fio"));
        service.setC2(rs.getString("sex_name"));
        service.setC3(rs.getString("BirthYear"));
        service.setC4(rs.getString("type_name"));
        service.setC5(rs.getString("reg_num"));
        service.setC6(rs.getString("diagnoz"));
        service.setC7(rs.getString("cr_on"));
        service.setC8(rs.getString("doc"));
        //
        rows.add(service);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Окулист амбулатория
  private void rep11(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<ObjList> rows = new ArrayList<ObjList>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    try {
      ps = conn.prepareStatement(
        " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "				 ser.Name Service_Name, " +
          "  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
          "        p.BirthYear, " +
          "        u.fio doc, " +
          "        p.id reg_num, " +
          "        (Select sex.Name From Sel_Opts sex WHERE sex.id = p.sex) Sex_Name, " +
          "        'Амб' type_name, " +
          "        t.diagnoz, " +
          "        t.confDate " +
          "   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p, Users u " +
          "  Where ser.Id = t.Service_Id " +
          "    And p.Id = t.Patient " +
          "    And u.id = t.worker_id " +
          "		 And ser.group_id = 5 " +
          " 	 And date (t.confDate) Between ? and ? " +
          "  Order By t.confDate "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList service = new ObjList();
        service.setC1(rs.getString("fio"));
        service.setC2(rs.getString("BirthYear"));
        service.setC3(rs.getString("cr_on"));
        service.setC4(rs.getString("service_name"));
        service.setC5(rs.getString("diagnoz"));
        //
        rows.add(service);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // УЗИ стационар
  private void rep12(HttpServletRequest req, Model m) {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<ObjList> rows = new ArrayList<ObjList>();
    //
		String cat = Util.get(req, "cat");
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    try {
      ps = conn.prepareStatement(
        "Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
          "         p.birthyear, " +
          "         p.yearNum reg_num, " +
          "         u.fio doc, " +
          "         Date_Format(t.Result_Date, '%d.%m.%Y') cr_on, " +
          "         f.c1 diagnoz, " +
          "         c.Name Service_Name, " +
          "         (Select cu.fio FROM Users cu Where cu.id = t.conf_user) diag_user " +
          " From Lv_Plans t, Kdos c, Patients p, Users u, F999 f  " +
          " Where t.Kdo_Id = c.id " +
          "   And t.patientId = p.id " +
          "   And f.plan_id = t.id" +
          "   And c.kdo_type = 4 " +
          "   And u.id = p.lv_id " + (cat.equals("") ? "" : " And c.id = " + cat) +
          "   And date (t.Result_Date) Between ? and ? " +
					"	 Order By p.id, t.Result_Date "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      Integer counter = 0;
			String fio = "";
      while (rs.next()) {
				if (!rs.getString("fio").equals(fio))
					counter++;
        ObjList service = new ObjList();
        service.setC1(rs.getString("fio"));
        service.setC2(rs.getString("BirthYear"));
        service.setC3(rs.getString("reg_num"));
        service.setC4(rs.getString("doc"));
        service.setC5(rs.getString("cr_on"));
        service.setC6(rs.getString("diagnoz"));
        service.setC7(rs.getString("service_name"));
        service.setC8(rs.getString("diag_user"));
				//
        service.setC10("" + counter);
				fio = rs.getString("fio");
        //
        rows.add(service);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Амб рег журнал
  private void rep13(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<ObjList> rows = new ArrayList<ObjList>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    try {
      ps = conn.prepareStatement(
        " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "				 Date_Format(p.crOn, '%d.%m.%Y %H:%i') cr_on, " +
          "        p.BirthYear, " +
          "        (Select sex.Name From Sel_Opts sex WHERE sex.id = p.sex) Sex_Name, " +
          "        (Select con.Name From counteries con WHERE con.id = p.counteryId) Country, " +
          "        (Select reg.Name From Regions reg WHERE reg.id = p.regionId) Region, " +
          "        p.Address, " +
          "        p.tel " +
          "   From Amb_Patients p " +
          "  Where date (p.crOn) Between ? and ? " +
          "  Order By p.crOn "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList service = new ObjList();
        service.setC1(rs.getString("cr_on"));
        service.setC2(rs.getString("fio"));
        service.setC3(rs.getString("BirthYear"));
        service.setC4("");
        if(rs.getString("country") != null)
          service.setC4(service.getC4() + rs.getString("country") + ", ");
        if(rs.getString("region") != null)
          service.setC4(service.getC4() + rs.getString("region") + ", ");
        if(rs.getString("address") != null)
          service.setC4(service.getC4() + rs.getString("address"));
        if(rs.getString("tel") != null)
          service.setC10(rs.getString("tel"));
        //
        rows.add(service);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Консультация (Стационар)
  private void rep14(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    Users user = dUser.get(SessionUtil.getUser(req).getUserId());
    List<ObjList> rows = new ArrayList<ObjList>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate) + "<br/>";
    params += "Консультация " + user.getProfil().toLowerCase() + "а. Врач: " + user.getFio();
    try {
      ps = conn.prepareStatement(
        "Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
          "         p.birthyear, " +
          "         p.yearNum reg_num, " +
          "         t.lvName doc, " +
          "         Date_Format(t.saveDate, '%d.%m.%Y %H:%i') cr_on, " +
          "         t.text diagnoz, " +
          "         u.fio lv, u.profil,  " +
          "         t.req " +
          " From Lv_Consuls t, Patients p, Users u " +
          " Where t.patientId = p.id " +
          "   And date (t.saveDate) Between ? and ? " +
          "   And u.id = t.lvid " +
        	"   And t.lvid = ? "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      ps.setInt(3, user.getId());
      //ps.setInt(3, SessionUtil.getUser(req).getUserId());
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList service = new ObjList();
        service.setC1(rs.getString("fio"));
        service.setC2(rs.getString("BirthYear"));
        service.setC3(rs.getString("reg_num"));
        service.setC4(rs.getString("doc"));
        service.setC5(rs.getString("cr_on"));
        service.setC6(rs.getString("diagnoz"));
        service.setC7(rs.getString("req"));
        //
        service.setC8("Консультация " + (rs.getString("profil") != null ? rs.getString("profil").toLowerCase() + "а" : ""));
        service.setC9(rs.getString("lv"));
        //
        rows.add(service);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Оториноларинголог (Амбулатория)
  private void rep15(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<Rep1>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<ObjList>();
    Rep1 r = new Rep1();
    try {
      ps = conn.prepareStatement(
				"Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
					"         c.Name Service_Name, " +
					"         Date_Format(t.Result_Date, '%d.%m.%Y') cr_on, " +
					"         p.birthyear, " +
					"         'Стац.' Type," +
					"         f.c1 diagnoz, " +
					"         t.result_date " +
					" From Lv_Plans t, Kdos c, Patients p, Users u, F999 f  " +
					" Where t.Kdo_Id = c.id " +
					"   And t.patientId = p.id " +
					"   And f.plan_id = t.id" +
					"   And c.kdo_type = 13 " +
					"   And u.id = p.lv_id " +
					"   And date (t.Result_Date) Between ? and ? " +
					" UNION ALL " +
        	" Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "				 ser.Name Service_Name, " +
          "  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
          "        p.birthyear, " +
          "				 'Амб' Type, " +
          "				 t.diagnoz, " +
          "        t.confDate reg_date " +
          "   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p " +
          "  Where ser.Id = t.Service_Id " +
          "    And p.Id = t.Patient " +
          "		 And ser.Group_Id = 4 " +
          " 	 And date (t.confDate) Between ? and ? "+
          " Order By 7 "
      );
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			ps.setString(3, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(4, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
      while (rs.next()) {
        ObjList service = new ObjList();
        service.setC1(rs.getString("fio"));
        service.setC2(rs.getString("service_name"));
        service.setC3(rs.getString("type"));
        service.setC4(rs.getString("cr_on"));
        service.setC5(rs.getString("birthyear"));
        service.setC6(rs.getString("diagnoz"));
        patients.add(service);
      }
      r.setServices(patients);
      if(r.getServices() != null && r.getServices().size() > 0)
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Биохимия (Стационар)
  private void rep16(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<Rep1>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<ObjList>();
    Rep1 r = new Rep1();
    try {
      ps = conn.prepareStatement(
        " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "  			 Date_Format(ser.result_date, '%d.%m.%Y') result_date, " +
          "        p.birthyear, " +
          "        t.* " +
          "   From F13 t, Lv_Plans ser, Patients p " +
          "  Where ser.Id = t.Plan_Id " +
          "    And p.Id = t.PatientId " +
          "    And ser.Done_Flag = 'Y' " +
          " 	 And date (ser.result_date) Between ? and ? "+
          " Order By ser.result_date "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList service = new ObjList();
        service.setC28(rs.getString("fio"));
        service.setC29(rs.getString("birthyear"));
        service.setC30(rs.getString("result_date"));

        service.setC1(rs.getString("c1"));
        service.setC2(rs.getString("c2"));
        service.setC3(rs.getString("c3"));
        service.setC4(rs.getString("c4"));
        service.setC5(rs.getString("c5"));
        service.setC6(rs.getString("c6"));
        service.setC7(rs.getString("c7"));
        service.setC8(rs.getString("c8"));
        service.setC9(rs.getString("c9"));
        service.setC10(rs.getString("c10"));
        service.setC11(rs.getString("c11"));
        service.setC12(rs.getString("c12"));
        service.setC13(rs.getString("c13"));
        service.setC14(rs.getString("c14"));
        service.setC15(rs.getString("c15"));
        service.setC16(rs.getString("c16"));
        service.setC17(rs.getString("c17"));
        service.setC18(rs.getString("c18"));
        service.setC19(rs.getString("c19"));
        service.setC20(rs.getString("c20"));
        service.setC21(rs.getString("c21"));
        service.setC22(rs.getString("c22"));
        service.setC23(rs.getString("c23"));
        service.setC24(rs.getString("c24"));
        service.setC25(rs.getString("c25"));
        service.setC26(rs.getString("c26"));
        service.setC27(rs.getString("c27"));

        patients.add(service);
      }
      r.setServices(patients);
      if(r.getServices() != null && r.getServices().size() > 0)
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Умумий кон тахлили (Стационар)
  private void rep17(HttpServletRequest req, Model m) {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<Rep1>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<ObjList>();
    Rep1 r = new Rep1();
    try {
      ps = conn.prepareStatement(
        " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "  			 Date_Format(ser.result_date, '%d.%m.%Y') result_date, " +
          "				 (Select dept.name From Depts dept Where dept.Id = p.Dept_Id) depName, " +
          "        p.birthyear, " +
          "        p.yearNum, " +
          "        t.* " +
          "   From F10 t, Lv_Plans ser, Patients p " +
          "  Where ser.Id = t.Plan_Id " +
          "    And p.Id = t.PatientId " +
          "    And ser.Done_Flag = 'Y' " +
          " 	 And date (ser.result_date) Between ? and ? "+
          " Order By ser.result_date "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList service = new ObjList();
        service.setDate(rs.getString("result_date"));
        service.setIb(rs.getString("yearnum"));
        service.setFio(rs.getString("fio"));
        service.setBirthyear(rs.getString("birthyear"));
        service.setC30(rs.getString("depName"));

        service.setC1(rs.getString("c1"));
        service.setC2(rs.getString("c2"));
        service.setC3(rs.getString("c3"));
        service.setC4(rs.getString("c4"));
        service.setC5(rs.getString("c5"));
        service.setC6(rs.getString("c6"));
        service.setC7(rs.getString("c7"));
        service.setC8(rs.getString("c8"));
        service.setC9(rs.getString("c9"));
        service.setC10(rs.getString("c10"));
        service.setC11(rs.getString("c11"));
        service.setC12(rs.getString("c12"));
        service.setC13(rs.getString("c13"));
        service.setC14(rs.getString("c14"));
        service.setC15(rs.getString("c15"));
        service.setC16(rs.getString("c16"));
        service.setC17(rs.getString("c17"));
        service.setC18(rs.getString("c18"));
        service.setC19(rs.getString("c19"));
        service.setC20(rs.getString("c11"));
        service.setC21(rs.getString("c21"));
        service.setC22(rs.getString("c22"));
        service.setC23(rs.getString("c23"));
        service.setC24(rs.getString("c24"));
        service.setC25(rs.getString("c25"));
        service.setC26(rs.getString("c26"));
        service.setC27(rs.getString("c27"));
        service.setC28(rs.getString("c28"));
        service.setC29(rs.getString("c29"));

        patients.add(service);
      }
      r.setServices(patients);
      if(r.getServices() != null && r.getServices().size() > 0)
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Консультация (Стационар)
  private void rep18(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<ObjList> rows = new ArrayList<ObjList>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    try {
      String doctor = req.getParameter("doctor");
      ps = conn.prepareStatement(
        "Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
          "         p.birthyear, " +
          "         p.yearNum reg_num, " +
          "         t.lvName doc, " +
          "         t.date cr_on, " +
          "         t.text diagnoz, " +
          "         u.fio lv, u.profil,  " +
          "         t.req " +
          " From Lv_Consuls t, Patients p, Users u " +
          " Where t.patientId = p.id " +
          "   And u.id = t.lvid " +
          "   And date(t.saveDate) Between ? and ? " +
          ("".equals(doctor) ? "" : " And lvid = " + doctor)
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList service = new ObjList();
        service.setC1(rs.getString("fio"));
        service.setC2(rs.getString("BirthYear"));
        service.setC3(rs.getString("reg_num"));
        service.setC4(rs.getString("doc"));
        service.setC5(rs.getString("cr_on"));
        service.setC6(rs.getString("diagnoz"));
        service.setC7(rs.getString("req"));
        //
        service.setC8("Консультация " + (rs.getString("profil") != null ? rs.getString("profil").toLowerCase() + "а" : ""));
        service.setC9(rs.getString("lv"));
        //
        rows.add(service);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Пешобда суткалик канд микдорини аниклаш
  private void rep19(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<Rep1>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<ObjList>();
    Rep1 r = new Rep1();
    try {
      ps = conn.prepareStatement(
        " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "  			 Date_Format(ser.result_date, '%d.%m.%Y') result_date, " +
          "				 (Select dept.name From Depts dept Where dept.Id = p.Dept_Id) depName, " +
          "        p.birthyear, " +
          "        p.yearNum, " +
          "        t.* " +
          "   From F152 t, Lv_Plans ser, Patients p " +
          "  Where ser.Id = t.Plan_Id " +
          "    And p.Id = t.PatientId " +
          "    And ser.Done_Flag = 'Y' " +
          " 	 And date (ser.result_date) Between ? and ? "+
          " Order By ser.result_date "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList service = new ObjList();
        service.setDate(rs.getString("result_date"));
        service.setIb(rs.getString("yearnum"));
        service.setFio(rs.getString("fio"));
        service.setBirthyear(rs.getString("birthyear"));
        service.setC30(rs.getString("depName"));

        service.setC1(rs.getString("c1"));
        service.setC2(rs.getString("c2"));
        service.setC3(rs.getString("c3"));

        patients.add(service);
      }
      r.setServices(patients);
      if(r.getServices() != null && r.getServices().size() > 0)
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Анти - ТРО
  private void rep20(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<Rep1>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<ObjList>();
    Rep1 r = new Rep1();
    try {
      ps = conn.prepareStatement(
        " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "  			 Date_Format(ser.result_date, '%d.%m.%Y') result_date, " +
          "				 (Select dept.name From Depts dept Where dept.Id = p.Dept_Id) depName, " +
          "        p.birthyear, " +
          "        p.yearNum, " +
          "        t.* " +
          "   From F999 t, Lv_Plans ser, Patients p " +
          "  Where ser.Id = t.Plan_Id " +
          "    And p.Id = t.PatientId " +
          "    And ser.Kdo_Id = 155 " +
          "    And ser.Done_Flag = 'Y' " +
          " 	 And date (ser.result_date) Between ? and ? "+
          " Order By ser.result_date "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList service = new ObjList();
        service.setDate(rs.getString("result_date"));
        service.setIb(rs.getString("yearnum"));
        service.setFio(rs.getString("fio"));
        service.setBirthyear(rs.getString("birthyear"));
        service.setC30(rs.getString("depName"));

        service.setC1(rs.getString("c1"));
        service.setC2(rs.getString("c2"));

        patients.add(service);
      }
      r.setServices(patients);
      if(r.getServices() != null && r.getServices().size() > 0)
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Кондаги гормонларни текшириш
  private void rep21(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<Rep1>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<ObjList>();
    Rep1 r = new Rep1();
    try {
      ps = conn.prepareStatement(
        " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "  			 Date_Format(ser.result_date, '%d.%m.%Y') result_date, " +
          "				 (Select dept.name From Depts dept Where dept.Id = p.Dept_Id) depName, " +
          "        p.birthyear, " +
          "        p.yearNum, " +
          "        t.* " +
          "   From F120 t, Lv_Plans ser, Patients p " +
          "  Where ser.Id = t.Plan_Id " +
          "    And p.Id = t.PatientId " +
          "    And ser.Done_Flag = 'Y' " +
          " 	 And date (ser.result_date) Between ? and ? "+
          " Order By ser.result_date "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList service = new ObjList();
        service.setDate(rs.getString("result_date"));
        service.setIb(rs.getString("yearnum"));
        service.setFio(rs.getString("fio"));
        service.setBirthyear(rs.getString("birthyear"));
        service.setC30(rs.getString("depName"));

        service.setC1(rs.getString("c1"));
        service.setC2(rs.getString("c2"));
        service.setC3(rs.getString("c3"));
        service.setC4(rs.getString("c4"));

        patients.add(service);
      }
      r.setServices(patients);
      if(r.getServices() != null && r.getServices().size() > 0)
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // TORCH инфекцияси текшируви
  private void rep22(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<Rep1>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<ObjList>();
    Rep1 r = new Rep1();
    try {
      ps = conn.prepareStatement(
        " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "  			 Date_Format(ser.result_date, '%d.%m.%Y') result_date, " +
          "				 (Select dept.name From Depts dept Where dept.Id = p.Dept_Id) depName, " +
          "        p.birthyear, " +
          "        p.yearNum, " +
          "        t.* " +
          "   From F121 t, Lv_Plans ser, Patients p " +
          "  Where ser.Id = t.Plan_Id " +
          "    And p.Id = t.PatientId " +
          "    And ser.Done_Flag = 'Y' " +
          " 	 And date (ser.result_date) Between ? and ? "+
          " Order By ser.result_date "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList service = new ObjList();
        service.setDate(rs.getString("result_date"));
        service.setIb(rs.getString("yearnum"));
        service.setFio(rs.getString("fio"));
        service.setBirthyear(rs.getString("birthyear"));
        service.setC30(rs.getString("depName"));

        service.setC1(rs.getString("c1"));
        service.setC2(rs.getString("c2"));
        service.setC3(rs.getString("c3"));
        service.setC4(rs.getString("c4"));

        patients.add(service);
      }
      r.setServices(patients);
      if(r.getServices() != null && r.getServices().size() > 0)
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Умумий пешоб тахлили
  private void rep23(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<Rep1>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<ObjList>();
    Rep1 r = new Rep1();
    try {
      ps = conn.prepareStatement(
        " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "  			 Date_Format(ser.result_date, '%d.%m.%Y') result_date, " +
          "				 (Select dept.name From Depts dept Where dept.Id = p.Dept_Id) depName, " +
          "        p.birthyear, " +
          "        p.yearNum, " +
          "        t.* " +
          "   From F6 t, Lv_Plans ser, Patients p " +
          "  Where ser.Id = t.Plan_Id " +
          "    And p.Id = t.PatientId " +
          "    And ser.Done_Flag = 'Y' " +
          " 	 And date (ser.result_date) Between ? and ? "+
          " Order By ser.result_date "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList service = new ObjList();
        service.setDate(rs.getString("result_date"));
        service.setIb(rs.getString("yearnum"));
        service.setFio(rs.getString("fio"));
        service.setBirthyear(rs.getString("birthyear"));
        service.setC30(rs.getString("depName"));

        service.setC1(rs.getString("c1"));
        service.setC2(rs.getString("c2"));
        service.setC3(rs.getString("c3"));
        service.setC4(rs.getString("c4"));
        service.setC5(rs.getString("c5"));
        service.setC6(rs.getString("c6"));
        service.setC7(rs.getString("c7"));
        service.setC8(rs.getString("c8"));
        service.setC9(rs.getString("c9"));
        service.setC10(rs.getString("c10"));
        service.setC11(rs.getString("c11"));
        service.setC12(rs.getString("c12"));
        service.setC13(rs.getString("c13"));
        service.setC14(rs.getString("c14"));
        service.setC15(rs.getString("c15"));
        service.setC16(rs.getString("c16"));
        service.setC17(rs.getString("c17"));

        patients.add(service);
      }
      r.setServices(patients);
      if(r.getServices() != null && r.getServices().size() > 0)
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Коагулограмма
  private void rep24(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<Rep1>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<ObjList>();
    Rep1 r = new Rep1();
    try {
      ps = conn.prepareStatement(
        " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "  			 Date_Format(ser.result_date, '%d.%m.%Y') result_date, " +
          "				 (Select dept.name From Depts dept Where dept.Id = p.Dept_Id) depName, " +
          "        p.birthyear, " +
          "        p.yearNum, " +
          "        t.* " +
          "   From F56 t, Lv_Plans ser, Patients p " +
          "  Where ser.Id = t.Plan_Id " +
          "    And p.Id = t.PatientId " +
          "    And ser.Done_Flag = 'Y' " +
          " 	 And date (ser.result_date) Between ? and ? "+
          " Order By ser.result_date "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList service = new ObjList();
        service.setDate(rs.getString("result_date"));
        service.setIb(rs.getString("yearnum"));
        service.setFio(rs.getString("fio"));
        service.setBirthyear(rs.getString("birthyear"));
        service.setC30(rs.getString("depName"));

        service.setC1(rs.getString("c1"));
        service.setC2(rs.getString("c2"));
        service.setC3(rs.getString("c3"));
        service.setC4(rs.getString("c4"));
        service.setC5(rs.getString("c5"));
        service.setC6(rs.getString("c6"));

        patients.add(service);
      }
      r.setServices(patients);
      if(r.getServices() != null && r.getServices().size() > 0)
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Гликимик профил
  private void rep25(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<Rep1>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<ObjList>();
    Rep1 r = new Rep1();
    try {
      ps = conn.prepareStatement(
        " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "  			 Date_Format(ser.result_date, '%d.%m.%Y') result_date, " +
          "				 (Select dept.name From Depts dept Where dept.Id = p.Dept_Id) depName, " +
          "        p.birthyear, " +
          "        p.yearNum, " +
          "        t.* " +
          "   From F17 t, Lv_Plans ser, Patients p " +
          "  Where ser.Id = t.Plan_Id " +
          "    And p.Id = t.PatientId " +
          "    And ser.Done_Flag = 'Y' " +
          " 	 And date (ser.result_date) Between ? and ? "+
          " Order By ser.result_date "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList service = new ObjList();
        service.setDate(rs.getString("result_date"));
        service.setIb(rs.getString("yearnum"));
        service.setFio(rs.getString("fio"));
        service.setBirthyear(rs.getString("birthyear"));
        service.setC30(rs.getString("depName"));

        service.setC1(rs.getString("c1"));
        service.setC2(rs.getString("c2"));
        service.setC3(rs.getString("c3"));

        patients.add(service);
      }
      r.setServices(patients);
      if(r.getServices() != null && r.getServices().size() > 0)
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Ничепоренко буйича пешоб тахлили
  private void rep26(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<Rep1>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<ObjList>();
    Rep1 r = new Rep1();
    try {
      ps = conn.prepareStatement(
        " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "  			 Date_Format(ser.result_date, '%d.%m.%Y') result_date, " +
          "				 (Select dept.name From Depts dept Where dept.Id = p.Dept_Id) depName, " +
          "        p.birthyear, " +
          "        p.yearNum, " +
          "        t.* " +
          "   From F11 t, Lv_Plans ser, Patients p " +
          "  Where ser.Id = t.Plan_Id " +
          "    And p.Id = t.PatientId " +
          "    And ser.Done_Flag = 'Y' " +
          " 	 And date (ser.result_date) Between ? and ? "+
          " Order By ser.result_date "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList service = new ObjList();
        service.setDate(rs.getString("result_date"));
        service.setIb(rs.getString("yearnum"));
        service.setFio(rs.getString("fio"));
        service.setBirthyear(rs.getString("birthyear"));
        service.setC30(rs.getString("depName"));

        service.setC1(rs.getString("c1"));
        service.setC2(rs.getString("c2"));
        service.setC3(rs.getString("c3"));
        service.setC4(rs.getString("c4"));

        patients.add(service);
      }
      r.setServices(patients);
      if(r.getServices() != null && r.getServices().size() > 0)
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Зимницкий буйича пешоб тахлили
  private void rep27(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<Rep1>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<ObjList>();
    Rep1 r = new Rep1();
    try {
      ps = conn.prepareStatement(
        " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "  			 Date_Format(ser.result_date, '%d.%m.%Y') result_date, " +
          "				 (Select dept.name From Depts dept Where dept.Id = p.Dept_Id) depName, " +
          "        p.birthyear, " +
          "        p.yearNum, " +
          "        t.* " +
          "   From F8 t, Lv_Plans ser, Patients p " +
          "  Where ser.Id = t.Plan_Id " +
          "    And p.Id = t.PatientId " +
          "    And ser.Done_Flag = 'Y' " +
          " 	 And date (ser.result_date) Between ? and ? "+
          " Order By ser.result_date "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList service = new ObjList();
        service.setDate(rs.getString("result_date"));
        service.setIb(rs.getString("yearnum"));
        service.setFio(rs.getString("fio"));
        service.setBirthyear(rs.getString("birthyear"));
        service.setC30(rs.getString("depName"));

        service.setC1(rs.getString("c1"));
        service.setC2(rs.getString("c2"));
        service.setC3(rs.getString("c3"));
        service.setC4(rs.getString("c4"));
        service.setC5(rs.getString("c5"));
        service.setC6(rs.getString("c6"));
        service.setC7(rs.getString("c7"));
        service.setC8(rs.getString("c8"));
        service.setC9(rs.getString("c9"));
        service.setC10(rs.getString("c10"));
        service.setC11(rs.getString("c11"));
        service.setC12(rs.getString("c12"));
        service.setC13(rs.getString("c13"));
        service.setC14(rs.getString("c14"));
        service.setC15(rs.getString("c15"));
        service.setC16(rs.getString("c16"));
        service.setC17(rs.getString("c17"));
        service.setC18(rs.getString("c18"));

        patients.add(service);
      }
      r.setServices(patients);
      if(r.getServices() != null && r.getServices().size() > 0)
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Кон зардобида липопротеидлар тахлили
  private void rep28(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<Rep1>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<ObjList>();
    Rep1 r = new Rep1();
    try {
      ps = conn.prepareStatement(
        " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "  			 Date_Format(ser.result_date, '%d.%m.%Y') result_date, " +
          "				 (Select dept.name From Depts dept Where dept.Id = p.Dept_Id) depName, " +
          "        p.birthyear, " +
          "        p.yearNum, " +
          "        t.* " +
          "   From F16 t, Lv_Plans ser, Patients p " +
          "  Where ser.Id = t.Plan_Id " +
          "    And p.Id = t.PatientId " +
          "    And ser.Done_Flag = 'Y' " +
          " 	 And date (ser.result_date) Between ? and ? "+
          " Order By ser.result_date "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList service = new ObjList();
        service.setDate(rs.getString("result_date"));
        service.setIb(rs.getString("yearnum"));
        service.setFio(rs.getString("fio"));
        service.setBirthyear(rs.getString("birthyear"));
        service.setC30(rs.getString("depName"));

        service.setC1(rs.getString("c1"));
        service.setC2(rs.getString("c2"));
        service.setC3(rs.getString("c3"));
        service.setC4(rs.getString("c4"));
        service.setC5(rs.getString("c5"));
				service.setC6(rs.getString("c6"));
				service.setC7(rs.getString("c7"));

        patients.add(service);
      }
      r.setServices(patients);
      if(r.getServices() != null && r.getServices().size() > 0)
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Окулист муолажалари (Стац, Амб)
  private void rep29(HttpServletRequest req, Model m) {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<ObjList> rows = new ArrayList<ObjList>();
    //
		String cat = Util.get(req, "cat");
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    try {
      ps = conn.prepareStatement(
        "Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
          "         p.birthyear, " +
          "         Date_Format(t.Result_Date, '%d.%m.%Y') cr_on, " +
          "         f.c1 diagnoz, " +
          "         c.Name Service_Name, " +
          "         'Стац.' service_Type," +
          "         t.result_date " +
          " From Lv_Plans t, Kdos c, Patients p, Users u, F999 f  " +
          " Where t.Kdo_Id = c.id " +
          "   And t.patientId = p.id " +
          "   And f.plan_id = t.id" +
          "   And c.kdo_type = 14 " + (cat != null && cat.equals("1") ? " And 1=0 " : "") +
          "   And u.id = p.lv_id " +
          "   And date (t.Result_Date) Between ? and ? " +
          " UNION ALL " +
          " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "        p.birthyear, " +
          "  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
          "        t.diagnoz, " +
          "				 ser.Name Service_Name, " +
          "				 'Амб' Service_Type, " +
          "        t.confDate " +
          "   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p " +
          "  Where ser.Id = t.Service_Id " +
          "    And p.Id = t.Patient " +
          "		 And ser.Group_Id = 5 " + (cat != null && cat.equals("2") ? " And 1=0 " : "") +
          " 	 And date (t.confDate) Between ? and ? "+
          " Order By 7 "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      ps.setString(3, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(4, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      int counter = 0; String fio = "";
      while (rs.next()) {
        if (!rs.getString("fio").equals(fio))
          counter++;
        ObjList service = new ObjList();
        service.setFio(rs.getString("fio"));
        service.setBirthyear(rs.getString("BirthYear"));
        service.setDate(rs.getString("cr_on"));
        //
        service.setC1(rs.getString("diagnoz"));
        service.setC2(rs.getString("service_name"));
        service.setC3(rs.getString("service_Type"));
        //
        service.setC4("" + counter);
        fio = rs.getString("fio");
        //
        rows.add(service);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // ЛОР муолажалари (Стац, Амб)
  private void rep30(HttpServletRequest req, Model m) {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<ObjList> rows = new ArrayList<ObjList>();
    //
		String cat = Util.get(req, "cat");
		String catStat = Util.get(req, "cat_stat");
		String catAmb = Util.get(req, "cat_amb");
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    try {
      ps = conn.prepareStatement(
        "Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
          "         p.birthyear, " +
          "         Date_Format(t.Result_Date, '%d.%m.%Y') cr_on, " +
          "         f.c1 diagnoz, " +
          "         c.Name Service_Name, " +
          "         'Стац.' service_Type," +
          "         t.result_date " +
          " From Lv_Plans t, Kdos c, Patients p, Users u, F999 f  " +
          " Where t.Kdo_Id = c.id " +
          "   And t.patientId = p.id " +
          "   And f.plan_id = t.id" + (catStat.equals("") ? "" : " And c.id = " + catStat) +
          "   And c.kdo_type = 13 " + (cat != null && cat.equals("1") ? " And 1=0 " : "") +
          "   And u.id = p.lv_id " +
          "   And date (t.Result_Date) Between ? and ? " +
          " UNION ALL " +
          " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "        p.birthyear, " +
          "  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
          "        t.diagnoz, " +
          "				 ser.Name Service_Name, " +
          "				 'Амб' Service_Type, " +
          "        t.confDate " +
          "   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p " +
          "  Where ser.Id = t.Service_Id " +
          "    And p.Id = t.Patient " + (catAmb.equals("") ? "" : " And ser.id = " + catAmb) +
          "		 And ser.Group_Id = 4 " + (cat != null && cat.equals("2") ? " And 1=0 " : "") +
          " 	 And date (t.confDate) Between ? and ? "+
          " Order By 7 "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      ps.setString(3, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(4, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      int counter = 0; String fio = "";
      while (rs.next()) {
        if (!rs.getString("fio").equals(fio))
          counter++;
        ObjList service = new ObjList();
        service.setFio(rs.getString("fio"));
        service.setBirthyear(rs.getString("BirthYear"));
        service.setDate(rs.getString("cr_on"));
        //
        service.setC1(rs.getString("diagnoz"));
        service.setC2(rs.getString("service_name"));
        service.setC3(rs.getString("service_Type"));
        //
        service.setC4("" + counter);
        fio = rs.getString("fio");
        //
        rows.add(service);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Холтер муолажалари (Стац, Амб)
  private void rep31(HttpServletRequest req, Model m) {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<ObjList> rows = new ArrayList<ObjList>();
    //
		String cat = Util.get(req, "cat");
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    try {
      ps = conn.prepareStatement(
        "Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
          "         p.birthyear, " +
          "         Date_Format(t.Result_Date, '%d.%m.%Y') cr_on, " +
          "         f.c1 diagnoz, " +
          "         c.Name Service_Name, " +
          "         'Стац.' service_Type," +
          "         t.result_date " +
          " From Lv_Plans t, Kdos c, Patients p, Users u, F999 f  " +
          " Where t.Kdo_Id = c.id " +
          "   And t.patientId = p.id " +
          "   And f.plan_id = t.id" +
          "   And c.kdo_type = 11 " + (cat != null && cat.equals("1") ? " And 1=0 " : "") +
          "   And u.id = p.lv_id " +
          "   And date (t.Result_Date) Between ? and ? " +
          " UNION ALL " +
          " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "        p.birthyear, " +
          "  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
          "        t.diagnoz, " +
          "				 ser.Name Service_Name, " +
          "				 'Амб' Service_Type, " +
          "        t.confDate " +
          "   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p " +
          "  Where ser.Id = t.Service_Id " +
          "    And p.Id = t.Patient " +
          "		 And ser.id = 32 " + (cat != null && cat.equals("2") ? " And 1=0 " : "") +
          " 	 And date (t.confDate) Between ? and ? "+
          " Order By 7 "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      ps.setString(3, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(4, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      int counter = 0; String fio = "";
      while (rs.next()) {
        if (!rs.getString("fio").equals(fio))
          counter++;
        ObjList service = new ObjList();
        service.setFio(rs.getString("fio"));
        service.setBirthyear(rs.getString("BirthYear"));
        service.setDate(rs.getString("cr_on"));
        //
        service.setC1(rs.getString("diagnoz"));
        service.setC2(rs.getString("service_name"));
        service.setC3(rs.getString("service_Type"));
        //
        service.setC4("" + counter);
        fio = rs.getString("fio");
        //
        rows.add(service);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Консультация (Амбулатория)
  private void rep32(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
		Users user = dUser.get(SessionUtil.getUser(req).getUserId());
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
		params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate) + "<br/>";
		params += "Консультация " + user.getProfil().toLowerCase() + "а. Врач: " + user.getFio();
    List<ObjList> rows = new ArrayList<ObjList>();
    try {
      ps = conn.prepareStatement(
        " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "				 ser.Name Service_Name, " +
          "  			 Date_Format(t.confDate, '%d.%m.%Y %H:%i') cr_on, " +
          "        p.birthyear, " +
          "        (Select con.Name From counteries con WHERE con.id = p.counteryId) Country, " +
          "        (Select reg.Name From Regions reg WHERE reg.id = p.regionId) Region, " +
          "        (Select u.fio FROM Users u where u.id = t.worker_id) lv_fio, " +
          "        p.Address, " +
          "        p.tel, " +
          "				 t.diagnoz " +
          "   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p " +
          "  Where ser.Id = t.Service_Id " +
          "    And p.Id = t.Patient " +
          "    And ser.consul = 'Y'" +
          " 	 And date (t.confDate) Between ? and ? "+
          "    And t.worker_id = ?" +
          " Order By t.confDate "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      ps.setInt(3, user.getId());
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList service = new ObjList();
        //
        service.setFio(rs.getString("fio"));
        service.setBirthyear(rs.getString("birthyear"));
        service.setDate(rs.getString("cr_on"));
        service.setC1(rs.getString("service_name"));
        service.setC2("");
        if(rs.getString("country") != null)
          service.setC2(service.getC2() + rs.getString("country") + ", ");
        if(rs.getString("region") != null)
          service.setC2(service.getC2() + rs.getString("region") + ", ");
        if(rs.getString("address") != null)
          service.setC2(service.getC2() + rs.getString("address"));
        service.setC2("".equals(service.getC2()) ? rs.getString("tel") : service.getC2() + " " + rs.getString("tel"));
        service.setC3(rs.getString("lv_fio"));
        service.setC4(rs.getString("diagnoz"));
        //
        rows.add(service);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
  // Все консультации (Амбулатория)
  private void rep33(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    //
		String cat = Util.get(req, "cat");
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    String doctor = req.getParameter("doctor");
    params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> rows = new ArrayList<ObjList>();
    try {
      ps = conn.prepareStatement(
        " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "				 ser.Name Service_Name, " +
          "  			 Date_Format(t.confDate, '%d.%m.%Y %H:%i') cr_on, " +
          "        p.birthyear, " +
          "        (Select con.Name From counteries con WHERE con.id = p.counteryId) Country, " +
          "        (Select reg.Name From Regions reg WHERE reg.id = p.regionId) Region, " +
          "        (Select u.fio FROM Users u where u.id = t.worker_id) lv_fio, " +
          "        p.Address, " +
          "        p.tel, " +
          "				 t.diagnoz " +
          "   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p " +
          "  Where ser.Id = t.Service_Id " +
          "    And p.Id = t.Patient " +
          "    And ser.consul = 'Y'" + (cat.equals("") ? "" : " And ser.id = " + cat) +
          " 	 And date (t.confDate) Between ? and ? " +
          ("".equals(doctor) ? "" : " And t.worker_id = " + doctor) +
          " Order By t.confDate "
      );
      ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
      ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList service = new ObjList();
        //
        service.setFio(rs.getString("fio"));
        service.setBirthyear(rs.getString("birthyear"));
        service.setDate(rs.getString("cr_on"));
        service.setC1(rs.getString("service_name"));
        service.setC2("");
        if(rs.getString("country") != null)
          service.setC2(service.getC2() + rs.getString("country") + ", ");
        if(rs.getString("region") != null)
          service.setC2(service.getC2() + rs.getString("region") + ", ");
        if(rs.getString("address") != null)
          service.setC2(service.getC2() + rs.getString("address"));
        service.setC2("".equals(service.getC2()) ? rs.getString("tel") : service.getC2() + " " + rs.getString("tel"));
        service.setC3(rs.getString("lv_fio"));
        service.setC4(rs.getString("diagnoz"));
        //
        rows.add(service);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // Параметры отчета
    m.addAttribute("params", params);
  }
	// Физиотерапия муолажалари (Стац, Амб)
	private void rep34(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<ObjList> rows = new ArrayList<ObjList>();
		//
		String cat = Util.get(req, "cat");
		String catStat = Util.get(req, "cat_stat");
		String catAmb = Util.get(req, "cat_amb");
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		try {
			ps = conn.prepareStatement(
				"Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
					"         p.birthyear, " +
					"         Date_Format(t.actDate, '%d.%m.%Y') cr_on, " +
					"         c.Name Service_Name, " +
					"         'Стац.' service_Type," +
					"         t.actDate " +
					" From Lv_Fizios t, Kdos c, Patients p, Users u  " +
					" Where t.Kdo_Id = c.id " +
					"   And t.patientId = p.id " + (catStat.equals("") ? "" : " And c.id = " + catStat) +
					"   And c.kdo_type = 8 " + (cat != null && cat.equals("1") ? " And 1=0 " : "") +
					"   And u.id = p.lv_id " +
					"   And date (t.actDate) Between ? and ? " +
					" UNION ALL " +
					" Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
					"        p.birthyear, " +
					"  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
					"        ser.Name Service_Name, " +
					"				 'Амб' Service_Type, " +
					"        t.confDate " +
					"   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p " +
					"  Where ser.Id = t.Service_Id " +
					"    And p.Id = t.Patient " + (catAmb.equals("") ? "" : " And ser.id = " + catAmb) +
					"		 And ser.Group_Id in (6, 7) " + (cat != null && cat.equals("2") ? " And 1=0 " : "") +
					" 	 And date (t.confDate) Between ? and ? "+
					" Order By 6 "
			);
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			ps.setString(3, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(4, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			int counter = 0; String fio = "";
			while (rs.next()) {
				if (!rs.getString("fio").equals(fio))
					counter++;
				ObjList service = new ObjList();
				service.setFio(rs.getString("fio"));
				service.setBirthyear(rs.getString("BirthYear"));
				service.setDate(rs.getString("cr_on"));
				//
				service.setC2(rs.getString("service_name"));
				service.setC3(rs.getString("service_Type"));
				//
				service.setC4("" + counter);
				fio = rs.getString("fio");
				//
				rows.add(service);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Детализация Кассы
	private void rep35(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<ObjList> rows = new ArrayList<ObjList>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "за период " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate) + " по типу " + (Util.get(req, "type").equals("amb") ? "Амбулатория" : "Стационар");
		try {
			if(Util.get(req, "type").equals("amb")) {
				ps = conn.prepareStatement(
					" Select Concat(c.surname, ' ',  c.name, ' ', c.middlename) Fio, " +
						"  			 Date_Format(t.crOn, '%d.%m.%Y') cr_on, " +
						"        c.birthyear, " +
						" 			 t.cash, " +
						" 			 t.transfer, " +
						" 			 t.card " +
						"   From Amb_Patient_Pays t, Amb_Patients c " +
						"  Where t.crOn between ? and ? " +
						"	   And t.patient = c.id " +
						"	 Order By t.crOn "
				);
				ps.setString(1, Util.dateDBBegin(Util.get(req, "period_start")));
				ps.setString(2, Util.dateDBEnd(Util.get(req, "period_end")));
				rs = ps.executeQuery();
				Double card = 0D, cash = 0D, transfer = 0D;
				int counter = 0;
				while (rs.next()) {
					ObjList obj = new ObjList();
					obj.setC10("" + ++counter);
					obj.setFio(rs.getString("fio"));
					obj.setDate(rs.getString("cr_on"));
					obj.setBirthyear(rs.getString("birthyear"));
					obj.setC1(rs.getString("card"));
					obj.setC2(rs.getString("cash"));
					obj.setC3(rs.getString("transfer"));
					card += rs.getDouble("card");
					cash += rs.getDouble("cash");
					transfer += rs.getDouble("transfer");
					obj.setC4((rs.getDouble("card") + rs.getDouble("cash") + rs.getDouble("transfer")) + "");
					rows.add(obj);
				}
				//
				ObjList obj = new ObjList();
				obj.setFio("ИТОГО");
				obj.setC1(card + "");
				obj.setC2(cash + "");
				obj.setC3(transfer + "");
				obj.setC4((card + cash + transfer) + "");
				rows.add(obj);
				//
			}
			if(Util.get(req, "type").equals("stat")) {
				ps = conn.prepareStatement(
					" Select Concat(Max(t.surname), ' ',  Max(t.name), ' ', Max(t.middlename)) Fio, " +
						"  			 Date_Format(p.crOn, '%d.%m.%Y') cr_on, " +
						"        Max(t.birthyear) birthyear, " +
						" 			 Sum(p.cash) cash, " +
						" 			 Sum(p.transfer) transfer, " +
						" 			 Sum(p.card) card " +
						"   From Patients t, Patient_Pays p " +
						"  Where p.crOn between ? and ? " +
						"		 And p.patient_id = t.id " +
						"  Group By t.id, p.crOn "
				);
				ps.setString(1, Util.dateDBBegin(Util.get(req, "period_start")));
				ps.setString(2, Util.dateDBEnd(Util.get(req, "period_end")));
				rs = ps.executeQuery();
				Double card = 0D, cash = 0D, transfer = 0D;
				int counter = 0;
				while (rs.next()) {
					ObjList obj = new ObjList();
					obj.setC10("" + ++counter);
					obj.setFio(rs.getString("fio"));
					obj.setDate(rs.getString("cr_on"));
					obj.setBirthyear(rs.getString("birthyear"));
					obj.setC1(rs.getString("card"));
					obj.setC2(rs.getString("cash"));
					obj.setC3(rs.getString("transfer"));
					card += rs.getDouble("card");
					cash += rs.getDouble("cash");
					transfer += rs.getDouble("transfer");
					obj.setC4((rs.getDouble("card") + rs.getDouble("cash") + rs.getDouble("transfer")) + "");
					rows.add(obj);
				}
				//
				ObjList obj = new ObjList();
				obj.setFio("ИТОГО");
				obj.setC1(card + "");
				obj.setC2(cash + "");
				obj.setC3(transfer + "");
				obj.setC4((card + cash + transfer) + "");
				rows.add(obj);
				//
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Биохимия (Амбулатория)
	private void rep36(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<ObjList>();
		try {
			Integer[] ids = {47, 54, 4, 45, 46, 52, 50, 51, 53, 48, 49, 134, 135, 136, 137, 138, 139, 5, 60, 58, 59, 65, 61, 63};
			String query = "Select t.patient, t.fio, t.birthyear, Date_Format(t.confDate, '%d.%m.%Y') date, t.service_id, t.result1, t.result2 From (";
			String subquery = "Select t.patient, Concat(p.surname, ' ', p.name, ' ', p.middlename) fio, p.birthyear, t.confDate, t.service_Id, r.c1 result1, r.c2 result2 From Amb_Patients p, Amb_Patient_Services t, Amb_Results r Where r.Id = t.result And date(t.confDate) between '@1' And '@2' And t.patient = p.id And t.Service_Id = @id ";
			int k = 0;
			for(Integer id: ids) {
				k++;
				query += subquery.replace("@id", "" + id).replace("@1", Util.dateDB(Util.get(req, "period_start"))).replace("@2", Util.dateDB(Util.get(req, "period_end")));
				if(k != ids.length)
					query += " Union All ";
			}
			query += ") t Order By t.confDate";
			ps = conn.prepareStatement(query);
			rs = ps.executeQuery();
			List<String> patIds = new ArrayList<String>();
			while (rs.next()) {
				if(patIds.contains(rs.getInt("patient") + rs.getString("date"))) {
					ObjList obj = rows.get(patIds.indexOf(rs.getInt("patient") + rs.getString("date")));
					if(rs.getInt("service_id") == 47 ) obj.setC1(rs.getString("result1"));
					if(rs.getInt("service_id") == 54 ) obj.setC2(rs.getString("result1"));
					if(rs.getInt("service_id") == 4  ) obj.setC3(rs.getString("result1"));
					if(rs.getInt("service_id") == 45 ) obj.setC4(rs.getString("result1"));
					if(rs.getInt("service_id") == 46 ) obj.setC5(rs.getString("result1"));
					if(rs.getInt("service_id") == 52 ) { obj.setC6(rs.getString("result1")); obj.setC7(rs.getString("result2")); }
					if(rs.getInt("service_id") == 50 ) obj.setC8(rs.getString("result1"));
					if(rs.getInt("service_id") == 51 ) obj.setC9(rs.getString("result1"));
					if(rs.getInt("service_id") == 53 ) obj.setC10(rs.getString("result1"));
					if(rs.getInt("service_id") == 48 ) obj.setC11(rs.getString("result1"));
					if(rs.getInt("service_id") == 49 ) obj.setC12(rs.getString("result1"));
					if(rs.getInt("service_id") == 134) obj.setC13(rs.getString("result1"));
					if(rs.getInt("service_id") == 135) obj.setC14(rs.getString("result1"));
					if(rs.getInt("service_id") == 136) obj.setC15(rs.getString("result1"));
					if(rs.getInt("service_id") == 137) obj.setC16(rs.getString("result1"));
					if(rs.getInt("service_id") == 138) obj.setC17(rs.getString("result1"));
					if(rs.getInt("service_id") == 139) obj.setC18(rs.getString("result1"));
					if(rs.getInt("service_id") == 5  ) obj.setC19(rs.getString("result1"));
					if(rs.getInt("service_id") == 60 ) obj.setC20(rs.getString("result1"));
					if(rs.getInt("service_id") == 58 ) obj.setC21(rs.getString("result1"));
					if(rs.getInt("service_id") == 59 ) obj.setC22(rs.getString("result1"));
					if(rs.getInt("service_id") == 65 ) obj.setC23(rs.getString("result1"));
					if(rs.getInt("service_id") == 61 ) obj.setC24(rs.getString("result1"));
					if(rs.getInt("service_id") == 63 ) obj.setC25(rs.getString("result1"));
				} else {
					ObjList obj = new ObjList();
					obj.setBirthyear(rs.getString("birthyear"));
					obj.setFio(rs.getString("fio"));
					obj.setDate(rs.getString("date"));
					if(rs.getInt("service_id") == 47 ) obj.setC1(rs.getString("result1"));
					if(rs.getInt("service_id") == 54 ) obj.setC2(rs.getString("result1"));
					if(rs.getInt("service_id") == 4  ) obj.setC3(rs.getString("result1"));
					if(rs.getInt("service_id") == 45 ) obj.setC4(rs.getString("result1"));
					if(rs.getInt("service_id") == 46 ) obj.setC5(rs.getString("result1"));
					if(rs.getInt("service_id") == 52 ) { obj.setC6(rs.getString("result1")); obj.setC7(rs.getString("result2")); }
					if(rs.getInt("service_id") == 50 ) obj.setC8(rs.getString("result1"));
					if(rs.getInt("service_id") == 51 ) obj.setC9(rs.getString("result1"));
					if(rs.getInt("service_id") == 53 ) obj.setC10(rs.getString("result1"));
					if(rs.getInt("service_id") == 48 ) obj.setC11(rs.getString("result1"));
					if(rs.getInt("service_id") == 49 ) obj.setC12(rs.getString("result1"));
					if(rs.getInt("service_id") == 134) obj.setC13(rs.getString("result1"));
					if(rs.getInt("service_id") == 135) obj.setC14(rs.getString("result1"));
					if(rs.getInt("service_id") == 136) obj.setC15(rs.getString("result1"));
					if(rs.getInt("service_id") == 137) obj.setC16(rs.getString("result1"));
					if(rs.getInt("service_id") == 138) obj.setC17(rs.getString("result1"));
					if(rs.getInt("service_id") == 139) obj.setC18(rs.getString("result1"));
					if(rs.getInt("service_id") == 5  ) obj.setC19(rs.getString("result1"));
					if(rs.getInt("service_id") == 60 ) obj.setC20(rs.getString("result1"));
					if(rs.getInt("service_id") == 58 ) obj.setC21(rs.getString("result1"));
					if(rs.getInt("service_id") == 59 ) obj.setC22(rs.getString("result1"));
					if(rs.getInt("service_id") == 65 ) obj.setC23(rs.getString("result1"));
					if(rs.getInt("service_id") == 61 ) obj.setC24(rs.getString("result1"));
					if(rs.getInt("service_id") == 63 ) obj.setC25(rs.getString("result1"));
					patIds.add(rs.getInt("patient") + rs.getString("date"));
					rows.add(obj);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Кондаги гормонларни текшириш (Амбулатория)
	private void rep37(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<ObjList>();
		try {
			Integer[] ids = {75, 74, 73, 145};
			String query = "Select t.patient, t.fio, t.birthyear, Date_Format(t.confDate, '%d.%m.%Y') date, t.service_id, t.result1, t.result2 From (";
			String subquery = "Select t.patient, Concat(p.surname, ' ', p.name, ' ', p.middlename) fio, p.birthyear, t.confDate, t.service_Id, r.c1 result1, r.c2 result2 From Amb_Patients p, Amb_Patient_Services t, Amb_Results r Where r.Id = t.result And date(t.confDate) between '@1' And '@2' And t.patient = p.id And t.Service_Id = @id ";
			int k = 0;
			for(Integer id: ids) {
				k++;
				query += subquery.replace("@id", "" + id).replace("@1", Util.dateDB(Util.get(req, "period_start"))).replace("@2", Util.dateDB(Util.get(req, "period_end")));
				if(k != ids.length)
					query += " Union All ";
			}
			query += ") t Order By t.confDate";
			ps = conn.prepareStatement(query);
			rs = ps.executeQuery();
			List<String> patIds = new ArrayList<String>();
			while (rs.next()) {
				if(patIds.contains(rs.getInt("patient") + rs.getString("date"))) {
					ObjList obj = rows.get(patIds.indexOf(rs.getInt("patient") + rs.getString("date")));
					if(rs.getInt("service_id") == 75 ) obj.setC1(rs.getString("result1"));
					if(rs.getInt("service_id") == 74 ) obj.setC2(rs.getString("result1"));
					if(rs.getInt("service_id") == 73 ) obj.setC3(rs.getString("result1"));
					if(rs.getInt("service_id") == 145) obj.setC4(rs.getString("result1"));
				} else {
					ObjList obj = new ObjList();
					obj.setBirthyear(rs.getString("birthyear"));
					obj.setFio(rs.getString("fio"));
					obj.setDate(rs.getString("date"));
					if(rs.getInt("service_id") == 75) obj.setC1(rs.getString("result1"));
					if(rs.getInt("service_id") == 74) obj.setC2(rs.getString("result1"));
					if(rs.getInt("service_id") == 73) obj.setC3(rs.getString("result1"));
					if(rs.getInt("service_id") == 145) obj.setC4(rs.getString("result1"));
					patIds.add(rs.getInt("patient") + rs.getString("date"));
					rows.add(obj);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// TORCH инфекцияси текшируви (Амбулатория)
	private void rep38(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<ObjList>();
		try {
			Integer[] ids = {69, 70, 72, 71};
			String query = "Select t.patient, t.fio, t.birthyear, Date_Format(t.confDate, '%d.%m.%Y') date, t.service_id, t.result1, t.result2 From (";
			String subquery = "Select t.patient, Concat(p.surname, ' ', p.name, ' ', p.middlename) fio, p.birthyear, t.confDate, t.service_Id, r.c1 result1, r.c2 result2 From Amb_Patients p, Amb_Patient_Services t, Amb_Results r Where r.Id = t.result And date(t.confDate) between '@1' And '@2' And t.patient = p.id And t.Service_Id = @id ";
			int k = 0;
			for(Integer id: ids) {
				k++;
				query += subquery.replace("@id", "" + id).replace("@1", Util.dateDB(Util.get(req, "period_start"))).replace("@2", Util.dateDB(Util.get(req, "period_end")));
				if(k != ids.length)
					query += " Union All ";
			}
			query += ") t Order By t.confDate";
			ps = conn.prepareStatement(query);
			rs = ps.executeQuery();
			List<String> patIds = new ArrayList<String>();
			while (rs.next()) {
				if(patIds.contains(rs.getInt("patient") + rs.getString("date"))) {
					ObjList obj = rows.get(patIds.indexOf(rs.getInt("patient") + rs.getString("date")));
					if(rs.getInt("service_id") == 69) obj.setC1(rs.getString("result1"));
					if(rs.getInt("service_id") == 70) obj.setC2(rs.getString("result1"));
					if(rs.getInt("service_id") == 72) obj.setC3(rs.getString("result1"));
					if(rs.getInt("service_id") == 71) obj.setC4(rs.getString("result1"));
				} else {
					ObjList obj = new ObjList();
					obj.setBirthyear(rs.getString("birthyear"));
					obj.setFio(rs.getString("fio"));
					obj.setDate(rs.getString("date"));
					if(rs.getInt("service_id") == 69) obj.setC1(rs.getString("result1"));
					if(rs.getInt("service_id") == 70) obj.setC2(rs.getString("result1"));
					if(rs.getInt("service_id") == 72) obj.setC3(rs.getString("result1"));
					if(rs.getInt("service_id") == 71) obj.setC4(rs.getString("result1"));
					patIds.add(rs.getInt("patient") + rs.getString("date"));
					rows.add(obj);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Коагулограмма (Амбулатория)
	private void rep39(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<ObjList>();
		try {
			Integer[] ids = {66, 67, 153, 68};
			String query = "Select t.fio, t.birthyear, Date_Format(t.confDate, '%d.%m.%Y') date, t.service_id, t.* From (";
			String subquery = "Select Concat(p.surname, ' ', p.name, ' ', p.middlename) fio, p.birthyear, t.confDate, t.service_Id, r.* From Amb_Patients p, Amb_Patient_Services t, Amb_Results r Where r.Id = t.result And date(t.confDate) between '@1' And '@2' And t.patient = p.id And t.Service_Id = @id ";
			int k = 0;
			for(Integer id: ids) {
				k++;
				query += subquery.replace("@id", "" + id).replace("@1", Util.dateDB(Util.get(req, "period_start"))).replace("@2", Util.dateDB(Util.get(req, "period_end")));
				if(k != ids.length)
					query += " Union All ";
			}
			query += ") t Order By t.confDate";
			ps = conn.prepareStatement(query);
			rs = ps.executeQuery();
			List<String> patIds = new ArrayList<String>();
			while (rs.next()) {
				if(patIds.contains(rs.getInt("patient") + rs.getString("date"))) {
					ObjList obj = rows.get(patIds.indexOf(rs.getInt("patient") + rs.getString("date")));
					if(rs.getInt("service_id") == 66) { obj.setC1(rs.getString("c1")); obj.setC2(rs.getString("c2")); obj.setC3(rs.getString("c3")); }
					if(rs.getInt("service_id") == 67) obj.setC4(rs.getString("c1"));
					if(rs.getInt("service_id") == 153) obj.setC5(rs.getString("c1"));
					if(rs.getInt("service_id") == 68) obj.setC6(rs.getString("c1"));
				} else {
					ObjList obj = new ObjList();
					obj.setBirthyear(rs.getString("birthyear"));
					obj.setFio(rs.getString("fio"));
					obj.setDate(rs.getString("date"));
					if(rs.getInt("service_id") == 66) { obj.setC1(rs.getString("c1")); obj.setC2(rs.getString("c2")); obj.setC3(rs.getString("c3")); }
					if(rs.getInt("service_id") == 67) obj.setC4(rs.getString("c1"));
					if(rs.getInt("service_id") == 153) obj.setC5(rs.getString("c1"));
					if(rs.getInt("service_id") == 68) obj.setC6(rs.getString("c1"));
					patIds.add(rs.getInt("patient") + rs.getString("date"));
					rows.add(obj);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Кон зардобида липопротеидлар тахлили
	private void rep41(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<ObjList>();
		try {
			ps = conn.prepareStatement(
				" Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
					"				 ser.Name Service_Name, " +
					"  			 Date_Format(t.confDate, '%d.%m.%Y %H:%i') cr_on, " +
					"        p.birthyear, " +
					"				 r.* " +
					"   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p, Amb_Results r " +
					"  Where ser.Id = t.Service_Id " +
					"    And t.result = r.id " +
					"    And p.Id = t.Patient " +
					"    And ser.id = 57 " +
					" 	 And date (t.confDate) Between ? and ? " +
					" Order By t.confDate "
			);
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			while (rs.next()) {
				ObjList service = new ObjList();
				//
				service.setFio(rs.getString("fio"));
				service.setBirthyear(rs.getString("birthyear"));
				service.setDate(rs.getString("cr_on"));
				service.setC1(rs.getString("c1"));
				service.setC2(rs.getString("c2"));
				service.setC3(rs.getString("c3"));
				service.setC4(rs.getString("c4"));
				service.setC5(rs.getString("c5"));
				service.setC6(rs.getString("c6"));
				//
				rows.add(service);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Общий анализ крови 21 параметр
	private void rep42(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<ObjList>();
		try {
			Integer[] ids = {1, 3};
			String query = "Select Date_Format(t.confDate, '%d.%m.%Y') date, t.* From (";
			String subquery = "Select Concat(p.surname, ' ', p.name, ' ', p.middlename) fio, p.birthyear, t.confDate, t.service_Id, r.* From Amb_Patients p, Amb_Patient_Services t, Amb_Results r Where r.Id = t.result And date(t.confDate) between '@1' And '@2' And t.patient = p.id And t.Service_Id = @id ";
			int k = 0;
			for(Integer id: ids) {
				k++;
				query += subquery.replace("@id", "" + id).replace("@1", Util.dateDB(Util.get(req, "period_start"))).replace("@2", Util.dateDB(Util.get(req, "period_end")));
				if(k != ids.length)
					query += " Union All ";
			}
			query += ") t Order By t.confDate";
			ps = conn.prepareStatement(query);
			rs = ps.executeQuery();
			List<String> patIds = new ArrayList<String>();
			while (rs.next()) {
				if(patIds.contains(rs.getInt("patient") + rs.getString("date"))) {
					ObjList obj = rows.get(patIds.indexOf(rs.getInt("patient") + rs.getString("date")));
					if(rs.getInt("service_id") == 1) {
						obj.setC1(rs.getString("c1"));
						obj.setC2(rs.getString("c2"));
						obj.setC3(rs.getString("c3"));
						obj.setC4(rs.getString("c4"));
						obj.setC5(rs.getString("c5"));
						obj.setC6(rs.getString("c6"));
						obj.setC7(rs.getString("c7"));
						obj.setC8(rs.getString("c8"));
						obj.setC9(rs.getString("c9"));
						obj.setC10(rs.getString("c10"));
						obj.setC11(rs.getString("c11"));
						obj.setC12(rs.getString("c12"));
						obj.setC13(rs.getString("c13"));
						obj.setC14(rs.getString("c14"));
						obj.setC15(rs.getString("c15"));
						obj.setC16(rs.getString("c16"));
						obj.setC17(rs.getString("c17"));
						obj.setC18(rs.getString("c18"));
						obj.setC19(rs.getString("c19"));
						obj.setC20(rs.getString("c20"));
					}
					if(rs.getInt("service_id") == 3 ) obj.setC21(rs.getString("c1"));
				} else {
					ObjList obj = new ObjList();
					obj.setBirthyear(rs.getString("birthyear"));
					obj.setFio(rs.getString("fio"));
					obj.setDate(rs.getString("date"));
					if(rs.getInt("service_id") == 1) {
						obj.setC1(rs.getString("c1"));
						obj.setC2(rs.getString("c2"));
						obj.setC3(rs.getString("c3"));
						obj.setC4(rs.getString("c4"));
						obj.setC5(rs.getString("c5"));
						obj.setC6(rs.getString("c6"));
						obj.setC7(rs.getString("c7"));
						obj.setC8(rs.getString("c8"));
						obj.setC9(rs.getString("c9"));
						obj.setC10(rs.getString("c10"));
						obj.setC11(rs.getString("c11"));
						obj.setC12(rs.getString("c12"));
						obj.setC13(rs.getString("c13"));
						obj.setC14(rs.getString("c14"));
						obj.setC15(rs.getString("c15"));
						obj.setC16(rs.getString("c16"));
						obj.setC17(rs.getString("c17"));
						obj.setC18(rs.getString("c18"));
						obj.setC19(rs.getString("c19"));
						obj.setC20(rs.getString("c20"));
					}
					if(rs.getInt("service_id") == 3 ) obj.setC21(rs.getString("c1"));
					patIds.add(rs.getInt("patient") + rs.getString("date"));
					rows.add(obj);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Пешобда суткалик канд микдорини аниклаш
	private void rep43(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<ObjList>();
		try {
			ps = conn.prepareStatement(
				" Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
					"				 ser.Name Service_Name, " +
					"  			 Date_Format(t.confDate, '%d.%m.%Y %H:%i') cr_on, " +
					"        p.birthyear, " +
					"				 r.* " +
					"   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p, Amb_Results r " +
					"  Where ser.Id = t.Service_Id " +
					"    And t.result = r.id " +
					"    And p.Id = t.Patient " +
					"    And ser.id = 4 " +
					" 	 And date (t.confDate) Between ? and ? " +
					" Order By t.confDate "
			);
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			while (rs.next()) {
				ObjList service = new ObjList();
				//
				service.setFio(rs.getString("fio"));
				service.setBirthyear(rs.getString("birthyear"));
				service.setDate(rs.getString("cr_on"));
				service.setC1(rs.getString("c1"));
				service.setC2(rs.getString("c2"));
				service.setC3(rs.getString("c3"));
				//
				rows.add(service);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Ничепоренко буйича пешоб тахлили
	private void rep44(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<ObjList>();
		try {
			ps = conn.prepareStatement(
				" Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
					"				 		ser.Name Service_Name, " +
					"  			 		Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
					"        		p.birthyear, " +
					"					  r.* " +
					"   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p, Amb_Results r " +
					"  Where ser.Id = t.Service_Id " +
					"		 And r.id = t.result " +
					"    And p.Id = t.Patient " +
					"    And t.service_id = 7 " +
					" 	 And date (t.confDate) Between ? and ? " +
					" Order By t.confDate "
			);
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			while (rs.next()) {
				ObjList service = new ObjList();
				//
				service.setFio(rs.getString("fio"));
				service.setBirthyear(rs.getString("birthyear"));
				service.setDate(rs.getString("cr_on"));
				service.setC1(rs.getString("c1"));
				service.setC2(rs.getString("c2"));
				service.setC3(rs.getString("c3"));
				//
				rows.add(service);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Зимницкий буйича пешоб тахлили
	private void rep45(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<ObjList>();
		try {
			ps = conn.prepareStatement(
				" Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
					"				 		ser.Name Service_Name, " +
					"  			 		Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
					"        		p.birthyear, " +
					"					  r.* " +
					"   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p, Amb_Results r " +
					"  Where ser.Id = t.Service_Id " +
					"		 And r.id = t.result " +
					"    And p.Id = t.Patient " +
					"    And t.service_id = 10 " +
					" 	 And date (t.confDate) Between ? and ? " +
					" Order By t.confDate "
			);
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			while (rs.next()) {
				ObjList service = new ObjList();
				//
				service.setFio(rs.getString("fio"));
				service.setBirthyear(rs.getString("birthyear"));
				service.setDate(rs.getString("cr_on"));
				service.setC1(rs.getString("c1"));
				service.setC2(rs.getString("c2"));
				service.setC3(rs.getString("c3"));
				service.setC4(rs.getString("c4"));
				service.setC5(rs.getString("c5"));
				service.setC6(rs.getString("c6"));
				service.setC7(rs.getString("c7"));
				service.setC8(rs.getString("c8"));
				service.setC9(rs.getString("c9"));
				service.setC10(rs.getString("c10"));
				service.setC11(rs.getString("c11"));
				service.setC12(rs.getString("c12"));
				service.setC13(rs.getString("c13"));
				service.setC14(rs.getString("c14"));
				service.setC15(rs.getString("c15"));
				service.setC16(rs.getString("c16"));
				service.setC17(rs.getString("c17"));
				service.setC18(rs.getString("c18"));
				service.setC19(rs.getString("c19"));
				//
				rows.add(service);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Анализ гинекологического мазка
	private void rep46(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<ObjList>();
		try {
			ps = conn.prepareStatement(
				" Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
					"				 		ser.Name Service_Name, " +
					"  			 		Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
					"        		p.birthyear, " +
					"					  r.* " +
					"   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p, Amb_Results r " +
					"  Where ser.Id = t.Service_Id " +
					"		 And r.id = t.result " +
					"    And p.Id = t.Patient " +
					"    And t.service_id = 11 " +
					" 	 And date (t.confDate) Between ? and ? " +
					" Order By t.confDate "
			);
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			while (rs.next()) {
				ObjList service = new ObjList();
				//
				service.setFio(rs.getString("fio"));
				service.setBirthyear(rs.getString("birthyear"));
				service.setDate(rs.getString("cr_on"));
				service.setC1(rs.getString("c1"));
				service.setC2(rs.getString("c2"));
				service.setC3(rs.getString("c3"));
				service.setC4(rs.getString("c4"));
				service.setC5(rs.getString("c5"));
				service.setC6(rs.getString("c6"));
				service.setC7(rs.getString("c7"));
				service.setC8(rs.getString("c8"));
				service.setC9(rs.getString("c9"));
				service.setC10(rs.getString("c10"));
				service.setC11(rs.getString("c11"));
				service.setC12(rs.getString("c12"));
				service.setC13(rs.getString("c13"));
				service.setC14(rs.getString("c14"));
				service.setC15(rs.getString("c15"));
				service.setC16(rs.getString("c16"));
				service.setC17(rs.getString("c17"));
				service.setC18(rs.getString("c18"));
				service.setC19(rs.getString("c19"));
				service.setC20(rs.getString("c20"));
				service.setC21(rs.getString("c21"));
				service.setC22(rs.getString("c22"));
				service.setC23(rs.getString("c23"));
				service.setC24(rs.getString("c24"));
				//
				rows.add(service);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Общий анализ мочи
	private void rep47(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<ObjList>();
		try {
			ps = conn.prepareStatement(
				" Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
					"				 ser.Name Service_Name, " +
					"  			 Date_Format(t.confDate, '%d.%m.%Y %H:%i') cr_on, " +
					"        p.birthyear, " +
					"				 r.* " +
					"   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p, Amb_Results r " +
					"  Where ser.Id = t.Service_Id " +
					"    And t.result = r.id " +
					"    And p.Id = t.Patient " +
					"    And ser.id = 6 " +
					" 	 And date (t.confDate) Between ? and ? " +
					" Order By t.confDate "
			);
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			while (rs.next()) {
				ObjList service = new ObjList();
				//
				service.setFio(rs.getString("fio"));
				service.setBirthyear(rs.getString("birthyear"));
				service.setDate(rs.getString("cr_on"));
				service.setC1(rs.getString("c1"));
				service.setC2(rs.getString("c2"));
				service.setC3(rs.getString("c3"));
				service.setC4(rs.getString("c4"));
				service.setC5(rs.getString("c5"));
				service.setC6(rs.getString("c6"));
				service.setC7(rs.getString("c7"));
				service.setC8(rs.getString("c8"));
				service.setC9(rs.getString("c9"));
				service.setC10(rs.getString("c10"));
				service.setC11(rs.getString("c11"));
				service.setC12(rs.getString("c12"));
				service.setC13(rs.getString("c13"));
				service.setC14(rs.getString("c14"));
				service.setC15(rs.getString("c15"));
				service.setC16(rs.getString("c16"));
				service.setC17(rs.getString("c17"));
				service.setC18(rs.getString("c18"));
				service.setC19(rs.getString("c19"));
				service.setC20(rs.getString("c20"));
				service.setC21(rs.getString("c21"));
				service.setC22(rs.getString("c22"));
				//
				rows.add(service);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Анализ гинекологического мазка (Стационар)
	private void rep48(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<ObjList> rows = new ArrayList<ObjList>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		try {
			ps = conn.prepareStatement(
				" Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
					"  			 Date_Format(ser.result_date, '%d.%m.%Y') result_date, " +
					"				 (Select dept.name From Depts dept Where dept.Id = p.Dept_Id) depName, " +
					"        p.birthyear, " +
					"        p.yearNum, " +
					"        t.* " +
					"   From F174 t, Lv_Plans ser, Patients p " +
					"  Where ser.Id = t.Plan_Id " +
					"    And p.Id = t.PatientId " +
					"    And ser.Done_Flag = 'Y' " +
					" 	 And date (ser.result_date) Between ? and ? "+
					" Order By ser.result_date "
			);
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			while (rs.next()) {
				ObjList service = new ObjList();
				service.setDate(rs.getString("result_date"));
				service.setIb(rs.getString("yearnum"));
				service.setFio(rs.getString("fio"));
				service.setBirthyear(rs.getString("birthyear"));
				service.setC30(rs.getString("depName"));

				service.setC1(rs.getString("c1"));
				service.setC2(rs.getString("c2"));
				service.setC3(rs.getString("c3"));
				service.setC4(rs.getString("c4"));
				service.setC5(rs.getString("c5"));
				service.setC6(rs.getString("c6"));
				service.setC7(rs.getString("c7"));
				service.setC8(rs.getString("c8"));
				service.setC9(rs.getString("c9"));
				service.setC10(rs.getString("c10"));
				service.setC11(rs.getString("c11"));
				service.setC12(rs.getString("c12"));
				service.setC13(rs.getString("c13"));
				service.setC14(rs.getString("c14"));
				service.setC15(rs.getString("c15"));
				service.setC16(rs.getString("c16"));
				service.setC17(rs.getString("c17"));
				service.setC18(rs.getString("c18"));
				service.setC19(rs.getString("c19"));
				service.setC20(rs.getString("c11"));
				service.setC21(rs.getString("c21"));
				service.setC22(rs.getString("c22"));
				service.setC23(rs.getString("c23"));
				service.setC24(rs.getString("c24"));

				rows.add(service);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Сводный отчет по текущим пациентам (Стационар)
	private void rep49(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<ObjList> rows = new ArrayList<ObjList>();
		//
		try {
			ps = conn.prepareStatement(
				" Select t.id, " +
					"				 Concat(t.surname, ' ',  t.name, ' ', t.middlename) Fio, " +
					"  			 Date_Format(t.date_begin, '%d.%m.%Y') reg_date, " +
					"  			 Date_Format(t.date_end, '%d.%m.%Y') vyp_date, " +
					"				 (Select dept.name From Depts dept Where dept.Id = t.Dept_Id) depName, " +
					"        t.birthyear, " +
					"        t.yearNum, " +
					"				 (Select c.Name From Rooms c WHere c.id = t.room_id) Room, " +
					"				 (Select Sum(c.Card + c.Transfer + c.Cash) From Patient_Pays c Where c.patient_id = t.id And c.PayType = 'pay') Paid, " +
					"				 (Select Sum(c.Card + c.Transfer + c.Cash) From Patient_Pays c Where c.patient_id = t.id And c.PayType = 'ret') returned, " +
					"				 (Select Sum(c.Summ) From Cash_Discounts c Where c.patient = t.id And c.ambStat = 'STAT') discount, " +
					"				 (Select Sum(c.rasxod * f.price / d.dropCount) From drug_write_off_rows f, hn_date_patient_rows c, hn_drugs d where f.Id = d.writeOffRows_Id And d.id = c.drug_Id And c.patient_Id = t.id) ddd " +
					"   From Patients t " +
					"  Where t.state != 'ARCH' "+
					" Order By t.date_begin "
			);
			rs = ps.executeQuery();
			Double tPaid = 0D, tReturned = 0D, tDiscount = 0D, tSer = 0D, ddd = 0D;
			while (rs.next()) {
				ObjList service = new ObjList();
				service.setFio(rs.getString("fio"));
				service.setDate(rs.getString("reg_date"));
				service.setIb(rs.getString("yearnum"));
				service.setBirthyear(rs.getString("birthyear"));
				service.setC1(rs.getString("depName"));
				service.setC2(rs.getString("vyp_date"));
				service.setC3(rs.getString("room"));
				//
				service.setC4(rs.getString("paid") == null ? "0" : rs.getString("paid"));
				service.setC5(rs.getString("returned") == null ? "0" : rs.getString("returned"));
				service.setC6(rs.getString("discount") == null ? "0" : rs.getString("discount"));
				service.setC10(rs.getString("ddd") == null ? "0" : rs.getString("ddd"));
				service.setC30("0");
				Double ser = patientMustPay(req, rs.getInt("id"));
				tSer += ser;
				service.setC7("" + ser);
				tPaid += rs.getString("paid") == null ? 0D : rs.getDouble("paid");
				tReturned += rs.getString("returned") == null ? 0D : rs.getDouble("returned");
				tDiscount += rs.getString("discount") == null ? 0D : rs.getDouble("discount");
				ddd += rs.getString("ddd") == null ? 0D : rs.getDouble("ddd");
				//
				rows.add(service);
			}
			if(rows.size() > 0) {
				ObjList service = new ObjList();
				service.setC30("1");
				service.setFio("ИТОГО");
				service.setC4("" + tPaid);
				service.setC5("" + tReturned);
				service.setC6("" + tDiscount);
				service.setC7("" + tSer);
				service.setC10("" + ddd);
				service.setC8("" + (ddd + tSer - tPaid + tReturned - tDiscount));
				rows.add(service);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	private Double patientMustPay(HttpServletRequest request, int id) {
		Session session = SessionUtil.getUser(request);
		Patients pat = dPatient.get(id);
		Double KOYKA_PRICE_LUX_UZB = Double.parseDouble(session.getParam("KOYKA_PRICE_LUX_UZB"));
		Double KOYKA_PRICE_SIMPLE_UZB = Double.parseDouble(session.getParam("KOYKA_PRICE_SIMPLE_UZB"));
		Double KOYKA_SEMILUX_UZB = Double.parseDouble(session.getParam("KOYKA_SEMILUX_UZB"));
		Double KOYKA_PRICE_LUX = Double.parseDouble(session.getParam("KOYKA_PRICE_LUX"));
		Double KOYKA_PRICE_SIMPLE = Double.parseDouble(session.getParam("KOYKA_PRICE_SIMPLE"));
		Double KOYKA_SEMILUX = Double.parseDouble(session.getParam("KOYKA_SEMILUX"));
		//
		Double total;
		if(pat.getCounteryId() == 199) { // Узбекистан
			if(pat.getRoom().getRoomType().getId() == 5)  // Люкс
				total = (pat.getDayCount() == null ? 0 : pat.getDayCount()) * KOYKA_PRICE_LUX_UZB;
			else if(pat.getRoom().getRoomType().getId() == 6) // Протая
				total = (pat.getDayCount() == null ? 0 : pat.getDayCount()) * KOYKA_PRICE_SIMPLE_UZB;
			else // Полулюкс
				total = (pat.getDayCount() == null ? 0 : pat.getDayCount()) * KOYKA_SEMILUX_UZB;
		} else {
			if(pat.getRoom().getRoomType().getId() == 5)  // Люкс
				total = (pat.getDayCount() == null ? 0 : pat.getDayCount()) * KOYKA_PRICE_LUX;
			else if(pat.getRoom().getRoomType().getId() == 6) // Протая
				total = (pat.getDayCount() == null ? 0 : pat.getDayCount()) * KOYKA_PRICE_SIMPLE;
			else // Полулюкс
				total = (pat.getDayCount() == null ? 0 : pat.getDayCount()) * KOYKA_SEMILUX;
		}
		List<PatientWatchers> watchers = dPatientWatchers.byPatient(pat.getId());
		for(PatientWatchers watcher: watchers) {
			total += watcher.getTotal();
		}
		//
		List<LvFizios> fizios = dLvFizio.getPaidServices(pat.getId());
		for(LvFizios fizio: fizios) {
			if(fizio.getPaid().equals("N")) {
				Long counter = dLvFizioDate.getStateCount(fizio.getId());
				total += fizio.getPrice() * (counter == null ? 0 : counter) - (fizio.getPaidSum() != null ? fizio.getPaidSum() : 0);
			}
		}
		// Услуги
		List<LvPlans> plans = dLvPlan.getByPatientId(pat.getId());
		for(LvPlans plan: plans) {
			if(plan.getPrice() != null)
				total += plan.getPrice();
		}
		//
		try {
			HNPatients hnPatient = dhnPatient.getObj("From HNPatients Where state = 'D' And patient.id = " + pat.getId());
			if (hnPatient != null) {
				total = hnPatient.getTotalSum();
			}
		} catch (Exception e) {}
		//
		return total;
	}
	// План обследования на след день
	private void rep50(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		ResultSet rd = null;
		String params = "";
		List<ObjList> rows = new ArrayList<ObjList>();
		//
		try {
			Calendar calendar = Calendar.getInstance();
			int day = calendar.get(Calendar.DAY_OF_WEEK);
			String dt = Util.getCurDate();
			Calendar c = Calendar.getInstance();
			c.setTime(new Date());
			c.add(Calendar.DATE, day == 7 ? 2 : 1);
			dt = Util.dateToString(c.getTime());
			conn = DB.getConnection();
			Integer deptId = !req.getParameter("dept").equals("") ? Util.getInt(req, "dept") : null;
			//
			List<Depts> depts = dDept.getAll();
			if(deptId != null) {
				Depts dd = dDept.get(deptId);
				depts = new ArrayList<Depts>();
				depts.add(dd);
			}
			for(Depts dept: depts) {
				if(dept.getId() > 0) {
					ObjList obj = new ObjList();
					obj.setC1(dept.getName());
					obj.setC30("O");
					rows.add(obj);
				}
				List<Integer> kdoIds = new ArrayList<Integer>();
				ps = conn.prepareStatement(
					"Select t.Id, t.Name " +
						"From Kdo_Types t " +
						"Where t.Id IN (SELECT c.kdo_type_id FROM Lv_Plans c, Patients d WHERE c.patientId = d.id And d.dept_id = ? And date(actDate) = ?)");
				ps.setInt(1, dept.getId());
				ps.setString(2, Util.dateDB(dt));
				rs = ps.executeQuery();
				List<String> kdos = new ArrayList<String>();
				while (rs.next()) {
					kdoIds.add(rs.getInt(1));
					kdos.add(rs.getString(2));
				}
				Integer counter = 1;
				for (int i = 0; i < kdos.size(); i++) {
					List<ObjList> patients = new ArrayList<ObjList>();
					ps = conn.prepareStatement(
						"SELECT Concat(d.surname, ' ', d.name, ' ', d.middlename) fio," +
							"         c.id, " +
							"         c.kdo_id, " +
							"         k.Name Kdo_Name, " +
							"         Date_Format(c.actDate, '%d.%m.%Y') actDate, " +
							"					Date_Format(c.crOn, '%H:%i') crOn, " +
							"         c.comment " +
							"  FROM Lv_Plans c, Patients d, Kdos k " +
							"  WHERE k.id = c.kdo_id " +
							"    And c.patientid = d.id " +
							"    And d.dept_id = ? " +
							"    And c.kdo_type_id = ?" +
							"    And date(actDate) = ?");
					ps.setInt(1, dept.getId());
					ps.setInt(2, kdoIds.get(i));
					ps.setString(3, Util.dateDB(dt));
					rs = ps.executeQuery();
					while (rs.next()) {
						ObjList obj = new ObjList();
						obj.setC30("N");
						obj.setC1(rs.getString("fio"));
						String name = rs.getString("kdo_name");
						if (rs.getInt("kdo_id") == 13) { // Биохимия
							String st = "";
							LvBios bio = dLvBio.getByPlan(rs.getInt("id"));
							if (bio != null) {
								if (bio.getC1() == 1) st += "Глюкоза крови,";
								if (bio.getC2() == 1) st += "Холестерин,";
								if (bio.getC3() == 1) st += "Бетта липопротеиды,";
								if (bio.getC4() == 1) st += "Общий белок,";
								if (bio.getC5() == 1) st += "Мочевина,";
								if (bio.getC23() == 1) st += "Fе (железо),";
								if (bio.getC8() == 1) st += "Билирубин,";
								if (bio.getC7() == 1) st += "Креатинин,";
								if (bio.getC13() == 1) st += "Амилаза крови,";
								if (bio.getC12() == 1) st += "Трансаминазы-АЛТ,";
								if (bio.getC14() == 1) st += "Мочевая кислота,";
								if (bio.getC11() == 1) st += "Трансаминазы-АСТ,";
								if (bio.getC15() == 1) st += "Сывороточное железо,";
								if (bio.getC16() == 1) st += "К-калий,";
								if (bio.getC17() == 1) st += "Na - натрий,";
								if (bio.getC18() == 1) st += "Са - кальций,";
								if (bio.getC19() == 1) st += "Cl - хлор,";
								if (bio.getC20() == 1) st += "Phos - фосфор,";
								if (bio.getC21() == 1) st += "Mg - магний,";
								if (bio.getC24() == 1) st += "Альбумин,";
								if (bio.getC25() == 1) st += "Лактатдегидрогеноза,";
								if (bio.getC26() == 1) st += "Гамма-глутамилтрансфераза,";
								if (bio.getC27() == 1) st += "Шелочная фосфотаза,";
								if (bio.getC28() == 1) st += "Тимоловая проба,";
								if (bio.getC29() == 1) st += "Креотенин киназа,";
								if (st != "") {
									st = st.substring(0, st.length() - 1);
									name = name + "<br/>" + st;
								}
							}
						}
						if (rs.getInt("kdo_id") == 153) { // Биохимия
							String st = "";
							LvBios bio = dLvBio.getByPlan(rs.getInt("id"));
							if (bio != null) {
								if (bio.getC1() == 1) st += "Умумий оксил,";
								if (bio.getC2() == 1) st += "Холестерин,";
								if (bio.getC3() == 1) st += "Глюкоза,";
								if (bio.getC4() == 1) st += "Мочевина,";
								if (bio.getC5() == 1) st += "Креатинин,";
								if (bio.getC6() == 1) st += "Билирубин,";
								if (bio.getC7() == 1) st += "АЛТ,";
								if (bio.getC8() == 1) st += "АСТ,";
								if (bio.getC9() == 1) st += "Альфа амилаза,";
								if (bio.getC10() == 1) st += "Кальций,";
								if (bio.getC11() == 1) st += "Сийдик кислотаси,";
								if (bio.getC12() == 1) st += "K – калий,";
								if (bio.getC13() == 1) st += "Na – натрий,";
								if (bio.getC14() == 1) st += "Fe – темир,";
								if (bio.getC15() == 1) st += "Mg – магний,";
								if (bio.getC16() == 1) st += "Ишкорий фасфотаза,";
								if (bio.getC17() == 1) st += "ГГТ,";
								if (bio.getC18() == 1) st += "Гликирланган гемоглобин,";
								if (bio.getC19() == 1) st += "РФ,";
								if (bio.getC20() == 1) st += "АСЛО,";
								if (bio.getC21() == 1) st += "СРБ,";
								if (bio.getC22() == 1) st += "RW,";
								if (bio.getC23() == 1) st += "Hbs Ag,";
								if (bio.getC24() == 1) st += "Гепатит «С» ВГС,";
								if (st != "") {
									st = st.substring(0, st.length() - 1);
									name = name + "<br/>" + st;
								}
							}
						}
						if (rs.getInt("kdo_id") == 56) { // Каулограмма
							String st = "";
							LvCouls bio = dLvCoul.getByPlan(rs.getInt("id"));
							if (bio != null) {
								if (bio.isC4()) st += "ПТИ,";
								if (bio.isC1()) st += "Фибриноген,";
								if (bio.isC2()) st += "Тромбин вакти,";
								if (bio.isC3()) st += "А.Ч.Т.В. (сек),";
								if (st != "") {
									st = st.substring(0, st.length() - 1);
									name = name + "<br/>" + st;
								}
							}
						}
						if (rs.getInt("kdo_id") == 120) { // Garmon
							String st = "";
							LvGarmons bio = dLvGarmon.getByPlan(rs.getInt("id"));
							if (bio != null) {
								if (bio.isC1()) st += "ТТГ,";
								if (bio.isC2()) st += "Т4,";
								if (bio.isC3()) st += "Т3,";
								if (bio.isC4()) st += "Анти-ТРО,";
								if (st != "") {
									st = st.substring(0, st.length() - 1);
									name = name + "<br/>" + st;
								}
							}
						}
						if (rs.getInt("kdo_id") == 121) { // Торч
							String st = "";
							LvTorchs bio = dLvTorch.getByPlan(rs.getInt("id"));
							if (bio != null) {
								if (bio.isC1()) st += "Хламидия,";
								if (bio.isC2()) st += "Токсоплазма,";
								if (bio.isC3()) st += "ЦМВ,";
								if (bio.isC4()) st += "ВПГ,";
								if (st != "") {
									st = st.substring(0, st.length() - 1);
									name = name + "<br/>" + st;
								}
							}
						}
						obj.setC3(name);
						obj.setC4(rs.getString("actdate") + " " + (rs.getString("crOn") == null ? "" : rs.getString("crOn")));
						obj.setC5(rs.getString("comment"));
						obj.setC10("" + counter++);
						patients.add(obj);
					}
					if (patients.size() > 0) {
						ObjList obj = new ObjList();
						obj.setC1(kdos.get(i));
						obj.setC30("Y");
						rows.add(obj);
						rows.addAll(patients);
					}
				}
				ps = conn.prepareStatement(
					"SELECT Concat(d.surname, ' ', d.name, ' ', d.middlename) fio," +
						"         t.lvName, " +
						"         u.profil, " +
						"         t.date actdate  " +
						"   FROM Lv_Consuls t, Patients d, Users u " +
						"   Where t.patientid = d.id " +
						"     And t.state = 'REQ' " +
						"     And t.lvId > 0 " +
						"     And u.id = t.lvid " +
						"     And d.dept_id = ? " +
						"     And t.date = ? "
				);
				ps.setInt(1, dept.getId());
				ps.setString(2, dt);
				rs = ps.executeQuery();
				List<ObjList> patients = new ArrayList<ObjList>();
				while (rs.next()) {
					ObjList obj = new ObjList();
					obj.setC30("N");
					obj.setC1(rs.getString("fio"));
					obj.setC4(rs.getString("actdate"));
					if (rs.getString("profil") != null)
						obj.setC3("Консультация " + rs.getString("profil").toLowerCase() + "a");
					obj.setC5(rs.getString("lvName"));
					obj.setC10("" + counter++);
					patients.add(obj);
				}
				if (patients.size() > 0) {
					ObjList obj = new ObjList();
					obj.setC1("Консультация");
					obj.setC30("Y");
					rows.add(obj);
					rows.addAll(patients);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Телефонные номера клиентов
	private void rep51(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<ObjList> rows = new ArrayList<ObjList>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		String params = "" + ("Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate));
		Integer doctorId = Util.getNullInt(req, "doctor");
		try {
			ps = conn.prepareStatement(
				"Select c.* From (Select Concat(t.surname, ' ',  t.name, ' ', t.middlename) Fio, " +
					"(Select con.Name From counteries con WHERE con.id = t.counteryId) Country, " +
					"(Select reg.Name From Regions reg Where reg.Id = t.RegionId) Region_Name, " +
					"max(t.tel) tel, " +
					"max(Date_Format(t.date_begin, '%d.%m.%Y')) date_begin, " +
					"max(t.date_begin) ord_date, " +
					"t.birthyear, " +
					"(Select dd.Start_Diagnoz From Patients dd Where dd.Id = max(t.id)) start_diagnoz, " +
					"(Select dd.yearNum From Patients dd Where dd.Id = max(t.id)) yearnum," +
					"(Select cc.Fio From Patients dd, Users cc Where dd.lv_id = cc.id And dd.Id = max(t.id)) lvfio " +
					"From Patients t  " +
					"Where " + (doctorId != null ? " t.lv_id = " + doctorId + " And " : "" ) +
					" date (t.Date_Begin) Between ? And ? " +
					"Group By t.counteryId, t.regionId,  t.surname, t.name, t.middlename, t.birthyear) c " +
					"Order By c.ord_date"
			);
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			while (rs.next()) {
				ObjList service = new ObjList();
				service.setFio(rs.getString("fio"));
				service.setBirthyear(rs.getString("birthyear"));
				service.setDate(rs.getString("date_begin"));
				service.setC1(rs.getString(2));
				service.setC2(rs.getString(3));
				service.setC3(rs.getString(4));
				service.setC4(rs.getString("start_diagnoz"));
				service.setC5(rs.getString("yearnum"));
				service.setC6(rs.getString("lvfio"));
				rows.add(service);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(ps);
			DB.done(rs);
			DB.done(conn);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Годовой отчет по пациентам
	private void rep52(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<ObjList> rows = new ArrayList<ObjList>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		String params = "" + ("Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate));
		try {
			ps = conn.prepareStatement(
				" Select Concat(t.surname, ' ',  t.name, ' ', t.middlename) Fio, " +
					" (Select con.Name From counteries con WHERE con.id = t.counteryId) Country, " +
					" (Select reg.Name From Regions reg Where reg.Id = t.RegionId) Region_Name, " +
					" (Select dp.name From Depts dp Where dp.Id = t.dept_id) dept, " +
					" (Select u.fio From Users u Where u.Id = t.lv_id) lv, " +
					" (Select Sum(pp.cash + pp.transfer + pp.card) From Patient_Pays pp Where pp.patient_id = t.id) summ," +
					" (Select Date_Format(max(pp.crOn), '%d.%m.%Y') From Patient_Pays pp Where pp.patient_id = t.id) pay_date," +
					" (Select dd.name From Rooms cc, Dicts dd Where dd.id = cc.roomType And cc.id = t.room_id) room_type, " +
					" t.tel, " +
					" Date_Format(t.date_begin, '%d.%m.%Y') date_begin, " +
					" Date_Format(t.date_end, '%d.%m.%Y') date_end, " +
					" t.birthyear, " +
					" t.address, " +
					" t.passportInfo, " +
					" t.Start_Diagnoz, " +
					" t.yearNum " +
					" From Patients t  " +
					" Where date (t.Date_Begin) Between ? And ? " +
					" Order By t.date_begin"
			);
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			while (rs.next()) {
				ObjList service = new ObjList();
				service.setFio(rs.getString("fio"));
				service.setBirthyear(rs.getString("birthyear"));
				service.setDate(rs.getString("date_begin"));
				service.setC1(rs.getString(2));
				service.setC2(rs.getString(3));
				service.setC3(rs.getString(4));
				service.setC4(rs.getString("start_diagnoz"));
				service.setC5(rs.getString("yearnum"));
				service.setC6(rs.getString("address"));
				service.setC7(rs.getString("passportInfo"));
				service.setC8(rs.getString("dept"));
				service.setC9(rs.getString("date_end"));
				service.setC10(rs.getString("lv"));
				service.setC11(rs.getString("tel"));
				service.setC12(rs.getString("summ"));
				service.setC13(rs.getString("pay_date"));
				service.setC14(rs.getString("room_type"));
				rows.add(service);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Расчет по партнерам
	private void rep53(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<Obj> rows = new ArrayList<Obj>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		String params = "" + ("Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate));
		try {
			List<LvPartners> partners = dLvPartner.getAll();
			for(LvPartners partner: partners) {
				Obj part = new Obj();
				part.setFio(partner.getCode() + " " + partner.getFio());
				part.setPrice(0D);
				ps = conn.prepareStatement(
					" Select Concat(t.surname, ' ',  t.name, ' ', t.middlename) Fio, " +
						" 			   s.name, " +
						"					 c.price " +
						" From Amb_Patients t, Amb_Patient_Services c, Amb_Services s  " +
						" Where date (t.reg_date) Between ? And ? " +
						"   And s.id = c.service_id " +
						"   And c.patient = t.id " +
						"   And c.crBy = t.crBy " +
						"   And t.lvpartner_id = ?" +
						" Order By t.reg_date"
				);
				ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
				ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
				ps.setInt(3, partner.getId());
				rs = ps.executeQuery();
				List<ObjList> services = new ArrayList<ObjList>();
				while (rs.next()) {
					ObjList service = new ObjList();
					service.setC1(rs.getString("fio"));
					service.setC2(rs.getString("name"));
					service.setC3(rs.getString("price"));
					part.setPrice(part.getPrice() + rs.getDouble("price"));
					services.add(service);
				}
				if(services.size() > 0) {
					part.setList(services);
					rows.add(part);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Скидки по услугам
	private void rep54(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		ResultSet rc = null;
		List<Obj> rows = new ArrayList<Obj>();
		List<Obj> rows2 = new ArrayList<Obj>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		String params = "" + ("Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate));
		try {
			// Амбулатория
			ps = conn.prepareStatement(
				" Select t.id, Concat(Max(t.surname), ' ',  Max(t.name), ' ', Max(t.middlename)) Fio, Sum(d.summ) summ " +
					" From Cash_Discounts d, Amb_Patients t " +
					" Where date(d.crOn) Between ? And ?" +
					"   And d.ambStat = 'AMB' " +
					"   And t.id = d.patient " +
					" Group By t.id"
			);
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			while (rs.next()) {
				Obj ob = new Obj();
				ob.setName(rs.getString("fio"));
				ob.setPrice(rs.getDouble("summ"));
				List<ObjList> srs = new ArrayList<ObjList>();
				ps = conn.prepareStatement(
					" Select s.name, " +
						"					 c.price " +
						" From Amb_Patient_Services c, Amb_Services s " +
						" Where s.id = c.service_id " +
						"   And c.patient = ?"
				);
				ps.setInt(1, rs.getInt("id"));
				rc = ps.executeQuery();
				while (rc.next()) {
					ObjList service = new ObjList();
					service.setC1(rc.getString("name"));
					service.setC2(rc.getString("price"));
					srs.add(service);
				}
				ob.setList(srs);
				rows.add(ob);
			}
			// Стационар
			ps = conn.prepareStatement(
				" Select t.id, sum(f.totalSum) totalSum, Concat(Max(t.surname), ' ',  Max(t.name), ' ', Max(t.middlename)) Fio, Sum(d.summ) summ " +
					" From Cash_Discounts d, Patients t, Hn_Patients f " +
					" Where date(d.crOn) Between ? And ?" +
					"   And d.ambStat = 'STAT' " +
					"   And f.patient_id = t.id " +
					"   And t.id = d.patient " +
					" Group By t.id"
			);
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			while (rs.next()) {
				Obj ob = new Obj();
				ob.setName(rs.getString("fio"));
				ob.setPrice(rs.getDouble("summ"));
				ob.setClaimCount(rs.getDouble("totalSum"));
				rows2.add(ob);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
			DB.done(rc);
		}
		m.addAttribute("rows", rows);
		m.addAttribute("rows2", rows2);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Отчет по производителям медикаментов
	private void rep55(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<Obj> rows = new ArrayList<Obj>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		String params = "" + ("Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate));
		try {
			List<DrugManufacturers> partners = dDrugManufacturer.getAll();
			for(DrugManufacturers partner: partners) {
				Obj part = new Obj();
				part.setName(partner.getName());
				part.setPrice(0D);
				ps = conn.prepareStatement(
					" Select c.name, " +
						"					 Sum(t.blockCount) counter, " +
						"					 Sum(t.blockCount * t.price) summ, " +
						"					 Max(t.price) price " +
						" From Drug_Act_Drugs t, Drug_S_Names c  " +
						" Where date (t.crOn) Between ? And ? " +
						"   And c.id = t.drug_id " +
						"   And t.manufacturer_Id = ?" +
						" Group By t.drug_id, c.name " +
						" Order By t.crOn "
				);
				ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
				ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
				ps.setInt(3, partner.getId());
				rs = ps.executeQuery();
				List<ObjList> services = new ArrayList<ObjList>();
				while (rs.next()) {
					ObjList service = new ObjList();
					service.setC1(rs.getString("name"));
					service.setC2(rs.getString("counter"));
					service.setC3(rs.getString("summ"));
					service.setC4(rs.getString("price"));
					part.setPrice(part.getPrice() + rs.getDouble("summ"));
					services.add(service);
				}
				if(services.size() > 0) {
					part.setList(services);
					rows.add(part);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Сводный отчет (Питание)
	private void rep56(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<ObjList> rows = new ArrayList<ObjList>();
		List<ObjList> dds = new ArrayList<ObjList>();
		//
		Date date = Util.getDate(req, "period");
		String params = "" + ("Параметры: За дату: " + Util.dateToString(date));
		try {
			List<Depts> depts = dDept.getList("From Depts Order By Length(name)");
			List<EatMenuTypes> menuTypes = dEatMenuType.getAll();
			LinkedHashMap<String, Integer> mm = new LinkedHashMap<String, Integer>();
			LinkedHashMap<String, String> keys = new LinkedHashMap<String, String>();
			for(Depts dept: depts) {
				for(EatMenuTypes menuType: menuTypes) {
					ps = conn.prepareStatement(
						"Select (Select Count(*) From Patients d Where d.dept_id = t.dept_id And d.State = 'LV') Patient_Count, " +
							"					(Select Count(*) From Patients d Where d.dept_id = t.dept_id And d.Date_Begin = ?) Reg_Count, " +
							"					(Select Count(*) From Patients d Where d.dept_id = t.dept_id And d.Date_End = ?) Out_Count, " +
							"					(Select Count(*) From Nurse_Eat_Patients d Where d.Nurse_Eat_Id = t.Id) Pat_Count, " +
							"				  (Select Count(*) From Nurse_Eat_Patients d Where d.Nurse_Eat_Id = t.Id And d.table_id = 3) t1, " +
							"				  (Select Count(*) From Nurse_Eat_Patients d Where d.Nurse_Eat_Id = t.Id And d.table_id = 7) t2, " +
							"				  (Select Count(*) From Nurse_Eat_Patients d Where d.Nurse_Eat_Id = t.Id And d.table_id = 9) t3, " +
							"				  (Select Count(*) From Nurse_Eat_Patients d Where d.Nurse_Eat_Id = t.Id And d.table_id = 11) t4, " +
							"				  (Select Count(*) From Nurse_Eat_Patients d Where d.Nurse_Eat_Id = t.Id And d.table_id = 12) t5, " +
							"				  (Select Count(*) From Nurse_Eat_Patients d Where d.Nurse_Eat_Id = t.Id And d.table_id = 17) t6, " +
							"				  (Select Count(*) From Nurse_Eat_Patients d Where d.Nurse_Eat_Id = t.Id And d.table_id = 18) t7, " +
							"				  (Select Count(*) From Nurse_Eat_Patients d Where d.Nurse_Eat_Id = t.Id And d.table_id = 19) t8 " +
							"	   From Nurse_Eats t " +
							"		Where date(t.act_date) = ? " +
							"			And t.dept_id = ? " +
							"			And t.menu_type_id = ? "
					);
					ps.setString(1, Util.dateDB(Util.get(req, "period")));
					ps.setString(2, Util.dateDB(Util.get(req, "period")));
					ps.setString(3, Util.dateDB(Util.get(req, "period")));
					ps.setInt(4, dept.getId());
					ps.setInt(5, menuType.getId());
					rs = ps.executeQuery();
					while (rs.next()) {
						ObjList row = new ObjList();
						row.setC1(dept.getName());
						row.setC2(menuType.getName());
						row.setC3(rs.getString("Patient_Count"));
						row.setC4(rs.getString("Pat_Count"));
						row.setC5(rs.getString("t1"));
						row.setC6(rs.getString("t2"));
						row.setC7(rs.getString("t3"));
						row.setC8(rs.getString("t4"));
						row.setC9(rs.getString("t5"));
						row.setC10(rs.getString("t6"));
						row.setC11(rs.getString("t7"));
						row.setC12(rs.getString("t8"));
						row.setC20(rs.getString("reg_count"));
						row.setC21(rs.getString("out_count"));
						keys.put(menuType.getId() + "", menuType.getName());
						mm.put(menuType.getId() + "_" + 1, (mm.get(menuType.getId() + "_" + 1) != null ? mm.get(menuType.getId() + "_" + 1) : 0) + rs.getInt("t1"));
						mm.put(menuType.getId() + "_" + 2, (mm.get(menuType.getId() + "_" + 2) != null ? mm.get(menuType.getId() + "_" + 2) : 0) + rs.getInt("t2"));
						mm.put(menuType.getId() + "_" + 3, (mm.get(menuType.getId() + "_" + 3) != null ? mm.get(menuType.getId() + "_" + 3) : 0) + rs.getInt("t3"));
						mm.put(menuType.getId() + "_" + 4, (mm.get(menuType.getId() + "_" + 4) != null ? mm.get(menuType.getId() + "_" + 4) : 0) + rs.getInt("t4"));
						mm.put(menuType.getId() + "_" + 5, (mm.get(menuType.getId() + "_" + 5) != null ? mm.get(menuType.getId() + "_" + 5) : 0) + rs.getInt("t5"));
						mm.put(menuType.getId() + "_" + 6, (mm.get(menuType.getId() + "_" + 6) != null ? mm.get(menuType.getId() + "_" + 6) : 0) + rs.getInt("t6"));
						mm.put(menuType.getId() + "_" + 7, (mm.get(menuType.getId() + "_" + 7) != null ? mm.get(menuType.getId() + "_" + 7) : 0) + rs.getInt("t7"));
						mm.put(menuType.getId() + "_" + 8, (mm.get(menuType.getId() + "_" + 8) != null ? mm.get(menuType.getId() + "_" + 8) : 0) + rs.getInt("t8"));
						mm.put(menuType.getId() + "_0", (mm.get(menuType.getId() + "_0") != null ? mm.get(menuType.getId() + "_0") : 0) + rs.getInt("pat_count"));
						rows.add(row);
					}
				}
				ps = conn.prepareStatement(
					"Select (Select Count(*) From Patients d, Rooms c Where c.id = d.Room_Id And c.roomType = 6 And d.dept_id = t.id And d.State = 'LV' And d.Date_Begin != ?) Sim_Count, " +
						"					(Select Count(*) From Patients d, Rooms c Where c.id = d.Room_Id And c.roomType = 6 And d.dept_id = t.id And d.Date_Begin = DATE_ADD(?, INTERVAL -1 DAY)) Reg_Sim_Count, " +
						"					(Select Count(*) From Patients d, Rooms c Where c.id = d.Room_Id And c.roomType = 6 And d.dept_id = t.id And d.Date_End = DATE_ADD(?, INTERVAL -1 DAY)) Out_Sim_Count, " +
						"					(Select Count(*) From Patients d, Rooms c Where c.id = d.Room_Id And c.roomType != 6 And d.dept_id = t.id And d.State = 'LV' And d.Date_Begin != ?) Ly_Count, " +
						"					(Select Count(*) From Patients d, Rooms c Where c.id = d.Room_Id And c.roomType != 6 And d.dept_id = t.id And d.Date_Begin = DATE_ADD(?, INTERVAL -1 DAY)) Reg_Ly_Count, " +
						"					(Select Count(*) From Patients d, Rooms c Where c.id = d.Room_Id And c.roomType != 6 And d.dept_id = t.id And d.Date_End = DATE_ADD(?, INTERVAL -1 DAY)) Out_Ly_Count, " +
						"					(Select Count(*) From Patients d Where d.dept_id = t.id And d.State = 'LV' And d.Date_Begin != ?) All_Count, " +
						"					(Select Count(*) From Patients d Where d.dept_id = t.id And d.Date_Begin = DATE_ADD(?, INTERVAL -1 DAY)) Reg_All_Count, " +
						"					(Select Count(*) From Patients d Where d.dept_id = t.id And d.Date_End = DATE_ADD(?, INTERVAL -1 DAY)) Out_All_Count " +
						"	   From Depts t " +
						"		Where t.id = ? "
				);
				ps.setString(1, Util.dateDB(Util.get(req, "period")));
				ps.setString(2, Util.dateDB(Util.get(req, "period")));
				ps.setString(3, Util.dateDB(Util.get(req, "period")));
				ps.setString(4, Util.dateDB(Util.get(req, "period")));
				ps.setString(5, Util.dateDB(Util.get(req, "period")));
				ps.setString(6, Util.dateDB(Util.get(req, "period")));
				ps.setString(7, Util.dateDB(Util.get(req, "period")));
				ps.setString(8, Util.dateDB(Util.get(req, "period")));
				ps.setString(9, Util.dateDB(Util.get(req, "period")));
				ps.setInt(10, dept.getId());
				rs = ps.executeQuery();
				while (rs.next()) {
					ObjList row = new ObjList();
					row.setC1(dept.getName());
					row.setC2(rs.getString("reg_sim_count"));
					row.setC3(rs.getString("out_sim_count"));
					row.setC4(rs.getString("sim_count"));
					row.setC5(rs.getString("reg_ly_count"));
					row.setC6(rs.getString("out_ly_count"));
					row.setC7(rs.getString("ly_count"));
					row.setC8(rs.getString("reg_all_count"));
					row.setC9(rs.getString("out_all_count"));
					row.setC10(rs.getString("all_count"));
					dds.add(row);
				}
			}
			for(String key: keys.keySet()) {
				ObjList row = new ObjList();
				row.setC1("B");
				row.setC2(keys.get(key));
				row.setC3("");
				row.setC4(mm.get(key + "_0") + "");
				row.setC5(mm.get(key + "_" + 1) + "");
				row.setC6(mm.get(key + "_" + 2) + "");
				row.setC7(mm.get(key + "_" + 3) + "");
				row.setC8(mm.get(key + "_" + 4) + "");
				row.setC9(mm.get(key + "_" + 5) + "");
				row.setC10(mm.get(key + "_" + 6) + "");
				row.setC11(mm.get(key + "_" + 7) + "");
				row.setC12(mm.get(key + "_" + 8) + "");
				rows.add(row);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		m.addAttribute("dds", dds);
		// Параметры отчета
		m.addAttribute("params", params);
	}

	// Отчет по пациентам (Амбулатория)
	private void rep57(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null, rc = null;
		List<ObjList> rows = new ArrayList<ObjList>();
		//
		Date date = Util.getDate(req, "period");
		String params = "" + ("Параметры: За дату: " + Util.dateToString(date));
		try {
			List<AmbGroups> types = dAmbGroup.getAll();
			ps = conn.prepareStatement(
				"Select t.Id, " +
					" 			  Date_Format(Max(t.crOn), '%d.%m.%Y') confDate " +
					"		 From Amb_Patients t, Amb_Patient_Services c " +
					"		Where t.id = c.patient " +
					"     And c.confDate between ? And ? " +
					"		Group By t.id "
			);
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			while(rs.next()) {
				ObjList row = new ObjList();
				AmbPatients d = dAmbPatient.get(rs.getInt("id"));
				row.setC1(d.getSurname() + " " + d.getName() + " " + d.getMiddlename());
				row.setC2(d.getBirthyear() + "");
				row.setC3(rs.getString("confDate") + "");
				for(AmbGroups type : types) {
					ps = conn.prepareStatement(
						"Select c.name " +
							"    From Amb_Patient_Services t, Amb_Services c " +
							"   Where t.service_id = c.id " +
							"     And t.patient = ? " +
							"     And t.confDate between ? And ? " +
							"     And c.group_id = ? "
					);
					ps.setInt(1, rs.getInt("id"));
					ps.setString(2, Util.dateDB(Util.get(req, "period_start")));
					ps.setString(3, Util.dateDB(Util.get(req, "period_end")));
					ps.setInt(4, type.getId());
					rc = ps.executeQuery();
					int i = 1;
					while (rc.next()) {
						if(type.getId() == 1)  row.setC10((row.getC10() == null ? "" : row.getC10()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 2)  row.setC11((row.getC11() == null ? "" : row.getC11()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 3)  row.setC12((row.getC12() == null ? "" : row.getC12()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 4)  row.setC13((row.getC13() == null ? "" : row.getC13()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 5)  row.setC14((row.getC14() == null ? "" : row.getC14()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 6)  row.setC15((row.getC15() == null ? "" : row.getC15()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 7)  row.setC16((row.getC16() == null ? "" : row.getC16()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 8)  row.setC17((row.getC17() == null ? "" : row.getC17()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 9)  row.setC18((row.getC18() == null ? "" : row.getC18()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 10) row.setC19((row.getC19() == null ? "" : row.getC19()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 11) row.setC20((row.getC20() == null ? "" : row.getC20()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 12) row.setC21((row.getC21() == null ? "" : row.getC21()) + " " + i + "." + rc.getString("name"));
						i++;
					}
					DB.done(rc);
				}
				rows.add(row);
			}
			m.addAttribute("types", types);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
			DB.done(rc);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}

	// Отчет по пациентам (Стационар)
	private void rep58(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null, rc = null;
		List<ObjList> rows = new ArrayList<ObjList>();
		//
		Date date = Util.getDate(req, "period");
		String params = "" + ("Параметры: За дату: " + Util.dateToString(date));
		try {
			List<AmbGroups> types = dAmbGroup.getAll();
			ps = conn.prepareStatement(
				"Select t.Id, " +
					" 			  Date_Format(Max(t.crOn), '%d.%m.%Y') confDate " +
					"		 From Amb_Patients t, Amb_Patient_Services c " +
					"		Where t.id = c.patient " +
					"     And c.confDate between ? And ? " +
					"		Group By t.id "
			);
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			while(rs.next()) {
				ObjList row = new ObjList();
				AmbPatients d = dAmbPatient.get(rs.getInt("id"));
				row.setC1(d.getSurname() + " " + d.getName() + " " + d.getMiddlename());
				row.setC2(d.getBirthyear() + "");
				row.setC3(rs.getString("confDate") + "");
				for(AmbGroups type : types) {
					ps = conn.prepareStatement(
						"Select c.name " +
							"    From Amb_Patient_Services t, Amb_Services c " +
							"   Where t.service_id = c.id " +
							"     And t.patient = ? " +
							"     And t.confDate between ? And ? " +
							"     And c.group_id = ? "
					);
					ps.setInt(1, rs.getInt("id"));
					ps.setString(2, Util.dateDB(Util.get(req, "period_start")));
					ps.setString(3, Util.dateDB(Util.get(req, "period_end")));
					ps.setInt(4, type.getId());
					rc = ps.executeQuery();
					int i = 1;
					while (rc.next()) {
						if(type.getId() == 1)  row.setC10((row.getC10() == null ? "" : row.getC10()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 2)  row.setC11((row.getC11() == null ? "" : row.getC11()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 3)  row.setC12((row.getC12() == null ? "" : row.getC12()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 4)  row.setC13((row.getC13() == null ? "" : row.getC13()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 5)  row.setC14((row.getC14() == null ? "" : row.getC14()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 6)  row.setC15((row.getC15() == null ? "" : row.getC15()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 7)  row.setC16((row.getC16() == null ? "" : row.getC16()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 8)  row.setC17((row.getC17() == null ? "" : row.getC17()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 9)  row.setC18((row.getC18() == null ? "" : row.getC18()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 10) row.setC19((row.getC19() == null ? "" : row.getC19()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 11) row.setC20((row.getC20() == null ? "" : row.getC20()) + " " + i + "." + rc.getString("name"));
						if(type.getId() == 12) row.setC21((row.getC21() == null ? "" : row.getC21()) + " " + i + "." + rc.getString("name"));
						i++;
					}
					DB.done(rc);
				}
				rows.add(row);
			}
			m.addAttribute("types", types);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
			DB.done(rc);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Отчет по RW
	private void rep59(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<Rep1> rows = new ArrayList<Rep1>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		Integer dept = Util.getNullInt(req, "dept");
		params += "Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate) + " Отделение: " + (dept == null ? "Все" : dDept.get(Util.getInt(req, "dept")).getName()) ;
		List<ObjList> patients = new ArrayList<ObjList>();
		Rep1 r = new Rep1();
		try {
			ps = conn.prepareStatement(
				" Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
					"  			 Date_Format(ser.result_date, '%d.%m.%Y') result_date, " +
					"				 p.yearNum, " +
					"				 p.Start_Diagnoz, " +
					"        p.birthyear, " +
					"        t.c24 " +
					"   From F13 t, Lv_Plans ser, Patients p " +
					"  Where ser.Id = t.Plan_Id " +
					"    And p.Id = t.PatientId " +
					(dept == null ? "" : "    And p.Dept_Id = " + dept + " ") +
					"    And ser.Done_Flag = 'Y' " +
					" 	 And date (ser.result_date) Between ? and ? " +
					(dept == null ?
					" Union All " +
					" Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
					"  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
					"			   '' yearNum, "+
					"			   '' start_diagnoz, "+
					"        p.birthyear, " +
					"				 r.c1 " +
					"   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p, Amb_Results r " +
					"  Where ser.Id = t.Service_Id " +
					"    And t.result = r.id " +
					"    And p.Id = t.Patient " +
					"    And ser.id = 65 " +
					" 	 And date (t.confDate) Between '" + Util.dateDB(Util.get(req, "period_start")) + "' and '" + Util.dateDB(Util.get(req, "period_end")) + "'" : "")
			);
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			while (rs.next()) {
				if(rs.getString("c24") != null && rs.getString("c24").length() > 0) {
					ObjList service = new ObjList();
					service.setC28(rs.getString("fio"));
					service.setC29(rs.getString("birthyear"));
					service.setC30(rs.getString("result_date"));
					service.setC1(rs.getString("yearNum"));
					service.setC2(rs.getString("Start_Diagnoz"));
					service.setC24(rs.getString("c24"));
					patients.add(service);
				}
			}
			r.setServices(patients);
			if(r.getServices() != null && r.getServices().size() > 0)
				rows.add(r);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
	// Приемный (Годовой отчет по пациентам)
	private void rep60(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<ObjList> rows = new ArrayList<ObjList>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		String params = "" + ("Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate));
		try {
			ps = conn.prepareStatement(
				" Select Concat(t.surname, ' ',  t.name, ' ', t.middlename) Fio, " +
					" (Select con.Name From counteries con WHERE con.id = t.counteryId) Country, " +
					" (Select reg.Name From Regions reg Where reg.Id = t.RegionId) Region_Name, " +
					" (Select dp.name From Depts dp Where dp.Id = t.dept_id) dept, " +
					" (Select u.fio From Users u Where u.Id = t.lv_id) lv, " +
					" (Select Sum(pp.cash + pp.transfer + pp.card) From Patient_Pays pp Where pp.patient_id = t.id) summ," +
					" (Select Date_Format(max(pp.crOn), '%d.%m.%Y') From Patient_Pays pp Where pp.patient_id = t.id) pay_date," +
					" (Select Concat(cc.name, ' - ', dd.name) From Rooms cc, Dicts dd Where dd.id = cc.roomType And cc.id = t.room_id) room_type, " +
					" t.tel, " +
					" Date_Format(t.date_begin, '%d.%m.%Y') date_begin, " +
					" Date_Format(t.date_end, '%d.%m.%Y') date_end, " +
					" t.birthyear, " +
					" t.address, " +
					" t.passportInfo, " +
					" t.Start_Diagnoz, " +
					" t.yearNum " +
					" From Patients t  " +
					" Where date (t.Date_Begin) Between ? And ? " +
					" Order By t.date_begin"
			);
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			while (rs.next()) {
				ObjList service = new ObjList();
				service.setFio(rs.getString("fio"));
				service.setBirthyear(rs.getString("birthyear"));
				service.setDate(rs.getString("date_begin"));
				service.setC1(rs.getString(2));
				service.setC2(rs.getString(3));
				service.setC3(rs.getString(4));
				service.setC4(rs.getString("start_diagnoz"));
				service.setC5(rs.getString("yearnum"));
				service.setC6(rs.getString("address"));
				service.setC7(rs.getString("passportInfo"));
				service.setC8(rs.getString("dept") + " " + rs.getString("room_type"));
				service.setC9(rs.getString("date_end"));
				service.setC10(rs.getString("lv"));
				rows.add(service);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}

	// Детальный отчет по стандартным формам
	private void rep61(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null, rc = null;
		List<Obj> rows = new ArrayList<Obj>(), krows = new ArrayList<Obj>();
		List<Obj> ss = new ArrayList<Obj>(), kss = new ArrayList<Obj>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		int cat = Util.getInt(req, "cat");
		String params = "" + ("Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate));
		try {
			if(cat == 1) {
				ps = conn.prepareStatement(
					" Select s.id, " +
						" 			   s.name " +
						" 	  From Amb_Patients t, Amb_Patient_Services c, Amb_Services s  " +
						" 	 Where date (t.Reg_Date) Between ? And ? " +
						"   	 And s.id = c.service_id " +
						"    	 And c.patient = t.id " +
						"   	 And c.state = 'DONE' " +
						"   	 And ifnull(c.result, 0) > 0 " +
						"    	 And s.Form_Id in (777, 888)" +
						" 	 Group By s.id "
				);
				ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
				ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
				rs = ps.executeQuery();
				while (rs.next()) {
					Obj service = new Obj();
					service.setId(rs.getInt("id"));
					service.setName(rs.getString("name"));
					ss.add(service);
				}
				ps = conn.prepareStatement(
					" Select Concat(Max(t.surname), ' ',  Max(t.name), ' ', Max(t.middlename)) Fio, " +
						" 			   Date_Format(max(t.Reg_Date), '%d.%m.%Y') reg_date, " +
						"				   t.Id Patient " +
						"     From Amb_Patients t, Amb_Patient_Services c, Amb_Services s  " +
						" 	 Where date (t.Reg_Date) Between ? And ? " +
						"   	 And s.id = c.service_id " +
						"   	 And c.patient = t.id " +
						"   	 And s.Form_Id in (777, 888)" +
						"    Group By t.id " +
						" 	 Order By t.Id"
				);
				ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
				ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
				rs = ps.executeQuery();
				while (rs.next()) {
					LinkedHashMap<Integer, String> rws = new LinkedHashMap<Integer, String>();
					Obj row = new Obj();
					row.setFio(rs.getString("fio"));
					row.setName(rs.getString("reg_date"));
					for (Obj s : ss) {
						ps = conn.prepareStatement(
							" Select t.c1 " +
								" 	  From Amb_Results t, Amb_Patient_Services c, Amb_Services s  " +
								" 	 Where s.id = c.service_id " +
								"   	 And t.id = c.result " +
								"   	 And c.patient = ? " +
								"   	 And s.id = ? "
						);
						ps.setInt(1, rs.getInt("patient"));
						ps.setInt(2, s.getId());
						rc = ps.executeQuery();
						while (rc.next()) rws.put(s.getId(), rc.getString("c1"));
					}
					row.setRows(rws);
					rows.add(row);
				}
			}
			// Стационар
			if(cat == 2) {
				ps = conn.prepareStatement(
					" Select s.id, " +
						" 			   s.name " +
						" 	  From Patients t, Lv_Plans c, Kdos s  " +
						" 	 Where date (t.date_end) Between ? And ? " +
						"   	 And s.id = c.kdo_id " +
						"    	 And c.patientId = t.id " +
						"   	 And c.done_flag = 'Y' " +
						"   	 And ifnull(c.result_id, 0) > 0 " +
						"    	 And s.FormId in (777, 888)" +
						" 	 Group By s.id "
				);
				ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
				ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
				rs = ps.executeQuery();
				while (rs.next()) {
					Obj service = new Obj();
					service.setId(rs.getInt("id"));
					service.setName(rs.getString("name"));
					kss.add(service);
				}
				ps = conn.prepareStatement(
					" Select Concat(Max(t.surname), ' ',  Max(t.name), ' ', Max(t.middlename)) Fio, " +
						" 			   Date_Format(max(t.date_end), '%d.%m.%Y') reg_date, " +
						"				   t.Id Patient " +
						"     From Patients t, Lv_Plans c, Kdos s  " +
						" 	 Where date (t.date_end) Between ? And ? " +
						"   	 And s.id = c.kdo_id " +
						"   	 And ifnull(c.result_id, 0) > 0 " +
						"   	 And c.patientId = t.id " +
						"   	 And s.FormId in (777, 888)" +
						"    Group By t.id " +
						" 	 Order By t.Id"
				);
				ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
				ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
				rs = ps.executeQuery();
				while (rs.next()) {
					LinkedHashMap<Integer, String> rws = new LinkedHashMap<Integer, String>();
					Obj row = new Obj();
					row.setFio(rs.getString("fio"));
					row.setName(rs.getString("reg_date"));
					for (Obj s : kss) {
						ps = conn.prepareStatement(
							" Select t.c1 " +
								" 	  From f999 t, lv_plans c, kdos s  " +
								" 	 Where s.id = c.kdo_id " +
								"   	 And t.id = c.result_Id " +
								"   	 And c.patientId = ? " +
								"   	 And s.id = ? "
						);
						ps.setInt(1, rs.getInt("patient"));
						ps.setInt(2, s.getId());
						rc = ps.executeQuery();
						while (rc.next()) rws.put(s.getId(), rc.getString("c1"));
					}
					row.setRows(rws);
					krows.add(row);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(rc);
			DB.done(rs);
			DB.done(ps);
			DB.done(conn);
		}
		m.addAttribute("services", ss);
		m.addAttribute("kdos", kss);
		m.addAttribute("rows", rows);
		m.addAttribute("krows", krows);
		// Параметры отчета
		m.addAttribute("params", params);
	}

	// Приемный (Годовой отчет по пациентам)
	private void rep62(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<ObjList> rows = new ArrayList<ObjList>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		String params = "" + ("Параметры: Период: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate));
		try {
			ps = conn.prepareStatement(
				"Select t.name, Sum(Case When t.sex_id = 12 Then t.counter else 0 End) Sex_12, Sum(Case When t.sex_id = 13 Then t.counter else 0 End) Sex_13 From (" +
					  "Select d.name, t.sex_id, Count(*) counter" +
						"  From Patients t, Lv_Form_4 c, Mkb d  " +
						" Where date (t.Date_End) Between ? And ? " +
					  "   And c.patient_id = t.id " +
						"		And d.id = c.mkb_id " +
						" Group By d.name, t.sex_id) t Group By t.name "
			);
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			while (rs.next()) {
				ObjList service = new ObjList();
				service.setC1(rs.getString("name"));
				service.setC2(rs.getString("sex_12"));
				service.setC3(rs.getString("sex_13"));
				rows.add(service);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// Параметры отчета
		m.addAttribute("params", params);
	}
}
