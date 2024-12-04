<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BBM (Leaderboard)</title>
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
    </style>
</head>
<body>
    <!-- Navbar -->
    <div class="navbar container-fluid" id="leaderboard">
        <div class="brand">
            <div><img src="images/brain2.png" alt="logo"></div>
            <div class="logotext"><span>Bee Bee</span> Memory</div>
        </div>
        <div class="navtext">
            <ul>
                <li><a href="index.html" id="home"><i class="fa-sharp fa-solid fa-house"></i>&nbsp;Home</a></li>
                <li><a href="aboutgame.html"><i class="fa-solid fa-bars"></i>&nbsp;About Games</a></li>
                <li><a href="game.html"><i class="fa-solid fa-gamepad"></i>&nbsp;Games</a></li>
                <li><a href="Profilelud.jsp"><i class="fa-solid fa-user"></i>&nbsp;Profile</a></li>
                <li class="active1"><a href="leaderboard.html"><i class="fa-solid fa-star"></i>&nbsp;Leaderboard</a></li>
                <li><a href="contact.html"><i class="fa-solid fa-address-book"></i>&nbsp;Contact</a></li>
                <!-- Down Button  -->
                <li class="active2"><a href="#footer" data-bs-toggle="tooltip"
                    title="Down"><i class="fa-solid fa-arrow-down"></i></a>
                </li>
        </div>
    </div>
    <!-- End of Navbar -->

    <!-- Table  -->
    <div class="container mt-3">
        <div class="row alert-primary p-3 rounded">
            <h1 class="text-center">Top Players</h1>
        </div>
    </div>
    <div class="tablecontainer container alert-primary p-4">

        <div class="table-wrapper row">
            <table class="table table-hover text-center table-secondary table-striped table-fixed">
                <thead>
                    <tr>
                        <th class="p-3 bg-dark text-white">Rank</th>
                        <th class="p-3 bg-dark text-white">Username</th>
                        <th class="p-3 bg-dark text-white">Total Score</th>
                        <th class="p-3 bg-dark text-white">Game Played</th>
                        <th class="p-3 bg-dark text-white">Last Played Date</th>
                    </tr>
                </thead>
    
                <tbody>
                         <%
				        String url = "jdbc:mysql://localhost:3306/projectupdate";
				        String dbUsername = "root";
				        String dbPassword = "root";
				        Connection connection = null;
				        PreparedStatement statement = null;
				        ResultSet resultSet = null;
				
				        try {
				            // Connect to the database
				            connection = DriverManager.getConnection(url, dbUsername, dbPassword);
				
				            // SQL query to retrieve leaderboard data ordered by total score
				            String sql = "SELECT u.username, " +
								             "SUM(gp.score) AS total_score, " +
								             "COUNT(gp.highest_level_completed) AS games_played, " +
								             "MAX(gp.date_played) AS last_played_date " +
								             "FROM user u " +
								             "JOIN game_played gp ON u.user_id = gp.user_id " +
								             "GROUP BY u.user_id " +
								             "ORDER BY total_score DESC";
												
				            statement = connection.prepareStatement(sql);
				            resultSet = statement.executeQuery();
				
				            int rank = 1;  // Start ranking from 1
				
				            // Loop through the result set and display leaderboard data
				            while (resultSet.next()) {
				        %>
				            <tr>
				                <td><%= rank++ %></td> <!-- Increment rank for each user -->
				                <td><%= resultSet.getString("username") %></td>
				                <td><%= resultSet.getInt("total_score") %></td>
				                <td><%= resultSet.getInt("games_played") %></td>
				                <td><%= resultSet.getTimestamp("last_played_date") %></td>
				            </tr>
				        <%
				            }
				        } catch (SQLException e) {
				            e.printStackTrace(); // Handle exceptions
				        } finally {
				            try {
				                if (resultSet != null) resultSet.close();
				                if (statement != null) statement.close();
				                if (connection != null) connection.close();
				            } catch (SQLException e) {
				                e.printStackTrace();
				            }
				        }
				        %>
    
                </tbody>
            </table>
        </div>
    </div>
    <!-- End of Table  -->


    <!-- Up Button -->
    <div class="up">
        <a href="#leaderboard" class="btn btn-danger" 
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
                    <li><a href="Leaderboardud.jsp">Leaderboard</a></li>
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
</body>
</html>