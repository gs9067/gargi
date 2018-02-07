
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="org.springframework.context.ApplicationContext"%>
<%@page import="com.intranet.service.ServiceAppContext" %>
<%@page import="com.intranet.util.ApplicationReader" %>
<%@page import=" java.util.Properties"%>
<%@page import="com.intranet.entity.Company"%>
<%@page import="com.intranet.company.service.ICompanyService"%>
<%@page import="com.intranet.employee.service.IEmploeeService"%>
<%@page import="com.intranet.entity.Employee"%>

<%@page import="javax.servlet.http.HttpServletResponse"%>
<%@page import="javax.servlet.http.HttpServletRequest"%>

<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.intranet.util.DateUtils"%>
<%@page import="java.util.Date"%>

<%@page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFCell"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFCellStyle"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFFont"%>
<%@page import="org.apache.poi.ss.usermodel.Drawing"%>
<%@page import="org.apache.poi.ss.usermodel.Picture"%>
<%@page import="org.apache.poi.ss.usermodel.ClientAnchor"%>
<%@page import="org.apache.poi.ss.usermodel.CreationHelper"%>
<%@page import="org.apache.poi.ss.usermodel.Workbook"%>

<%@page import="java.io.InputStream" %>
<%@page import="java.io.FileInputStream" %>
<%@page import="java.io.FileOutputStream" %>
<%@page import="java.io.OutputStream" %>
<%@page import="java.io.File" %>
<%@page import="org.apache.poi.util.IOUtils"%>


