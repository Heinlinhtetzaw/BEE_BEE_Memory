package coder;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public LoginServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            response.getWriter().println("Username and password must not be empty.");
            return;
        }

        String query = "SELECT user_id, username, email FROM user WHERE username = ? AND password = ?";
       
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/projectupdate", "root", "root");

            // Query to check user login
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
            	

                // Valid user, retrieve user info
                int userId = rs.getInt("user_id");
                String email = rs.getString("email");
                
                // Insert login activity into the login_activity table
                String insertLoginActivityQuery = "INSERT INTO login_activity (User_id, Login_Time) VALUES (?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertLoginActivityQuery);
                insertStmt.setInt(1, userId);
                insertStmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
                insertStmt.executeUpdate();
                insertStmt.close();
                

                // Store the logged-in user's details in session
                session.setAttribute("user_id", userId);
                session.setAttribute("username", username);
                session.setAttribute("email", email);

                response.sendRedirect("index.html");

            } else {
                // Invalid credentials
                request.setAttribute("errorMessage", "Invalid username or password.");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
            }

            // Close resources
            rs.close();
            stmt.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Driver not found: " + e.getMessage());
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }
}


