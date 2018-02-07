<!doctype html>

<%@page import="java.text.DateFormat"%>
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
	#customDatatable tr>td:first-child{text-align:right; font-weight:700;}
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
IEmploeeService employeeService=(IEmploeeService)appContext.getBean("employeeService");
ICompanyService companyService=(ICompanyService)appContext.getBean("companyService");

Employee emp = null;

List<Employee> employeeList=employeeService.getAllEmployee();
List<Company> companyList=companyService.getAllCompany();
if(request.getParameter("type")!=null && request.getParameter("type").equalsIgnoreCase("supervisor")){
	
	String empId = request.getParameter("emp").trim();
	emp = employeeService.getEmployeeById(Integer.parseInt(empId));
	
	String cmpnyId=request.getParameter("company"); 
	
}

DateFormat formatter = new SimpleDateFormat("dd-MM-yyyy");

%>
<div class="page-content">
<div class="row-fluid">
    <div class="span12">
        <div class="page-header position-relative">
            <h1>Report</h1>
        </div><!--/.page-header-->
        
        <div class="row-fluid customReportBox">
            <div class="span12">
	            <form class="form-horizontal" role="form" action="supervisor.jsp?type=supervisor" name="supervisorreport" id="supervisorreport" method="post" onsubmit="return validateSupervisor();">
	            <span id="errorMesage" class="message errors span12 noMarginPadding" style="display: none;"></span>
	            <div class="clearfix"></div>
				<fieldset style="margin-top:10px;">
	            	<legend><i class="icon-user"></i>Supervisor Report</legend>
	            	<div class="row-fluid">
	            		
	            		<div class="span4"><label>Company <span></span></label>
			               	<select id="cmpny_g" name="cmpny_g" class="form-control" onchange="cmpnyonchange(document.supervisorreport.cmpny_g.value,'emp');" > 
					            <option value="">select</option>
					            <%if(companyList.size()>0){
		 			            	for(Company cmp : companyList){%>
					            		<option value="<%=cmp.getCompanyId()%>"><%=cmp.getCompnayName()%></option>
					            	<%}
					            }%>
		 	             	</select>
			            </div>
		                <div class="span4">
		                	<label>Employee Name <span></span></label>
			                <select name="emp" id="emp" class="form-control">
			                 <option value="" >Select Employee</option>
			                 <%
			                   if(employeeList.size()>0){
			        	 		for(Employee employee:employeeList){%>
			                       <option value="<%=employee.getEmployeeId()%>"><%=employee.getName()%>&nbsp;<%=employee.getMiddleName()%>&nbsp;<%=employee.getLastName()%></option>
		
		              		  <% }
			               	}       %>
			               </select>
		                </div>
		            
	            
	                </div>
	                
	            </fieldset> 
	            	
	            	<div class="clearfix"></div>           
	                <div class="row-fluid" style="margin-top:15px;">
	                	<div class="span12 text-right">
	                		<input type="submit" value="Search" id="" name="" onclick="" class="btn btn-small btn-info fr" />
	                	</div>
	                </div>
	      
	            </form>
            </div>
            <!--end of span12-->
            
            <!-- table report -->
            
            
           <%if(emp!=null){
        	   Employee employee = employeeService.getEmployeeById(emp.getReportAuthorizedId());
        	   
        	   SimpleDateFormat sd=new SimpleDateFormat("yyyy-MM-dd");
        	   
        	   Date frmDt = emp.getDateOfJoing();
        	   Date toDt = new Date();
        	   
        	   int m1 = frmDt.getYear() * 12 + frmDt.getMonth();
        	   int m2 = toDt.getYear() * 12 + toDt.getMonth();
        	   int diffInMonth = m2-m1+1;
       	    
        	   %>
            
            <div class="span12" style="margin-left:0;">
            
               <a href="supervisorsheet.jsp?Employee=<%=request.getParameter("emp")%>&company=<%=request.getParameter("cmpny_g")%>" style="margin-right:50px;" >
          			<i class="icon-download-alt"></i><b>Download Report</b></a>
          			<br>
            
            	<table id="customDatatable" class="display table table-bordered">
            		<tr>
            			<td>Employee Code</td>
            			<td><%=emp==null?"":emp.getEmployeeCode()==null?"": emp.getEmployeeCode() %></td>
            		</tr>
            		<tr>
            			<td>Employee Name</td>
            			<td><%=emp==null?"":(emp.getName()==null?"":emp.getName())+" "+ (emp.getMiddleName()==null?"":emp.getMiddleName())+" "+(emp.getLastName()==null?"":emp.getLastName())%></td>
            		</tr>
            		<tr>
            			<td>Designation</td>
            			<td><%=emp==null?"":emp.getDesignation()==null?"": emp.getDesignation() %></td>
            		</tr>
            		<tr>
            			<td>Date Of Joining</td>
            			<td><%=formatter.format(emp.getDateOfJoing())%></td>
            		</tr>
            		<tr>
            			<td>Department</td>
            			<td><%=emp==null?"":emp.getDepartment()==null?"": emp.getDepartment().getName() %></td>
            		</tr>
            		<tr>
            			<td>Supervisor</td>
            			<td><%=employee==null?"": (employee.getName()==null?"":employee.getName())+" "+ (employee.getMiddleName()==null?"":employee.getMiddleName())+" "+(employee.getLastName()==null?"":employee.getLastName()) %></td>
            		</tr>
            		<tr>
            			<td>Primary Skills</td>
            			<td></td>
            		</tr>
            		<tr>
            			<td>Secondary Skills</td>
            			<td></td>
            		</tr>
            		<tr>
            			<td>Total Exp (In Months)</td>
            			<td><%=String.valueOf(diffInMonth) %></td>
            		</tr>
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
<script src="js/jquery.dataTables.min.js"></script>

<script>
	setactive('hrReportTree');
	 $( document ).ready(function() {
		  $('#hrreporttreeopen').show();
	});	
</script>
</body>
</html>