<%
  try{
    ApplicationContext context=ServiceAppContext.getApplicationContext();
    ICompanyService compService=(ICompanyService)context.getBean("companyService");
    IEmploeeService empService=(IEmploeeService)context.getBean("employeeService");

    List<Employee> employeeList=empService.getAllEmployee();
    System.out.println("employeeList->"+employeeList.size());

    List<Company> companyList=compService.getAllCompany();
    System.out.println("companyList->"+companyList.size());

    List<Employee>supervisorList= new ArrayList<Employee>();
    
    String empId = request.getParameter("Employee");
    System.out.println("empId->"+empId);
    
    String cmpnyId=request.getParameter("company");
    System.out.println("cmpnyId->"+cmpnyId);
    
    Company company= compService.getCompanyById(Integer.parseInt(cmpnyId));
    System.out.println("company->"+company);

    Employee employee = empService.getEmployeeById(Integer.parseInt(empId));
    System.out.println("employee->"+employee);
 	   
    supervisorList= empService.getSupervisorByEmpNameCompany(empId,cmpnyId);
    System.out.println("supervisorList->"+supervisorList.size());
  
    
     Properties property=ApplicationReader.INSTANCE.getProperties();
	
	
	String logoPath=property.getProperty("supervisorsheet_logo.filepath");
	
	 XSSFWorkbook book= new XSSFWorkbook();
	 XSSFSheet sheet= book.createSheet("supervisor details of - "+company.getCompnayName());
	 System.out.println("Sheet created.");
	 
	 InputStream is = null;
		
	 is = new FileInputStream(logoPath+File.separator+"supervisorsheetLogo.png");
	
		
		 byte[] bytes=IOUtils.toByteArray(is);
		int pictureIndex= book.addPicture(bytes,Workbook.PICTURE_TYPE_PNG);
	    is.close();
	      
	      CreationHelper helper= book.getCreationHelper();
	      Drawing drawingpatriarch= sheet.createDrawingPatriarch();
	      ClientAnchor anchor= helper.createClientAnchor();
	      
	      anchor.setCol1(4);
	      anchor.setRow1(6);
	      
	      Picture pic=drawingpatriarch.createPicture(anchor, pictureIndex);
	      pic.resize(0.5);
	      
	      System.out.println("Logo Created"); 
	      
	      XSSFFont font=book.createFont();
	      font.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
	      font.setFontHeightInPoints((short) 12);
	      XSSFCellStyle style=book.createCellStyle();
	      style.setFont(font);
	      
	      XSSFCellStyle style1 = book.createCellStyle();
	      XSSFFont font1 = book.createFont();
	      
	      font1.setFontHeightInPoints((short)8);
	      font1.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
	      
	      style1.setFont(font1);
	      
	      XSSFRow row=sheet.createRow((short)0);
	      XSSFCell cell=row.createCell((short)0);
	      cell.setCellValue("SUPERVISOR DETAILS SHEET");
	      cell.setCellStyle(style);
	      
	      
	      System.out.println("1st row Created");
	      
	      XSSFRow row1 = sheet.createRow((short) 1);
	      
	      String[] index={"Employee Code.","Employee Name","Designation","Date Of Joining","Department","Supervisor","Primary Skills","Secondary Skills","Total Exp (In Months)"};
	      for(int cellNum=0;cellNum<index.length;cellNum++){
	    	  XSSFCell cellA = row1.createCell((short)cellNum);
	    	  cellA.setCellValue(index[cellNum]);
	    	  cellA.setCellStyle(style);                            
	      }
	      System.out.println("supervisorsheet header row Created");
	      String [][] excelData = new String [10000][25];
	      int slCount=1;
	      int columnCount=1;
	      int serialNo=0;
	      XSSFRow myRow = null;
	      XSSFCell myCell = null;
	      
	      
	   
				
				for(Employee emp:supervisorList){
					
				     slCount++;
	    		     serialNo++;
	    		     
	    		     myRow = sheet.createRow(slCount);
	    		     
	    		     System.out.println("myRow  created");
	    			 
	    			 excelData[slCount][0]=  emp.getEmployeeCode();
	    			 System.out.println("employee code come"+emp.getEmployeeCode());
	    			 excelData[slCount][1]=  emp.getName()+" "+ emp.getMiddleName()+" "+emp.getLastName();
	    			 System.out.println(" employee name"+(emp.getName()+" "+ emp.getMiddleName()+" "+emp.getLastName()));
	    			 excelData[slCount][2]=  emp.getDesignation();
	    			 System.out.println(" employee designation"+(emp.getDesignation()));
	    			 excelData[slCount][3]=  DateUtils.convertDateToStrng(emp.getDateOfJoing());
	    			 System.out.println(" employee date of joining"+(emp.getDateOfJoing()));
	    			 excelData[slCount][4]= emp.getDepartment().getName();
	    			 System.out.println(" employee department name"+(emp.getDepartment().getName()));
	    			 excelData[slCount][5]=  employee.getName()+" "+ employee.getMiddleName()+" "+employee.getLastName();
	    			 System.out.println(" employee supervisor name"+(emp.getName()+" "+ emp.getMiddleName()+" "+employee.getLastName()));
	    			 excelData[slCount][6]= emp.getDepartment().getName();;
	    			 System.out.println("employee primary skills"+(emp.getDepartment().getName()));
	    			 excelData[slCount][7]= emp.getDepartment().getName();  ;
	    			 System.out.println("employee secondary skills"+(emp.getDepartment().getName()));
	    			 /* excelData[slCount][8]=  String.valueOf(diffInMonth);
	    			 System.out.println(" Total Exp (In Months)"+(String.valueOf(diffInMonth))); */
	    			 
				 for (int cellNum = 0; cellNum < 10 ; cellNum++){
					myCell = myRow.createCell((short)cellNum);
					myCell.setCellValue(excelData[slCount][cellNum]); 
					//myCell.setCellStyle(arg0);
				} 
			}
				System.out.println("supervisorsheet header row respective cell Created");
//		      }
	    			 

File newjoineefile = new File(property.getProperty("supervisorsheet.filepath")); 

if(!newjoineefile.isDirectory()){
newjoineefile.mkdirs();
}
//InputStream is = new FileInputStream(file);
FileOutputStream fileOut = new FileOutputStream(newjoineefile+"\\"+"Supervisor.xlsx"); 

book.write(fileOut);
fileOut.flush();
fileOut.close();

System.out.println("excel sheet Created");

String downloadExcelFileName="Supervisor.xlsx";
response.setContentType("application/vnd.ms-excel");
response.setHeader("Content-Disposition", "attachment; filename=\""+downloadExcelFileName+"\"");
response.setHeader("cache-control", "no-cache");
OutputStream outExcel = response.getOutputStream();

File file = new File(property.getProperty("supervisorsheet.filepath")); 
//InputStream is = new FileInputStream(file);
//FileInputStream fileIn = new FileInputStream(file); 
FileInputStream fileIn = new FileInputStream(file+"\\"+"Supervisor.xlsx"); 

byte[] outputByte = new byte[8192]; 
//copy binary contect to output stream 
while(fileIn.read(outputByte, 0, 8192) != -1) 
{ 
outExcel.write(outputByte, 0, 8192); 
} 

fileIn.close(); 
outExcel.flush(); 
outExcel.close(); 
System.out.println("excel sheet downloaded");
     
    
    
    
    }  catch(Exception e)
    {
    	e.printStackTrace();
    }
      
 

 

%>
