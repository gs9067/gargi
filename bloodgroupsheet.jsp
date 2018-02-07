<%@page import="java.util.ArrayList"%>
<%@page import="com.intranet.employee.service.IEmploeeService"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.text.DateFormat"%>
<%@page import="com.intranet.entity.Company"%>
<%@page import="com.intranet.company.service.ICompanyService"%>
<%@page import="com.intranet.util.DateUtils"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import=" java.util.Properties"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFCell"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFCellStyle"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFFont"%>
<%@page import="com.intranet.employee.service.EmployeeService"%>
<%@page import="com.intranet.entity.Employee"%>
<%@page import="org.apache.poi.ss.usermodel.Drawing"%>
<%@page import="org.apache.poi.ss.usermodel.Picture"%>
<%@page import="org.apache.poi.ss.usermodel.ClientAnchor"%>
<%@page import="org.apache.poi.ss.usermodel.CreationHelper"%>
<%@page import="org.apache.poi.ss.usermodel.Workbook"%>
<%@page import="org.apache.poi.hssf.util.HSSFColor"%>
<%@page import="javax.servlet.http.HttpServletResponse"%>

<%@page import="javax.servlet.http.HttpServletRequest"%>
<%@page import="org.apache.poi.util.IOUtils"%>
<%@page import="com.intranet.service.ServiceAppContext" %>
<%@page import="com.intranet.util.ApplicationReader" %>
<%@page import="java.io.InputStream" %>
<%@page import="java.io.FileInputStream" %>
<%@page import="java.io.FileOutputStream" %>
<%@page import="java.io.OutputStream" %>
<%@page import="java.io.File" %>

<%
  
	try{
		ApplicationContext appContext = ServiceAppContext.getApplicationContext();
		IEmploeeService empService=(IEmploeeService)appContext.getBean("employeeService"); 
		ICompanyService companyService=(ICompanyService)appContext.getBean("companyService"); 
		
		
		
		

	/* 	List<Employee> employeeList=empService.getAllEmployee();
		System.out.println("employeeList->"+employeeList.size());
		
		List<Company> companyList=companyService.getAllCompany();
		System.out.println("companyList->"+companyList.size()); */
		    

		String employee = request.getParameter("emploee");
		System.out.println("employee->"+employee);
		
		String bloodGroup = request.getParameter("bloodgr");
		System.out.println("bloodGroup1->"+bloodGroup);
	/* 	bloodGroup=bloodGroup.trim()+"+";*/
		System.out.println("bloodGroup->"+bloodGroup); 
		
		String company = request.getParameter("company"); 
		System.out.println("company->"+company);
		
		List<Employee> BloodGrpList = new ArrayList<Employee>();
		
		BloodGrpList = empService.getEmpoloyeeByNameAndBloodgroup(employee,bloodGroup,company);
		System.out.println("bloodGrpList->"+BloodGrpList.size());
			
			
			/* Company companyname=companyService.getCompanyById(Integer.parseInt(company));
			System.out.println("companyname->"+companyname); */
		
		Properties property=ApplicationReader.INSTANCE.getProperties();
		
		
		 //String logoPath=property.getProperty("bloodgroup_logo.filepath");
		 
		
		 XSSFWorkbook book= new XSSFWorkbook();
		 XSSFSheet sheet= book.createSheet("Bloodgroup  of - ");
		 System.out.println("Sheet created.");
		 
		 /*InputStream is = null;
			
		 is = new FileInputStream(logoPath+File.separator+"bloodgroupsheetLogo.png");
		
			
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
		       */
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
		      cell.setCellValue("BLOODGROUP SHEET");
		      cell.setCellStyle(style);
		      
		      
		      System.out.println("1st row Created");
		      
		      XSSFRow row1 = sheet.createRow((short) 1);
		      
		      String[] index={"Employee Code.","Employee Name","Contact No.","Emergency Contact","Dependent Name","Blood Group"};
		      for(int cellNum=0;cellNum<index.length;cellNum++){
		    	  XSSFCell cellA = row1.createCell((short)cellNum);
		    	  cellA.setCellValue(index[cellNum]);
		    	  cellA.setCellStyle(style);                            
		      }
		      System.out.println("bloodgroupsheet header row Created");
		      String [][] excelData = new String [10000][25];
		      int slCount=1;
		      int columnCount=1;
		      int serialNo=0;
		      XSSFRow myRow = null;
		      XSSFCell myCell = null;
		      
		      
		     
					
					for(Employee emp:BloodGrpList){
						System.out.println("EmpId=>"+emp.getEmployeeId());
						
					     slCount++;
		    		     serialNo++;
		    		     
		    		     myRow = sheet.createRow(slCount);
		    		     
		    		     System.out.println("myRow  created");
		    			 
		    			 excelData[slCount][0]=  emp.getEmployeeCode();
		    			 //System.out.println("employee code come"+emp.getEmployeeCode());
		    			 excelData[slCount][1]=  emp.getName()+" "+ emp.getMiddleName()+" "+emp.getLastName();
		    			 //System.out.println(" employee name"+(emp.getName()+" "+ emp.getMiddleName()+" "+emp.getLastName()));
		    			 excelData[slCount][2]= emp.getMobileNo();
		    			 //System.out.println(" Employee mobile no"+emp.getMobileNo());
		    			 excelData[slCount][3]=  emp.getAlternativePhoneNo();
		    			 //System.out.println("employee alternative contact"+emp.getAlternativePhoneNo());
		    			 excelData[slCount][4]=  emp.getSpouseName();
		    			 //System.out.println("employee dependent name"+emp.getSpouseName());
		    			 excelData[slCount][5]=  emp.getBloodGroup();
		    			// System.out.println("employee blood group"+emp.getBloodGroup());
		    			 
		    			 
					
					 for (int cellNum = 0; cellNum < 7 ; cellNum++){
						myCell = myRow.createCell((short)cellNum);
						myCell.setCellValue(excelData[slCount][cellNum]); 
						//myCell.setCellStyle(arg0);
					} 
				
					System.out.println("bloodgroupsheet header row respective cell Created");
 		      }
		    			 
	
File bloodgroupfile = new File(property.getProperty("bloodgroup.filepath")); 

if(!bloodgroupfile.isDirectory()){
	bloodgroupfile.mkdirs();
	}
//InputStream is = new FileInputStream(file);
FileOutputStream fileOut = new FileOutputStream(bloodgroupfile+"\\"+"Bloodgroup.xlsx"); 

book.write(fileOut);
fileOut.flush();
fileOut.close();

System.out.println("excel sheet Created");

String downloadExcelFileName="Bloodgroup.xlsx";
response.setContentType("application/vnd.ms-excel");
response.setHeader("Content-Disposition", "attachment; filename=\""+downloadExcelFileName+"\"");
response.setHeader("cache-control", "no-cache");
OutputStream outExcel = response.getOutputStream();

File file = new File(property.getProperty("bloodgroup.filepath")); 
//InputStream is = new FileInputStream(file);
//FileInputStream fileIn = new FileInputStream(file); 
FileInputStream fileIn = new FileInputStream(file+"\\"+"Bloodgroup.xlsx"); 

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

	}catch(Exception e)
	{ 
	 e.printStackTrace();
	}	
   
%>	
		

