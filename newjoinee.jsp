<!doctype html>

<%@page import="com.intranet.designation.service.IDesignationService"%>
<%@page import="com.intranet.entity.Designation"%>
<%@page import="com.intranet.entity.Company"%>
<%@page import="com.intranet.company.service.ICompanyService"%>
<%@page import="com.intranet.util.DateUtils"%>
<%@page import="java.util.Date"%>
<%@page import="com.intranet.util.CryptoUtils"%>
<%@page import="com.intranet.entity.Location"%>
<%@page import="com.intranet.entity.Department"%>
<%@page import="com.intranet.department.service.IDepartmentService"%>
<%@page import="com.intranet.location.service.ILocationService"%>
<%@page import="com.intranet.entity.Level"%>
<%@page import="com.intranet.level.service.ILevelService"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.intranet.broadcast.service.IBroadcastService"%>
<%@page import="com.intranet.entity.Broadcast"%>
<%@page import="com.intranet.sanction.service.ISanctionService"%>
<%@page import="com.intranet.sanctionprocess.service.ISanctionProcessService"%>
<%@page import="java.util.List"%>
<%@page import="com.intranet.entity.Sanction"%><html>
<head>
<%@ include file="../includes/head.jsp" %>

<title>Report</title>
<link href="https://cdn.datatables.net/1.10.13/css/jquery.dataTables.min.css" rel="stylesheet">

<style>
	.customReportBox legend{text-indent:4px; padding-left:0;}
	.customReportBox select{width:230px;}
	.clearfix{clear:both;}
	#customDatatable thead>tr>th:after{display:none}
	#customDatatable thead>tr>th{color:#fff; background-color:#f37622; border-right:1px solid #fff; font-weight:normal; font-size:13px;}
	#customDatatable thead>tr>th:last-child{border-right:none;}
</style>
</head>
<body>

<%@ include file="../includes/header.jsp" %>

<div class="main-container container">
<%@ include file="/includes/nav.jsp" %>

<div class="main-content">
<%@ include file="/includes/breadcrums.jsp" %>
<script src="js/ajax.js"> </script>
<%
ApplicationContext appContext = WebApplicationContextUtils.getWebApplicationContext(request.getSession().getServletContext());
ILevelService levelService=(ILevelService)appContext.getBean("levelService");
ILocationService locationService = (ILocationService)appContext.getBean("locationService");
IDepartmentService departmentService = (IDepartmentService)appContext.getBean("departmentService");
IEmploeeService employeeService=(IEmploeeService)appContext.getBean("employeeService");
ICompanyService companyService=(ICompanyService)appContext.getBean("companyService");
IDesignationService designationService = (IDesignationService)appContext.getBean("designationService");

List<Department> departmentList=departmentService.getAllDepartment();
List<Location> locationListt=locationService.getAllLocation();
List<Level> levelList=levelService.getAllLevel();
List<Employee> employeeList=employeeService.getAllEmployee();
List<Company> companyList=companyService.getAllCompany();

List<Designation> designationList = designationService.getAllDesignation();

