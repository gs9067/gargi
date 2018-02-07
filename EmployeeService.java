package com.intranet.employee.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.caucho.quercus.annotation.ReadOnly;
import com.intranet.employee.dao.EmployeeDAO;
import com.intranet.employee.dao.IEmployeeDAO;
import com.intranet.entity.EmpDetl;
import com.intranet.entity.Employee;
import com.intranet.service.GenericServiceImpl;

@Service("employeeService")
@Transactional(propagation=Propagation.REQUIRED, readOnly = true)
public class EmployeeService extends GenericServiceImpl implements 
		IEmploeeService {  
	
	@Autowired 
	IEmployeeDAO employeeDAO;

	
	@Override
	@Transactional(readOnly = true)
	public List<Employee> getAllEmployee() {
		return employeeDAO.getAllEmployee();
	}

	@Override
	@Transactional(readOnly = true)
	public Employee getEmployeeById(Integer employeeId){
		return employeeDAO.findById(Employee.class, employeeId);
	}
	
	@Override
	@Transactional(readOnly = false)
	public Employee saveOrUpdate(Employee employee){
		
		return employeeDAO.saveOrUpdate(employee);
	}
	
	@Override
	@Transactional(readOnly = true)
	public Employee getEmployeeByEmailandPassword(String email,String password){
		return employeeDAO.getEmployeeByEmailandPassword(email,password);
	}
	
	@Override
	@Transactional(readOnly = true)
	public List<Employee> getEmployeeBySearchString(String serachstring,Employee emp){
		return employeeDAO.getEmployeeBySearchString(serachstring,emp);
	}
	
	@Override
	@Transactional(readOnly = true)
	public List<Employee> getAvailabilityCount(Employee user){
		return employeeDAO.getAvailabilityCount(user);
	}

	@Override
	@Transactional(readOnly = true)
	public List<Employee> getAllEmployeesByLocationanddepartmentId(
			Integer locationId, Integer departmentId) {
		// TODO Auto-generated method stub
		return employeeDAO.getAllEmployeesByLocationanddepartmentId(locationId, departmentId); 
	}

	@Override
	@Transactional(readOnly = true)
	public List<Employee> getAllBodEmployee() {
		// TODO Auto-generated method stub
		return employeeDAO.getAllBodEmployee();
	}

	@Override
	@Transactional(readOnly = true)
	public Employee getEmployeeByEmail(String email) {
		// TODO Auto-generated method stub
		return employeeDAO.getEmployeeByEmail(email); 
	}

	@Override
	@Transactional(readOnly = true)
	public Employee getEmployeeByCode(String code) {
		// TODO Auto-generated method stub
		return employeeDAO.getEmployeeByCode(code);
	}

	@Override
	@Transactional(readOnly = true)
	public List<Employee> getAllEmployeesByDepartmentId(Integer departmentId) {
		// TODO Auto-generated method stub
		return employeeDAO.getAllEmployeesByDepartmentId(departmentId); 
	}

	@Override
	@Transactional(readOnly = true)
	public List<Employee> getAllHOD() {
		// TODO Auto-generated method stub
		return employeeDAO.getAllHOD();
	}

	@Override
	@Transactional(readOnly = true)
	public List<Employee> getAllEmployeeByDepartmentIdAndCompanyId(Integer departmentId,Integer companyId) {
		// TODO Auto-generated method stub
		return employeeDAO.getAllEmployeeByDepartmentIdAndCompanyId(departmentId,companyId); 
	}

	@Override
	public List<Employee> getAllEmployeeByCompanyId(Integer companyId) {
		// TODO Auto-generated method stub
		return employeeDAO.getAllEmployeeByCompanyId(companyId);
	}

	@Override
	public List<Employee> getEmpoloyeeByBdayMonth(String month, Integer companyId) {
		// TODO Auto-generated method stub
		return employeeDAO.getEmpoloyeeByBdayMonth(month, companyId);
	}

	@Override
	public List<Employee> getEmpoloyeeByNameAndDOJ(String empId, String doj) {
		// TODO Auto-generated method stub
		return employeeDAO.getEmpoloyeeByNameAndDOJ(empId, doj);
	}
	
	

	

	@Override
	public List<Employee> getAllNewJoineeList(String frmDate, String toDate,
			String desig, String dept, String level, String location, String companyId) {
		// TODO Auto-generated method stub
		return employeeDAO.getAllNewJoineeList(frmDate, toDate, desig, dept, level, location, companyId);
	}

	@Override
	public List<EmpDetl> getCompemsationReport(String empId, String desig, String dept,
			 String level, String location) {
		// TODO Auto-generated method stub
		return employeeDAO.getCompemsationReport(empId, desig, dept,  level, location);
	}

	@Override
	public List<Employee> getEmpListForCompemsationReport(String empId,
			String desig, String dept, String level, String location) {
		try{
			return employeeDAO.getEmpListForCompemsationReport(empId, desig, dept,  level, location);
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public EmpDetl getCompemsationReportByEmpId(Integer empId) {
		try{
			return employeeDAO.getCompemsationReportByEmpId(empId);
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public Employee getEmployeeByPersonalEmail(String personalEmail) {
		try{
			return employeeDAO.getEmployeeByPersonalEmail(personalEmail);
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public List<Employee> getEmpStatusList(Integer cmpnyId, Integer empId,
			String status) {
		try{
			return employeeDAO.getEmpStatusList(cmpnyId, empId, status);
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public List<Employee> getWorkAnniversaryList(String empId, String month,
			String companyId) {
		try{
			return employeeDAO.getWorkAnniversaryList(empId, month, companyId);
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public List<Employee> getSupervisorByEmpNameCompany(String empId,
			String companyId) {
		try{
			return employeeDAO.getSupervisorByEmpNameCompany(empId, companyId);
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return null;
	}

	@Override
	public List<Employee> getEmpoloyeeByNameAndBloodgroup(String empId,
			String bloodGrp, String company) {
		try{
			return employeeDAO.getEmpoloyeeByNameAndBloodgroup(empId, bloodGrp,company);
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}

	
    
	
	/*public List<Employee> getEmpoloyeeBdaySheet(String employeeCode,
			String name, String dateOfJoining, String dateOfBirth) {
		try{
			return employeeDAO.getEmpoloyeeByBdayMonth(employeeCode,name,dateOfJoining,dateOfBirth);
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}*/
	
	 
}
