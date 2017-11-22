<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 

<%!
public Connection connection = null; 
public String name;
public int servingsize;
public int servingunit;
public int calories;
public int fat;
public int protein;
public int carb;
public int cholesterol;
public int sodium;
public String url;
public String ingredientID;
%>

<!-- Establish DB Connection -->
<%@include  file="/common_nav.html" %>
<% 
	
	try {
		String connectionURL = "jdbc:mysql://mysql2.000webhost.com/a3932573_product";
		
		Class.forName("com.mysql.jdbc.Driver").newInstance(); 
		connection = DriverManager.getConnection("jdbc:mysql://10.0.2.94/recipes", "jspsql", "Uspatents99!");
		
	}catch(Exception ex){
		out.println("Unable to connect to database.\n");
		out.println(ex);
	}
%>
<div class="w3-container w3-half"  style="margin:auto" >
<% 
	name = request.getParameter("name");
	servingsize = Integer.parseInt(request.getParameter("servingsize"));
	servingunit = Integer.parseInt(request.getParameter("servingunit"));
	calories = Integer.parseInt(request.getParameter("calories"));
	fat = Integer.parseInt(request.getParameter("fat"));
	protein = Integer.parseInt(request.getParameter("protein"));
	carb = Integer.parseInt(request.getParameter("carb"));
	cholesterol = Integer.parseInt(request.getParameter("cholesterol"));
	sodium = Integer.parseInt(request.getParameter("sodium"));
	url = request.getParameter("url");
	ingredientID = request.getParameter("ingredientID");
	String cmd = "";
	
	Statement stmt = connection.createStatement();
	
	cmd = "UPDATE ingredients SET " +
		"Name = '" + name + "', " +
		"Serving_Size = '" + servingsize + "', " +
		"Serving_Unit = '" + servingunit + "', " +
		"Fat = '" + fat + "', " +
		"Protein = '" + protein + "', " +
		"Carbs = '" + carb + "', " +
		"Sodium = '" + sodium + "', " +
		"Cholesterol = '" + cholesterol + "', " +
		"Calories = '" + calories + "', " +
		"URL = '" + url + "' " +
		"WHERE ID='" + ingredientID + "'";
		

	if ( stmt.executeUpdate(cmd) == 1 ) {
		out.println("<br><br><h1>Successfully updated " + name + "!</h1>");
	}
	else {
		out.println("<br><br><h1>Something has gone wrong. " + name + " was not updated.</h1>");
	}
	
	
	connection.close();
	
	
	
%>
	<br><br>
	
	<a href="http://www.fkhatri.net/maint">Back to Maintenance Page</a>

</div>