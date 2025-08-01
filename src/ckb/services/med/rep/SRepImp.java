package ckb.services.med.rep;

import ckb.dao.admin.country.DCountry;
import ckb.dao.admin.depts.DDept;
import ckb.dao.admin.dicts.DLvPartner;
import ckb.dao.admin.params.DParam;
import ckb.dao.admin.reports.DReport;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.amb.DAmbGroup;
import ckb.dao.med.amb.DAmbPatient;
import ckb.dao.med.drug.dict.manufacturer.DDrugManufacturer;
import ckb.dao.med.drug.out.DDrugOut;
import ckb.dao.med.drug.out.DDrugOutRow;
import ckb.dao.med.eat.dict.menuTypes.DEatMenuType;
import ckb.dao.med.head_nurse.patient.DHNPatient;
import ckb.dao.med.lv.bio.DLvBio;
import ckb.dao.med.lv.coul.DLvCoul;
import ckb.dao.med.lv.fizio.DLvFizio;
import ckb.dao.med.lv.fizio.DLvFizioDate;
import ckb.dao.med.lv.garmon.DLvGarmon;
import ckb.dao.med.lv.plan.DKdoChoosen;
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
import ckb.domains.med.drug.DrugOuts;
import ckb.domains.med.drug.dict.DrugManufacturers;
import ckb.domains.med.eat.dict.EatMenuTypes;
import ckb.domains.med.head_nurse.HNPatients;
import ckb.domains.med.lv.*;
import ckb.domains.med.patient.PatientWatchers;
import ckb.domains.med.patient.Patients;
import ckb.models.Obj;
import ckb.models.ObjList;
import ckb.models.reports.Rep1;
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

	Date startDate = Util.stringToDate("31.03.2024");

	@Autowired private DAmbGroup dAmbGroup;
	@Autowired private DReport dReport;
	@Autowired private DUser dUser;
	@Autowired private DCountry dCountry;
	@Autowired private DParam dParam;
	//
	@Autowired private DPatientWatchers dPatientWatchers;
	@Autowired private DLvFizio dLvFizio;
	@Autowired private DLvFizioDate dLvFizioDate;
	@Autowired private DLvPlan dLvPlan;
	@Autowired private DPatient dPatient;
	@Autowired private DAmbPatient dAmbPatient;
	@Autowired private DLvBio dLvBio;
	@Autowired private DLvCoul dLvCoul;
	@Autowired private DLvGarmon dLvGarmon;
	@Autowired private DLvTorch dLvTorch;
	@Autowired private DDept dDept;
	@Autowired private DHNPatient dhnPatient;
	@Autowired private DLvPartner dLvPartner;
	@Autowired private DDrugManufacturer dDrugManufacturer;
	@Autowired private DEatMenuType dEatMenuType;
	@Autowired private DDrugOutRow dDrugOutRow;
	@Autowired private DDrugOut dDrugOut;
	@Autowired private DKdoChoosen dKdoChoosen;

	@Override
	public void gRep(HttpServletRequest req, Model m) {
		int id = Util.getInt(req, "repId");
		m.addAttribute("rep", dReport.get(id));
		// ������������ ������ - �� ����������
		if(id == 1) { // ������������ ������ - �� ����������
			rep1(req, m);
		} else if (id == 2) { // ����� ����
			rep2(req, m);
		} else if (id == 3) { // ����������� ������
			rep3(req, m);
		} else if (id == 4) { // ������ �������(�����������)
			rep4(req, m);
		} else if (id == 5) { // ���������� ��������� �� ��������
			rep5(req, m);
    } else if (id == 6) { // ��������� ����������� (����, ���)
      rep6(req, m);
    } else if (id == 7) { // ��� ��
      rep7(req, m);
    } else if (id == 8) { // ��� �����������
      rep8(req, m);
    } else if (id == 9) { // ��������� �����������
      rep9(req, m);
    } else if (id == 10) { // ��� �����������
      rep10(req, m);
    } else if (id == 11) { // ������� �����������
      rep11(req, m);
    } else if (id == 12) { // ��� ���������
      rep12(req, m);
    } else if(id == 13) { // ��� ��� ������
      rep13(req, m);
    } else if(id == 14) { // ������������ (���������)
      rep14(req, m);
    } else if(id == 15) { // ����������������� (�����������)
      rep15(req, m);
    } else if(id == 16) { // �������� (���������)
      rep16(req, m);
    } else if(id == 17) { // ������ ��� ������� (���������)
      rep17(req, m);
    } else if(id == 18) { // ��� ������������ (���������)
      rep18(req, m);
    } else if(id == 19) { // ������� �������� ���� ��������� �������
      rep19(req, m);
    } else if(id == 20) { // ���� - ���
      rep20(req, m);
    } else if(id == 21) { // ������� ����������� ��������
      rep21(req, m);
    } else if(id == 22) { // TORCH ���������� ���������
      rep22(req, m);
    } else if(id == 23) { // ������ ����� �������
      rep23(req, m);
    } else if(id == 24) { // �������������
      rep24(req, m);
    } else if(id == 25) { // �������� ������
      rep25(req, m);
    } else if(id == 26) { // ����������� ������ ����� �������
      rep26(req, m);
    } else if(id == 27) { // ��������� ������ ����� �������
      rep27(req, m);
    } else if(id == 28) { // ��� ��������� �������������� �������
      rep28(req, m);
    } else if(id == 29) { // ������� ����������� (����, ���)
      rep29(req, m);
    } else if(id == 30) { // ��� ����������� (����, ���)
      rep30(req, m);
    } else if(id == 31) { // ������ ����������� (����, ���)
      rep31(req, m);
    } else if(id == 32) { // ������������ (���)
      rep32(req, m);
    } else if(id == 33) { // ��� ������������ (���)
      rep33(req, m);
    } else if(id == 34) { // ��� ������������ (���)
			rep34(req, m);
		} else if(id == 35) { // ����������� �����
			rep35(req, m);
		} else if(id == 36) { // �������� (�����������)
			rep36(req, m);
		} else if(id == 37) { // ������� ����������� �������� (�����������)
			rep37(req, m);
		} else if(id == 38) { // TORCH ���������� ��������� (�����������)
			rep38(req, m);
		} else if(id == 39) { // ������������� (�����������)
			rep39(req, m);
		} else if(id == 41) { // ��� ��������� �������������� �������
			rep41(req, m);
		} else if(id == 42) { // ����� ������ ����� 21 ��������
			rep42(req, m);
		} else if(id == 43) { // ������� �������� ���� ��������� �������
			rep43(req, m);
		} else if(id == 44) { // ����������� ������ ����� �������
			rep44(req, m);
		} else if(id == 45) { // ��������� ������ ����� �������
			rep45(req, m);
		} else if(id == 46) { // ������ ����������������� �����
			rep46(req, m);
		} else if(id == 47) { // ����� ������ ����
			rep47(req, m);
		} else if(id == 48) { // ������ ����������������� ����� (���������)
			rep48(req, m);
		} else if(id == 49) { // ������� ����� �� ������� ��������� (���������)
			rep49(req, m);
		} else if(id == 50) { // ���� ������������ �� ���� ����
			rep50(req, m);
		} else if(id == 51) { // ���������� ������ ��������
			rep51(req, m);
		} else if(id == 52) { // ����� �� ���������
			rep52(req, m);
		} else if(id == 53) { // ������ �� ���������
			rep53(req, m);
		} else if(id == 54) { // ������ �� �������
			rep54(req, m);
		} else if(id == 55) { // ������ �� �������
			rep55(req, m);
		} else if(id == 56) { // ������� ����� (�������)
			rep56(req, m);
		} else if(id == 57) { // ����� �� ��������� (�����������)
			rep57(req, m);
		} else if(id == 58) { // ����� �� ��������� (�����������)
			rep57(req, m);
		} else if(id == 59) { // ����� �� RW
			rep59(req, m);
		} else if(id == 60) { // �������� (�������)
			rep60(req, m);
		} else if(id == 61) { // ��������� ����� �� �������
			rep61(req, m);
		} else if(id == 62) { // ����� �� ��� 10 �� ������
			rep62(req, m);
		} else if(id == 63) { // ������� ����������� (����, ���)
			rep63(req, m);
		} else if(id == 64) { // ��������� (������)
			rep64(req, m);
		} else if(id == 65) { // ��������� (������)
			rep65(req, m);
		} else if(id == 66) { // ��������� (������)
			rep66(req, m);
		} else if(id == 67) { // �����������
			rep67(req, m);
		} else if(id == 68) { // ���������
			rep68(req, m);
		}
	}
	// ������������ ������ - �� ����������
	private void rep1(HttpServletRequest req, Model m) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<Rep1> rows = new ArrayList<>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		try {
			conn = DB.getConnection();
			List<AmbGroups> groups = dAmbGroup.getAll();
			int counter = 0;

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
						"  And c.State = 'DONE' " +
						"  And date(c.crOn) Between ? And ? " +
						"GROUP BY s.Name, c.Worker_Id " +
						"Order By c.Worker_id"
				);
				ps.setInt(1, group.getId());
				ps.setString(2, Util.dateDB(Util.get(req, "period_start")));
				ps.setString(3, Util.dateDB(Util.get(req, "period_end")));
				rs = ps.executeQuery();
				List<ObjList> services = new ArrayList<>();
				int groupCounter = 0;
				while(rs.next()) {
					ObjList service = new ObjList();
					int serCount = rs.getInt(2);
					service.setC1(rs.getString(1));
					service.setC2("" + serCount);
					service.setC3(rs.getString(3));
					groupCounter += serCount;
					services.add(service);
				}
				counter += groupCounter;
				r.setServices(services);
				r.setCounter(groupCounter);
				if(!services.isEmpty())
					rows.add(r);
			}
			Rep1 total = new Rep1();
			total.setGroupName("����� �� ����");
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ����� ����
	private void rep2(HttpServletRequest req, Model m) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<Rep1> rows = new ArrayList<>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		String dateBegin = Util.dateDB(Util.get(req, "period_start"));
		String dateEnd = Util.dateDB(Util.get(req, "period_end"));
		Integer deptId = !req.getParameter("dept").isEmpty() ? Util.getInt(req, "dept") : null;
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		Integer total = 0;
		// ���� ������ ����
		if (!req.getParameter("doctor").isEmpty()) {
			Integer doctorId = Util.getInt(req, "doctor");
			Users user = dUser.get(doctorId);
			List<ObjList> patients = new ArrayList<>();
			Rep1 r = new Rep1();
			r.setGroupName(user.getFio());
			try {
				conn = DB.getConnection();
				String sql = "Select Concat(t.surname, ' ',  t.name, ' ', t.middlename) Fio , " +
					"				 (Select dept.name From Depts dept Where dept.Id = t.Dept_Id) depName, " +
					"				 (Select concat(f.Name, ' - ', ff.name)  From Rooms f, Dicts ff Where ff.typeCode = 'roomType' And ff.id = f.roomType And f.id = t.Room_Id) Palata, " +
					"				 Date_Format(t.Date_Begin, '%d.%m.%Y') dateBegin, " +
					"				 Date_Format(d.dateEnd, '%d.%m.%Y') dateEnd, " +
					"				 Datediff(d.dateEnd, t.Date_Begin) + 1 bunkDay," +
					"				 1 Row_Type," +
					"		     (Select Count(*) From Lv_Epics f Where f.patientid = t.id) Epic_Count," +
					"			   Date_Format(t.Start_Epic_Date, '%d.%m.%Y') epic_date," +
					"				 Datediff(date(d.dateEnd), date(t.Start_Epic_Date)) extraDay " +
					"   From Patients t, Hn_Patients d" +
					"  Where d.dateEnd Is Not Null" +
					"    AND t.lv_id != 1 " +
					"    And d.patient_id = t.id " +
					"    And d.dateEnd Between '" + dateBegin + "' And '" + dateEnd + "'" +
					(deptId != null ? " And t.Dept_Id = " + deptId : "") +
					(doctorId != null ? " And t.Lv_Id = " + doctorId : "") +
					" Union All " +
					"Select Concat(p.surname, ' ',  p.name, ' ', p.middlename, ' (�������)') Fio , " +
					"				 (Select dept.name From Depts dept Where dept.Id = p.Dept_Id) depName, " +
					"				 (Select concat(f.Name, ' - ', ff.name)  From Rooms f, Dicts ff Where ff.typeCode = 'roomType' And ff.id = f.roomType And f.id = e.Room_Id) Palata, " +
					"				 (Case When e.dateBegin Is Not Null Then DATE_FORMAT(e.dateBegin, '%d.%m.%Y') Else Date_Format(p.Start_Epic_Date, '%d.%m.%Y') End) dateBegin, " +
					"				 Date_Format(e.dateEnd, '%d.%m.%Y') dateEnd, " +
					"				 (Case When e.dateBegin Is Not Null Then Datediff(e.dateEnd, e.dateBegin) Else Datediff(e.dateEnd, p.Start_Epic_Date) End) bunkDay ," +
					"				 0 Row_Type," +
					"		     0 Epic_Count," +
					" 		   null epic_date, " +
					" 		   null extraDay " +
					"   From Lv_Epics e, Patients p " +
					"  Where e.dateEnd Between '" + dateBegin + "' And '" + dateEnd + "'" +
					"    And date(e.dateEnd) != date(e.dateBegin) " +
					"    AND p.lv_id != 1 " +
					" 	 And e.patientId = p.Id " +
					(deptId != null ? " And e.DeptId = " + deptId : "") +
					" And e.LvId = " + doctorId;
				ps = conn.prepareStatement(
					sql
				);
				rs = ps.executeQuery();
				while (rs.next()) {
					ObjList service = new ObjList();
					service.setC1(rs.getString("Fio"));
					service.setC2(rs.getString("depName"));
					service.setC3(rs.getString("Palata"));
					service.setC4(rs.getString("dateBegin"));
					service.setC5(rs.getString("dateEnd"));
					service.setC6(rs.getString("bunkDay"));
					if(rs.getInt("Row_Type") > 0 && rs.getInt("Epic_Count") > 0) {
						service.setC4(rs.getString("epic_date"));
						service.setC6(rs.getString("extraDay"));
					}
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

					String sql = "Select Concat(t.surname, ' ',  t.name, ' ', t.middlename) Fio , " +
						"				 (Select dept.name From Depts dept Where dept.Id = t.Dept_Id) depName, " +
						"				 (Select concat(f.Name, ' - ', ff.name)  From Rooms f, Dicts ff Where ff.typeCode = 'roomType' And ff.id = f.roomType And f.id = t.Room_Id) Palata, " +
						"				 Date_Format(t.Date_Begin, '%d.%m.%Y') dateBegin, " +
						"				 Date_Format(d.dateEnd, '%d.%m.%Y') dateEnd, " +
						"				 Datediff(d.dateEnd, t.Date_Begin) + 1 bunkDay," +
						"				 1 Row_Type," +
						"		     (Select Count(*) From Lv_Epics f Where f.patientid = t.id) Epic_Count," +
						"			   Date_Format(t.Start_Epic_Date, '%d.%m.%Y') epic_date," +
						"				 Datediff(date(d.dateEnd), date(t.Start_Epic_Date)) extraDay " +
						"   From Patients t, Hn_Patients d" +
						"  Where d.dateEnd Is Not Null" +
						"    AND t.lv_id != 1 " +
						"    And d.patient_id = t.id " +
						"    And d.dateEnd Between '" + dateBegin + "' And '" + dateEnd + "'" +
						(deptId != null ? " And t.Dept_Id = " + deptId : "") +
						" And t.Lv_Id = " + user.getId() +
						" Union All " +
						"Select Concat(p.surname, ' ',  p.name, ' ', p.middlename, ' (�������)') Fio , " +
						"				 (Select dept.name From Depts dept Where dept.Id = p.Dept_Id) depName, " +
						"				 (Select concat(f.Name, ' - ', ff.name)  From Rooms f, Dicts ff Where ff.typeCode = 'roomType' And ff.id = f.roomType And f.id = e.Room_Id) Palata, " +
						"				 (Case When e.dateBegin Is Not Null Then DATE_FORMAT(e.dateBegin, '%d.%m.%Y') Else Date_Format(p.Start_Epic_Date, '%d.%m.%Y') End) dateBegin, " +
						"				 Date_Format(e.dateEnd, '%d.%m.%Y') dateEnd, " +
						"				 (Case When e.dateBegin Is Not Null Then Datediff(e.dateEnd, e.dateBegin) Else Datediff(e.dateEnd, p.Start_Epic_Date) End) bunkDay ," +
						"				 0 Row_Type," +
						"		     0 Epic_Count," +
						" 		   null epic_date, " +
						" 		   null extraDay " +
						"   From Lv_Epics e, Patients p " +
						"  Where e.dateEnd Between '" + dateBegin + "' And '" + dateEnd + "'" +
						"    And date(e.dateEnd) != date(e.dateBegin) " +
						"    AND p.lv_id != 1 " +
						" 	 And p.Lv_Id = " + user.getId() +
						" 	 And e.patientId = p.Id " +
					(deptId != null ? " And e.DeptId = " + deptId : "");
					ps = conn.prepareStatement(sql);
					rs = ps.executeQuery();
					List<ObjList> services = new ArrayList<>();
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
					// ���� ���� ������
					if(!services.isEmpty()) {
						ObjList service = new ObjList();
						service.setC1("���-�� �� ����� " + counter);
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
				if(!rows.isEmpty()) {
					List<ObjList> services = new ArrayList<>();
					ObjList service = new ObjList();
					Rep1 r = new Rep1();
					service.setC1("����� �� �������");
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
    // ��������� ������
    m.addAttribute("params", params);
	}
  // ������ ������ - ����������� ������
  private void rep3(HttpServletRequest req, Model m) {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<AmbGroups> groups = new ArrayList<>();
    if (!req.getParameter("group").isEmpty()) {
      Integer groupId = Util.getInt(req, "group");
      AmbGroups group = dAmbGroup.get(groupId);
      groups.add(group);
    } else
      groups = dAmbGroup.getAll();
    for (AmbGroups group : groups) {
      List<ObjList> patients = new ArrayList<>();
      Rep1 r = new Rep1();
      r.setGroupName(group.getName());
      try {
				conn = DB.getConnection();
        ps = conn.prepareStatement(
          "Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
            "				 ser.Name Service_Name, " +
            "  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
            "				 '���' Type " +
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
        int counter = 0;
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
      if(r.getServices() != null && !r.getServices().isEmpty())
        rows.add(r);
    }
    m.addAttribute("rows", rows);
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ������ �������(�����������)
  private void rep4(HttpServletRequest req, Model m) {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
		String cat = Util.get(req, "cat");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate) + " ���������: " + (cat.equals("1") ? "�����������" : "���������");
    List<Users> doctors = new ArrayList<>();
    if (!req.getParameter("doctor").isEmpty()) {
      Integer doctorId = Util.getInt(req, "doctor");
      Users doctor = dUser.get(doctorId);
      doctors.add(doctor);
    } else {
			if(cat.equals("1")) {
				doctors = dUser.getList(
					"Select t From Users t, AmbServiceUsers s, AmbServices c " +
						"	Where t.id = s.user " +
						"	  And s.service = c.id " +
						"		And c.consul = 'Y'");
			} else {
				doctors = dUser.getAll();
			}
		}
    try {
			Double total = 0D;
			if(cat.equals("1")) {
				for (Users doctor : doctors) {
					List<ObjList> patients = new ArrayList<>();
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
					// ����� �� �����
					ObjList service = new ObjList();
					service.setC1("���-�� �����������: " + counter);
					service.setC2("" + summ);
					total += summ;
					service.setC6("TOTAL");
					patients.add(service);
					r.setServices(patients);
					if (r.getServices() != null && r.getServices().size() > 1)
						rows.add(r);
				}
			} else {
				for (Users doctor : doctors) {
					List<ObjList> patients = new ArrayList<>();
					Rep1 r = new Rep1();
					r.setGroupName(doctor.getFio());
					ps = conn.prepareStatement(
						"Select Date_Format(t.result_date, '%d.%m.%Y') CrOn," +
							"				  Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio , " +
							"				  ser.Name Service_Name, " +
							"				  t.Price Price, " +
							"				  gr.Name Group_Name," +
							"				  ser.id kdo_id," +
							"				  t.id " +
							"    From Lv_Plans t, Kdos ser, Kdo_Types gr, Patients p " +
							"   Where ser.Id = t.kdo_Id " +
							"     And p.Id = t.PatientId " +
							"		  And gr.Id = ser.Kdo_Type " +
							"	    And t.done_flag = 'Y' " +
							"		  And t.userId = " + doctor.getId() +
							" 	  And date (t.result_date) Between ? AND ? " +
							"   Order By ser.Kdo_Type, t.result_date "
					);
					ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
					ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
					rs = ps.executeQuery();
					Integer counter = 0;
					Double summ = 0D;
					while (rs.next()) {
						counter++;
						if(rs.getInt("kdo_id") == 120) {
							LvPlans pl = dLvPlan.get(rs.getInt("id"));
							Patients pat = dPatient.get(pl.getPatientId());
							List<KdoChoosens> choosens = dKdoChoosen.getList("From KdoChoosens Where kdo.id = " + pl.getKdo().getId() + " And (price > 0 Or for_price > 0)");
							if (pl.getKdo().getId() == 120) {
								LvGarmons bio = dLvGarmon.getByPlan(pl.getId());
								if (bio != null) {
									for(KdoChoosens choosen: choosens) {
										Double price = pat.getCounteryId() == 199 ? choosen.getPrice() : choosen.getFor_price();
										if(price > 0) {
											ObjList service = new ObjList();
											service.setC1(rs.getString(1));
											service.setC2(rs.getString(2));
											service.setC3(choosen.getName());
											service.setC5(rs.getString(5));
											service.setC4("" + price);
											summ += price;
											if ("1".equals(choosen.getColName()) && bio.isC1()) { patients.add(service); continue; }
											if ("2".equals(choosen.getColName()) && bio.isC2()) { patients.add(service); continue; }
											if ("3".equals(choosen.getColName()) && bio.isC3()) { patients.add(service); continue; }
											if ("4".equals(choosen.getColName()) && bio.isC4()) { patients.add(service); continue; }
											if ("5".equals(choosen.getColName()) && bio.isC5()) { patients.add(service); continue; }
											if ("6".equals(choosen.getColName()) && bio.isC6()) { patients.add(service); continue; }
											if ("7".equals(choosen.getColName()) && bio.isC7()) { patients.add(service); continue; }
											if ("8".equals(choosen.getColName()) && bio.isC8()) { patients.add(service); continue; }
											if ("9".equals(choosen.getColName()) && bio.isC9()) { patients.add(service); continue; }
											if ("10".equals(choosen.getColName()) && bio.isC10()) { patients.add(service); continue; }
											if ("11".equals(choosen.getColName()) && bio.isC11()) { patients.add(service); continue; }
											if ("12".equals(choosen.getColName()) && bio.isC12()) { patients.add(service); continue; }
											if ("13".equals(choosen.getColName()) && bio.isC13()) { patients.add(service); continue; }
											if ("14".equals(choosen.getColName()) && bio.isC14()) { patients.add(service); continue; }
											if ("15".equals(choosen.getColName()) && bio.isC15()) { patients.add(service); continue; }
											if ("16".equals(choosen.getColName()) && bio.isC16()) { patients.add(service); continue; }
											if ("17".equals(choosen.getColName()) && bio.isC17()) { patients.add(service); continue; }
											if ("18".equals(choosen.getColName()) && bio.isC18()) { patients.add(service); continue; }
											if ("19".equals(choosen.getColName()) && bio.isC19()) { patients.add(service); continue; }
											if ("20".equals(choosen.getColName()) && bio.isC20()) { patients.add(service); continue; }
											if ("21".equals(choosen.getColName()) && bio.isC21()) { patients.add(service); continue; }
											if ("22".equals(choosen.getColName()) && bio.isC22()) { patients.add(service); continue; }
											if ("23".equals(choosen.getColName()) && bio.isC23()) { patients.add(service); continue; }
											if ("24".equals(choosen.getColName()) && bio.isC24()) { patients.add(service); continue; }
											if ("25".equals(choosen.getColName()) && bio.isC25()) { patients.add(service); continue; }
											if ("26".equals(choosen.getColName()) && bio.isC26()) { patients.add(service); continue; }
											if ("27".equals(choosen.getColName()) && bio.isC27()) { patients.add(service); continue; }
											if ("28".equals(choosen.getColName()) && bio.isC28()) { patients.add(service); continue; }
											if ("29".equals(choosen.getColName()) && bio.isC29()) { patients.add(service); continue; }
											if ("30".equals(choosen.getColName()) && bio.isC30()) { patients.add(service); }
										}
									}
								}
							}
						} else {
							if(rs.getDouble(4) > 0) {
								ObjList service = new ObjList();
								service.setC1(rs.getString(1));
								service.setC2(rs.getString(2));
								service.setC3(rs.getString(3));
								service.setC4("" + rs.getDouble(4));
								summ += rs.getDouble(4);
								service.setC5(rs.getString(5));
								patients.add(service);
							}
						}
					}
					// ����� �� �����
					ObjList service = new ObjList();
					service.setC1("���-�� �����������: " + counter);
					service.setC2("" + summ);
					total += summ;
					service.setC6("TOTAL");
					patients.add(service);
					r.setServices(patients);
					if (r.getServices() != null && r.getServices().size() > 1)
						rows.add(r);
				}
			}
      if(!rows.isEmpty()) {
				List<ObjList> patients = new ArrayList<>();
				Rep1 r = new Rep1();
				ObjList service = new ObjList();
				service.setC1("����� �� �������");
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
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ���������� ��������� �� ��������
  private void rep5(HttpServletRequest req, Model m) {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<Counteries> countries = dCountry.getCounteries();
    for (Counteries country : countries) {
      List<ObjList> patients = new ArrayList<>();
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
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ��������� ����������� (����, ���)
  private void rep6(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<ObjList> rows = new ArrayList<>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		try {
			ps = conn.prepareStatement(
				"Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
					"         p.birthyear, " +
					"         Date_Format(t.Result_Date, '%d.%m.%Y') cr_on, " +
					"         f.c1 diagnoz, " +
					"         c.Name Service_Name, " +
					"         '����.' service_Type," +
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
          "				 '���' Service_Type, " +
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
		// ��������� ������
		m.addAttribute("params", params);
  }
  // ���, ���, ���
  private void rep7(HttpServletRequest req, Model m) {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<>();
    //
		String catStat = Util.get(req, "cat_stat");
		String catAmb = Util.get(req, "cat_amb");
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<>();
    Rep1 r = new Rep1();
    try {
      ps = conn.prepareStatement(
        "Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
          "         c.Name Service_Name, " +
          "         Date_Format(t.Result_Date, '%d.%m.%Y') cr_on, " +
          "         '����' Type, " +
          "         t.Result_Date " +
          " From Lv_Plans t, Kdos c, Patients p " +
          " Where t.Kdo_Id = c.id " +
          "   And t.patientId = p.id " +
					"   And t.done_flag = 'Y' " +
          "   And c.Kdo_Type = 10 " + (catStat.isEmpty() ? "" : " And c.id = " + catStat) +
          "   And date (t.Result_Date) Between ? AND ? " +
          " Union All " +
          " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "				 ser.Name Service_Name, " +
          "  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
          "				 '���' Type, " +
          "        t.confDate " +
          "   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p " +
          "  Where ser.Id = t.Service_Id " +
          "    And p.Id = t.Patient " +
					"    And t.state = 'DONE' " +
          "		 And ser.Group_Id = 8 " + (catAmb.isEmpty() ? "" : " And ser.id = " + catAmb) +
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
      if(r.getServices() != null && !r.getServices().isEmpty())
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ��� �����������
  private void rep8(HttpServletRequest req, Model m) {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<ObjList> rows = new ArrayList<>();
    //
		String cat = Util.get(req, "cat");
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
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
          "		 And ser.Group_Id = 2 " + (cat.isEmpty() ? "" : " And ser.id = " + cat) +
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
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ��������� �����������
  private void rep9(HttpServletRequest req, Model m) {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<ObjList> rows = new ArrayList<>();
    //
		String catStat = Util.get(req, "cat_stat");
		String catAmb = Util.get(req, "cat_amb");
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
		String cat = Util.get(req, "cat");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
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
					"				 '���' type_name, " +
					"				 t.confDate " +
          "   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p, Users u " +
          "  Where ser.Id = t.Service_Id " +
          "    And p.Id = t.Patient " +
          "    And u.id = t.worker_id " + ("2".equals(cat) ? " And 1 = 0 " : "") +
          "		 And ser.id in (98, 99) " + (catAmb.isEmpty() ? "" : " And ser.id = " + catAmb) +
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
					"        '����' type_name, " +
					"        t.Result_Date " +
					" From Lv_Plans t, Kdos c, Patients p, Users u " +
					" Where t.Kdo_Id = c.id " +
					"   And t.patientId = p.id " + ("1".equals(cat) ? " And 1 = 0 " : "") +
					"   And c.kdo_type = 12 " + (catStat.isEmpty() ? "" : " And c.id = " + catStat) +
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
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ��� �����������
  private void rep10(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<ObjList> rows = new ArrayList<>();
    //
		String cat = Util.get(req, "cat");
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    try {
      ps = conn.prepareStatement(
        "Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
          "         Date_Format(t.Result_Date, '%d.%m.%Y') cr_on, " +
          "         p.birthyear, " +
          "         u.fio doc, " +
          "         p.yearNum reg_num, " +
          "        (Select sex.Name From Sel_Opts sex WHERE sex.id = p.sex_id) Sex_Name, " +
          "         '����' type_name, " +
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
          "        '���' type_name, " +
          "        '��������' diagnoz, " +
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
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ������� �����������
  private void rep11(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<ObjList> rows = new ArrayList<>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    try {
      ps = conn.prepareStatement(
        " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "				 ser.Name Service_Name, " +
          "  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
          "        p.BirthYear, " +
          "        u.fio doc, " +
          "        p.id reg_num, " +
          "        (Select sex.Name From Sel_Opts sex WHERE sex.id = p.sex) Sex_Name, " +
          "        '���' type_name, " +
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
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ��� ���������
  private void rep12(HttpServletRequest req, Model m) {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<ObjList> rows = new ArrayList<>();
    //
		String cat = Util.get(req, "cat");
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
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
          "   And u.id = p.lv_id " + (cat.isEmpty() ? "" : " And c.id = " + cat) +
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
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ��� ��� ������
  private void rep13(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<ObjList> rows = new ArrayList<>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
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
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ������������ (���������)
  private void rep14(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    Users user = dUser.get(SessionUtil.getUser(req).getUserId());
    List<ObjList> rows = new ArrayList<>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate) + "<br/>";
    params += "������������ " + user.getProfil().toLowerCase() + "�. ����: " + user.getFio();
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
        service.setC8("������������ " + (rs.getString("profil") != null ? rs.getString("profil").toLowerCase() + "�" : ""));
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
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ����������������� (�����������)
  private void rep15(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<>();
    Rep1 r = new Rep1();
    try {
      ps = conn.prepareStatement(
				"Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
					"         c.Name Service_Name, " +
					"         Date_Format(t.Result_Date, '%d.%m.%Y') cr_on, " +
					"         p.birthyear, " +
					"         '����.' Type," +
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
          "				 '���' Type, " +
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
      if(r.getServices() != null && !r.getServices().isEmpty())
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // ��������� ������
    m.addAttribute("params", params);
  }
  // �������� (���������)
  private void rep16(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<>();
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
      if(r.getServices() != null && !r.getServices().isEmpty())
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ������ ��� ������� (���������)
  private void rep17(HttpServletRequest req, Model m) {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<>();
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
      if(r.getServices() != null && !r.getServices().isEmpty())
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ������������ (���������)
  private void rep18(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<ObjList> rows = new ArrayList<>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
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
        service.setC8("������������ " + (rs.getString("profil") != null ? rs.getString("profil").toLowerCase() + "�" : ""));
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
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ������� �������� ���� ��������� �������
  private void rep19(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<>();
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
      if(r.getServices() != null && !r.getServices().isEmpty())
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ���� - ���
  private void rep20(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<>();
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
      if(r.getServices() != null && !r.getServices().isEmpty())
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ������� ����������� ��������
  private void rep21(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<>();
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
      if(r.getServices() != null && !r.getServices().isEmpty())
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // ��������� ������
    m.addAttribute("params", params);
  }
  // TORCH ���������� ���������
  private void rep22(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<>();
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
      if(r.getServices() != null && !r.getServices().isEmpty())
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ������ ����� �������
  private void rep23(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<>();
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
      if(r.getServices() != null && !r.getServices().isEmpty())
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // ��������� ������
    m.addAttribute("params", params);
  }
  // �������������
  private void rep24(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<>();
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
      if(r.getServices() != null && !r.getServices().isEmpty())
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // ��������� ������
    m.addAttribute("params", params);
  }
  // �������� ������
  private void rep25(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<>();
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
      if(r.getServices() != null && !r.getServices().isEmpty())
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ����������� ������ ����� �������
  private void rep26(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<>();
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
      if(r.getServices() != null && !r.getServices().isEmpty())
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ��������� ������ ����� �������
  private void rep27(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<>();
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
      if(r.getServices() != null && !r.getServices().isEmpty())
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ��� ��������� �������������� �������
  private void rep28(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<Rep1> rows = new ArrayList<>();
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> patients = new ArrayList<>();
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
      if(r.getServices() != null && !r.getServices().isEmpty())
        rows.add(r);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
      DB.done(ps);
      DB.done(rs);
    }
    m.addAttribute("rows", rows);
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ������� ����������� (����, ���)
  private void rep29(HttpServletRequest req, Model m) {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<ObjList> rows = new ArrayList<>();
    //
		String cat = Util.get(req, "cat");
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    try {
      ps = conn.prepareStatement(
        "Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
          "         p.birthyear, " +
          "         Date_Format(t.Result_Date, '%d.%m.%Y') cr_on, " +
          "         f.c1 diagnoz, " +
          "         c.Name Service_Name, " +
          "         '����.' service_Type," +
          "         t.result_date " +
          " From Lv_Plans t, Kdos c, Patients p, Users u, F999 f  " +
          " Where t.Kdo_Id = c.id " +
          "   And t.patientId = p.id " +
          "   And f.plan_id = t.id" +
          "   And c.kdo_type = 14 " + (cat != null && cat.equals("1") ? " And 1=0 " : "") +
          "   And u.id = p.lv_id " +
					"   And t.done_flag = 'Y' " +
          "   And date (t.Result_Date) Between ? and ? " +
          " UNION ALL " +
          " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "        p.birthyear, " +
          "  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
          "        t.diagnoz, " +
          "				 ser.Name Service_Name, " +
          "				 '���' Service_Type, " +
          "        t.confDate " +
          "   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p " +
          "  Where ser.Id = t.Service_Id " +
          "    And p.Id = t.Patient " +
					"    And t.state = 'DONE' " +
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
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ��� ����������� (����, ���)
  private void rep30(HttpServletRequest req, Model m) {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<ObjList> rows = new ArrayList<>();
    //
		String cat = Util.get(req, "cat");
		String catStat = Util.get(req, "cat_stat");
		String catAmb = Util.get(req, "cat_amb");
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    try {
      ps = conn.prepareStatement(
        "Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
          "         p.birthyear, " +
          "         Date_Format(t.Result_Date, '%d.%m.%Y') cr_on, " +
          "         f.c1 diagnoz, " +
          "         c.Name Service_Name, " +
          "         '����.' service_Type," +
          "         t.result_date " +
          " From Lv_Plans t, Kdos c, Patients p, Users u, F999 f  " +
          " Where t.Kdo_Id = c.id " +
					"   And t.done_flag = 'Y' " +
          "   And t.patientId = p.id " +
          "   And f.plan_id = t.id" + (catStat.isEmpty() ? "" : " And c.id = " + catStat) +
          "   And c.kdo_type = 13 " + (cat != null && cat.equals("1") ? " And 1=0 " : "") +
          "   And u.id = p.lv_id " +
          "   And date (t.Result_Date) Between ? and ? " +
          " UNION ALL " +
          " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "        p.birthyear, " +
          "  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
          "        t.diagnoz, " +
          "				 ser.Name Service_Name, " +
          "				 '���' Service_Type, " +
          "        t.confDate " +
          "   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p " +
          "  Where ser.Id = t.Service_Id " +
					"    And t.state = 'DONE' " +
          "    And p.Id = t.Patient " + (catAmb.isEmpty() ? "" : " And ser.id = " + catAmb) +
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
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ������ ����������� (����, ���)
  private void rep31(HttpServletRequest req, Model m) {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
    List<ObjList> rows = new ArrayList<>();
    //
		String cat = Util.get(req, "cat");
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    try {
      ps = conn.prepareStatement(
        "Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
          "         p.birthyear, " +
          "         Date_Format(t.Result_Date, '%d.%m.%Y') cr_on, " +
          "         f.c1 diagnoz, " +
          "         c.Name Service_Name, " +
          "         '����.' service_Type," +
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
          "				 '���' Service_Type, " +
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
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ������������ (�����������)
  private void rep32(HttpServletRequest req, Model m){
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    String params = "";
		Users user = dUser.get(SessionUtil.getUser(req).getUserId());
    //
    Date startDate = Util.getDate(req, "period_start");
    Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate) + "<br/>";
		params += "������������ " + user.getProfil().toLowerCase() + "�. ����: " + user.getFio();
    List<ObjList> rows = new ArrayList<>();
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
    // ��������� ������
    m.addAttribute("params", params);
  }
  // ��� ������������ (�����������)
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
    params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
    List<ObjList> rows = new ArrayList<>();
    try {
      ps = conn.prepareStatement(
        " Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
          "				 	 ser.Name Service_Name, " +
          "  			 	 Date_Format(t.confDate, '%d.%m.%Y %H:%i') cr_on, " +
          "        	 p.birthyear, " +
          "        	 (Select con.Name From counteries con WHERE con.id = p.counteryId) Country, " +
          "        	 (Select reg.Name From Regions reg WHERE reg.id = p.regionId) Region, " +
          "        	 (Select u.fio FROM Users u where u.id = t.worker_id) lv_fio, " +
          "        	 p.Address, " +
          "        	 p.tel, " +
          "				 	 t.diagnoz," +
					"				   t.state " +
          "   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p " +
          "  Where ser.Id = t.Service_Id " +
					"    And p.Id = t.Patient " +
          "    And ser.consul = 'Y'" + (cat.isEmpty() ? "" : " And ser.id = " + cat) +
          " 	 And date (t.crOn) Between ? and ? " +
          ("".equals(doctor) ? "" : " And t.worker_id = " + doctor) +
          " Order By t.crOn "
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
				service.setC5(rs.getString("state"));
				service.setC6(rs.getString("tel"));
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
    // ��������� ������
    m.addAttribute("params", params);
  }
	// ������������ ����������� (����, ���)
	private void rep34(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<ObjList> rows = new ArrayList<>();
		//
		String cat = Util.get(req, "cat");
		String catStat = Util.get(req, "cat_stat");
		String catAmb = Util.get(req, "cat_amb");
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		try {
			ps = conn.prepareStatement(
				"Select p.id, Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
					"         p.birthyear, " +
					"         Date_Format(g.confDate, '%d.%m.%Y') cr_on, " +
					"         c.Name Service_Name, " +
					"         '����.' service_Type," +
					"         g.confDate," +
					"				  t.fizei," +
					"				  Count(*) Counter" +
					" From Lv_Fizios t, Kdos c, Patients p, Users u, Lv_Fizio_Dates g  " +
					" Where t.Kdo_Id = c.id " +
					"   And t.patientId = p.id " + (catStat.isEmpty() ? "" : " And c.id = " + catStat) +
					"   And c.kdo_type = 8 " + (cat != null && cat.equals("1") ? " And 1=0 " : "") +
					"   And u.id = p.lv_id " +
					"   And g.fizio_id = t.Id " +
					"   And g.state = 'Y' " +
					"   And date (g.confDate) Between ? and ? " +
					" Group By p.id, p.surname, p.name, p.birthyear, c.name, g.confDate, t.fizei " +
					" UNION ALL " +
					" Select p.id, Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
					"        p.birthyear, " +
					"  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
					"        ser.Name Service_Name, " +
					"				 '���' Service_Type, " +
					"        t.confDate," +
					"				 0 fizei," +
					"			   0 Counter " +
					"   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p " +
					"  Where ser.Id = t.Service_Id " +
					"    And p.Id = t.Patient " + (catAmb.isEmpty() ? "" : " And ser.id = " + catAmb) +
					"		 And ser.Group_Id in (6, 7) " + (cat != null && cat.equals("2") ? " And 1=0 " : "") +
					" 	 And date (t.confDate) Between ? and ? "+
					" Order By 1, 6 "
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
				service.setC5(rs.getString("fizei"));
				service.setC6(rs.getString("counter"));
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ����������� �����
	private void rep35(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<ObjList> rows = new ArrayList<>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "�� ������ " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate) + " �� ���� " + (Util.get(req, "type").equals("amb") ? "�����������" : "���������");
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
						"  Where date(t.crOn) between ? and ? " +
						"	   And t.patient = c.id " +
						"	 Order By t.crOn "
				);
				ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
				ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
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
				obj.setFio("�����");
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
						"  Where date(p.crOn) between ? and ? " +
						"		 And p.patient_id = t.id " +
						"  Group By t.id, p.crOn "
				);
				ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
				ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
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
				obj.setFio("�����");
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// �������� (�����������)
	private void rep36(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<>();
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
			List<String> patIds = new ArrayList<>();
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ������� ����������� �������� (�����������)
	private void rep37(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<>();
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
			List<String> patIds = new ArrayList<>();
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// TORCH ���������� ��������� (�����������)
	private void rep38(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<>();
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
			List<String> patIds = new ArrayList<>();
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ������������� (�����������)
	private void rep39(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<>();
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
			List<String> patIds = new ArrayList<>();
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ��� ��������� �������������� �������
	private void rep41(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<>();
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ����� ������ ����� 21 ��������
	private void rep42(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<>();
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
			List<String> patIds = new ArrayList<>();
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ������� �������� ���� ��������� �������
	private void rep43(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<>();
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ����������� ������ ����� �������
	private void rep44(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<>();
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ��������� ������ ����� �������
	private void rep45(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<>();
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ������ ����������������� �����
	private void rep46(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<>();
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ����� ������ ����
	private void rep47(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		List<ObjList> rows = new ArrayList<>();
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ������ ����������������� ����� (���������)
	private void rep48(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<ObjList> rows = new ArrayList<>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ������� ����� �� ������� ��������� (���������)
	private void rep49(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<ObjList> rows = new ArrayList<>();
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
					"				 (Select Sum(c.rasxod * f.price) From drug_out_rows f, hn_date_patient_rows c, hn_drugs d where f.Id = d.outRow_id And d.id = c.drug_Id And c.patient_Id = t.id) ddd " +
					"   From Patients t " +
					"  Where t.state != 'ARCH' " +
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
				service.setC30("0");
				Double ser;
				try {
					HNPatients hnPatient = dhnPatient.getObj("From HNPatients Where state = 'D' And patient.id = " + rs.getInt("id"));
					if (hnPatient != null) {
						ser = hnPatient.getTotalSum();
						service.setC10("0");
					} else {
						service.setC10(rs.getString("ddd") == null ? "0" : rs.getString("ddd"));
						ser = patientMustPay(rs.getInt("id"));
					}
				} catch (Exception e) {
					service.setC10(rs.getString("ddd") == null ? "0" : rs.getString("ddd"));
					ser = patientMustPay(rs.getInt("id"));
				}

				tSer += ser;
				service.setC7("" + ser);
				tPaid += rs.getString("paid") == null ? 0D : rs.getDouble("paid");
				tReturned += rs.getString("returned") == null ? 0D : rs.getDouble("returned");
				tDiscount += rs.getString("discount") == null ? 0D : rs.getDouble("discount");
				ddd += rs.getString("ddd") == null ? 0D : rs.getDouble("ddd");
				//
				rows.add(service);
			}
			if(!rows.isEmpty()) {
				ObjList service = new ObjList();
				service.setC30("1");
				service.setFio("�����");
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	private Double patientMustPay(int id) {
		//
		Patients pat = dPatient.get(id);

		Date d = pat.getDateEnd() == null ? new Date() : pat.getDateEnd();
		Double ndsProc = d.after(startDate) ? Double.parseDouble(dParam.byCode("NDS_PROC")) : 0;
		Double price = pat.getRoomPrice() * (100 + ndsProc) / 100;
		Double total = (pat.getDayCount() == null ? 0 : pat.getDayCount()) * price;
		//
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
		// ������
		List<LvPlans> plans = dLvPlan.getByPatientId(pat.getId());
		for(LvPlans plan: plans) {
			if(plan.getPrice() != null)
				total += plan.getPrice();
		}
		//
		return total;
	}
	// ���� ������������ �� ���� ����
	private void rep50(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<ObjList> rows = new ArrayList<>();
		//
		try {
			Calendar calendar = Calendar.getInstance();
			int day = calendar.get(Calendar.DAY_OF_WEEK);
			Calendar c = Calendar.getInstance();
			c.setTime(new Date());
			c.add(Calendar.DATE, day == 7 ? 2 : 1);
			String dt = Util.dateToString(c.getTime());
			conn = DB.getConnection();
			Integer deptId = !req.getParameter("dept").isEmpty() ? Util.getInt(req, "dept") : null;
			//
			List<Depts> depts = dDept.getAll();
			if(deptId != null) {
				Depts dd = dDept.get(deptId);
				depts = new ArrayList<>();
				depts.add(dd);
			}
			for(Depts dept: depts) {
				if(dept.getId() > 0) {
					ObjList obj = new ObjList();
					obj.setC1(dept.getName());
					obj.setC30("O");
					rows.add(obj);
				}
				List<Integer> kdoIds = new ArrayList<>();
				ps = conn.prepareStatement(
					"Select t.Id, t.Name " +
						"From Kdo_Types t " +
						"Where t.Id IN (SELECT c.kdo_type_id FROM Lv_Plans c, Patients d WHERE c.patientId = d.id And d.dept_id = ? And date(actDate) = ?)");
				ps.setInt(1, dept.getId());
				ps.setString(2, Util.dateDB(dt));
				rs = ps.executeQuery();
				List<String> kdos = new ArrayList<>();
				while (rs.next()) {
					kdoIds.add(rs.getInt(1));
					kdos.add(rs.getString(2));
				}
				Integer counter = 1;
				for (int i = 0; i < kdos.size(); i++) {
					List<ObjList> patients = new ArrayList<>();
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
						if (rs.getInt("kdo_id") == 13) { // ��������
							String st = "";
							LvBios bio = dLvBio.getByPlan(rs.getInt("id"));
							if (bio != null) {
								if (bio.getC1() == 1) st += "������� �����,";
								if (bio.getC2() == 1) st += "����������,";
								if (bio.getC3() == 1) st += "����� ������������,";
								if (bio.getC4() == 1) st += "����� �����,";
								if (bio.getC5() == 1) st += "��������,";
								if (bio.getC23() == 1) st += "F� (������),";
								if (bio.getC8() == 1) st += "���������,";
								if (bio.getC7() == 1) st += "���������,";
								if (bio.getC13() == 1) st += "������� �����,";
								if (bio.getC12() == 1) st += "������������-���,";
								if (bio.getC14() == 1) st += "������� �������,";
								if (bio.getC11() == 1) st += "������������-���,";
								if (bio.getC15() == 1) st += "������������ ������,";
								if (bio.getC16() == 1) st += "�-�����,";
								if (bio.getC17() == 1) st += "Na - ������,";
								if (bio.getC18() == 1) st += "�� - �������,";
								if (bio.getC19() == 1) st += "Cl - ����,";
								if (bio.getC20() == 1) st += "Phos - ������,";
								if (bio.getC21() == 1) st += "Mg - ������,";
								if (bio.getC24() == 1) st += "��������,";
								if (bio.getC25() == 1) st += "�������������������,";
								if (bio.getC26() == 1) st += "�����-�������������������,";
								if (bio.getC27() == 1) st += "�������� ���������,";
								if (bio.getC28() == 1) st += "��������� �����,";
								if (bio.getC29() == 1) st += "��������� ������,";
								if (!st.equals("")) {
									st = st.substring(0, st.length() - 1);
									name = name + "<br/>" + st;
								}
							}
						}
						if (rs.getInt("kdo_id") == 153) { // ��������
							String st = "";
							LvBios bio = dLvBio.getByPlan(rs.getInt("id"));
							if (bio != null) {
								if (bio.getC1() == 1) st += "������ �����,";
								if (bio.getC2() == 1) st += "����������,";
								if (bio.getC3() == 1) st += "�������,";
								if (bio.getC4() == 1) st += "��������,";
								if (bio.getC5() == 1) st += "���������,";
								if (bio.getC6() == 1) st += "���������,";
								if (bio.getC7() == 1) st += "���,";
								if (bio.getC8() == 1) st += "���,";
								if (bio.getC9() == 1) st += "����� �������,";
								if (bio.getC10() == 1) st += "�������,";
								if (bio.getC11() == 1) st += "������ ���������,";
								if (bio.getC12() == 1) st += "K � �����,";
								if (bio.getC13() == 1) st += "Na � ������,";
								if (bio.getC14() == 1) st += "Fe � �����,";
								if (bio.getC15() == 1) st += "Mg � ������,";
								if (bio.getC16() == 1) st += "������� ���������,";
								if (bio.getC17() == 1) st += "���,";
								if (bio.getC18() == 1) st += "������������ ����������,";
								if (bio.getC19() == 1) st += "��,";
								if (bio.getC20() == 1) st += "����,";
								if (bio.getC21() == 1) st += "���,";
								if (bio.getC22() == 1) st += "RW,";
								if (bio.getC23() == 1) st += "Hbs Ag,";
								if (bio.getC24() == 1) st += "������� �ѻ ���,";
								if (!st.equals("")) {
									st = st.substring(0, st.length() - 1);
									name = name + "<br/>" + st;
								}
							}
						}
						if (rs.getInt("kdo_id") == 56) { // �����������
							String st = "";
							LvCouls bio = dLvCoul.getByPlan(rs.getInt("id"));
							if (bio != null) {
								if (bio.isC4()) st += "���,";
								if (bio.isC1()) st += "����������,";
								if (bio.isC2()) st += "������� �����,";
								if (bio.isC3()) st += "�.�.�.�. (���),";
								if (!st.equals("")) {
									st = st.substring(0, st.length() - 1);
									name = name + "<br/>" + st;
								}
							}
						}
						if (rs.getInt("kdo_id") == 120) { // Garmon
							String st = "";
							LvGarmons bio = dLvGarmon.getByPlan(rs.getInt("id"));
							if (bio != null) {
								if (bio.isC1()) st += "���,";
								if (bio.isC2()) st += "�4,";
								if (bio.isC3()) st += "�3,";
								if (bio.isC4()) st += "����-���,";
								if (!st.equals("")) {
									st = st.substring(0, st.length() - 1);
									name = name + "<br/>" + st;
								}
							}
						}
						if (rs.getInt("kdo_id") == 121) { // ����
							String st = "";
							LvTorchs bio = dLvTorch.getByPlan(rs.getInt("id"));
							if (bio != null) {
								if (bio.isC1()) st += "��������,";
								if (bio.isC2()) st += "�����������,";
								if (bio.isC3()) st += "���,";
								if (bio.isC4()) st += "���,";
								if (!st.equals("")) {
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
					if (!patients.isEmpty()) {
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
				List<ObjList> patients = new ArrayList<>();
				while (rs.next()) {
					ObjList obj = new ObjList();
					obj.setC30("N");
					obj.setC1(rs.getString("fio"));
					obj.setC4(rs.getString("actdate"));
					if (rs.getString("profil") != null)
						obj.setC3("������������ " + rs.getString("profil").toLowerCase() + "a");
					obj.setC5(rs.getString("lvName"));
					obj.setC10("" + counter++);
					patients.add(obj);
				}
				if (!patients.isEmpty()) {
					ObjList obj = new ObjList();
					obj.setC1("������������");
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ���������� ������ ��������
	private void rep51(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<ObjList> rows = new ArrayList<>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		String params = ("���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate));
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ������� ����� �� ���������
	private void rep52(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<ObjList> rows = new ArrayList<>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		String params = ("���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate));
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
					" t.yearNum," +
					"	t.work," +
					"	t.post " +
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
				service.setC15(rs.getString("work"));
				service.setC16(rs.getString("post"));
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ������ �� ���������
	private void rep53(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<Obj> rows = new ArrayList<>();
		//
		String pt = Util.get(req, "cat");
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		String repType = Util.get(req, "rep_type", "1");
		String params = ("���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate));
		double procSum = 0, totalSum = 0;
		try {
			List<LvPartners> partners = pt == null || pt.isEmpty() ? dLvPartner.getList("From LvPartners" + (repType.equals("0") ? " Where report != 'Y' or report is null" : "")) : dLvPartner.getList("From LvPartners Where id = " + Integer.parseInt(pt));
			for(LvPartners partner: partners) {
				Obj part = new Obj();
				Double ambCount = DB.getSum(conn, "Select Count(*) From Amb_Patients t Where t.lvpartner_id = " + partner.getId() + " And date (t.reg_date) Between '" + Util.dateDB(Util.get(req, "period_start")) + "' And '" + Util.dateDB(Util.get(req, "period_end")) + "'");
				part.setPrice(0D);
				part.setClaimCount(0D);
				ps = conn.prepareStatement(
					" Select Concat(t.surname, ' ',  t.name, ' ', t.middlename) Fio, " +
						" 			   s.name, " +
						"				   f.partnerProc * c.price / 100 summ, " +
						"				   f.partnerProc, " +
						"					 c.price, " +
						"					 c.crOn " +
						" From Amb_Patients t, Amb_Patient_Services c, Amb_Services s, Amb_Groups f  " +
						" Where date (t.reg_date) Between ? And ? " +
						"   And f.id = s.group_id " +
						"   And s.id = c.service_id " +
						"   And c.patient = t.id " +
						"   And f.partnerProc > 0 " +
						"   And (c.crBy = t.crBy Or c.crBy = 1) " +
						"   And t.lvpartner_id = ?" +
						" Order By t.reg_date"
				);
				ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
				ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
				ps.setInt(3, partner.getId());
				rs = ps.executeQuery();
				List<ObjList> services = new ArrayList<>();
				while (rs.next()) {
					ObjList service = new ObjList();
					service.setC1(rs.getString("fio"));
					service.setC2(rs.getString("name"));
					service.setC3(rs.getString("price"));
					service.setC4(rs.getString("partnerProc"));
					service.setC5(rs.getString("summ"));
					service.setC6(Util.dateToString(rs.getDate("crOn")));
					part.setPrice(part.getPrice() + rs.getDouble("price"));
					part.setClaimCount(part.getClaimCount() + rs.getDouble("summ"));
					services.add(service);
				}
				ps = conn.prepareStatement(
					" Select Concat(t.surname, ' ',  t.name, ' ', t.middlename) Fio, " +
						" 			   t.yearNum name, " +
						"				   0.1 * (c.koykoPrice / 112 * 100) * c.dayCount summ, " +
						"				   10 partnerProc, " +
						"					 (c.koykoPrice / 112 * 100) * c.dayCount price, " +
						"					 t.date_end " +
						" From Patients t, Hn_Patients c " +
						"Where t.id = c.patient_id " +
						"  And date(t.date_end) Between ? And ? " +
						"  And t.lvpartner_id = ? " +
						" Order By t.date_end "
				);
				ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
				ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
				ps.setInt(3, partner.getId());
				rs = ps.executeQuery();
				int statCount = 0;
				while (rs.next()) {
					statCount++;
					ObjList service = new ObjList();
					service.setC1(rs.getString("fio"));
					service.setC2("��������� �� �: " + rs.getString("name"));
					service.setC3(rs.getString("price"));
					service.setC4(rs.getString("partnerProc"));
					service.setC5(rs.getString("summ"));
					service.setC6(Util.dateToString(rs.getDate("date_end")));
					part.setPrice(part.getPrice() + rs.getDouble("price"));
					part.setClaimCount(part.getClaimCount() + rs.getDouble("summ"));
					services.add(service);
				}
				if(!services.isEmpty()) {
					String count =  "(" + (ambCount > 0 ? " ���-�� ���. ���������: " + Math.round(ambCount) : "") + (statCount > 0 ? " ���-�� ����. ���������: " + statCount : "") + " )";
					part.setFio(partner.getCode() + " " + partner.getFio() + count);
					procSum += part.getClaimCount();
					totalSum += part.getPrice();
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
		m.addAttribute("procSum", procSum);
		m.addAttribute("totalSum", totalSum);
		m.addAttribute("rows", rows);
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ������ �� �������
	private void rep54(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		ResultSet rc = null;
		List<Obj> rows = new ArrayList<>();
		List<Obj> rows2 = new ArrayList<>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		String params = ("���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate));
		try {
			// �����������
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
				List<ObjList> srs = new ArrayList<>();
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
			// ���������
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ����� �� �������������� ������������
	private void rep55(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<Obj> rows = new ArrayList<>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		String params = ("���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate));
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
				List<ObjList> services = new ArrayList<>();
				while (rs.next()) {
					ObjList service = new ObjList();
					service.setC1(rs.getString("name"));
					service.setC2(rs.getString("counter"));
					service.setC3(rs.getString("summ"));
					service.setC4(rs.getString("price"));
					part.setPrice(part.getPrice() + rs.getDouble("summ"));
					services.add(service);
				}
				if(!services.isEmpty()) {
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ������� ����� (�������)
	private void rep56(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<ObjList> rows = new ArrayList<>();
		List<ObjList> dds = new ArrayList<>();
		//
		Date date = Util.getDate(req, "period");
		String params = ("���������: �� ����: " + Util.dateToString(date));
		try {
			List<Depts> depts = dDept.getList("From Depts Order By Length(name)");
			List<EatMenuTypes> menuTypes = dEatMenuType.getAll();
			LinkedHashMap<String, Integer> mm = new LinkedHashMap<>();
			LinkedHashMap<String, String> keys = new LinkedHashMap<>();
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
		// ��������� ������
		m.addAttribute("params", params);
	}

	// ����� �� ��������� (�����������)
	private void rep57(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null, rc = null;
		List<ObjList> rows = new ArrayList<>();
		//
		Date date = Util.getDate(req, "period");
		String params = ("���������: �� ����: " + Util.dateToString(date));
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
				row.setC3(rs.getString("confDate"));
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
		// ��������� ������
		m.addAttribute("params", params);
	}

	// ����� �� ��������� (���������)
	private void rep58(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null, rc = null;
		List<ObjList> rows = new ArrayList<>();
		//
		Date date = Util.getDate(req, "period");
		String params = ("���������: �� ����: " + Util.dateToString(date));
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
				row.setC3(rs.getString("confDate"));
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ����� �� RW
	private void rep59(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<Rep1> rows = new ArrayList<>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		Integer dept = Util.getNullInt(req, "dept");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate) + " ���������: " + (dept == null ? "���" : dDept.get(Util.getInt(req, "dept")).getName()) ;
		List<ObjList> patients = new ArrayList<>();
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
				if(rs.getString("c24") != null && !rs.getString("c24").isEmpty()) {
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
			if(r.getServices() != null && !r.getServices().isEmpty())
				rows.add(r);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		// ��������� ������
		m.addAttribute("params", params);
	}
	// �������� (������� ����� �� ���������)
	private void rep60(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<ObjList> rows = new ArrayList<>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		String params = ("���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate));
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
		// ��������� ������
		m.addAttribute("params", params);
	}

	// ��������� ����� �� ����������� ������
	private void rep61(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null, rc = null;
		List<Obj> rows = new ArrayList<>(), krows = new ArrayList<>();
		List<Obj> ss = new ArrayList<>(), kss = new ArrayList<>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		int cat = Util.getInt(req, "cat");
		String params = ("���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate));
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
					LinkedHashMap<Integer, String> rws = new LinkedHashMap<>();
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
			// ���������
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
					LinkedHashMap<Integer, String> rws = new LinkedHashMap<>();
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
		// ��������� ������
		m.addAttribute("params", params);
	}

	// �������� (������� ����� �� ���������)
	private void rep62(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<ObjList> rows = new ArrayList<>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		String params = ("���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate));
		try {
			ps = conn.prepareStatement(
				"Select t.name, Sum(Case When t.sex_id = 12 Then t.counter else 0 End) Sex_12, Sum(Case When t.sex_id = 13 Then t.counter else 0 End) Sex_13 From (" +
					  "Select d.name, t.sex_id, Count(*) counter" +
						"  From Patients t, Lv_Docs c, Mkb d  " +
						" Where date (t.Date_End) Between ? And ? " +
					  "   And c.patient_id = t.id" +
					  "   And c.docCode = 'vypiska'  " +
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ������� ����������� (����, ���)
	private void rep63(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<ObjList> rows = new ArrayList<>();
		//
		String cat = Util.get(req, "cat");
		String catStat = Util.get(req, "cat_stat");
		String catAmb = Util.get(req, "cat_amb");
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		try {
			ps = conn.prepareStatement(
				"Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
					"         p.birthyear, " +
					"         Date_Format(t.Result_Date, '%d.%m.%Y') cr_on, " +
					"         f.c1 diagnoz, " +
					"         c.Name Service_Name, " +
					"         '����.' service_Type," +
					"         t.result_date " +
					" From Lv_Plans t, Kdos c, Patients p, Users u, F999 f  " +
					" Where t.Kdo_Id = c.id " +
					"   And t.done_flag = 'Y' " +
					"   And t.patientId = p.id " +
					"   And f.plan_id = t.id" + (catStat.isEmpty() ? "" : " And c.id = " + catStat) +
					"   And c.kdo_type = 3 " + (cat != null && cat.equals("1") ? " And 1=0 " : "") +
					"   And u.id = p.lv_id " +
					"   And date (t.Result_Date) Between ? and ? " +
					" UNION ALL " +
					" Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
					"        p.birthyear, " +
					"  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
					"        t.diagnoz, " +
					"				 ser.Name Service_Name, " +
					"				 '���' Service_Type, " +
					"        t.confDate " +
					"   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p " +
					"  Where ser.Id = t.Service_Id " +
					"    And t.state = 'DONE' " +
					"    And p.Id = t.Patient " + (catAmb.isEmpty() ? "" : " And ser.id = " + catAmb) +
					"		 And ser.Group_Id = 12 " + (cat != null && cat.equals("2") ? " And 1=0 " : "") +
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
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ��������� (������)
	private void rep64(HttpServletRequest req, Model m) {
		try {
			DrugOuts out = dDrugOut.get(Util.getInt(req, "id"));
			m.addAttribute("reg_date", Util.dateToString(out.getRegDate()));
			m.addAttribute("glv", dUser.getGlb(0));
			m.addAttribute("reg_num", out.getRegNum());
			m.addAttribute("rows", dDrugOutRow.getList("From DrugOutRows Where doc.id = " + out.getId()));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	// ������
	private void rep65(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<ObjList> rows = new ArrayList<>();
		List<ObjList> ambs = new ArrayList<>();
		List<ObjList> users = new ArrayList<>();
		HashMap<Integer, Double> lv = new HashMap<>();
		//
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		try {
			ps = conn.prepareStatement(
				"Select t.Lv, " +
					"         c.fio, " +
					"         Sum(t.lux_count) lux_count, " +
					"         Sum(t.lux_sum) lux_sum, " +
					"         Sum(t.lux_count * t.eat) eat_lux_sum, " +
					"          " +
					"         Sum(t.delux_count) delux_count, " +
					"         Sum(t.delux_sum) delux_sum, " +
					"         Sum(t.delux_count * t.eat) eat_delux_sum, " +
					"          " +
					"         Sum(t.simple_count) simple_count, " +
					"         Sum(t.simple_sum) simple_sum, " +
					"         Sum(t.simple_count * t.eat) eat_simple_sum, " +
					"          " +
					"         Count(*) Patient_Count, " +
					"         Sum(t.Total_Sum) Total_Sum, " +
					"         Sum(t.total_count * t.eat) eat_total_sum, " +
					"         Sum(t.Total_Sum) - Sum(t.total_count * t.eat) bonus_total, " +
					"         Sum(t.Total_Sum - t.total_count * t.eat) * 0.1 bonus " +
					"  From ( " +
					"      Select t.lv, " +
					"             t.patient, " +
					"             Sum(Case When t.roomType = 5 Then t.koyko Else 0 End) lux_count, " +
					"             Sum(Case When t.roomType = 5 Then t.koyko * t.price Else 0 End) lux_sum, " +
					"             Sum(Case When t.roomType = 7 Then t.koyko Else 0 End) delux_count, " +
					"             Sum(Case When t.roomType = 7 Then t.koyko * t.price Else 0 End) delux_sum, " +
					"             Sum(Case When t.roomType = 6 Then t.koyko Else 0 End) simple_count, " +
					"             Sum(Case When t.roomType = 6 Then t.koyko * t.price Else 0 End) simple_sum, " +
					"             Sum(t.koyko) total_count, " +
					"             Sum(t.koyko * t.price) total_sum, " +
					"             (Select a.val From Params a Where a.Code = 'EAT_PRICE') eat " +
					"        From ( " +
					"          Select c.lvId lv, " +
					"                 t.patient_Id patient, " +
					"                 r.roomType, " +
					"                 c.koyko, " +
					"                 c.price " +
					"          From Hn_Patients t, Lv_Epics c, Rooms r " +
					"        Where t.patient_Id = c.patientId " +
					"           And t.state = 'D' " +
					"           And t.dateEnd between ? And ? " +
					"           And c.koyko > 0 " +
					"           And r.Id = c.room_Id " +
					"       Union All " +
					"       Select c.lv_id, " +
					"                 t.patient_Id, " +
					"                 r.roomType, " +
					"                 t.dayCount - (Select ifnull(Sum(g.koyko), 0) From Lv_Epics g Where g.patientId = c.id) Koyko, " +
					"                 t.koykoPrice / 112 * 100 koykoPrice " +
					"          From Hn_Patients t, Patients c, Rooms r " +
					"        Where t.patient_Id = c.id " +
					"           And t.dateEnd between ? And ? " +
					"           And r.id = c.Room_Id) t " +
					"    Group By t.lv, t.patient) t, Users c " +
					"  Where c.id = t.lv " +
					"  Group By t.lv"
			);
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			ps.setString(3, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(4, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			while (rs.next()) {
				ObjList a = new ObjList();
				//
				a.setC1(rs.getString("fio"));
				a.setC2(rs.getString("lux_count"));
				a.setC3(rs.getString("lux_sum"));
				a.setC4(rs.getString("eat_lux_sum"));
				//
				a.setC5(rs.getString("delux_count"));
				a.setC6(rs.getString("delux_sum"));
				a.setC7(rs.getString("eat_delux_sum"));
				//
				a.setC8(rs.getString("simple_count"));
				a.setC9(rs.getString("simple_sum"));
				a.setC10(rs.getString("eat_simple_sum"));
				//
				a.setC11(rs.getString("patient_count"));
				a.setC12(rs.getString("total_sum"));
				a.setC13(rs.getString("eat_total_sum"));
				a.setC14(rs.getString("bonus_total"));
				a.setC15(rs.getString("bonus"));
				//
				lv.put(rs.getInt("lv"), rs.getDouble("bonus"));
				//
				rows.add(a);
			}
			//
			ps = conn.prepareStatement(
				"Select a.id lv," +
					"          a.fio, " +
					"          c.name, " +
					"          Count(*) Counter, " +
					"          Sum(t.price) Summ, " +
					"          Sum(t.price) * Case When f.bonusProc > 0 Then f.bonusProc Else c.bonusProc End / 100 Bonus " +
					"     From amb_patient_services t, Amb_Services c, Users a, Amb_Groups f " +
					"    Where t.state = 'DONE' " +
					"      And t.confDate between ? And ? " +
					"      And c.id = t.service_Id " +
					"      And f.id = c.group_id " +
					"   	 And (c.bonusProc > 0 Or f.bonusProc > 0) " +
					"   	 And a.id = t.worker_Id " +
					" 	 Group By a.fio, c.name"
			);
			ps.setString(1, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(2, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			while (rs.next()) {
				ObjList a = new ObjList();
				//
				a.setC1(rs.getString("fio"));
				a.setC2(rs.getString("name"));
				a.setC3(rs.getString("counter"));
				a.setC4(rs.getString("summ"));
				a.setC5(rs.getString("bonus"));
				//
				if(lv.containsKey(rs.getInt("lv"))) {
					Double bonus = lv.get(rs.getInt("lv"));
					bonus += rs.getDouble("bonus");
					lv.put(rs.getInt("lv"), bonus);
				} else {
					lv.put(rs.getInt("lv"), rs.getDouble("bonus"));
				}
				//
				ambs.add(a);
			}
			//
			Double total = 0D;
			Set<Integer> keys = lv.keySet();
			for(Integer key: keys) {
				ObjList a = new ObjList();
				a.setC1(dUser.get(key).getFio());
				total += lv.get(key);
				a.setC2(lv.get(key).toString());
				//
				users.add(a);
			}
			m.addAttribute("total", total);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		m.addAttribute("ambs", ambs);
		m.addAttribute("users", users);
		// ��������� ������
		m.addAttribute("params", params);
	}
	// ������ �����������
	private void rep66(HttpServletRequest req, Model m) {
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<ObjList> rows = new ArrayList<>();
		List<ObjList> ambs = new ArrayList<>();
		//
		Integer id = Util.getInt(req, "lv", 0);
		Users lv = dUser.get(id);
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate) + " ����: " + lv.getFio();
		try {
			ps = conn.prepareStatement(
				"Select t.lv,  " +
					"       t.patient,  " +
					"       Concat(c.surname, ' ', c.name, ' ', c.middlename) fio, " +
					"       c.Date_Begin, " +
					"       t.date_end, " +
					"       Sum(Case When t.roomType = 5 Then t.koyko Else 0 End) lux_count,  " +
					"       Sum(Case When t.roomType = 5 Then t.koyko * t.price Else 0 End) lux_sum,  " +
					"       Sum(Case When t.roomType = 7 Then t.koyko Else 0 End) delux_count,  " +
					"       Sum(Case When t.roomType = 7 Then t.koyko * t.price Else 0 End) delux_sum,  " +
					"       Sum(Case When t.roomType = 6 Then t.koyko Else 0 End) simple_count,  " +
					"       Sum(Case When t.roomType = 6 Then t.koyko * t.price Else 0 End) simple_sum,  " +
					"       Sum(t.koyko) total_count,  " +
					"       Sum(t.koyko * t.price) total_sum, " +
					"       Sum(t.koyko * (t.price - (Select a.val From Params a Where a.Code = 'EAT_PRICE'))) Bonus_Sum, " +
					"       Sum(t.koyko * (t.price - (Select a.val From Params a Where a.Code = 'EAT_PRICE'))) * 0.1 Bonus " +
					"  From (  " +
					"    Select c.lvId lv,  " +
					"           t.patient_Id patient,  " +
					"           r.roomType,  " +
					"           c.koyko,  " +
					"           c.price, " +
					"           date(t.dateEnd) date_end " +
					"      From Hn_Patients t, Lv_Epics c, Rooms r  " +
					"     Where t.patient_Id = c.patientId  " +
					"       And t.state = 'D' " +
					"       And c.lvid = ? " +
					"       And t.dateEnd between ? And ? " +
					"       And c.koyko > 0  " +
					"       And r.Id = c.room_Id  " +
					"    Union All  " +
					"    Select c.lv_id,  " +
					"           t.patient_Id, " +
					"           r.roomType,  " +
					"           t.dayCount - (Select ifnull(Sum(g.koyko), 0) From Lv_Epics g Where g.patientId = c.id) Koyko,  " +
					"           t.koykoPrice / 112 * 100 koykoPrice, " +
					"           date(t.dateEnd) date_end " +
					"      From Hn_Patients t, Patients c, Rooms r  " +
					"     Where t.patient_Id = c.id  " +
					"       And c.lv_id = ? " +
					"       And t.dateEnd between ? And ? " +
					"      And r.id = c.Room_Id) t, Patients c  " +
					"    Where t.patient = c.id " +
					"    Group By t.lv, t.patient"
			);
			ps.setInt(1, id);
			ps.setString(2, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(3, Util.dateDB(Util.get(req, "period_end")));
			ps.setInt(4, id);
			ps.setString(5, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(6, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			while (rs.next()) {
				ObjList a = new ObjList();
				a.setC1(rs.getString("fio"));
				a.setC2(Util.dateToString(rs.getDate("date_begin")));
				a.setC3(Util.dateToString(rs.getDate("date_end")));
				a.setC4(rs.getString("lux_count"));
				a.setC5(rs.getString("lux_sum"));
				a.setC6(rs.getString("delux_count"));
				a.setC7(rs.getString("delux_sum"));
				a.setC8(rs.getString("simple_count"));
				a.setC9(rs.getString("simple_sum"));
				a.setC10(rs.getString("total_count"));
				a.setC11(rs.getString("total_sum"));
				a.setC12(rs.getString("bonus_sum"));
				a.setC13(rs.getString("bonus"));
				//
				rows.add(a);
			}
			ps = conn.prepareStatement(
				"Select concat(f.surname, ' ', f.name, ' ', f.middlename) fio, " +
					"       date(f.Reg_Date) reg_date, " +
					"       date(t.confDate) conf_date, " +
					"       c.name,  " +
					"       t.price Summ,  " +
					"       c.bonusProc,  " +
					"       t.price * Case When a.bonusProc > 0 Then a.bonusPorc Else c.bonusProc End / 100 Bonus  " +
					"  From amb_patient_services t, Amb_Patients f, Amb_Services c, Amb_Groups a  " +
					" Where t.state = 'DONE'  " +
					"   And t.worker_Id = ? " +
					"   And t.confDate between ? And ? " +
					"   And c.id = t.service_Id  " +
					"   And c.group_id = a.id  " +
					"   And (c.bonusProc > 0 Or a.bonusProc > 0)  " +
					"   And f.id = t.patient " +
					" Order By f.Reg_Date, f.id"
			);
			ps.setInt(1, id);
			ps.setString(2, Util.dateDB(Util.get(req, "period_start")));
			ps.setString(3, Util.dateDB(Util.get(req, "period_end")));
			rs = ps.executeQuery();
			while (rs.next()) {
				ObjList a = new ObjList();
				//
				a.setC1(rs.getString("fio"));
				a.setC2(Util.dateToString(rs.getDate("reg_date")));
				a.setC3(Util.dateToString(rs.getDate("conf_date")));
				a.setC4(rs.getString("name"));
				a.setC5(rs.getString("summ"));
				a.setC6(rs.getString("bonusProc"));
				a.setC7(rs.getString("bonus"));
				//
				ambs.add(a);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DB.done(conn);
			DB.done(ps);
			DB.done(rs);
		}
		m.addAttribute("rows", rows);
		m.addAttribute("ambs", ambs);
		// ��������� ������
		m.addAttribute("params", params);
	}

	// �����������
	private void rep67(HttpServletRequest req, Model m){
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<ObjList> rows = new ArrayList<>();
		//
		String cat = Util.get(req, "cat");
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		try {
			ps = conn.prepareStatement(
				"Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
					"         Date_Format(t.Result_Date, '%d.%m.%Y') cr_on, " +
					"         p.birthyear, " +
					"         u.fio doc, " +
					"         p.yearNum reg_num, " +
					"        (Select sex.Name From Sel_Opts sex WHERE sex.id = p.sex_id) Sex_Name, " +
					"         '����' type_name, " +
					"         p.Start_Diagnoz diagnoz, " +
					"         t.Result_Date " +
					" From Lv_Plans t, Kdos c, Patients p, Users u " +
					" Where t.Kdo_Id = c.id " +
					"   And t.patientId = p.id " +
					"   And c.id = 288 " + (cat != null && cat.equals("1") ? " And 1=0 " : "") +
					"   And u.id = p.lv_id " +
					"   And date (t.Result_Date) Between ? and ? " +
					" Union All " +
					" Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
					"  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
					"        p.BirthYear, " +
					"        u.fio doc, " +
					"        p.id reg_num, " +
					"        (Select sex.Name From Sel_Opts sex WHERE sex.id = p.sex) Sex_Name, " +
					"        '���' type_name, " +
					"        '��������' diagnoz, " +
					"        t.confDate " +
					"   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p, Users u " +
					"  Where ser.Id = t.Service_Id " +
					"    And p.Id = t.Patient " +
					"    And u.id = t.worker_id " +
					"		 And ser.id in (314) " + (cat != null && cat.equals("2") ? " And 1=0 " : "") +
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
		// ��������� ������
		m.addAttribute("params", params);
	}

	// ���������
	private void rep68(HttpServletRequest req, Model m){
		Connection conn = DB.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String params = "";
		List<ObjList> rows = new ArrayList<>();
		//
		String cat = Util.get(req, "cat");
		Date startDate = Util.getDate(req, "period_start");
		Date endDate = Util.getDate(req, "period_end");
		params += "���������: ������: " + Util.dateToString(startDate) + " - " + Util.dateToString(endDate);
		try {
			ps = conn.prepareStatement(
				"Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio,  " +
					"         Date_Format(t.Result_Date, '%d.%m.%Y') cr_on, " +
					"         p.birthyear, " +
					"         u.fio doc, " +
					"         c.name ser_name, " +
					"        (Select sex.Name From Sel_Opts sex WHERE sex.id = p.sex_id) Sex_Name, " +
					"         '����' type_name, " +
					"         p.Start_Diagnoz diagnoz, " +
					"         t.Result_Date " +
					" From Lv_Plans t, Kdos c, Patients p, Users u " +
					" Where t.Kdo_Id = c.id " +
					"   And t.patientId = p.id " +
					"   And c.kdo_type = 19 " + (cat != null && cat.equals("1") ? " And 1=0 " : "") +
					"   And u.id = p.lv_id " +
					"   And date (t.Result_Date) Between ? and ? " +
					" Union All " +
					" Select Concat(p.surname, ' ',  p.name, ' ', p.middlename) Fio, " +
					"  			 Date_Format(t.confDate, '%d.%m.%Y') cr_on, " +
					"        p.BirthYear, " +
					"        u.fio doc, " +
					"        ser.name ser_name, " +
					"        (Select sex.Name From Sel_Opts sex WHERE sex.id = p.sex) Sex_Name, " +
					"        '���' type_name, " +
					"        '��������' diagnoz, " +
					"        t.confDate " +
					"   From Amb_Patient_Services t, Amb_Services ser, Amb_Patients p, Users u " +
					"  Where ser.Id = t.Service_Id " +
					"    And p.Id = t.Patient " +
					"    And u.id = t.worker_id " +
					"		 And ser.group_id in (36) " + (cat != null && cat.equals("2") ? " And 1=0 " : "") +
					" 	 And date(t.crOn) Between ? and ? " +
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
				service.setC5(rs.getString("ser_name"));
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
		// ��������� ������
		m.addAttribute("params", params);
	}

}
