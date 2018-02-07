<!doctype html>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.intranet.entity.EmpDetl"%>
<%@page import="com.intranet.designation.service.IDesignationService"%>
<%@page import="com.intranet.entity.Designation"%>
<%@page import="com.intranet.entity.Company"%>
<%@page import="com.intranet.company.service.ICompanyService"%>
<%@page import="com.intranet.util.DateUtils"%>
<%@page import="java.util.Date"%>
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

<style type="text/css">
	.marginTop30{margin-top:30px;}
 	#salaryBox{display:none; padding:6px;}
	#salaryBox table{margin-bottom:0;}
	#salaryBox table tr td{padding:2px 3px;}
	
	.salaryBoxRow td{padding:0;}
	.salaryBoxHead td{text-align:center !important;}
	.table-bordered tbody:first-child tr:first-child td{border-top:1px solid #ddd;}
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

List<Employee> empList = null;
if(request.getParameter("type")!=null && request.getParameter("type").equals("compensation")){
	
	String empId = request.getParameter("emp");
	String designation = request.getParameter("designation");
	String dept = request.getParameter("dept");
	String level = request.getParameter("level");
	String location = request.getParameter("location");
	
	empList = employeeService.getEmpListForCompemsationReport(empId,designation,dept,level,location);
	System.out.println("empList->"+empList.size());
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
	            <form class="form-horizontal" action="compensation_report.jsp?type=compensation" name="compensationreport" id="compensationreport" method="post" onsubmit="return validateCompensationReport();">
	            <span id="errorMesage" class="message errors  span12 noMarginPadding" style="display: none;"></span>
<!-- 	            <span id="successMesage" class=" success message  span12 noMarginPadding" style="display:block;"></span> -->
				<fieldset>
	            	<legend><i class="icon-user"></i> Compensation Report</legend>
	            	<div class="row-fluid">
		                
		                <div class="span4"><label>Company <span></span></label>
			               	<select id="cmpny_g" name="cmpny_g" class="form-control" onchange="cmpnyonchange(document.compensationreport.cmpny_g.value,'emp');"> 
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
			        	 		for(Employee empl:employeeList){
			        	 			String empName = empl.getName()+" "+empl.getMiddleName()+" "+empl.getLastName();%>
			                       <option value="<%=empl.getEmployeeId()%>"><%=empName%></option>
		              		  <% }
			               	}       %>
			               </select>
		                </div>
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
           <%--   --%>
            <!-- table report -->
             <div class="row-fluid customReportBox marginTop30">
                
                
               
                <div class="span12" style="margin-left:0;">
                
                <%if(empList!=null && empList.size()>0){%>
                
               <a href="compensationsheet.jsp?company=<%=request.getParameter("cmpny_g")%>&empl=<%=request.getParameter("emp")%>&designtn=<%=request.getParameter("designation")%>&departmnt=<%=request.getParameter("dept")%>&level=<%=request.getParameter("level")%>&locatn=<%=request.getParameter("location")%>" style="margin-right:50px;" >
          			<i class="icon-download-alt"></i><b>Download Report</b></a>
                
                   <table class="table table-bordered" id="salaryTable_1">
                   
                   	<thead>
	                   	<tr>
	                   		<th>Employee Code</th>
	                        <th>Employee Name</th>
	                        <th>Employee Details</th>
	                   	</tr>
                    </thead>
                    <tbody>
	            	<%for(Employee empObj : empList){
	            		EmpDetl empDetl = employeeService.getCompemsationReportByEmpId(empObj.getEmployeeId());
	            		if(empDetl!=null){
		            		System.out.println("emp dtl id->"+empDetl.getEmpDetlId());
		                	BigDecimal grossPay = new BigDecimal(0.00);
		                	BigDecimal totalDeduction = new BigDecimal(0.00);
		                	grossPay = empDetl.getBasic().add(empDetl.getHra()).add(empDetl.getCommAll()).add(empDetl.getOutfitAll()).add(empDetl.getExeAll());
		                	totalDeduction = empDetl.getPfDeduc().add(empDetl.getpTaxDeduc());
		                	BigDecimal netPay = new BigDecimal(0.00);
		                	netPay = grossPay.subtract(totalDeduction);
	                	%>
	                	<tr>
                           	<td><%=empDetl.getEmployee().getEmployeeCode() %></td>
                            <td><%=(empDetl.getEmployee().getName()==null?"":empDetl.getEmployee().getName())+" "+ (empDetl.getEmployee().getMiddleName()==null?"":empDetl.getEmployee().getMiddleName())+" "+(empDetl.getEmployee().getLastName()==null?"":empDetl.getEmployee().getLastName()) %></td>
                            <td><a href="#" id="salaryViewClick_<%=empDetl.getEmpDetlId()%>" onclick="viewStructure('<%=empDetl.getEmpDetlId()%>');">View Salary Structure</a></td>
                        </tr>
                        <tr class="salaryBoxRow">
                        	<td colspan="3">
                            	<div id="salaryBox" class="salaryBox_<%=empDetl.getEmpDetlId()%>">
                                	<table class="table table-bordered" style="margin-bottom:0;">
                                        <tr>
                                            <td>
                                                <table class="table table-bordered" style="margin-bottom:0; border-top:none;">
                                                    <tr>
                                                        <td colspan="2" style="text-align:center; font-weight:bold;">Earnings</td>
                                                    </tr>
                                                    <tr>
                                                        <td>BASIC</td>
                                                        <td><%=empDetl.getBasic() %></td>
                                                    </tr>
                                                    <tr>
                                                        <td>HRA</td>
                                                        <td><%=empDetl.getHra() %></td>
                                                    </tr>
                                                    <tr>
                                                        <td>COMM. ALL</td>
                                                        <td><%=empDetl.getCommAll() %></td>
                                                    </tr>
                                                    <tr>
                                                        <td>OUTFIT</td>
                                                        <td><%=empDetl.getOutfitAll() %></td>
                                                    </tr>
                                                    <tr>
                                                        <td>EXE.ALL.</td>
                                                        <td><%=empDetl.getExeAll() %></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="font-weight:bold;">Gross pay</td>
                                                        <td style="font-weight:bold;"><%=grossPay %></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="font-weight:bold;">Net pay</td>
                                                        <td style="font-weight:bold;"><%=netPay %></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td>
                                                <table class="table table-bordered" style="margin-bottom:0; border-top:none;">
                                                    <tr>
                                                        <td colspan="2" style="text-align:center; font-weight:bold;">Deduction</td>
                                                    </tr>
                                                    <tr>
                                                        <td>PF</td>
                                                        <td><%=empDetl.getPfDeduc() %></td>
                                                    </tr>
                                                    <tr>
                                                        <td>P.TAX</td>
                                                        <td><%=empDetl.getpTaxDeduc() %></td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp;</td>
                                                        <td>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp;</td>
                                                        <td>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp;</td>
                                                        <td>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="font-weight:bold;">Total Deduction</td>
                                                        <td style="font-weight:bold;"><%=totalDeduction %></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="font-weight:bold;">Payment By</td>
                                                        <td style="font-weight:bold;">Cash</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
	            		<%}
		           	}%>
	            	</tbody>
	          	</table>
		      <% } %>
		      </div>
		    </div>
        </div>
        
    </div><!-- end of span86-->


</div>
</div><!--end of page content -->
        
</div><!--end of main content-->

<%@ include file="../includes/foot.jsp" %>
<!-- </div> -->

<script>
	setactive('hrReportTree');
	$( document ).ready(function() {
		$('#hrreporttreeopen').show();
		$('#salaryTable_1').DataTable();
		/* $("#salaryViewClick").click(function(){
			$("#salaryBox").slideToggle();
		}); */
	});
	
	function viewStructure(id){
		$(".salaryBox_"+id).slideToggle();
	}
</script>
</body>
</html>