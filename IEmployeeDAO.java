package com.intranet.employee.dao;

import java.util.List;

import com.intranet.dao.IGenericDAO;
import com.intranet.entity.EmpDetl;
import com.intranet.entity.Employee;

public interface IEmployeeDAO extends IGenericDAO {

	public List<Employee> getAllEmployee();
	
	public Employee getEmployeeByEmailandPassword(String email,String password);
	
	public List<Employee> getEmployeeBySearchString(String serachstring,Employee emp);
	
	public List<Employee> getAvailabilityCount(Employee user);
	
	public List<Employee> getAllEmployeesByLocationanddepartmentId(Integer locationId,Integer departmentId);
	public List<Employee> getAllBodEmployee();
	public Employee getEmployeeByEmail(String email);
	
	public Employee getEmployeeByCode(String code);
	public List<Employee> getAllEmployeesByDepartmentId(Integer departmentId);
	public List<Employee> getAllHOD();
	public List<Employee> getAllEmployeeByDepartmentIdAndCompanyId(Integer departmentId,Integer companyId);
	
	public List<Employee> getAllEmployeeByCompanyId(Integer companyId);
	
	public List<Employee> getEmpoloyeeByBdayMonth(String month, Integer companyId);
	public List<Employee> getEmpoloyeeByNameAndDOJ(String empId,String doj);
	public List<Employee> getEmpoloyeeByNameAndBloodgroup(String empId,
			String bloodGrp, String company);
	public List<Employee> getAllNewJoineeList(String frmDate, String toDate, String desig, String dept, String level, String location, String companyId);
	public List<EmpDetl> getCompemsationReport(String empId, String desig, String dept,String level, String location);
	public List<Employee> getEmpListForCompemsationReport(String empId, String desig, String dept,String level, String location);
	public EmpDetl getCompemsationReportByEmpId(Integer empId);
	
	public Employee getEmployeeByPersonalEmail(String personalEmail);
	
	public List<Employee> getEmpStatusList(Integer cmpnyId, Integer empId, String status);
	
	public List<Employee> getWorkAnniversaryList(String empId,String month, String companyId);

	public List<Employee> getSupervisorByEmpNameCompany(String empId,
			String companyId);

	
}
