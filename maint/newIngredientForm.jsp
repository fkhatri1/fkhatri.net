<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 
<html> 
<head> 
<title>Add New Ingredients</title>
</head> 

<%!
public Connection connection = null; 
%>

<% 
	try {
		String connectionURL = "jdbc:mysql://mysql2.000webhost.com/a3932573_product";
		
		Class.forName("com.mysql.jdbc.Driver").newInstance(); 
		connection = DriverManager.getConnection("jdbc:mysql://10.0.2.94/recipes", "jspsql", "Uspatents99!");
		if(!connection.isClosed())
			 out.println("Successfully connected to " + "MySQL server using TCP/IP...");
		
	}catch(Exception ex){
		out.println("Unable to connect to database.\n");
		out.println(ex);
	}
%>


<body>
<%@include  file="/common_nav.html" %>
<div class="w3-container w3-half"  style="margin:auto" >
	<br><br>
	<h1>New Ingredient Form</h1>
	

	<form action="addIngredient.jsp" method="post">
		
		<fieldset>
			<legend>Basic Info</legend>
			<table border=0 cellpadding=5 cellspacing=1>
			<tr><td align=right width=150>Name: </td><td><input type="text" maxlength=60 name="name"></td></tr>
			<tr><td align=right width=150>Serving Size: </td><td><input type="number" maxlength=60 name="servingsize"></td></tr>
			<tr><td align=right width=150>Serving Unit: </td><td><select name="servingunit">
				<% 
				Statement stmt = connection.createStatement();
				ResultSet rs = stmt.executeQuery("SELECT * FROM servingunits");
				while (rs.next()) {
					out.println("<option value='" + rs.getString("ID") + "'>" + rs.getString("Name") + "</option>");
				}
				%>
			</select></td></tr>
			<tr><td align=right width=150>URL: </td><td><input type="text" maxlength=200 name="url"></td></tr>
			</table>
		</fieldset>
		
		<fieldset>
			<legend>Nutrition Data (per Serving)</legend>
			<table border=0 cellpadding=5 cellspacing=1>
			<tr><td align=right width=150>Calories: </td><td><input type="number" maxlength=10 name="calories"></td></tr>
			<tr><td align=right width=150>Fat (g): </td><td><input type="number" maxlength=10 name="fat"></td></tr>
			<tr><td align=right width=150>Protein (g): </td><td><input type="number" maxlength=10 name="protein"></td></tr>
			<tr><td align=right width=150>Sugar (g): </td><td><input type="number" maxlength=10 name="sugar"></td></tr>
			<tr><td align=right width=150>Fiber (g): </td><td><input type="number" maxlength=10 name="fiber"></td></tr>
			<tr><td align=right width=150>Total Carbs (g): </td><td><input type="number" maxlength=10 name="carbs"></td></tr>
			<tr><td align=right width=150>Sodium (mg): </td><td><input type="number" maxlength=10 name="sodium"></td></tr>
			<tr><td align=right width=150>Cholesterol (mg): </td><td><input type="number" maxlength=10 name="cholesterol"></td></tr>
			</table>
		</fieldset>
		<br>
		<input type=submit value="Submit New Ingredient" name="submit">
	</form>
</div>


<% connection.close(); %>
</font>
</body> 
</html>