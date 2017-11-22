<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 

<html> 
<head> 
<title>Site Maintenance</title>
</head> 

<%@include  file="/common_nav.html" %>

<%!
public Connection connection = null; 
public Statement stmt = null;
public ResultSet rs = null;
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

<br>
<br>
<div class="w3-container w3-lightblue w3-twothird w3-padding-32">
	<h1>Recipe Maintenance</h1>
</div>

<div class="w3-container w3-lightblue w3-twothird w3-padding-32">
  <a href="newIngredientForm.jsp">Add a New Ingredient</a>
</div>
<div class="w3-container w3-lightblue w3-twothird w3-padding-32">
  Update an Ingredient
  <br>
	<form action="updateIngredientForm.jsp" method="post">
		<select name="ID"> 
			<% 
			stmt = connection.createStatement();
			rs = stmt.executeQuery("SELECT ID, Name FROM ingredients order by Name");
			while (rs.next()) {
				out.println("<option value='" + rs.getString("ID") + "'>" + rs.getString("Name") + "</option>");
			}
			%>
		</select>
		<input type="submit" value="Go">
	</form>
</div>

<div class="w3-container w3-lightblue w3-twothird w3-padding-32">
  <a href="newRecipeForm.jsp">Add a New Recipe</a>
</div>

<div class="w3-container w3-lightblue w3-twothird w3-padding-32">
  Update a Recipe
  <br>
	<form action="updateIngredientForm.jsp" method="post">
		<select name="ID"> 
			<% 
			stmt = connection.createStatement();
			rs = stmt.executeQuery("SELECT ID, Name FROM ingredients order by Name");
			while (rs.next()) {
				out.println("<option value='" + rs.getString("ID") + "'>" + rs.getString("Name") + "</option>");
			}
			%>
		</select>
		<input type="submit" value="Go">
	</form>
</div>