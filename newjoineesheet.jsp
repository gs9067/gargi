<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


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
 
 ApplicationContext context= ServiceAppContext.getApplicationContext();
ICompanyService compService=(ICompanyService)context.getBean("companyService");
IEmploeeService empService=(IEmploeeService)context.getBean("employeeService");




List<Employee> employeeList=empService.getAllEmployee();
System.out.println("employeeList->"+employeeList.size());

List<Company> companyList=compService.getAllCompany();
System.out.println("companyList->"+companyList.size());

List<Employee>newjoineeList=new ArrayList<Employee>();

String frmDate = request.getParameter("fromdate").trim();
System.out.println("fromdate->"+frmDate);

String toDate = request.getParameter("todate".trim());
System.out.println("todate->"+toDate);

String cmpnyId = request.getParameter("company");
System.out.println("company->"+cmpnyId);                            
                                                                  

String desig=request.getParameter("Designation");

String dept=request.getParameter("Dept");

String lev=request.getParameter("Level");
String loc=request.getParameter("Location");


  Company company= compService.getCompanyById(Integer.parseInt(cmpnyId));
  
  newjoineeList=  empService.getAllNewJoineeList(frmDate, toDate,desig,dept,lev,loc,cmpnyId);
  System.out.println("newjoineeList->"+newjoineeList);
  
  Properties property=ApplicationReader.INSTANCE.getProperties();
		
		
		String logoPath=property.getProperty("newjoineesheet_logo.filepath");
		
		 XSSFWorkbook book= new XSSFWorkbook();
		 XSSFSheet sheet= book.createSheet("new joinee of - "+company.getCompnayName());
		 System.out.println("Sheet created.");
		 
		 InputStream is = null;
			
		 is = new FileInputStream(logoPath+File.separator+"birthdaysheetLogo.png");
		
			
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
		      cell.setCellValue("NEW JOINEE SHEET");
		      cell.setCellStyle(style);
		      
		      
		      System.out.println("1st row Created");
		      
		      XSSFRow row1 = sheet.createRow((short) 1);
		      
		      String[] index={"Employee Code.","Employee Name"};
		      for(int cellNum=0;cellNum<index.length;cellNum++){
		    	  XSSFCell cellA = row1.createCell((short)cellNum);
		    	  cellA.setCellValue(index[cellNum]);
		    	  cellA.setCellStyle(style);                            
		      }
		      System.out.println("newjoineesheet header row Created");
		      String [][] excelData = new String [10000][25];
		      int slCount=1;
		      int columnCount=1;
		      int serialNo=0;
		      XSSFRow myRow = null;
		      XSSFCell myCell = null;
		      
		      
		   
					
					for(Employee emp:newjoineeList){
						
					     slCount++;
		    		     serialNo++;
		    		     
		    		     myRow = sheet.createRow(slCount);
		    		     
		    		     System.out.println("myRow  created");
		    			 
		    			 excelData[slCount][0]=  emp.getEmployeeCode();
		    			 System.out.println("employee code come"+emp.getEmployeeCode());
		    			 excelData[slCount][1]=  emp.getName()+" "+ emp.getMiddleName()+" "+emp.getLastName();
		    			 System.out.println(" employee name"+(emp.getName()+" "+ emp.getMiddleName()+" "+emp.getLastName()));
		    			 
		    			 
		    			 
					
					 for (int cellNum = 0; cellNum < 2 ; cellNum++){
						myCell = myRow.createCell((short)cellNum);
						myCell.setCellValue(excelData[slCount][cellNum]); 
						//myCell.setCellStyle(arg0);
					} 
				}
					System.out.println("newjoineesheet header row respective cell Created");
// 		      }
		    			 
	
File newjoineefile = new File(property.getProperty("newjoineesheet.filepath")); 

if(!newjoineefile.isDirectory()){
	newjoineefile.mkdirs();
	}
//InputStream is = new FileInputStream(file);
FileOutputStream fileOut = new FileOutputStream(newjoineefile+"\\"+"Newjoinee.xlsx"); 

book.write(fileOut);
fileOut.flush();
fileOut.close();

System.out.println("excel sheet Created");

String downloadExcelFileName="Newjoinee.xlsx";
response.setContentType("application/vnd.ms-excel");
response.setHeader("Content-Disposition", "attachment; filename=\""+downloadExcelFileName+"\"");
response.setHeader("cache-control", "no-cache");
OutputStream outExcel = response.getOutputStream();

File file = new File(property.getProperty("newjoineesheet.filepath")); 
//InputStream is = new FileInputStream(file);
//FileInputStream fileIn = new FileInputStream(file); 
FileInputStream fileIn = new FileInputStream(file+"\\"+"Newjoinee.xlsx"); 

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