List<Location> locationList=new ArrayList<Location>();
Employee emp=null;
String bdDate="";
String gender="";
String employeeId="";
List<Employee> reportingempList=new ArrayList<Employee>();
List<Employee> deptEmpList=new ArrayList<Employee>();
if(request.getParameter("type")!=null && request.getParameter("type").equals("edit") && request.getParameter("empId")!=null){
Integer empId=Integer.parseInt(CryptoUtils.dodecrypt(request.getParameter("empId")));
//System.out.println("empId>>"+empId);	

emp=employeeService.getEmployeeById(empId); 
//System.out.println("emp>>"+emp.getName());

Date bdayDate=emp.getDateOfBirth();
bdDate=DateUtils.convertDateToStrng(bdayDate); 
gender=emp.getGender().toString();

if(emp!=null && emp.getEmployeeId()!=null){
employeeId=emp.getEmployeeId().toString();
}

if(emp!=null && emp.getDepartment()!=null){
//employeeId=emp.getEmployeeId().toString();
 deptEmpList= employeeService.getAllEmployeesByDepartmentId(emp.getDepartment().getDepartmentId()); 
 
 List<Employee> empHodList=employeeService.getAllHOD();
 
 System.out.println("empHodList>>"+empHodList.size());
 if(deptEmpList!=null && deptEmpList.size()>0){
 for(Employee employee:deptEmpList){
	 reportingempList.add(employee);
 }
 }
 
 if(empHodList!=null && empHodList.size()>0){
	   for(Employee employee:empHodList){
		   reportingempList.add(employee);
	 }
}

 if(reportingempList!=null && reportingempList.size()>0){
 for(Employee employee:reportingempList){
	// System.out.println("name>>"+employee.getName());
 } 
 } 
}

if(emp!=null && emp.getCompany()!=null){
	  locationList=locationService.getAllLocationsByCompany(emp.getCompany().getCompanyId());
}

 
}else if(request.getParameter("type")==null && request.getParameter("empId")!=null){
	Integer empId=Integer.parseInt(CryptoUtils.dodecrypt(request.getParameter("empId")));
	//System.out.println("empId>>"+empId);	

	emp=employeeService.getEmployeeById(empId); 
	//System.out.println("emp>>"+emp.getName());

	Date bdayDate=emp.getDateOfBirth();
	bdDate=DateUtils.convertDateToStrng(bdayDate); 
	gender=emp.getGender().toString();

	if(emp!=null && emp.getEmployeeId()!=null){
	employeeId=emp.getEmployeeId().toString();
	}

	if(emp!=null && emp.getDepartment()!=null){
	//employeeId=emp.getEmployeeId().toString();
	 deptEmpList= employeeService.getAllEmployeesByDepartmentId(emp.getDepartment().getDepartmentId()); 
	 
	 List<Employee> empHodList=employeeService.getAllHOD();
	 
	 System.out.println("empHodList>>"+empHodList.size());
	 if(deptEmpList!=null && deptEmpList.size()>0){
	 for(Employee employee:deptEmpList){
		 reportingempList.add(employee);
	 }
	 }
	 
	 if(empHodList!=null && empHodList.size()>0){
		   for(Employee employee:empHodList){
			   reportingempList.add(employee);
		 }
	}

	 if(reportingempList!=null && reportingempList.size()>0){
	 for(Employee employee:reportingempList){
		// System.out.println("name>>"+employee.getName());
	 } 
	 } 
	}

	if(emp!=null && emp.getCompany()!=null){
		  locationList=locationService.getAllLocationsByCompany(emp.getCompany().getCompanyId());
	}

	
}

List<Employee> newJoineeList = null;

if(request.getParameter("type")!=null && request.getParameter("type").equals("newjoinee")){
	
	String frmDate = request.getParameter("newjoineefrom");
	String toDate = request.getParameter("newjoineeto");
	String designation = request.getParameter("designation");
	String dept = request.getParameter("dept");
	String level = request.getParameter("level");
	String location = request.getParameter("location");
	String cmpnyId = request.getParameter("cmpny_g");
	
	newJoineeList = employeeService.getAllNewJoineeList(frmDate,toDate,designation,dept,level,location, cmpnyId);
	
}




%>

