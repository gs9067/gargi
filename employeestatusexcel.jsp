
<%@page import="com.intranet.service.ServiceAppContext"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="org.springframework.context.ApplicationContext"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>
<%@page import="com.intranet.service.ServiceAppContext" %>
<%@page import="com.intranet.employee.service.IEmploeeService"%>
<%@page import="com.intranet.employee.service.EmployeeService"%>
<%@page import="com.intranet.entity.Employee"%>

<%@page import="java.util.List"%>
<%@page import="com.intranet.util.DateUtils"%>
<%@page import="com.intranet.entity.Employee"%>

<%@page import="java.util.ArrayList"%>
<%@page import=" java.util.Properties"%>
<%@page import="com.intranet.util.ApplicationReader" %>
<%@page import="org.apache.poi.ss.usermodel.Workbook"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@page import="java.io.InputStream" %>
<%@page import="java.io.FileInputStream" %>
<%@page import="java.io.File" %>
<%@page import="java.io.FileOutputStream" %>
<%@page import="java.io.OutputStream" %>
<%@page import="org.apache.poi.util.IOUtils"%>
<%@page import="org.apache.poi.ss.usermodel.Picture"%>
<%@page import="org.apache.poi.ss.usermodel.ClientAnchor"%>
<%@page import="org.apache.poi.ss.usermodel.CreationHelper"%>
<%@page import="org.apache.poi.ss.usermodel.Drawing"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFCell"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFCellStyle"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFFont"%>
<%@page import="com.intranet.entity.Department"%>
<%@page import="com.intranet.department.service.IDepartmentService"%>
<%@page import="com.intranet.location.service.ILocationService"%>
<%@page import="com.intranet.entity.Company"%>
<%@page import="com.intranet.company.service.ICompanyService"%>
<%@page import="com.intranet.company.service.CompanyService"%>

<%@page import="javax.servlet.http.HttpServletResponse"%>
<%@page import="javax.servlet.http.HttpServletRequest"%>


<%
try{
 
	  ApplicationContext appContext=ServiceAppContext.getApplicationContext();
	  IEmploeeService empService=(IEmploeeService)appContext.getBean("employeeService"); 
	  ICompanyService compService=(ICompanyService)appContext.getBean("companyService"); 
      
      List<Employee> empList= empService.getAllEmployee();
      System.out.println("empList->"+empList.size());
	  
      List<Company> complist=compService.getAllCompany();
      System.out.println("complist->"+complist.size());
      
      
      
      List<Employee>empStatusList=new ArrayList<Employee>();
      
      
     //if(request.getParameter("type")!=null && request.getParameter("type").equalsIgnoreCase("empstatus")){
    	 String employee= request.getParameter("name");
     // System.out.println("employee->"+name);
      
      
      String company=request.getParameter("company");
      System.out.println("company->"+company);
      
      Company companyName=compService.getCompanyById(Integer.parseInt(company));
      System.out.println("companyName->"+companyName);
      
      String status=request.getParameter("status");
      System.out.println("status->"+status); 
    	  
        /* if(employee!=null && !employee.equalsIgnoreCase("")){
		empStatusList = empService.getEmpStatusList(Integer.parseInt(company), Integer.parseInt(employee), status);
		 System.out.println(" without employee name empStatusList is->"+empStatusList.size());
	}else{
		empStatusList = empService.getEmpStatusList(Integer.parseInt(company), null, status);
		 System.out.println("with employee name empStatusList is->"+empStatusList.size()); 
		 
	} */
      
    
      
      Properties property=ApplicationReader.INSTANCE.getProperties();
      XSSFWorkbook book= new XSSFWorkbook();
      XSSFSheet sheet= book.createSheet("Status of Employee");
      System.out.println("Sheet created.");
       
      String logoPath=property.getProperty("empstatussheet_logo.filepath");
      InputStream is = null;
		
		 is = new FileInputStream(logoPath+File.separator+"employeestatussheetLogo.png");
		
			
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
              
              XSSFCellStyle style1= book.createCellStyle();
              XSSFFont font1=book.createFont();
              font1.setFontHeightInPoints((short)8);
              font1.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
              style1.setFont(font1);
              
              XSSFRow row=sheet.createRow((short)0);
              XSSFCell cell=row.createCell((short)0);
              cell.setCellValue("EMPLOYEE STATUS SHEET");
              cell.setCellStyle(style);
              System.out.println("1st row Created");
              
              XSSFRow row1=sheet.createRow((short) 1);
              //XSSFCell cell1=row1.createCell(columnIndex);
              
                
		      String[] index={"Employee Name","Date Of Joining","Designation","Department"};
		      for(int cellNum=0;cellNum<index.length;cellNum++){
		    	  XSSFCell cellA = row1.createCell((short)cellNum);
		    	  cellA.setCellValue(index[cellNum]);
		    	  cellA.setCellStyle(style);                            
		      }
		      System.out.println("empstatus sheet header row Created");
		      String [][] excelData = new String [10000][25];
		      int slCount=1;
		      int columnCount=1;
		      int serialNo=0;
		      XSSFRow myRow = null;
		      XSSFCell myCell = null;
	
      
  
		      for(Employee emp:empList)
		      {
		    	  slCount++;
	    		     serialNo++;
	    		     
	    		     myRow = sheet.createRow(slCount);
	    		     
	    		     System.out.println("myRow  created");
	    		     
	    		     excelData[slCount][0]=  emp.getName()+" "+ emp.getMiddleName()+" "+emp.getLastName();
	    			 System.out.println(" employee name"+(emp.getName()+" "+ emp.getMiddleName()+" "+emp.getLastName()));
	    			 
	    			 excelData[slCount][1]=  DateUtils.convertDateToStrng(emp.getDateOfJoing());
	    			 System.out.println(" date of joining"+emp.getDateOfJoing());
	    			 
	    			 excelData[slCount][2]=  emp.getDesignation();
	    			 System.out.println("employee designation is"+emp.getDesignation());
	    			 
	    			
	    			 excelData[slCount][3]=  emp.getDepartment().getName();
	    			 System.out.println("department name"+emp.getDepartment().getName());
	    			 
	    			 
				
				 for (int cellNum = 0; cellNum < 4 ; cellNum++){
					myCell = myRow.createCell((short)cellNum);
					myCell.setCellValue(excelData[slCount][cellNum]); 
					//myCell.setCellStyle(arg0);
				} 
			}
				System.out.println("employee status sheet header row respective cell Created");
				
				File statusfile = new File(property.getProperty("empstatussheet.filepath")); 

				if(!statusfile.isDirectory()){
					statusfile.mkdirs();
					}
				//InputStream is = new FileInputStream(file);
				FileOutputStream fileOut = new FileOutputStream(statusfile+"\\"+"EmployeeStatus.xlsx"); 

				book.write(fileOut);
				fileOut.flush();
				fileOut.close();
				System.out.println("excel sheet Created");
				
				String downloadExcelFileName="EmployeeStatus.xlsx";
				response.setContentType("application/vnd.ms-excel");
				response.setHeader("Content-Disposition", "attachment; filename=\""+downloadExcelFileName+"\"");
				response.setHeader("cache-control", "no-cache");
				OutputStream outExcel = response.getOutputStream();
				
				File file = new File(property.getProperty("empstatussheet.filepath")); 
				
				FileInputStream fileIn = new FileInputStream(file+"\\"+"EmployeeStatus.xlsx"); 

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
      
}
      catch(Exception e)
      {
    	  e.printStackTrace();
      }
				
  
			
 

  
  
		
			   
%>	
		

