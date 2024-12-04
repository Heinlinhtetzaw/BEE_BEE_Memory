<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BBM (Profile)</title>
   
    <style>
        /* General styles */
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .profile-container {
            display: flex;
            gap: 20px;
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 1000px;
            width: 100%;
        }
        /* Profile sidebar styles */
        .profile-sidebar {
            width: 250px;
            background-color: #4A90E2;
            color: #fff;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
        }
        .profile-sidebar img {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            margin-bottom: 10px;
            background-color: #ccc;
        }
        .profile-sidebar h2 {
            margin: 10px 0;
        }
        .profile-sidebar p {
            margin: 5px 0;
            font-size: 14px;
        }
        .profile-sidebar .total-games {
            margin-top: 10px;
            font-weight: bold;
        }
        .update-button {
            margin-top: 15px;
            padding: 10px;
            color: #4A90E2;
            background-color: #fff;
            border: 2px solid #fff;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
        }
        .update-button:hover {
            background-color: #4A90E2;
            color: #fff;
        }
        /* Main content styles */
        .profile-content {
            flex: 1;
        }
        .profile-content h3 {
            color: #4A90E2;
            border-bottom: 2px solid #4A90E2;
            padding-bottom: 5px;
            margin-bottom: 20px;
        }
        .game-history-table-container {
            max-height: 250px;
            overflow-y: auto;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .game-history-table {
            width: 100%;
            border-collapse: collapse;
        }
        .game-history-table th, .game-history-table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .game-history-table th {
            background-color: #4A90E2;
            color: #fff;
            position: sticky;
            top: 0;
        }
        .profile-form {
    	background: linear-gradient(#96b6ed, #f8f6f9);
    	padding: 20px;
   		border-radius: 10px;
    	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    	width: 100%;
    	max-width: 600px;
    	margin: 20px;
    	position: absolute;
    	top: 50%;
    	left: 50%;
    	transform: translate(-50%, -50%);
    	display: none; /* Hide form by default */
		}
		.close {
		    color: #aaa;
		    float: right;
		    font-size: 28px;
		    font-weight: bold;
		}
		
		.close:hover,
		.close:focus {
		    color: black;
		    text-decoration: none;
		    cursor: pointer;
		}
		
		.profile-form table {
		    width: 100%;
		    border-collapse: collapse;
		}
		
		.profile-form td {
		    padding: 10px;
		    text-align: left;
		}
		
		.profile-form button {
		    background-color: #007bff;
		    border: none;
		    border-radius: 5px;
		    color: #fff;
		    padding: 10px 20px;
		    font-size: 16px;
		    cursor: pointer;
		    transition: background-color 0.3s, transform 0.3s;
		}
		
		.profile-form button:hover {
		    background-color: #0056b3;
		    transform: scale(1.05);
		}
		
		.profile-form button:active {
		    background-color: #004094;
		    transform: scale(0.95);
		}
    </style>
</head>
<body>


<%
    // Database connection information
    String url = "jdbc:mysql://localhost:3306/projectupdate";
    String dbUsername = "root";
    String dbPassword = "root";
    Connection connection = null;
    PreparedStatement gamesPlayedStmt = null;
    PreparedStatement totalScoreStmt = null;
    ResultSet gamesPlayedResult = null;
    ResultSet totalScoreResult = null;

    int totalGamesPlayed = 0;
    int totalScore = 0;

    try {
        // Connect to the database
        connection = DriverManager.getConnection(url, dbUsername, dbPassword);

        // Retrieve user ID from session
        int userId = (int) session.getAttribute("user_id");

        // SQL query to calculate total games played
        String gamesPlayedQuery = "SELECT COUNT(*) AS games_played FROM game_played WHERE user_id = ?";
        gamesPlayedStmt = connection.prepareStatement(gamesPlayedQuery);
        gamesPlayedStmt.setInt(1, userId);
        gamesPlayedResult = gamesPlayedStmt.executeQuery();
        
        if (gamesPlayedResult.next()) {
            totalGamesPlayed = gamesPlayedResult.getInt("games_played");
        }

        // SQL query to calculate total score
        String totalScoreQuery = "SELECT SUM(score) AS total_score FROM game_played WHERE user_id = ?";
        totalScoreStmt = connection.prepareStatement(totalScoreQuery);
        totalScoreStmt.setInt(1, userId);
        totalScoreResult = totalScoreStmt.executeQuery();

        if (totalScoreResult.next()) {
            totalScore = totalScoreResult.getInt("total_score");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        try {
            if (gamesPlayedResult != null) gamesPlayedResult.close();
            if (totalScoreResult != null) totalScoreResult.close();
            if (gamesPlayedStmt != null) gamesPlayedStmt.close();
            if (totalScoreStmt != null) totalScoreStmt.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<div class="profile-container">
    <!-- Profile Sidebar -->
    <div class="profile-sidebar">
        <img src="https://via.placeholder.com/100" alt="Profile Picture">
        <h2><%= session.getAttribute("username") %></h2>
        <p>ID: <%= session.getAttribute("user_id") %></p>
        <p>Email: <%= session.getAttribute("email") %></p>
        <p class="total-games">Total games played: <%= totalGamesPlayed %></p>
        <p class="total-games">Total Score: <%= totalScore %></p>
        <button class="update-button" onclick="toggleForm()">Update Your Information</button>
    </div>
<%
    // Database connection information
    String uurl = "jdbc:mysql://localhost:3306/projectupdate";
    String dbname = "root";
    String dbPw = "root";

    // Get the user ID from the session
    int userId = (int) session.getAttribute("user_id");

    // Initialize database objects
    Connection c = null;
    PreparedStatement statement = null;
    ResultSet resultSet = null;

    try {
        // Connect to the database
        c = DriverManager.getConnection(uurl, dbname, dbPw);

        // Query to fetch game history
        String sql = "SELECT gp.date_played, gl.level_name, gl.level_score " +
                     "FROM game_played gp " +
                     "JOIN game_level gl ON gp.game_id = gl.game_id AND gp.highest_level_completed = gl.level_number " +
                     "WHERE gp.user_id = ? " +
                     "ORDER BY gp.date_played DESC";
        statement = c.prepareStatement(sql);
        statement.setInt(1, userId);

        // Execute the query
        resultSet = statement.executeQuery();

        int rowNumber = 1; // To auto-increment row number
%>
    <!-- Main Profile Content -->
    <div class="profile-content">
        <!-- Game History Section -->
        <h3>Your Game History</h3>
        <div class="game-history-table-container">
            <table class="game-history-table">
                <thead>
                    <tr>
                        <th>No.</th>
                        <th>Game Name</th>
                        <th>Score</th>
                        <th>Date Played</th>
                    </tr>
                </thead>
                <tbody>
                <%
                while (resultSet.next()) {
                    String datePlayed = resultSet.getString("date_played");
                    String gameName = resultSet.getString("level_name");
                    int score = resultSet.getInt("level_score");
            	%>
                     <tr>
                <td><%= rowNumber++ %></td>
                <td><%= gameName %></td>
                <td><%= score %></td>
                <td><%= datePlayed %></td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Close database resources
        if (resultSet != null) try { resultSet.close(); } catch (Exception e) { e.printStackTrace(); }
        if (statement != null) try { statement.close(); } catch (Exception e) { e.printStackTrace(); }
        if (connection != null) try { connection.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
        </div>
    </div>
    
    <div id="updateForm" class="profile-form" style="display:none;">
        <span class="close" onclick="closeModal()">&times;</span>
        <h2>Update Profile Information</h2>
        <form action="ProfileUpdateServlet" method="POST">
            <input type="hidden" name="profile-id" value="<%= session.getAttribute("user_id") %>">
            <table>
                <tr>
                    <td><label for="profile-name">Name:</label></td>
                    <td><input type="text" id="profile-name" name="profile-name" value="<%= session.getAttribute("username") %>"></td>
                </tr>
                <tr>
                    <td><label for="profile-email">Email:</label></td>
                    <td><input type="email" id="profile-email" name="profile-email" value="<%= session.getAttribute("email") %>"></td>
                </tr>
                <tr>
                    <td colspan="2"><button type="submit">Update</button></td>
                </tr>
            </table>
        </form>
    </div>

<script>
	function toggleForm() {
    	const form = document.getElementById('updateForm');
    	form.style.display = form.style.display === 'none' ? 'block' : 'none';
		}
	function closeModal() {
    	const form = document.getElementById('updateForm');
    	form.style.display = 'none';
		}
	
</script>

</body>
</html>
