import java.sql.*;
import java.io.*;

class Uber {

    public static void main(String args[]) throws IOException {
        String url;
        Connection conn;
        ResultSet rs;
        String queryString;

        try {
            Class.forName("org.postgresql.Driver");
        }
        catch (ClassNotFoundException e) {
            System.out.println("Failed to find the JDBC driver");
        }

        try {
            // In this try block, you should
            // 1) Connect to the database and set the search path
            // 2) Prompt the user for the name of a client
            // 3) Make the appropriate database query string
            //    (use the '?' placeholder!!)
            // 4) Output the results
            // 5) Close the connection

            // NOTE: We didn't cover this in lecture, but you'll need to
            // execute a "SET search_path TO uber" statement before
            // executing any queries. Use the following code snippet to do so:
            //

            // YOUR CODE GOES HERE
           url = "jdbc:postgresql://localhost:5432/csc343h-c5guptaa";
           conn = DriverManager.getConnection(url, "c5guptaa", "");
	
	   conn.prepareStatement("SET search_path TO uber").execute();

           queryString = "select driver.firstname as name from client, driver, request, dispatch where client.surname = ? and request.request_id = dispatch.request_id and request.client_id = client.client_id and dispatch.driver_id = driver.driver_id"; 
           PreparedStatement ps = conn.prepareStatement(queryString);

           BufferedReader br = new BufferedReader(new 
                     InputStreamReader(System.in));
           System.out.println("Enter the name of a client: ");
           String who = br.readLine();

                // Insert that string into the PreparedStatement and execute it.
           ps.setString(1, who);
           rs = ps.executeQuery();

                // Iterate through the result set and report on each tuple.
           while (rs.next()) {
		String name = rs.getString("name");
                System.out.println(name);
           }
                
         }
	   catch (SQLException se)
	 {		
            System.err.println("SQL Exception." +
                    "<Message>: " + se.getMessage());
        }
    }
}
