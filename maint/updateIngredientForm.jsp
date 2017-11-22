<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 

<%!
public Connection connection = null; 
public String name;
public String servingsize;
public String servingunit;
public String calories;
public String fat;
public String protein;
public String carb;
public String cholesterol;
public String sodium;
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
		out.print("Unable to connect to database.\n");
		out.print(ex);
	}
%>

<% 
	String cmd = "";
	Statement stmt = connection.createStatement();
	ResultSet rs;
	
	/*
	Read in ingredient ID from the form 
	*/
		ingredientID = request.getParameter("ID");
	
	/*
	Select existing values from the db
	*/
		cmd = "SELECT * FROM ingredients where ID='" + ingredientID + "'";
		
		
		rs = stmt.executeQuery(cmd);
		rs.next();
		
		String name = rs.getString("Name");
		String servingsize = rs.getString("Serving_Size");
		String servingunit = rs.getString("Serving_Unit");
		String calories = rs.getString("Calories");
		String fat = rs.getString("Fat");
		String protein = rs.getString("Protein");
		String carb = rs.getString("Carbs");
		String cholesterol = rs.getString("Cholesterol");
		String sodium = rs.getString("Sodium");
		String url = rs.getString("URL");
		
	
	/*
	Populate existing values onto the page
	*/
%>
<div class="w3-container w3-half"  style="margin:auto" >
	<br><br>
	<h1>Update Ingredient</h1>
	<form action="updateIngredient.jsp" method="post">
		
		<fieldset>
			<legend>Basic Info</legend>
			<table border=0 cellpadding=5 cellspacing=1>
			<tr><td align=right width=150>Name: </td><td><input type="text" maxlength=60 name="name" value= <% out.print(name); %> ></td></tr>
			<tr><td align=right width=150>Serving Size: </td><td><input type="number" maxlength=60 name="servingsize" value= <% out.print(servingsize); %>></td></tr>
			<tr><td align=right width=150>Serving Unit: </td><td><select name="servingunit"%>">
				<% 
				rs = stmt.executeQuery("SELECT * FROM servingunits");
				while (rs.next()) {
					out.print("<option value='" + rs.getString("ID"));
					if (rs.getString("ID").equals(servingunit)) {
						out.print("' selected='selected'>");
					}
					else {
						out.print("'>");
					}
					out.print(rs.getString("Name") + "</option>");
				}
				%>
			</select></td></tr>
			<tr><td align=right width=150>URL: </td><td><input type="text" maxlength=200 name="url" value= <% out.print(url); %>></td></tr>
			</table>
		</fieldset>
		
		<fieldset>
			<legend>Nutrition Data (per Serving)</legend>
			<table border=0 cellpadding=5 cellspacing=1>
			<tr><td align=right width=150>Calories: </td><td><input type="number" maxlength=10 name="calories" value= <% out.print(calories); %>></td></tr>
			<tr><td align=right width=150>Fat (g): </td><td><input type="number" maxlength=10 name="fat" value= <% out.print(fat); %>></td></tr>
			<tr><td align=right width=150>Protein (g): </td><td><input type="number" maxlength=10 name="protein" value= <% out.print(protein); %>></td></tr>
			<tr><td align=right width=150>Carbohydrate (g): </td><td><input type="number" maxlength=10 name="carb" value= <% out.print(carb); %>></td></tr>
			<tr><td align=right width=150>Sodium (mg): </td><td><input type="number" maxlength=10 name="sodium" value= <% out.print(sodium); %>></td></tr>
			<tr><td align=right width=150>Cholesterol (mg): </td><td><input type="number" maxlength=10 name="cholesterol" value= <% out.print(cholesterol); %>></td></tr>
			</table>
		</fieldset>
		<br>
		<input type=hidden value= <% out.print(ingredientID); %> name="ingredientID">
		<input type=submit value="Submit Changes" name="submit">
	</form>
</div>
	
	<!--
	String cmd = "INSERT INTO ingredients (Name, Serving_Size, Serving_Unit, Fat, Protein, Carbs, Sodium, Cholesterol, Calories, URL) VALUES ('" +
		name + "', '" +
		servingsize + "', '" +
		servingunit + "', '" +
		fat + "', '" +
		protein + "', '" +
		carb + "', '" +
		sodium + "', '" +
		cholesterol + "', '" +
		calories + "', '" +
		url + "')";
		
	
	
	
	if ( stmt.executeUpdate(cmd) == 1 ) {
		out.print("<br><br><h1>Successfully added " + name + " as a new ingredient!</h1>");
	}
	else {
		out.print("<br><br><h1>Something has gone wrong. " + name + " was not added.</h1>");
	}
	
	
	connection.close();
	
	*/
	
%>
	<br><br>
	<a href="http://www.fkhatri.net/maint/newIngredientForm.jsp">Add another one</a>
	<a href="http://www.fkhatri.net/maint">Back to Maintenance Page</a>
	
	-->