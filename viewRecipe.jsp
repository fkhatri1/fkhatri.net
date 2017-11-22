<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.lang.Math" %>

<html> 


<%!
	/*
	 *Global Declarations
	 */
	 
	public Connection connection = null; 
	public Statement stmt = null;
	public ResultSet rs = null;
	public String cmd = "";
	
	/*
	 *Recipe Object
	 */
			public static class Recipe {
				public int recID = 0;
				public int numServings = 0;
				public String title = "";
				public String method = "";
				public int calories = 0;
				public int protein = 0;
				public int carbs = 0;
				public int sugar = 0;
				public int fiber = 0;
				public int sodium = 0;
				public int cholesterol = 0;
				public int fat = 0;
				public Date createDate = new Date();
			}
			
			Recipe thisRecipe = new Recipe();
	
	/*
	 *Ingredient Object
	 */
		public static class Ingredient {
			public int ingID = 0;
			public String name = "";
			public int unit = 0;
			public String unitName = "fakes";
			public int qty = 0;
			public int unitqty = 0;
			public int calories = 0;
			public int protein = 0;
			public int sugar = 0;
			public int fiber = 0;			
			public int carbs = 0;
			public int sodium = 0;
			public int cholesterol = 0;
			public int fat = 0;
			public String url = "";
		}
		
		ArrayList<Ingredient> ingredients = new ArrayList<Ingredient>();
		
	
	/*
	 *Photo Object
	 */
	
			public static class Photo {
				public String filename = "";
			}
			
			ArrayList<Photo> photos = new ArrayList<Photo>();
			int photoCounter = 1;
	
	/*
	 *Inspiration Object
	 */
			public static class Inspiration {
				public String description = "";
				public String url = "";
			}
			
			ArrayList<Inspiration> inspirations = new ArrayList<Inspiration>();
			
	/*
	 *Variation Object
	 */
			public static class Variation {
				public String description = "";
				public String url = "";
			}
			
			ArrayList<Variation> variations = new ArrayList<Variation>();
	/*
	 *Pairing Object
	 */
			public static class Pairing {
				public String description = "";
				public String url = "";
			}
			
			ArrayList<Pairing> pairings = new ArrayList<Pairing>();

			
	/*
	 *Note Object
	 */
			public static class Note {
				public int noteID = 0;
				public String description = "";
				public Date createDate = new Date();
			}
			
			ArrayList<Note> notes = new ArrayList<Note>();
	/*
	 *Comment Object
	 */
			public static class Comment {
				public String commentText = "";
				public String author = "";
				public Date createDate = new Date();
			}
			
			ArrayList<Comment> comments = new ArrayList<Comment>();

	SimpleDateFormat readformat = null;
	SimpleDateFormat writeformat = null;
	
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
	
	readformat = new SimpleDateFormat("yyyy-MM-d");
	writeformat = new SimpleDateFormat("MMM d, yyyy");
%>

