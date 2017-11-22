<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.util.ArrayList" %>

<html> 
<head> 
<title>Add a New Recipe</title>
</head> 

<%!
	/*
	 *Global Declarations
	 */
	 
	public Connection connection = null; 
	public Statement stmt = null;
	public ResultSet rs = null;
	public ArrayList ingredientsList = new ArrayList();

%>

<% 
	/*
	 *Establish connection to recipes MySQL DB
	 */
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

<%
	/*
	 *Get list of available ingredients and populate ArrayLists for re-use
	 */
	stmt = connection.createStatement();
	rs = stmt.executeQuery("SELECT ID, Name, Serving_Unit FROM ingredients ORDER BY Name");
	ResultSet rs2 = null;
	Statement stmt2 = connection.createStatement();
	ingredientsList.clear();
	
	while (rs.next()) {
		rs2 = stmt2.executeQuery("SELECT * FROM servingunits where ID='" + rs.getString("Serving_Unit") + "'");
		rs2.next();
		ingredientsList.add("<option value='" + rs.getString("ID") + "'>" + rs.getString("Name") + " - [" + rs2.getString("Name") + "]</option>");
				
	}
%>


<body>
<%@include  file="/common_nav.html" %>



<div class="w3-container w3-half"  style="margin:auto" >
	<br><br>
	<h1>New Recipe Form</h1>
	
	<button onclick="addIngredient()">Add Ingredient</button>
	<form action="addRecipe.jsp" method="post">
		<input type="hidden" value="1" id="numIngParam" name="numIng"/>
		
		<fieldset>
			<legend>Basic Info</legend>
			<table border=0 cellpadding=5 cellspacing=1>
			<tr><td align=right width=150>Title: </td><td><input type="text" maxlength=60 name="title"></td></tr>
			<tr><td align=right width=150>Number of Servings: </td><td><input type="number" maxlength=60 name="servings"></td></tr>
			<tr><td align=right width=150>Category: </td><td><select name="category">
				<% 
					/*
					 *Read category values from DB and populate as dropdown choices. 
					 */
			
					stmt = connection.createStatement();
					rs = stmt.executeQuery("SELECT * FROM categories");
					while (rs.next()) {
						out.println("<option value='" + rs.getString("ID") + "'>" + rs.getString("Description") + "</option>");
					}
				%>
			</select></td></tr>
			<tr><td align=right width=150>Photo Filename: </td><td><input type="text" maxlength=60 name="photo"></td></tr>
			</table>
		</fieldset>
			
		<fieldset>
			<legend>Ingredients</legend>
			<table border=0 cellpadding=5 cellspacing=1 id="ingTable">
			<tr>
				<td align=right width=150>Ingredient 1:</td>
				<td>
					<select name="ing1">
					<% 
						for(int i = 0; i < ingredientsList.size(); i++) {
						out.println(ingredientsList.get(i));
						}
					%>
					</select>
				</td>
				<td>
					<input type="number" maxlength=10 name="ing1Amt">
				</td>
			</tr>
			</table>
			<img src="plus.jpg" onclick="addIngredient();"/> Add Ingredient
			
		</fieldset>
		
		<fieldset>
			<legend>Method</legend>
			<table border=0 cellpadding=5 cellspacing=1>
			<tr><td align=right width=150>Method: </td><td><textarea cols="50" rows="40" name="method" maxlength="10000"></textarea></td></tr>
			</table>
		</fieldset>
		<br>
		
		<input type="submit" value="Submit New Recipe" name="submit"/>
	</form>
</div>

<script  type="text/javascript">
	var numIngredients = 1;
	var numIngParam = document.getElementById("numIngParam");
	
	function addIngredient() {
		numIngredients++;
		numIngParam.value = numIngredients.toString();
		
		var ingTable = document.getElementById("ingTable");
		var newRow = ingTable.insertRow(ingTable.rows.length);
		var labelCell = newRow.insertCell(0);
			labelCell.innerHTML = "Ingredient " + numIngredients + ":";
			labelCell.style.textAlign = "right";
		var dropdownCell = newRow.insertCell(1);
			dropdownCell.innerHTML = "<select name='ing" + numIngredients + "'>" +
					<% 
						
						for(int i = 0; i < ingredientsList.size(); i++) {
							if ( (i+1) == ingredientsList.size()) {
								out.println("\"" + ingredientsList.get(i) + "</select>\"");
							}
							else {
								out.println("\"" + ingredientsList.get(i) + "\" +");
							}
						}
					%>
					;
		var amountCell = newRow.insertCell(2);
			amountCell.innerHTML = "<input type=number maxlength=10 name='ing" + numIngredients + "Amt'>";
		
	}
					
		
</script>

<% connection.close(); %>

</font>
</body> 
</html>