<!doctype html>

<%@page import="java.text.DateFormat"%>
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
<%@page import="java.util.List"%>
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
	#customDatatable tbody{font-size:13px;}
	#customDatatable tbody>tr>td{text-align:center;}
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

List<Employee> empStatusList = null;

List<Employee> employeeList=employeeService.getAllEmployee();
List<Company> companyList=companyService.getAllCompany();
String empstatus="";
if(request.getParameter("type")!=null && request.getParameter("type").equalsIgnoreCase("empstatus")){

	String cmpny = request.getParameter("cmpny_g");
	System.out.println("cmpny->"+cmpny);
	String emp = request.getParameter("emp");
	System.out.println("emp->"+emp);
	String status = request.getParameter("status");
	if(status.equalsIgnoreCase("1")){
		empstatus="Active";
	}
	if(status.equalsIgnoreCase("2")){
		empstatus="Block";
	}
	if(status.equalsIgnoreCase("0")){
		empstatus="In-Active";
	}
	if(emp!=null && !emp.equalsIgnoreCase("")){
		empStatusList = employeeService.getEmpStatusList(Integer.parseInt(cmpny), Integer.parseInt(emp), status);
	}else{
		empStatusList = employeeService.getEmpStatusList(Integer.parseInt(cmpny), null, status);
	}
	
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
	            <form class="form-horizontal" role="form" action="employeestatus_report.jsp?type=empstatus" name="employeestatus_report" id="employeestatus_report" method="post" onsubmit="return validateEmployeeStatus();">
	            <span id="errorMesage" class="message errors span12 noMarginPadding" style="display: none;"></span>
	            <div class="clearfix"></div>
				<fieldset style="margin-top:10px;">
	            	<legend><i class="icon-user"></i>Employee Status Report</legend>
	            	<div class="row-fluid">
	            	
	            		<div class="span4"><label>Company <span></span></label>
			               	<select id="cmpny_g" name="cmpny_g" class="form-control" onchange="cmpnyonchange(document.employeestatus_report.cmpny_g.value,'emp');"> 
					            <option value="">select</option>
					            <%if(companyList.size()>0){
		 			            	for(Company cmp : companyList){%>
					            		<option value="<%=cmp.getCompanyId()%>"><%=cmp.getCompnayName()%></option>
					            	<%}
					            }%>
		 	             	</select>
			            </div>
		                <div class="span4">
		                	<label>Employee Name</label>
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
		               
		              <div class="span4">
			              <label>Status <span></span></label>
		               		<select name="status" id="status" class="form-control">
		               			<option value="">Select Status</option>
			                 	<option value="1">Active</option>
				                <option value="0">InActive</option>
				                <option value="2">Block</option>
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
            
           <%if(empStatusList!=null && empStatusList.size()>0){ %>
           
           <div class="span12" style="margin-left:0;">
           	<p style="color:#000; font-size:20px; line-height:30px; margin-bottom:10px; background: #DFE9F1 !important; padding-left:10px;"><%=empstatus %> List</p>
           </div>
            <div class="span12" style="margin-left:0;">
              
               <a href="employeestatusexcel.jsp?company=<%=request.getParameter("cmpny_g")%>&name=<%=request.getParameter("emp")%>&status=<%=request.getParameter("status")%>" style="margin-right:50px;" >
          			<i class="icon-download-alt"></i><b>Download Report</b></a>
          			<br>
              
            	<table id="customDatatable" class="display" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th>Employee Name</th>
                            <th>Date Of Joining</th>
                            <th>Designation</th>
                            <th>Department</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%for(Employee emp:empStatusList){ %>
                        <tr>
                            <td><%=emp==null?"":(emp.getName()==null?"":emp.getName())+" "+ (emp.getMiddleName()==null?"":emp.getMiddleName())+" "+(emp.getLastName()==null?"":emp.getLastName())%></td>
                            <td><%=emp==null?"":emp.getDateOfJoing()==null?"":DateUtils.convertDateToStrng(emp.getDateOfJoing())%></td>
                            <td><%=emp==null?"":emp.getDesignation()==null?"":emp.getDesignation()%></td>
                            <td><%=emp==null?"":emp.getDepartment()==null?"":emp.getDepartment().getName()%></td>
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
<script src="js/jquery.dataTables.min.js"></script>

<script>
	setactive('hrReportTree');
	 $( document ).ready(function() {
		  $('#hrreporttreeopen').show();
		  
		  $('#customDatatable').DataTable();
	});	
</script>
</body>
</html>