<%
	/*
	 *Get Recipe Data
	 */
	 
			thisRecipe.recID = Integer.parseInt( request.getParameter("ID") );
			stmt = connection.createStatement();
			cmd = "select * from recipe where ID = '" + thisRecipe.recID + "'";
			rs = stmt.executeQuery(cmd);
			rs.next();
			thisRecipe.numServings = Integer.parseInt( rs.getString("NUMSERVINGS") );
			thisRecipe.title = rs.getString("TITLE");
			thisRecipe.method = rs.getString("METHOD");
			
			thisRecipe.createDate = readformat.parse( rs.getString("CREATETIME").substring(0, 10) );
			
			
			
	/*
	 *Get Ingredients and Nutrition Facts
	 */
			stmt = connection.createStatement();
			cmd = "select * from recipeingjunc where RecipeID = '" + thisRecipe.recID + "' order by ListOrder";
			rs = stmt.executeQuery(cmd);
			ingredients.clear();
			thisRecipe.calories = 0;
			thisRecipe.protein = 0;
			thisRecipe.carbs = 0;
			thisRecipe.sodium = 0;
			thisRecipe.cholesterol = 0;
			thisRecipe.fat = 0;
			
			while (rs.next()) {
				Ingredient temp = new Ingredient();
				temp.ingID = Integer.parseInt( rs.getString("IngredientID") );
				temp.qty = Integer.parseInt( rs.getString("NumServings") );
				ingredients.add(temp);
				temp = null;
			}
				
			for (int i=0; i<ingredients.size(); i++) {
				cmd = "select * from ingredients where ID = '" + ingredients.get(i).ingID + "'";
				rs = stmt.executeQuery(cmd);
				rs.next();
				ingredients.get(i).name = rs.getString("Name");
				ingredients.get(i).unit = Integer.parseInt( rs.getString("Serving_Unit") );
				ingredients.get(i).unitqty = Integer.parseInt( rs.getString("Serving_Size") );
				ingredients.get(i).calories = Integer.parseInt( rs.getString("Calories") );
				ingredients.get(i).protein = Integer.parseInt( rs.getString("Protein") );
				ingredients.get(i).sugar = Integer.parseInt( rs.getString("Sugars") );
				ingredients.get(i).fiber = Integer.parseInt( rs.getString("Fiber") );
				ingredients.get(i).carbs = Integer.parseInt( rs.getString("Carbs") );
				ingredients.get(i).sodium = Integer.parseInt( rs.getString("Sodium") );
				ingredients.get(i).cholesterol = Integer.parseInt( rs.getString("Cholesterol") );
				ingredients.get(i).fat = Integer.parseInt( rs.getString("Fat") );
				ingredients.get(i).url = rs.getString("URL");
				
				thisRecipe.calories += ingredients.get(i).qty * ingredients.get(i).calories;
				thisRecipe.protein += ingredients.get(i).qty * ingredients.get(i).protein;
				thisRecipe.sugar += ingredients.get(i).qty * ingredients.get(i).sugar;
				thisRecipe.fiber += ingredients.get(i).qty * ingredients.get(i).fiber;
				thisRecipe.carbs += ingredients.get(i).qty * ingredients.get(i).carbs;
				thisRecipe.sodium += ingredients.get(i).qty * ingredients.get(i).sodium;
				thisRecipe.cholesterol += ingredients.get(i).qty * ingredients.get(i).cholesterol;
				thisRecipe.fat += ingredients.get(i).qty * ingredients.get(i).fat;
			}

			thisRecipe.calories = thisRecipe.calories / thisRecipe.numServings;
			thisRecipe.protein = thisRecipe.protein / thisRecipe.numServings;
			thisRecipe.carbs = thisRecipe.carbs / thisRecipe.numServings;
			thisRecipe.sugar = thisRecipe.sugar / thisRecipe.numServings;
			thisRecipe.fiber = thisRecipe.fiber / thisRecipe.numServings;
			thisRecipe.sodium = thisRecipe.sodium / thisRecipe.numServings;
			thisRecipe.cholesterol = thisRecipe.cholesterol / thisRecipe.numServings;
			thisRecipe.fat = thisRecipe.fat / thisRecipe.numServings;
			
			//Get unit string name
			
			for (int i=0; i<ingredients.size(); i++) {			
				stmt = connection.createStatement();
				cmd = "select Name from servingunits where ID = '" + ingredients.get(i).unit + "'";
				rs = stmt.executeQuery(cmd);
				rs.next();
				ingredients.get(i).unitName = rs.getString("Name");
			}
				
			
			//TODO need to add order to ingredients
			
		/*
		 * Get inspiration data
		 */
			stmt = connection.createStatement();
			cmd = "select * from inspiration where RecID = '" + thisRecipe.recID + "'";
			rs = stmt.executeQuery(cmd); 
			inspirations.clear();
			
			while (rs.next()) {
				Inspiration temp = new Inspiration();
				temp.description = rs.getString("Description") ;
				temp.url = rs.getString("URL") ;
				inspirations.add(temp);
			}

		/*
		 * Get pairing data
		 */
			stmt = connection.createStatement();
			cmd = "select * from pairings where RecID = '" + thisRecipe.recID + "'";
			rs = stmt.executeQuery(cmd); 
			pairings.clear();
			
			while (rs.next()) {
				Pairing temp = new Pairing();
				temp.description = rs.getString("Description") ;
				temp.url = rs.getString("URL") ;
				pairings.add(temp);
			}	

		/*
		 * Get variation data
		 */
			stmt = connection.createStatement();
			cmd = "select * from variations where RecID = '" + thisRecipe.recID + "'";
			rs = stmt.executeQuery(cmd); 
			variations.clear();
			
			while (rs.next()) {
				Variation temp = new Variation();
				temp.description = rs.getString("Description") ;
				temp.url = rs.getString("URL");
				variations.add(temp);
			}
			
		/*
		 * Get notes data
		 */
			stmt = connection.createStatement();
			cmd = "select * from notes where RecID = '" + thisRecipe.recID + "'";
			rs = stmt.executeQuery(cmd); 
			notes.clear();
			
			while (rs.next()) {
				Note temp = new Note();
				temp.description = rs.getString("Description") ;
				notes.add(temp);
			}
			 
		/*
		 * Get comments data
		 */
			stmt = connection.createStatement();
			cmd = "select * from comments where RecID = '" + thisRecipe.recID + "' order by CREATETIME DESC";
			rs = stmt.executeQuery(cmd); 

			
			comments.clear();
			
			while (rs.next()) {
				Comment temp = new Comment();
				temp.commentText = rs.getString("Comment");
				temp.createDate = readformat.parse( rs.getString("CREATETIME").substring(0, 10) );
				temp.author = rs.getString("Author");
				comments.add(temp);
			}			 

		/*
		 * Get photos data
		 */
			stmt = connection.createStatement();
			cmd = "select * from photo where RecipeID = '" + thisRecipe.recID + "' order by main DESC";
			rs = stmt.executeQuery(cmd); 

			
			photos.clear();
			photoCounter=1;
			
			while (rs.next()) {
				Photo temp = new Photo();
				temp.filename = rs.getString("FILENAME");
				photos.add(temp);
			}				
