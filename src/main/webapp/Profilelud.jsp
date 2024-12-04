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
    <link rel="icon" href="images/brain2.png"> 
    <link rel="stylesheet" href="css/main.css">
    <script src="js/tooltip.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- font-awesome link  -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

    <style>
        .profilecontainer{
            margin-top:-10px;
        }
        .userinformation{
            border:none;
            border-radius: 10px;
            /* box-shadow: 0 0 5px grey; */
            height:300px;
            margin-top:55px;
        }
        .userinformation .userinfotext{
            margin-top:25px;
            
            text-align:center;
        }
        .table tbody tr td{
            padding:10px 0;
        }
        .table{
            box-shadow:0 0 10px grey;
        }
        .tablecontainer{
            margin-top:20px;
            box-shadow: 0 5px 5px rgb(184, 181, 181);
        }
        .table-wrapper{
            overflow-y:scroll;
            max-height:400px;
        }
        .table thead th{
            position:sticky;
            top:0;
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
<body class="alert-primary">
    <!-- Navbar -->
    <div class="navbar container-fluid" id="profile">
        <div class="brand">
            <div><img src="images/brain2.png" alt="logo"></div>
            <div class="logotext"><span>Bee Bee</span> Memory</div>
        </div>
        <div class="navtext">
            <ul>
                <li><a href="index.html" id="home"><i class="fa-sharp fa-solid fa-house"></i>&nbsp;Home</a></li>
                <li><a href="aboutgame.html"><i class="fa-solid fa-bars"></i>&nbsp;About Games</a></li>
                <li><a href="game.html"><i class="fa-solid fa-gamepad"></i>&nbsp;Games</a></li>
                <li class="active1"><a href="profile.html"><i class="fa-solid fa-user"></i>&nbsp;Profile</a></li>
                <li><a href="Leaderboardud.jsp"><i class="fa-solid fa-star"></i>&nbsp;Leaderboard</a></li>
                <li><a href="contact.html"><i class="fa-solid fa-address-book"></i>&nbsp;Contact</a></li>
                <!-- Logout Button  -->
                <li class="active1">
                    <a href="LogoutServlet" class="btn text-white" data-bs-toggle="tooltip" title="Logout"><i class="fa-solid fa-right-from-bracket"></i></a>
                </li>
            </ul>
        </div>
    </div>
    <!-- End of Navbar -->
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
    <!-- User Profile  -->
    <div class="container mt-3">
        <div class="row p-4 bg-primary rounded ">
            <h1 class="text-center text-white">My Profile</h1>
        </div>
    </div>

    <div class="profilecontainer container">
        <div class="row justify-content-evenly">
            <img src="images/profileimage.png" alt="" class="col-4">

            <div class="userinformation col-6 bg-primary">
                <div class="userinfotext text-white">
                    <h3><%= session.getAttribute("username") %></h3>
                    <h5>ID : <%= session.getAttribute("user_id") %></h5>
                    <h5>E-mail : <%= session.getAttribute("email") %></h5>
                    <h5>Total Games Played : <%= totalGamesPlayed %></h5>
                    <h5>Total Score : <%= totalScore %></h5>
        		<button class="update-button" onclick="toggleForm()">Update Your Information</button>
                </div>
            </div>

        </div>
    </div>
    <!-- End of User Profile  -->
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
    <!-- Table  -->
    <div class="tablecontainer container bg-white p-4">
        <div class="row">
            <h2>My Game History</h2>
        </div>

        <div class="table-wrapper row">
            <table class="table table-hover text-center table-secondary table-striped table-fixed">
                <thead>
                    <tr>
                        <th class="p-3 bg-dark text-white">No.</th>
                        <th class="p-3 bg-dark text-white">Game Name</th>
                        <th class="p-3 bg-dark text-white">Score</th>
                        <th class="p-3 bg-dark text-white">Date Played</th>
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
    <!-- End of Table  -->
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
   <!-- Up Button -->
   <div class="up">
    <a href="#profile" class="btn btn-danger" 
    data-bs-toggle="tooltip" title="Up"><i class="fa-solid fa-arrow-up"></i></a> 
 </div>
 <!-- End of Up Button  -->

    <!-- Footer -->
    <div class="container-fluid bg-dark mt-3" id="footer">
        <div class="footerlogo row">
            <h2 class="col-4" data-bs-toggle="tooltip" title="Our Website"><img src="images/brain2.png" alt="" width="50px">Bee Bee Memory</h2>
        </div>
        <div class="row bg-dark text-white justify-content-between p-4">
            <div class="r1 col-3 row">
                <h3>Contact Us</h3>
                <ul class="col-6">
                    
                    <li><a class="btn btn-outline-danger" href="index.html#index" data-bs-toggle="tooltip" title="Facebook: Bee Bee Memory"><i class="fa-brands fa-facebook"></i></a></li>
                    <li><a class="btn btn-outline-danger" href="aboutgame.html#aboutgame" data-bs-toggle="tooltip" title="Messenger: Bee Bee Memory"><i class="fa-brands fa-facebook-messenger"></i></a></li>
                    <li><a class="btn btn-outline-danger" href="game.html#game" data-bs-toggle="tooltip" title="Instagram: Bee Bee Memory"><i class="fa-brands fa-instagram"></i></a></li>
                    <li><a class="btn btn-outline-danger" href="profile.html#profile" data-bs-toggle="tooltip" title="Telegram: Bee Bee Memory"><i class="fa-brands fa-telegram"></i></a></li>
                    
                </ul>
                
            </div>
            <div class="r2 col-3">
                <ul>
                    <h3>Website Links</h3>
                    <li><a href="index.html">Home</a></li>
                    <li><a href="aboutgame.html">About Games</a></li>
                    <li><a href="game.html#game">Games</a></li>
                    <li><a href="Profilelud.jsp">Profile</a></li>
                    <li><a href="Profilelud.jsp">Leaderboard</a></li>
                    <li><a href="contact.html">Contact</a></li>
                </ul>
            </div>
            <div class="r3 col-3">    
                <ul>
                    <h3>Game Links</h3>
                    <li><a href="mathpf.html#mathpf" data-bs-toggle="tooltip" title="kids level">Math Game</a></li>
                    <li><a href="color cardpf.html#colorcardpf" data-bs-toggle="tooltip" title="kids level">Color Card Game</a></li>
                    <li><a href="fruitcardkidspf.html#fruitcardkidspf" data-bs-toggle="tooltip" title="kids level">Fruit Card Game</a></li>
                    <li><a href="guesswordkidspf.html#guesswordkidspf" data-bs-toggle="tooltip" title="kids level">Guess Word Game</a></li>
                    <li><a href="wordscramblekidspf.html#wordscramblekidspf" data-bs-toggle="tooltip" title="kids level">Word Scramble Game</a></li>
                    <li><a href="multiplyingpf.html#multiplyingpf" data-bs-toggle="tooltip" title="Toddlers level">Multiplying Game</a></li>
                    <li><a href="cardpf.html#cardpf" data-bs-toggle="tooltip" title="Toddlers level">Card Game</a></li>
                    <li><a href="guesswordtoddlerspf.html#guesswordtoddlerspf" data-bs-toggle="tooltip" title="Toddlers level">Guess Word Game</a></li>
                </ul>
            </div>
            <div class="r4 col-3">    
                <ul>
                    <h3>Game Links</h3>
                    
                    <li><a href="wordscrambletoddlerspf.html#wordscrambletoddlerspf" data-bs-toggle="tooltip" title="Toddlers level">Word Scramble Game</a></li>
                    <li><a href="numberpf.html#numberpf" data-bs-toggle="tooltip" title="Teenagers level">Number Game</a></li>
                    <li><a href="brainpf.html#brainpf" data-bs-toggle="tooltip" title="Teenagers level">Brain Game</a></li>
                    <li><a href="guesswordteenagerspf.html#guesswordteenagerspf" data-bs-toggle="tooltip" title="Teenagers level">Guess Word Game</a></li>
                    <li><a href="wordscrambleteenagerspf.html#wordscrambleteenagerspf" data-bs-toggle="tooltip" title="Teenagers level">Word Scramble Game</a></li>
                    <li><a href="2playerscardpf.html#2playerscardpf" data-bs-toggle="tooltip" title="2 Players Type">Card Game</a></li>
                    <li><a href="2playerstic ta toepf.html#2playerstictatoepf" data-bs-toggle="tooltip" title="2 Players Type">Tic Ta Toe Game</a></li>
                    <li><a href="2playersconnect4pf.html#2playersconnect4pf" data-bs-toggle="tooltip" title="2 Players Type">Connect 4 Game</a></li>
                </ul>
            </div>

        </div>
        
    </div>
    <div class="container-fluid bg-danger">
        <div class="footertext column p-2 text-white text-center">
            <h5 >&copy; copyright! all right reserved</h5>
            <h6 >Designed By Bee Bee Memory</h6>
        </div>
    </div>
    <!-- End of Footer -->
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