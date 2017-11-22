<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.util.ArrayList" %>

<html> 


<%!
	/*
	 *Global Declarations
	 */
	 
	public Connection connection = null; 
	public Statement stmt = null;
	public ResultSet rs = null;
	
	public static class Recipe {
		public int recID = 0;
		public String category = "";
		public int numServings = 0;
		public String title = "";
		public String method = "";
		public String photo = "";
		public int catCode = 0;
	}
	
	ArrayList<Recipe> recipes = new ArrayList<Recipe>();
	
	public String chosenCat ="";
	

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

<%@include  file="/common_nav.html" %>
<%@include  file="/recipe_nav.html" %>
<body>

<div class="w3-main w3-content w3-padding" style="max-width:1200px;margin-top:65px">
<div class="w3-row-padding w3-padding-16 w3-center" id="food">
<%
	/*
	 *Get list of available recipes and populate ArrayList for re-use
	 */
	chosenCat = "";
	String cmd = "";
	
	try {
		chosenCat = request.getParameter("cat");
		cmd = "SELECT r.ID, r.TITLE, r.NUMSERVINGS, c.DESCRIPTION as CATEGORY, r.METHOD, p.FILENAME, r.CATEGORY as CATCODE FROM recipe r, categories c, photo p " +
			"where r.CATEGORY=c.ID and r.ID=p.RECIPEID and p.MAIN='1' and r.category='" + chosenCat.substring(1, 2) + "' order by TITLE";
	}
	catch (Exception e) {
		cmd = "SELECT r.ID, r.TITLE, r.NUMSERVINGS, c.DESCRIPTION as CATEGORY, r.METHOD, p.FILENAME, r.CATEGORY as CATCODE FROM recipe r, categories c, photo p where r.CATEGORY=c.ID and r.ID=p.RECIPEID and p.MAIN='1' order by TITLE";
	}
	finally { 
		
	}
	
	stmt = connection.createStatement();
	rs = stmt.executeQuery(cmd);
		
	while (rs.next()) {
		Recipe newRec = new Recipe();
		newRec.recID = Integer.parseInt(rs.getString("ID"));
		newRec.category = rs.getString("CATEGORY");
		newRec.catCode = Integer.parseInt( rs.getString("CATCODE") );
		newRec.numServings = Integer.parseInt(rs.getString("NUMSERVINGS"));
		newRec.title = rs.getString("TITLE");
		newRec.method = rs.getString("METHOD");
		newRec.photo = rs.getString("FILENAME");
		recipes.add(newRec);
	}
	
	
	for (int i=0; i<recipes.size(); i++) {
		out.println("<div class='w3-quarter'>");
		out.println("<a href='viewRecipe.jsp?nav=t1&ID=" + recipes.get(i).recID + "&cat=r" + recipes.get(i).catCode + "'>");
		out.println("<img src='/photos/" + recipes.get(i).photo + "' style='width:100%' class='w3-round-large'>");
		out.println("<h3>" + recipes.get(i).title + "</h3>");
		out.println("</a></div>");
	}
    
	recipes.clear();


%>
</div>




<% connection.close(); %>

</font>
</body> 
</html>