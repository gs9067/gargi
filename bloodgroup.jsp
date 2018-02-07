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

List<Employee> bloodGrpList = null;

List<Employee> employeeList=employeeService.getAllEmployee();
List<Company> companyList=companyService.getAllCompany();

if(request.getParameter("type")!=null && request.getParameter("type").equalsIgnoreCase("bloodGroup")){
	
	String emp = request.getParameter("emp").trim();
	System.out.println("emp->"+emp);
	
	String bloodGrp = request.getParameter("bloodGrp").trim();
	System.out.println("bloodGrp->"+bloodGrp);
	
	//Integer companyId= Integer.getInteger(request.getParameter("cmpny_g")).intValue();
    String cmpnyId = request.getParameter("cmpny_g");
    System.out.println("cmpnyId->"+cmpnyId);
	
	bloodGrpList = employeeService.getEmpoloyeeByNameAndBloodgroup(emp,bloodGrp,cmpnyId);
	System.out.println("bloodGrpList->"+bloodGrpList.size());
	
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
	            <form class="form-horizontal" role="form" action="bloodgroup.jsp?type=bloodGroup" name="bloodgroupreport" id="bloodgroupreport" method="post" onsubmit="return validateBloodGrp();">
	            <span id="errorMesage" class="message errors span12 noMarginPadding" style="display: none;"></span>
	            <div class="clearfix"></div>
				<fieldset style="margin-top:10px;">
	            	<legend><i class="icon-user"></i>Blood Group Report</legend>
	            	<div class="row-fluid">
	            	
	            		<div class="span4"><label>Company <span></span></label>
			               	<select id="cmpny_g" name="cmpny_g" class="form-control" onchange="cmpnyonchange(document.bloodgroupreport.cmpny_g.value,'emp');"> 
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
			              <label>Blood Group</label>
		               		<select name="bloodGrp" id="bloodGrp" class="form-control">
			                 <option value="" >Select blood group</option>
			                 
			                 <option value="A+" >A+</option>
			                 <option value="A-" >A-</option>
			                 <option value="B+" >B+</option>
			                 <option value="B-" >B-</option>
			                 <option value="AB+" >AB+</option>
			                 <option value="AB-" >AB-</option>
			                 <option value="O+" >O+</option>
			                 <option value="O-" >O-</option>
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
            
            
           <%if(bloodGrpList!=null && bloodGrpList.size()>0){ %>
            
            <div class="span12" style="margin-left:0;">
              
             
          			<a href="bloodgroupsheet.jsp?emploee=<%=request.getParameter("emp")%>&bloodgr=<%=request.getParameter("bloodGrp").trim()%>&company=<%=request.getParameter("cmpny_g")%>" style="margin-right:50px;" >
          			<i class="icon-download-alt"></i><b>Download Report</b></a>
          			<br>
               
            	<table id="customDatatable" class="display" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th>Employee Code</th>
                            <th>Employee Name</th>
                            <th>Contact No.</th>
                            <th>Emergency Contact</th>
                            <th>Dependent Name</th>
                            <th>Blood Group</th>
                            
                        </tr>
                    </thead>
                    <tbody>
                    <%for(Employee emp:bloodGrpList){ %>
                        <tr>
                            <td><%=emp==null?"":emp.getEmployeeCode()==null?"": emp.getEmployeeCode() %></td>
                            <td><%=emp==null?"":(emp.getName()==null?"":emp.getName())+" "+ (emp.getMiddleName()==null?"":emp.getMiddleName())+" "+(emp.getLastName()==null?"":emp.getLastName())%></td>
                            <td><%=emp==null?"":emp.getMobileNo()==null?"":emp.getMobileNo()%></td>
                            <td><%=emp==null?"":emp.getAlternativePhoneNo()==null?"":emp.getAlternativePhoneNo()%></td>
                            <td><%=emp==null?"":emp.getSpouseName()==null?"":emp.getSpouseName()%></td>
                            <td><%=emp==null?"":emp.getBloodGroup()==null?"":emp.getBloodGroup()%></td>
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