<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.util.ArrayList" %>

<%!
	/*
	 *Global Declarations
	 */
	 
	public Connection connection = null; 
	public Statement stmt = null;
	public Statement stmt2 = null;
	public Statement stmt3 = null;
	
	public static class Ingredient {
		int ingID = 0;
		int ingAmt = 0;
		
		public int getID() {
			return ingID;
		}
		
		public int getAmt() {
			return ingAmt;
		}
		
		public void setID(int ID) {
			ingID = ID;
		}
		
		public void setAmt(int Amt) {
			ingAmt = Amt;
		}
	}
	
	ArrayList<Ingredient> ingredients = new ArrayList<Ingredient>();
	
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


<%@include  file="/common_nav.html" %>

<%
	/*
	 *Establish connection to recipes MySQL DB
	 */
	
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
	 *Read in new recipe data from the form 
	 */
	
	String title = request.getParameter("title");
	int servings = Integer.parseInt(request.getParameter("servings"));
	int category = Integer.parseInt(request.getParameter("category"));
	String method = request.getParameter("method");
	String photo = request.getParameter("photo");
	

	/*
	 *Build SQL insert command into recipe table
	 */
	
	stmt = connection.createStatement();
	String cmd = "INSERT INTO recipe (TITLE, NUMSERVINGS, CATEGORY, METHOD) VALUES ('" +
		title + "', '" +
		servings + "', '" +
		category + "', '" +
		method + "')";
	
	/*
	 *Execute commands
	 */
	stmt.executeUpdate(cmd);
	ResultSet rs = stmt.executeQuery("SELECT ID FROM recipe ORDER BY ID DESC LIMIT 1");
	rs.next();
	int thisRecipeID = Integer.parseInt(rs.getString("ID"));
	
	/*
	 *Read in 	 from form and build insert command into ingredients table
	 */
	
	int numIngredients = Integer.parseInt(request.getParameter("numIng"));
	out.println("<br><br>Number of Ingredients received from form: " + numIngredients);
	ingredients.clear();
	for (int i=1; i<=numIngredients; i++) {
		Ingredient ing = new Ingredient();
		ing.setID(Integer.parseInt(request.getParameter("ing" + i)));
		ing.setAmt(Integer.parseInt(request.getParameter("ing" + i + "Amt")));
		ingredients.add(ing);
	}
	
	
	
	stmt2 = connection.createStatement();
	String cmd2 = "";
	
	for (int i=0; i<ingredients.size(); i++) {
		cmd2 = "INSERT INTO recipeingjunc (NumServings, RecipeID, IngredientID, ListOrder) VALUES ('" +
			ingredients.get(i).getAmt() + "', '" +
			thisRecipeID + "', '" +
			ingredients.get(i).getID() + "', '" +
			i + "')";
		stmt2.executeUpdate(cmd2);
		cmd2 = "";
	}
	
	/*
	 *Insert main photo receord
	 */
	
	stmt3 = connection.createStatement();
	String cmd3 = "INSERT INTO photo (RECIPEID, MAIN, FILENAME) VALUES ('" + thisRecipeID + "', '1', '" + photo + "')";
	stmt3.executeUpdate(cmd3);
	
	
	connection.close();
	
	out.println("<br><br><h1>Successfully updated " + title + "!</h1>");
	
%>
	<br><br>

	<a href="http://www.fkhatri.net/maint">Back to Maintenance Page</a>