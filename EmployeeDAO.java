package com.intranet.employee.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.lucene.analysis.Analyzer;
import org.hibernate.Criteria;
import org.hibernate.Hibernate;
import org.hibernate.Query;
import org.hibernate.criterion.Disjunction;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.intranet.dao.GenericDAO;
import com.intranet.entity.EmpDetl;
import com.intranet.entity.Employee;
import com.intranet.util.DateUtils;

@Repository
public  class EmployeeDAO extends GenericDAO implements IEmployeeDAO {
	
	 
	@SuppressWarnings("unchecked")
	public List<Employee> getAllEmployee(){
		try{
			return createCriteria(Employee.class).add(Restrictions.eq("status", new Byte("1"))).addOrder(Order.asc("name")).list();
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
	public Employee getEmployeeByEmailandPassword(String email,String password){
		//System.out.println("email :"+email+" && password :"+password);
		if(email!=null&&password!=null){

			System.out.println("-if-email :"+email+" &&password :"+password);
			return (Employee)createCriteria(Employee.class).add(Restrictions.eq("email", email)).add(Restrictions.eq("password", password)).add(Restrictions.eq("status", new Byte("1"))).uniqueResult();
 
			//System.out.println("-if-email :"+email+" &&password :"+password);
			//Employee e= (Employee)createCriteria(Employee.class).add(Restrictions.eq("email", email)).add(Restrictions.eq("password", password)).uniqueResult();
			//System.out.println("emp from database : "+e);
			//return e;

		}else{
			return null;
		}
	}
	
	public List<Employee> getEmployeeBySearchString(String serachstring,Employee emp){
		List<Employee> employeeList=new ArrayList<Employee>();
		Disjunction diskey = Restrictions.disjunction();
		Criteria crit=createCriteria(Employee.class);
		
		if(emp.getDepartment().getDepartmentId()==4){
			diskey.add(Restrictions.ilike("name", serachstring+"%")).add(Restrictions.ilike("lastName", serachstring+"%")).add(Restrictions.ilike("tag", serachstring+"%")); 
		 //employeeList =createCriteria(Employee.class).add(Restrictions.ilike("name", serachstring+"%")).add(Restrictions.ne("employeeId", emp.getEmployeeId())).list();
		//List<Employee> employeeList = getHibernateSession().createQuery("from Employee where ((lower(name) like '"+serachstring+"%')) and employeeId").list();
			crit.add(Restrictions.ne("employeeId", emp.getEmployeeId()));
		}else{
			diskey.add(Restrictions.ilike("name", serachstring+"%")).add(Restrictions.ilike("lastName", serachstring+"%")).add(Restrictions.ilike("tag", serachstring+"%"));
			
			crit.add(Restrictions.ne("employeeId", emp.getEmployeeId())).add(Restrictions.eq("status", new Byte("1")));
		}
		crit.add(diskey);
		employeeList=crit.list();
		return employeeList;
	}
	
	
	public List<Employee> getAvailabilityCount(Employee user){
		
		return createCriteria(Employee.class).add(Restrictions.eq("availability", 1)).add(Restrictions.ne("employeeId", user.getEmployeeId())).add(Restrictions.eq("status", new Byte("1"))).list();
	}
	
	public List<Employee> getAllEmployeesByLocationanddepartmentId(Integer locationId,Integer departmentId){
		return createCriteria(Employee.class).add(Restrictions.eq("location.locationId",locationId)).add(Restrictions.eq("department.departmentId", departmentId)).add(Restrictions.eq("status", new Byte("1"))).list();
	}
	
	
	public List<Employee> getAllBodEmployee(){
		//return createCriteria(Employee.class).list();
		
        Query query = getHibernateSession().createSQLQuery( "SELECT * FROM `g_employee` WHERE MONTH(`d_birth`)=MONTH(CURDATE()) AND DAY(`d_birth`)=DAY(CURDATE()) AND STATUS=1").addEntity(Employee.class);
       
        return (List<Employee>)query.list();
    }
	
	public Employee getEmployeeByEmail(String email){
	
		if(email!=null){
			//System.out.println("-if-email :"+email);
			return (Employee)createCriteria(Employee.class).add(Restrictions.eq("email", email)).add(Restrictions.eq("status", new Byte("1"))).uniqueResult();
		}else{
			return null;
		}
	}
	
	public Employee getEmployeeByCode(String code) {
		// TODO Auto-generated method stub
		return (Employee)createCriteria(Employee.class).add(Restrictions.eq("employeeCode", code)).uniqueResult();
	}
	
	public List<Employee> getAllEmployeesByDepartmentId(Integer departmentId){
		return createCriteria(Employee.class).add(Restrictions.eq("department.departmentId", departmentId)).add(Restrictions.ne("levelInDep", 1)).add(Restrictions.eq("status", new Byte("1"))).list();
		//return createCriteria(Employee.class).add(Restrictions.eq("department.departmentId", departmentId)).add(Restrictions.ne("levelInDep", 1)).list();
	}
	
	public List<Employee> getAllHOD(){
		return createCriteria(Employee.class).add(Restrictions.eq("levelInDep", 1)).add(Restrictions.eq("status", new Byte("1"))).list();
		
	}
	
	public List<Employee> getAllEmployeeByDepartmentIdAndCompanyId(Integer departmentId,Integer companyId){
		//return createCriteria(Employee.class).add(Restrictions.eq("department.departmentId", departmentId)).add(Restrictions.ne("levelInDep", 1)).add(Restrictions.eq("status", new Byte("1"))).list();
		return createCriteria(Employee.class).add(Restrictions.eq("department.departmentId", departmentId)).add(Restrictions.eq("company.companyId", companyId)).list();
	}

	@Override
	public List<Employee> getAllEmployeeByCompanyId(Integer companyId) {
		// TODO Auto-generated method stub
		return createCriteria(Employee.class).add(Restrictions.eq("company.companyId", companyId)).add(Restrictions.eq("company.companyId", companyId)).add(Restrictions.eq("status", new Byte("1"))).list();
	}
	
	
	public List<Employee> getEmpoloyeeByBdayMonth(String month, Integer companyId){
		
		try {
			/*Criteria crit = createCriteria(Employee.class);
			
			crit.add(Restrictions.sqlRestriction("MONTH(d_birth) = ?", Integer.valueOf(month),Hibernate.INTEGER));
			System.out.println("crit=="+crit.list().size());
			
			return crit.list();*/
			int month1 = Integer.valueOf(month);
			Query query = getHibernateSession().createSQLQuery( "SELECT * FROM `g_employee` WHERE MONTH(`d_birth`)="+month1+" AND company_id= "+ companyId +" AND `status`=1").addEntity(Employee.class);
			System.out.println("query=="+query.list().size());
		       
	        return (List<Employee>)query.list();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return null;
		
	}
	
	
	public List<Employee> getEmpoloyeeByNameAndDOJ(String empId,String doj){
		
		try {
			Criteria crit = createCriteria(Employee.class);
			
			if(empId!=null && !empId.equalsIgnoreCase("")){
				crit.add(Restrictions.eq("employeeId", Integer.parseInt(empId)));
			}
			
			if(empId!=doj && !doj.equalsIgnoreCase("")){
				crit.add(Restrictions.eq("dateOfJoing", DateUtils.convertStrToDate(doj)));
			}
			
			
			System.out.println("doj list in daoo=="+crit.list().size());
			
			return crit.list();
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return null;
	}
	
	
	
	public List<Employee> getAllNewJoineeList(String frmDate, String toDate, String desig, String dept, String level, String location, String companyId){
		
		try {
			Criteria crit = createCriteria(Employee.class);
			
			if(frmDate!=null && !frmDate.equalsIgnoreCase("")){
				crit.add(Restrictions.ge("dateOfJoing", DateUtils.convertStrToDate(frmDate)));
			}
			
			if(toDate!=null && !toDate.equalsIgnoreCase("")){
				crit.add(Restrictions.le("dateOfJoing", DateUtils.convertStrToDate(toDate)));
			}
			
			if(desig!=null && !desig.equalsIgnoreCase("")){
				crit.add(Restrictions.eq("designation", desig));
			}
			
			if(dept!=null && !dept.equalsIgnoreCase("")){
				crit.add(Restrictions.eq("department.departmentId", Integer.parseInt(dept)));
			}
			
			
			if(level!=null && !level.equalsIgnoreCase("")){
				crit.add(Restrictions.eq("level.levelId", Integer.parseInt(level)));
			}
			
			if(location!=null && !location.equalsIgnoreCase("")){
				crit.add(Restrictions.eq("location.locationId", location));
			}
			crit.add(Restrictions.eq("company.companyId", Integer.parseInt(companyId)));
			System.out.println("new joinee  list in daoo=="+crit.list().size());
			
			return crit.list();
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return null;
	}
	
	public List<EmpDetl> getCompemsationReport(String empId,String desig, String dept, String level, String location){
		
		try {
			Criteria crit = createCriteria(EmpDetl.class);
			crit.createAlias("employee", "employeeObj");
			
			if(empId!=null && !empId.equalsIgnoreCase("")){
				crit.add(Restrictions.eq("employeeObj.employeeId", Integer.parseInt(empId)));
			}
			
			if(desig!=null && !desig.equalsIgnoreCase("")){
				crit.add(Restrictions.eq("employeeObj.designation", desig));
			}
			
			if(dept!=null && !dept.equalsIgnoreCase("")){
				crit.createAlias("employeeObj.department", "deptObj");
				crit.add(Restrictions.eq("deptObj.departmentId", Integer.parseInt(dept)));
			}
			
			
			if(level!=null && !level.equalsIgnoreCase("")){
				crit.createAlias("employeeObj.level", "levelObj");
				crit.add(Restrictions.eq("levelObj.levelId", Integer.parseInt(level)));
			}
			
			if(location!=null && !location.equalsIgnoreCase("")){
				crit.createAlias("employeeObj.location", "locationObj");
				crit.add(Restrictions.eq("locationObj.locationId", Integer.parseInt(location)));
			}
			
			System.out.println("compensation  list in daoo=="+crit.list().size());
			
			return crit.list();
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return null;
	}

	@Override
	public List<Employee> getEmpListForCompemsationReport(String empId,
			String desig, String dept, String level, String location) {
		try{
			Criteria crit = createCriteria(Employee.class);
			
			if(empId!=null && !empId.equalsIgnoreCase("")){
				crit.add(Restrictions.eq("employeeId", Integer.parseInt(empId)));
			}
			
			if(desig!=null && !desig.equalsIgnoreCase("")){
				crit.add(Restrictions.eq("designation", desig));
			}
			
			if(dept!=null && !dept.equalsIgnoreCase("")){
				crit.createAlias("department", "deptObj");
				crit.add(Restrictions.eq("deptObj.departmentId", Integer.parseInt(dept)));
			}
			
			
			if(level!=null && !level.equalsIgnoreCase("")){
				crit.createAlias("level", "levelObj");
				crit.add(Restrictions.eq("levelObj.levelId", Integer.parseInt(level)));
			}
			
			if(location!=null && !location.equalsIgnoreCase("")){
				crit.createAlias("location", "locationObj");
				crit.add(Restrictions.eq("locationObj.locationId", Integer.parseInt(location)));
			}
			
			System.out.println("compensation  list in daoo=="+crit.list().size());
			
			return crit.list();
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public EmpDetl getCompemsationReportByEmpId(Integer empId) {
		try{
			Criteria crit = createCriteria(EmpDetl.class);
			crit.createAlias("employee", "employeeObj");
			crit.add(Restrictions.eq("employeeObj.employeeId", empId));
			crit.addOrder(Order.desc("empDetlId"));
			crit.setMaxResults(1);
			return (EmpDetl) crit.uniqueResult();
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public Employee getEmployeeByPersonalEmail(String personalEmail) {
		try{
			Criteria crit = createCriteria(Employee.class);
			crit.add(Restrictions.eq("emailPersonal", personalEmail));
			return (Employee) crit.uniqueResult();
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public List<Employee> getEmpStatusList(Integer cmpnyId, Integer empId,
			String status) {
		try{
			Criteria crit = createCriteria(Employee.class);
			if(cmpnyId!=null){
				crit.add(Restrictions.eq("company.companyId", cmpnyId));
			}
			if(empId!=null){
				crit.add(Restrictions.eq("employeeId", empId));
			}
			if(status!=null && !status.equalsIgnoreCase("")){
				crit.add(Restrictions.eq("status", new Byte(status)));
			}
			return crit.list();
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public List<Employee> getWorkAnniversaryList(String empId, String month,
			String companyId) {
		try{
			int month1 = Integer.valueOf(month);
			String sqlQuery="";
			if(empId!=null && !empId.equalsIgnoreCase("")){
				sqlQuery = "SELECT * FROM `g_employee` WHERE MONTH(`d_joining`)="+month1+" AND company_id= "+ companyId +" AND employee_id= " + empId + " AND `status`=1";
			}else{
				sqlQuery = "SELECT * FROM `g_employee` WHERE MONTH(`d_joining`)="+month1+" AND company_id= "+ companyId +" AND `status`=1";
			}
			Query query = getHibernateSession().createSQLQuery(sqlQuery).addEntity(Employee.class);
			System.out.println("query=="+query.list().size());
			return (List<Employee>)query.list();
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}

	

	

	

	@Override
	public List<Employee> getSupervisorByEmpNameCompany(String empId,
			String companyId) {
		try{
			Criteria crit = createCriteria(Employee.class);
			
			if(empId!=null && !empId.equalsIgnoreCase("")){
				crit.add(Restrictions.eq("employeeId", Integer.parseInt(empId)));
			}
			if(companyId!=null && !companyId.equalsIgnoreCase("")){
				
				crit.add(Restrictions.eq("company.companyId",Integer.parseInt(companyId)));
				System.out.println("company->"+companyId);
			}
			System.out.println("supervisor  list in daoo=="+crit.list().size());
			return crit.list();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return null;
	}

	


	

	

	

	@Override
	public List<Employee> getEmpoloyeeByNameAndBloodgroup(String empId,
			String bloodGrp,String company) {
		try {
			Criteria crit = createCriteria(Employee.class);
			
			if(empId!=null && !empId.equalsIgnoreCase("")){
				crit.add(Restrictions.eq("employeeId", Integer.parseInt(empId)));
				System.out.println("empId->"+empId);
			}
			
			if(bloodGrp!=null && !bloodGrp.equalsIgnoreCase("")){
				crit.add(Restrictions.eq("bloodGroup", bloodGrp));
				System.out.println("bloodGrp->"+bloodGrp);
			}
			if(company!=null && !company.equalsIgnoreCase("")){
				System.out.println("company->"+company);
				crit.createAlias("company", "companyobj");
				crit.add(Restrictions.eq("companyobj.companyId",Integer.parseInt(company)));
				
			}
			
			System.out.println("blood grp  list in daoo=="+crit.list().size());
			
			return crit.list();
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return null;
		
	}
	

	

	


	
}
