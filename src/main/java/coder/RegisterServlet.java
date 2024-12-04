package coder;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirm_password = request.getParameter("confirm_password");

        if(!password.equals(confirm_password)) {
        	request.setAttribute("errorMessage","Password do not match.");
        	request.getRequestDispatcher("Register.jsp").forward(request, response);
        	return;
        }
      
        	 try {
                 Class.forName("com.mysql.cj.jdbc.Driver");
                 Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectupdate", "root", "root");
                 
                 String sql = "insert into user (username,email,password) values (?,?,?)";
                 PreparedStatement stmt = conn.prepareStatement(sql);
               
                 stmt.setString(1, username);
                 stmt.setString(2, email);
                 stmt.setString(3, password);
                
                 int rowinserted=stmt.executeUpdate();
		                 if(rowinserted>0) {
		                 	response.sendRedirect("Login.jsp");
		                 }else{
		                	 request.setAttribute("errorMessage", "User registration failed."); // database issue
		                	 request.getRequestDispatcher("Register.jsp").forward(request, response);
		                 }
                 stmt.close();
                 conn.close();
             } catch (SQLException e) {
                 e.printStackTrace();
                 request.setAttribute("errorMessage","Database error: "+e.getMessage());
                 request.getRequestDispatcher("Register.jsp").forward(request,response);
                 }catch(ClassNotFoundException e) {
                	 e.printStackTrace();
                	 request.setAttribute("errorMessage","Driver Not Found: "+ e.getMessage());
                	 request.getRequestDispatcher("Register.jsp").forward(request,response);
                 }
        
    }
}
