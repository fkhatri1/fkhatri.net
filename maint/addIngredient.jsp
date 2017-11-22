<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 

<%!
public Connection connection = null; 

	public class Properties {
	
		public String connString = "";
		public String user = "";
		public String pw = "";
		public String driver = "";

		public void readFile() {

			String fileName = "/usr/share/tomcat8/webapps/ROOT/fkhatri.prop";
			String line = null;

			try {
				FileReader fileReader = new FileReader(fileName);
				BufferedReader bufferedReader = new BufferedReader(fileReader);
				
				connString = bufferedReader.readLine(); //first line contains connection string
				user = bufferedReader.readLine(); 		//second line contains db username
				pw = bufferedReader.readLine();			//third line contains db pw
				driver = bufferedReader.readLine();		//fourth line contains db driver path
	 
				bufferedReader.close();         
			}
			catch(FileNotFoundException ex) {
				System.out.println("Unable to open properties file.");      
			}
			catch(IOException ex) {
				System.out.println("Unable to open properties file.");
			}
    }
}
	Properties prop = new Properties();
%>

<!-- Establish DB Connection -->
<%@include  file="/common_nav.html" %>
<% 
prop.readFile();
	try {
		String connectionURL = prop.connString;
		
		Class.forName("com.mysql.jdbc.Driver").newInstance(); 
		connection = DriverManager.getConnection(prop.driver, prop.user, prop.pw);
		if(!connection.isClosed())
			 out.println("Successfully connected to " + "MySQL server using TCP/IP...");
		
	}catch(Exception ex){
		out.println("Unable to connect to database.\n");
		out.println(ex);
	}
%>

<% 
	/*
	Read in new ingredient values from the form 
	*/
	
	String name = request.getParameter("name");
	int servingsize = Integer.parseInt(request.getParameter("servingsize"));
	int servingunit = Integer.parseInt(request.getParameter("servingunit"));
	int calories = Integer.parseInt(request.getParameter("calories"));
	int fat = Integer.parseInt(request.getParameter("fat"));
	int protein = Integer.parseInt(request.getParameter("protein"));
	int sugar = Integer.parseInt(request.getParameter("sugar"));
	int fiber = Integer.parseInt(request.getParameter("fiber"));
	int carbs = Integer.parseInt(request.getParameter("carbs"));
	int cholesterol = Integer.parseInt(request.getParameter("cholesterol"));
	int sodium = Integer.parseInt(request.getParameter("sodium"));
	String url = request.getParameter("url");
	
	Statement stmt = connection.createStatement();
	
	String cmd = "INSERT INTO ingredients (Name, Serving_Size, Serving_Unit, Fat, Protein, Sugars, Fiber, Carbs, Sodium, Cholesterol, Calories, URL) VALUES ('" +
		name + "', '" +
		servingsize + "', '" +
		servingunit + "', '" +
		fat + "', '" +
		protein + "', '" +
		sugar + "', '" +
		fiber + "', '" +
		carbs + "', '" +
		sodium + "', '" +
		cholesterol + "', '" +
		calories + "', '" +
		url + "')";
		

	
	
	if ( stmt.executeUpdate(cmd) == 1 ) {
		out.println("<br><br><h1>Successfully added " + name + " as a new ingredient!</h1>");
	}
	else {
		out.println("<br><br><h1>Something has gone wrong. " + name + " was not added.</h1>");
	}
	
	
	connection.close();
	
	
	
%>
	<br><br>
	<a href="http://www.fkhatri.net/maint/newIngredientForm.jsp">Add another one</a>
	<br>
	<a href="http://www.fkhatri.net/maint">Back to Maintenance Page</a>