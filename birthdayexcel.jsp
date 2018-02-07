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
		
		
		List<Employee> bDayList = new ArrayList<Employee>();
		
		String bdayMonth = request.getParameter("month").trim();
		System.out.println("bdayMonth->"+bdayMonth);
		
		String company = request.getParameter("company");
		System.out.println("company->"+company);
		
		bDayList = empService.getEmpoloyeeByBdayMonth(bdayMonth, Integer.parseInt(company));
		Company companyName=companyService.getCompanyById(Integer.parseInt(company)); 
		
		System.out.println("bDayList->"+bDayList.size());
		
		//DateFormat formatter = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		Properties property=ApplicationReader.INSTANCE.getProperties();
		
		
		String logoPath=property.getProperty("birthdaysheet_logo.filepath");
		
		 XSSFWorkbook book= new XSSFWorkbook();
		 XSSFSheet sheet= book.createSheet("Birthday  of - "+companyName.getCompnayName());
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
		      cell.setCellValue("BIRTHDAY SHEET");
		      cell.setCellStyle(style);
		      
		      
		      System.out.println("1st row Created");
		      
		      XSSFRow row1 = sheet.createRow((short) 1);
		      
		      String[] index={"Employee Code.","Employee Name","Date Of Joining","Date Of Birth"};
		      for(int cellNum=0;cellNum<index.length;cellNum++){
		    	  XSSFCell cellA = row1.createCell((short)cellNum);
		    	  cellA.setCellValue(index[cellNum]);
		    	  cellA.setCellStyle(style);                            
		      }
		      System.out.println("birthdaysheet header row Created");
		      String [][] excelData = new String [10000][25];
		      int slCount=1;
		      int columnCount=1;
		      int serialNo=0;
		      XSSFRow myRow = null;
		      XSSFCell myCell = null;
		      
		      
		     /*  if(request.getParameter("type")!=null && request.getParameter("type").equalsIgnoreCase("birthday"))
		      {
					
					
					
					bDayList = empService.getEmpoloyeeByBdayMonth(bdayMonth, Integer.parseInt(company)); */
					
					for(Employee emp:bDayList){
						
					     slCount++;
		    		     serialNo++;
		    		     
		    		     myRow = sheet.createRow(slCount);
		    		     
		    		     System.out.println("myRow  created");
		    			 
		    			 excelData[slCount][0]=  emp.getEmployeeCode();
		    			 System.out.println("employee code come"+emp.getEmployeeCode());
		    			 excelData[slCount][1]=  emp.getName()+" "+ emp.getMiddleName()+" "+emp.getLastName();
		    			 System.out.println(" employee name"+(emp.getName()+" "+ emp.getMiddleName()+" "+emp.getLastName()));
		    			 excelData[slCount][2]=  DateUtils.convertDateToStrng(emp.getDateOfJoing());
		    			 System.out.println(" date of joining"+emp.getDateOfJoing());
		    			 excelData[slCount][3]=  DateUtils.convertDateToStrng(emp.getDateOfBirth());
		    			 System.out.println("date of birth"+emp.getDateOfBirth());
		    			 
		    			 
					
					 for (int cellNum = 0; cellNum < 4 ; cellNum++){
						myCell = myRow.createCell((short)cellNum);
						myCell.setCellValue(excelData[slCount][cellNum]); 
						//myCell.setCellStyle(arg0);
					} 
				}
					System.out.println("birthdaysheet header row respective cell Created");
// 		      }
		    			 
	
File birthdayfile = new File(property.getProperty("birthdaysheet.filepath")); 

if(!birthdayfile.isDirectory()){
	birthdayfile.mkdirs();
	}
//InputStream is = new FileInputStream(file);
FileOutputStream fileOut = new FileOutputStream(birthdayfile+"\\"+"Birthday.xlsx"); 

book.write(fileOut);
fileOut.flush();
fileOut.close();

System.out.println("excel sheet Created");

String downloadExcelFileName="Birthday.xlsx";
response.setContentType("application/vnd.ms-excel");
response.setHeader("Content-Disposition", "attachment; filename=\""+downloadExcelFileName+"\"");
response.setHeader("cache-control", "no-cache");
OutputStream outExcel = response.getOutputStream();

File file = new File(property.getProperty("birthdaysheet.filepath")); 
//InputStream is = new FileInputStream(file);
//FileInputStream fileIn = new FileInputStream(file); 
FileInputStream fileIn = new FileInputStream(file+"\\"+"Birthday.xlsx"); 

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
		

