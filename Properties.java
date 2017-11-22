import java.io.*;

public class Properties {
	
	public String connString = "";
	public String user = "";
	public String pw = "";
	public String driver = "";

    public void readFile() {

        String fileName = "fkhatri.prop";
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