%>
<%@include  file="/common_nav.html" %>
<%@include  file="/recipe_nav.html" %>
<% out.println("<head><title>" + thisRecipe.title + "</title></head>"); %>
<body>
	<div class="w3-main w3-content w3-padding w3-container  w3-card-2" style="margin-top:65px"> <!-- top level card container -->
		<!-- ***Recipe title, inspiration and serving stats*** -->
			<div class="w3-white w3-medium w3-bar" style="margin:auto">
				<div class="w3-bar-item" style="width:70%"> 
					<h2> <% out.print( thisRecipe.title ); %></h2>
					<p> <% out.print( writeformat.format(thisRecipe.createDate) ); %>
					<p> <i>
					   
					  <%
					    if (inspirations.size() > 0) {
							out.print("An original recipe inspired by ");
							for (int i=0; i<inspirations.size(); i++) {
								if (i == (inspirations.size() - 1) ) {
									if (inspirations.get(i).url.equals("none")) {
										out.print (inspirations.get(i).description + ".");
									} else {
										out.print ("<a href='" + inspirations.get(i).url + "'>" + inspirations.get(i).description + "</a>.");
									}
								}
								else if (i == (inspirations.size() - 2) ) {
									if (inspirations.get(i).url.equals("none")) {
										out.print (inspirations.get(i).description + " and ");
									} else {
										out.print ("<a href='" + inspirations.get(i).url + "'>" + inspirations.get(i).description + "</a> and ");
									}
								}							
								else {
									if (inspirations.get(i).url.equals("none")) {
										out.print (inspirations.get(i).description + ", ");
									} else {
										out.print ("<a href='" + inspirations.get(i).url + "'>" + inspirations.get(i).description + "</a>, ");
									}
								}
							}
						}
						else {
							out.print("An original recipe.");
						}
					  %>
					</i> </p>
				</div>
				<p class="w3-bar-item w3-right-align" style="width:30%">
					<%out.print(thisRecipe.numServings);%> servings<br>
					Calories: <%out.print(thisRecipe.calories);%><br>
					Fat: <%out.print(thisRecipe.fat);%>g<br>
					Protein: <%out.print(thisRecipe.protein);%>g<br>
					Sugar: <%out.print(thisRecipe.sugar);%>g<br>
					Fiber: <%out.print(thisRecipe.fiber);%>g<br>
					Total Carbs: <%out.print(thisRecipe.carbs);%>g<br>
					Sodium: <%out.print(thisRecipe.sodium);%>mg<br>
					Cholesterol: <%out.print(thisRecipe.cholesterol);%>mg<br>
				</p>
			</div>
		
		<!-- ***Ingredients and Method *** -->
			<div class="w3-cell-row w3-padding">
				<div class="w3-cell" style="width:50%; vertical-align:top%">
					<h4>Ingredients</h4>
					<ul>
						<%
						for (int i=0; i<ingredients.size(); i++) {
							if (ingredients.get(i).url.equals("none")) {
								out.println("<li>" + ingredients.get(i).name + 
								", " + ingredients.get(i).qty + 
								" " + ingredients.get(i).unitName 
								+ "</li>");
							}
							else {
								out.println("<li><a href='" + ingredients.get(i).url + "'>" + 
								ingredients.get(i).name + 
								"</a>, " + ingredients.get(i).qty + 
								" " + ingredients.get(i).unitName 
								+ "</li>");
							}
						}
						%>
					</ul>
				</div>
				<div class="w3-cell" style="width:50%; vertical-align:top">
					<h4>Method</h4>
					
					<p style="white-space: pre-wrap"><% out.println( thisRecipe.method ); %> </p>
				</div>
			</div>
			
		<!-- ***Pairings and Variations and Images*** -->
		<!--
			**
			**
			TODO: set up 3 cases for this area.  parings only, vars only, neither, both.
		-->
		<div class="w3-cell-row w3-padding" name="pairings-variations-images">
		
		<!-- ***Pairings and Image*** -->
		<%
		if ((pairings.size() > 0) && (variations.size() == 0)) {
			//Pairings
			out.println("<div class='w3-cell w3-left' style='width:50%; vertical-align:top'>");
			out.println("<h6>Pairings</h6>");
			out.println("<ul>");
			  	for (int i=0; i<pairings.size(); i++) {
					if  (!(pairings.get(i).url.equals("none"))) {
						out.println ("<li><a href='" + pairings.get(i).url + "'>" + pairings.get(i).description + "</a></li>");
					}
					else {
						out.println ("<li>" + pairings.get(i).description + "</li>");
					}
				}
			out.println("</ul>");
			out.println("</div>");
			
			//Image 2
			out.println("<div class='w3-cell w3-center' style='width:50%; vertical-align:middle'>");
			out.println("<img src='/photos/" + photos.get(photoCounter++).filename + "' alt='image' class='w3-round-large' style='width:98%'>");
			out.println("</div>");
		}
		%>	
		<!-- ***Variations and Image*** -->
		<%
		if ((pairings.size() == 0) && (variations.size() > 0)) {
			//Variations
			out.println("<div class='w3-cell w3-left' style='width:50%; vertical-align:top'>");
			out.println("<h6>Variations</h6>");
			out.println("<ul>");
			  	for (int i=0; i<variations.size(); i++) {
					if  (!(variations.get(i).url.equals("none"))) {
						out.println ("<li><a href='" + variations.get(i).url + "'>" + variations.get(i).description + "</a></li>");
					}
					else {
						out.println ("<li>" + variations.get(i).description + "</li>");
					}
				}
			out.println("</ul>");
			out.println("</div>");
			
			//Image 2
			out.println("<div class='w3-cell w3-center' style='width:50%; vertical-align:middle'>");
			out.println("<img src='/photos/" + photos.get(photoCounter++).filename + "' alt='image' class='w3-round-large' style='width:98%'>");
			out.println("</div>");
		}
		%>	
		<!-- ***Image and Image*** -->
		<%
		if ((pairings.size() == 0) && (variations.size() == 0)) {
			//Image 1
			out.println("<div class='w3-cell w3-center' style='width:50%; vertical-align:middle'>");
			out.println("<img src='/photos/" + photos.get(photoCounter++).filename + "' alt='image' class='w3-round-large' style='width:98%'>");
			out.println("</div>");
			
			//Image 2
			out.println("<div class='w3-cell w3-center' style='width:50%; vertical-align:middle'>");
			out.println("<img src='/photos/" + photos.get(photoCounter++).filename + "' alt='image' class='w3-round-large' style='width:98%'>");
			out.println("</div>");
		}
		%>		
		<!-- ***Pairings, Variations and Image*** -->
		<%
		if ((pairings.size() > 0) && (variations.size() > 0)) {
			//Pairings
			out.println("<div class='w3-cell w3-left' style='width:25%; vertical-align:top'>");
			out.println("<h6>Pairings</h6>");
			out.println("<ul>");
			  	for (int i=0; i<pairings.size(); i++) {
					if  (!(pairings.get(i).url.equals("none"))) {
						out.println ("<li><a href='" + pairings.get(i).url + "'>" + pairings.get(i).description + "</a></li>");
					}
					else {
						out.println ("<li>" + pairings.get(i).description + "</li>");
					}
				}
			out.println("</ul>");
			out.println("</div>");
			
			//Variations
			out.println("<div class='w3-cell w3-left' style='width:25%; vertical-align:top'>");
			out.println("<h6>Variations</h6>");
			out.println("<ul>");
			  	for (int i=0; i<variations.size(); i++) {
					if  (!(variations.get(i).url.equals("none"))) {
						out.println ("<li><a href='" + variations.get(i).url + "'>" + variations.get(i).description + "</a></li>");
					}
					else {
						out.println ("<li>" + variations.get(i).description + "</li>");
					}
				}
			out.println("</ul>");
			out.println("</div>");
			
			//Image
			out.println("<div class='w3-cell w3-center' style='width:50%; vertical-align:middle'>");
			out.println("<img src='/photos/" + photos.get(photoCounter++).filename + "' alt='image' class='w3-round-large' style='width:98%'>");
			out.println("</div>");
		}
		%>
		
		</div>
			
		<!-- ***Notes and Comments *** -->
			<div class="w3-cell-row w3-padding">
				<div class="w3-cell" style="width:50%; vertical-align:top%">
					<h6>Notes</h6>
					<ul>
					<%
					   	for (int i=0; i<notes.size(); i++) {
							out.println ("<li>" + notes.get(i).description + "</li>");
						}
					%>
					</ul>
				</div>
				<div class="w3-cell" style="width:50%; vertical-align:top">
					<h6>Comments</h6>
					<%
					   	for (int i=0; i<comments.size(); i++) {
							out.println ("<p>" + comments.get(i).commentText + "<br>");
							out.println ("<i>-" + comments.get(i).author + ", " + writeformat.format(comments.get(i).createDate) + "</i></p>");
						}
					%>
					
					<form name="commentForm" action="addComment.jsp" method='POST'>
						<table border=0 cellpadding=5 cellspacing=1>
							<tr><td align=right width=150>Your Name: </td><td><input type="text" maxlength=60 name="author"></td></tr>
							<tr><td align=right width=150>Comment: </td><td><textarea maxlength=200 name="commentText" rows='3' cols='20'> </textarea></td></tr>
						</table>
						<input type='hidden' value='<%out.print(thisRecipe.recID);%>' name='RecID'>
						<input type='hidden' value='myFace' name='URL' id='URL'>
						<input type='submit' value="Submit Comment"/>
					</form>
				</div>
			</div>
			
		<!-- ***Photos*** -->
		<%
			while (photoCounter < photos.size()) {
				out.println("<div class='w3-cell-row w3-padding'>");
				out.println("<div class='w3-cell' style='width:85%;'>");
				out.println("<img src='/photos/" + photos.get(photoCounter++).filename + "' alt='image' class='w3-round-large' style='width:98%'>");
				out.println("</div></div>");
			}
		%>
	</div>
			





<% connection.close(); %>

<script>
document.getElementById("URL").value = window.location.href;

</script>

</font>
</body> 
</html>