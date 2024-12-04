package coder;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class ProfileUpdateServlet
 */
@WebServlet("/ProfileUpdateServlet")
public class ProfileUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ProfileUpdateServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Retrieve form data
        String userId = request.getParameter("profile-id");
        String newName = request.getParameter("profile-name");
        String newEmail = request.getParameter("profile-email");

        // Database connection information
        String url = "jdbc:mysql://localhost:3306/projectupdate";
        String dbUsername = "root";
        String dbPassword = "root";
        
        Connection connection = null;
        PreparedStatement statement = null;

        try {
            // Connect to the database
            connection = DriverManager.getConnection(url, dbUsername, dbPassword);

            // Prepare SQL update statement
            String sql = "UPDATE user SET username = ?, email = ? WHERE user_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setString(1, newName);
            statement.setString(2, newEmail);
            statement.setInt(3, Integer.parseInt(userId));

            // Execute the update
            int rowsUpdated = statement.executeUpdate();
            if (rowsUpdated > 0) {
                // Update session attributes
                HttpSession session = request.getSession();
                session.setAttribute("username", newName);
                session.setAttribute("email", newEmail);

                // Redirect back to profile page with success message
                response.sendRedirect("Profilelud.jsp?update=success");
            } else {
                // Handle case where update fails (optional)
                response.sendRedirect("Profilelud.jsp?update=failure");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
	}

}
