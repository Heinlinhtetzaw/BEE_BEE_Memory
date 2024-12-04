<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Math Addition Quiz Game - Level 3</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background: #b7e7f0;
        }
        .container {
            text-align: center;
        }
        h1 {
            font-size: 40px;
        }
        .main-box {
            background: #caf797;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
            display: inline-block;
        }
        .show-answer {
            background: #fb6868;
            color: #fff;
            padding: 10px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .box1 {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 20px;
        }
        .intext11 {
            width: 60px;
            height: 40px;
            text-align: center;
            font-size: 18px;
            margin: 0 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .add-s {
            font-size: 24px;
        }
        #intext2 {
            width: 140px;
            height: 40px;
            text-align: center;
            font-size: 18px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .btn {
            padding: 10px 20px;
            font-size: 16px;
            color: #fff;
            background: #fb6868;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn:hover {
            background: #e05555;
        }
        .timer {
            font-size: 20px;
            margin-bottom: 20px;
        }
        .victory-screen, .try-again-screen {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            padding: 20px;
            width: 300px;
            z-index: 1000;
        }
        .victory-screen h1 {
            color: goldenrod;
            font-size: 2em;
            margin: 0;
        }
        .try-again-screen h1 {
            color: red;
            font-size: 2em;
            margin: 0;
        }
        .buttons {
            display: flex;
            justify-content: space-around;
            margin-top: 20px;
        }
        .buttons button {
            background-color: #03783b;
            border: none;
            border-radius: 5px;
            color: #fff;
            padding: 10px 20px;
            cursor: pointer;
        }
        .buttons button:hover {
            background-color: skyblue;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Math Addition Quiz Game - Level 3</h1>
        <div class="timer">🕥Time Left: <span id="timer">10</span> seconds</div>
        <div class="main-box">
            <div class="show-answer" id="ans"></div>
            <div class="box1">
                <input type="text" id="intext" class="intext11" readonly>
                <span class="add-s">+</span>
                <input type="text" id="intext1" class="intext11" readonly>
            </div>
            <input type="text" id="intext2">
            <button class="btn" onclick="checkAnswer()">Check Answer</button>
        </div>
    </div>
    <div class="victory-screen" style="display: none;">
        <h1>Level 3 Completed!</h1>
        <h2>Score : 3 </h2>
        <div class="buttons">
            <button id="replay-button">Replay</button>
            <button id="home-button">Home</button>
            <button id="next-level-button">Next Level</button>
        </div>
    </div>
    <div class="try-again-screen" style="display: none;">
        <h1>Incorrect!</h1>
        <div class="buttons">
            <button id="replay-button-again">Replay</button>
            <button id="home-button-again">Home</button>
        </div>
    </div>
<!-- Hidden Form for Submitting Game Progress -->
	<form id="gameProgressForm" method="POST" style="display: none;">
    <input type="hidden" name="userId" value="<%= session.getAttribute("user_id") %>">
    <input type="hidden" name="gameId" value="2"> <!-- Replace with actual game ID -->
    <input type="hidden" name="completedLevel" value="1"> <!-- Track level completion -->
    <input type="hidden" name="score" value="3"> <!-- Track score -->
	</form>

    <script>
        let n1, n2, correctAnswer;
        let timerInterval;

        function startGame() {
            n1 = Math.floor(Math.random() * 10 + 1); // Random number for Level 1
            n2 = Math.floor(Math.random() * 10 + 1);
            correctAnswer = n1 + n2;

            document.getElementById("intext").value = n1;
            document.getElementById("intext1").value = n2;
            document.getElementById("intext2").value = "";
            document.getElementById("ans").innerHTML = "";

            startTimer(10);  // Start timer with 10 seconds
        }

        function startTimer(duration) {
            let timer = duration;
            document.getElementById("timer").textContent = timer;

            timerInterval = setInterval(() => {
                timer--;
                document.getElementById("timer").textContent = timer;

                if (timer <= 0) {
                    clearInterval(timerInterval);
                    document.querySelector(".try-again-screen").style.display = "block";
                }
            }, 1000);
        }

        function checkAnswer() {
            let userAnswer = parseInt(document.getElementById("intext2").value, 10);

            if (userAnswer === correctAnswer) {
                document.getElementById("ans").innerHTML = "Well Done! Your Answer is Correct";
                clearInterval(timerInterval);
                document.querySelector(".victory-screen").style.display = "block";
            } else {
                document.getElementById("ans").innerHTML = `Correct Answer: ${correctAnswer}. Try Again`;
            }
        }

        function replay() {
            document.querySelector(".victory-screen").style.display = "none";
            document.querySelector(".try-again-screen").style.display = "none";
            startGame();
        }

        function nextLevel() {
            // Disable the button to prevent multiple clicks
            document.getElementById('next-level-button').disabled = true;

            // Submit the hidden form
            document.getElementById('gameProgressForm').submit();

            // If you want to show a message or perform actions after submission, 
            // you can do that here, but keep in mind that the page will navigate 
            // after form submission.
        }

        function goHome() {
            window.location.href = 'index.html'; 
        }

        // Add event listeners to buttons
        document.getElementById("replay-button").addEventListener("click", replay);
        document.getElementById("home-button").addEventListener("click", goHome);
        document.getElementById("next-level-button").addEventListener("click", nextLevel);
        document.getElementById("replay-button-again").addEventListener("click", replay);
        document.getElementById("home-button-again").addEventListener("click", goHome);

        // Start the game when the page loads
        window.onload = startGame;
    </script>
    
    <%
    // Ensure the user is logged in and retrieve user ID
    if (session == null || session.getAttribute("user_id") == null) {
        // Redirect to login page if user is not logged in
        response.sendRedirect("login.jsp");
        return;
    }

    // Handle form submission for game progress
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        int userId = (int) session.getAttribute("user_id");
        int gameId = Integer.parseInt(request.getParameter("gameId"));
        int completedLevel = Integer.parseInt(request.getParameter("completedLevel"));
        int score = Integer.parseInt(request.getParameter("score"));

        // Database connection details
        String url = "jdbc:mysql://localhost:3306/projectupdate"; // Update with your database name
        String dbUsername = "root"; // Your DB username
        String dbPassword = "root"; // Your DB password

        Connection connection = null;
        PreparedStatement statement = null;

        try {
            // Connect to the database
            connection = DriverManager.getConnection(url, dbUsername, dbPassword);

            // SQL query to insert a new record into the game_played table
            String sql = "INSERT INTO game_played (user_id, game_id, highest_level_completed, score, date_played) VALUES (?, ?, ?, ?, ?)";
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            statement.setInt(2, gameId);
            statement.setInt(3, completedLevel);
            statement.setInt(4, score);
            statement.setTimestamp(5, new Timestamp(System.currentTimeMillis()));

            // Execute the query
            statement.executeUpdate();

            // Redirect to the next level or success page after inserting
            response.sendRedirect("MathLevel4.jsp"); // Redirect to the next level
        } catch (SQLException e) {
            e.printStackTrace(); // Handle exceptions
        } finally {
            try {
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>
    
</body>
</html>
