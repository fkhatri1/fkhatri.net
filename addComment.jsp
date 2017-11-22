<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.util.*" %>

<%!
	/*
	 *Global Declarations
	 */
	 
	public Connection connection = null; 
	public Statement stmt = null;
	
	
	public static class Comment {
		String author = "";
		String commentText = "";;
	}
	
	Comment newComment = new Comment();
	int recID = 0;
	String redirect = "";
	
	
%>



<%
	/*
	 *Establish connection to recipes MySQL DB
	 */
	
	try {
		String connectionURL = "jdbc:mysql://mysql2.000webhost.com/a3932573_product";
		
		Class.forName("com.mysql.jdbc.Driver").newInstance(); 
		connection = DriverManager.getConnection("jdbc:mysql://10.0.2.94/recipes", "jspsql", "Uspatents99!");
		
	}catch(Exception ex){
		out.println("Unable to connect to database.\n");
		out.println(ex);
	}
%>

<% 
	/*
	 *Read in new recipe data from the form 
	 */
	
	newComment.author = request.getParameter("author");
	newComment.commentText = request.getParameter("commentText");
	recID = Integer.parseInt(request.getParameter("RecID"));
	redirect = request.getParameter("URL");

	/*
	 *Build SQL insert command into recipe table
	 */
	
	stmt = connection.createStatement();
	String cmd = "INSERT INTO comments (Author, Comment, RecID) VALUES ('" +
		newComment.author + "', '" +
		newComment.commentText + "', '" +
		recID	+ "')";
	
	/*
	 *Execute command
	 */
	stmt.executeUpdate(cmd);
	
	connection.close();
	out.println("<h1>" + redirect + "</h1>");
	    response.setStatus(301);
        response.setHeader("Location", redirect);
        response.setHeader("Connection", "close");
	
%>
	