<div class="page-content">
<div class="row-fluid">
    <div class="span12">
        <div class="page-header position-relative">
            <h1>Report</h1>
        </div><!--/.page-header-->
        
        <div class="row-fluid customReportBox">
            <div class="span12">
	            <form class="form-horizontal" role="form" action="newjoinee.jsp?type=newjoinee" name="newjoineereport" id="newjoineereport" method="post" onsubmit="return validateNewJoinee();">
	            <span id="errorMesage" class="message errors span12 noMarginPadding" style="display: none;"></span>
	          
				<fieldset>
	            	<legend><i class="icon-user"></i> New Joinee Report</legend>
	            	<div class="row-fluid">
		                 <div class="span4">
			              <label>From date <span></span></label>
		               		<input type="text" name="newjoineefrom" id="newjoineefrom" readonly class="form-control" />
		              </div>
		               <div class="span4">
			              <label>To Date <span></span></label>
		               		<input type="text" name="newjoineeto" id="newjoineeto" readonly class="form-control" />
		              </div>
		              
		              <div class="span4"><label>Company <span></span></label>
			               	<select id="cmpny_g" name="cmpny_g" class="form-control" > 
					            <option value="">select</option>
					            <%if(companyList.size()>0){
		 			            	for(Company cmp : companyList){%>
					            		<option value="<%=cmp.getCompanyId()%>"><%=cmp.getCompnayName()%></option>
					            	<%}
					            }%>
		 	             	</select>
			            </div>
	                </div>
	                
	                
	                <div class="row-fluid" style="margin-top:15px;">
	                
	                 <div class="span4">
		                	<label>Department</label>
			                <select name="dept" id="dept" class="form-control">
			                 <option value="" >Select Department</option>
			                 <%
			                   if(departmentList.size()>0){
			        	 		for(Department dept:departmentList){%>
			                       <option value="<%=dept.getDepartmentId()%>"><%=dept.getName()%></option>
		
		              		  <% }
			               	}       %>
			               </select>
		                </div>
		                
		                <div class="span4">
		                	<label>Level</label>
			                <select name="level" id="level" class="form-control">
			                 <option value="" >Select Level</option>
			                 <%
			                   if(levelList.size()>0){
			        	 		for(Level level:levelList){%>
			                       <option value="<%=level.getLevelId()%>"><%=level.getName()%></option>
		
		              		  <% }
			               	}       %>
			               </select>
		                </div>
		                <div class="span4">
		                	<label>Location</label>
			                <select name="location" id="location" class="form-control">
			                 <option value="" >Select Location</option>
			                 <%
			                   if(locationListt.size()>0){
			        	 		for(Location location:locationListt){%>
			                       <option value="<%=location.getLocationId()%>"><%=location.getName()%></option>
		
		              		  <% }
			              		}       %>
			               </select>
		                </div>
	                </div>
	                
	                <div class="row-fluid" style="margin-top:15px;">
	                	<div class="span4">
		                	<label>Designation</label>
			                <select name="designation" id="designation" class="form-control">
			                 <option value="" >Select Designation</option>
			                 <%
			                   if(designationList.size()>0){
			        	 		for(Designation designation:designationList){%>
			                       <option value="<%=designation.getName()%>"><%=designation.getName()%></option>
		
		              		  <% }
			              		}       %>
			               </select>
		                </div>
	                </div>
	            </fieldset> 
	            	<div class="clearfix"></div>           
	                <div class="row-fluid" style="margin-top:15px;">
	                	<div class="span12 text-right">
	                		<input type="submit" value="Search" id="" name="" class="btn btn-small btn-info fr" />
	                	</div>
	                </div>                                              
	      
	            </form>                  
            </div>
            <!--end of span12-->
            
            <!-- table report -->          
            
            <%if(newJoineeList!=null && newJoineeList.size()>0){ %>
            
            <div class="span12" style="margin-left:0;">
              
              <a href="newjoineesheet.jsp?fromdate=<%=request.getParameter("newjoineefrom")%>&todate=<%=request.getParameter("newjoineeto")%>&Designation=<%=request.getParameter("designation")%>&Dept=<%=request.getParameter("dept")%>&Level=<%=request.getParameter("level")%>&Location=<%=request.getParameter("location")%>&company=<%=request.getParameter("cmpny_g")%>" style="margin-right:50px;" >
          			<i class="icon-download-alt"></i><b>Download Report</b></a>
          			<br>
               
            	<table id="customDatatable" class="display" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th>Employee Code</th>
                            <th>Employee Name</th>
                        </tr>
                    </thead>
                    <tbody>
                       <%for(Employee newJoinee:newJoineeList){ %>
                        <tr>
                            <td><%=newJoinee==null?"":newJoinee.getEmployeeCode()==null?"": newJoinee.getEmployeeCode() %></td>
                            <td><%=newJoinee==null?"":(newJoinee.getName()==null?"":newJoinee.getName())+" "+ (newJoinee.getMiddleName()==null?"":newJoinee.getMiddleName())+" "+(newJoinee.getLastName()==null?"":newJoinee.getLastName())%></td>
                            
                        </tr>
                        
                     	<%} %>
                        
                    </tbody>
                </table>
            	
            </div>
            
            <%} %>
            
        </div>
        
    </div><!-- end of span86-->


</div>
</div><!--end of page content -->
        
</div><!--end of main content-->

<%@ include file="../includes/foot.jsp" %>
</div>
<script src="https://cdn.datatables.net/1.10.13/js/jquery.dataTables.min.js"></script>

<script>
	setactive('hrReportTree');
	 $( document ).ready(function() {
		  $('#hrreporttreeopen').show();
		  
		  $('#customDatatable').DataTable();
	});	
</script>
</body>
</html>