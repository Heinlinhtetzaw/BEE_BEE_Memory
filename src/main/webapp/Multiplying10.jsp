<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Multiplying Game Level 10</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * {
            font-family: sans-serif;
        }
        body {
            background-color: #7CC0CF;
        }
        .gametitle {
            text-align: center;
            font-size: 30px;
            color: #FFF;
            margin-top: 50px;
        }
        #board {
            background-color: #FF8C00;
            width: 500px;
            height: 380px;
            border-radius: 5px;  
            box-shadow: 0px 5px 5px #134b80;
            position: relative;
            margin: 50px auto;
        }
        #right, #wrong {
            padding: 5px;
            width: 70px;
            position: absolute;
            margin: 20px 200px;
            text-align: center;
            color: white;
            border-radius: 5px;
            display: none;
        }
        #right { background-color: #4fb832; }
        #wrong { background-color: #bb1010; }
        #problem {
            padding: 5px;
            background-color: #7CC0CF;
            width: 400px;
            height: 60px;
            text-align: center;
            position: absolute;
            margin: 85px 40px;
            font-size: 40px;
            line-height: 60px;
            color: white;
            border-radius: 5px;
        }
        #instruction {
            padding: 5px;
            background-color: #75ba26;
            width: 400px;
            height: 30px;    
            text-align: center;
            line-height: 30px;
            position: absolute;
            margin: 165px 40px;
            font-size: 20px;
            color: white;
            border-radius: 5px;
        }
        #answers {
            margin: 215px auto;  /* Centering answers */
            display: flex;
            justify-content: center;
            position: absolute;
            width: 100%;  /* Full width for centering */
        }
        .answer {
            padding: 5px;
            height: 50px; 
            width: 60px;
            background-color: aliceblue;
            border-radius: 5px;
            font-size: 34px;
            text-align: center;
            margin: 0 10px;  /* Adjusted spacing */
            box-shadow: 0px 5px 5px grey;
            cursor: pointer;
        }
        .answer:hover {
            background-color: #4b4ecc;
            color: white;
        }
        #start {
            padding: 5px;
            background-color: #0000cd;
            width: 70px;
            position: absolute;    
            margin: 300px 210px;
            text-align: center;
            color: white;
            border-radius: 5px;   
        }
        #time {
            padding: 5px;
            background-color: #e4c6f0;
            width: 105px;
            text-align: center;
            position: absolute;
            margin: 310px 350px;
            border-radius: 5px;
            display: none;
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
        .victory-screen h1, .try-again-screen h1 {
            margin: 0;
        }
        .victory-screen h1 { color: goldenrod; }
        .try-again-screen h1 { color: red; }
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
    <h1 class="gametitle">Multiplying Number Game &nbsp;<span id="level">Level 10</span><br><br>You need 12 correct answers to proceed to the next level.</h1>

    <!-- Victory Screen -->
    <div class="victory-screen">
        <h1>Level 10  Completed!</h1>
        <br>
        <div class="score">Score : 21</div>
        <div class="buttons">
            <button id="replay-button">Replay</button>
            <button id="home-button">Home</button>
            <button id="next-level-button">Next Level</button>
        </div>
    </div>

    <!-- Try Again Screen -->
    <div class="try-again-screen">
        <h1>Incorrect!</h1>
        <div class="buttons">
            <button id="replay-again-button">Replay</button>
            <button id="home-again-button">Home</button>
        </div>
    </div>

    <!-- Game Board -->
    <div id="board">
        <div id="right">Right</div>
        <div id="wrong">Try again</div>
        <div id="problem"></div>
        <div id="instruction">Click on the right answer</div>
        <div id="answers">
            <div class="answer" id="answer1"></div>
            <div class="answer" id="answer2"></div>
            <div class="answer" id="answer3"></div>
            <div class="answer" id="answer4"></div>
        </div>
        <div id="start">Start Game</div>
        <div id="time">Time: <span id="remainingTime">30</span> sec</div>
        <div id="gameover"></div>
    </div>

<!-- Hidden Form for Submitting Game Progress -->
	<form id="gameProgressForm" method="POST" style="display: none;">
    <input type="hidden" name="userId" value="<%= session.getAttribute("user_id") %>">
    <input type="hidden" name="gameId" value="4"> <!-- Replace with actual game ID -->
    <input type="hidden" name="completedLevel" value="1"> <!-- Track level completion -->
    <input type="hidden" name="score" value="12"> <!-- Track score -->
	</form>
    <script>
        var playing = false;
        var timeRemaining;
        var action;
        var correctAnswer;
        var score = 0;
        var level = 1;  // Level fixed at 1
        var maxScore = 12;  // Correct answers required to complete the level
        var lastAnswerWasCorrect = false;  // Track the last answer status

        document.getElementById("start").onclick = function() {
            if (playing) {
                location.reload();
            } else {
                playing = true;
                initializeGame(level);  // Initialize game at level 1
            }
        }

        function initializeGame(level) {
            score = 0;
            lastAnswerWasCorrect = false;  // Reset the answer status
            document.getElementById("instruction").innerHTML = "Click on the right answer";
            show("time");
            setTimeForLevel(level);
            hide("gameover");
            document.getElementById("start").innerHTML = "Reset Game";
            startCountdown();
            generateQA();
        }

        function setTimeForLevel(level) {
            timeRemaining = 48;  // Fixed time for level 1
            document.getElementById("remainingTime").innerHTML = timeRemaining;
        }

        function startCountdown() {
            stopCountdown();
            lastAnswerWasCorrect = false;  // Reset before starting the countdown
            action = setInterval(function() {
                timeRemaining--;
                document.getElementById("remainingTime").innerHTML = timeRemaining;
                if (timeRemaining <= 0) {
                    stopCountdown();
                    if (!lastAnswerWasCorrect) {
                        showTryAgainScreen();
                    }
                }
            }, 1000);
        }

        function stopCountdown() {
            clearInterval(action);
        }

        function showVictoryScreen() {
            hide("time");
            hide("right");
            hide("wrong");
            document.querySelector(".victory-screen").style.display = "block";
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
        function showTryAgainScreen() {
            hide("time");
            hide("right");
            hide("wrong");
            document.querySelector(".try-again-screen").style.display = "block";
        }

        function generateQA() {
            var randomNumber1 = Math.round(Math.random() * 10);
            var randomNumber2 = Math.round(Math.random() * 10);
            document.getElementById("problem").innerHTML = randomNumber1 + " x " + randomNumber2;
            correctAnswer = randomNumber1 * randomNumber2;
            var answerBox = Math.round(Math.random() * 3) + 1;
            document.getElementById("answer" + answerBox).innerHTML = correctAnswer;

            var answers = [correctAnswer];
            for (var i = 1; i <= 4; i++) {
                if (i !== answerBox) {
                    var wrongAnswer;
                    do {
                        wrongAnswer = (Math.round(Math.random() * 10)) * (Math.round(Math.random() * 10));
                    } while (answers.indexOf(wrongAnswer) > -1);
                    document.getElementById("answer" + i).innerHTML = wrongAnswer;
                    answers.push(wrongAnswer);
                }
            }
        }

        // Answer click event
        for (var i = 1; i <= 4; i++) {
            document.getElementById("answer" + i).onclick = function() {
                if (playing) {
                    if (this.innerHTML == correctAnswer) {
                        score++;
                        lastAnswerWasCorrect = true;  // Correct answer clicked
                        show("right");
                        setTimeout(function() {
                            hide("right");
                        }, 1000);
                        hide("wrong");
                        if (score === maxScore) {
                            showVictoryScreen();
                        } else {
                            generateQA();
                        }
                    } else {
                        // Show "wrong" only if the last answer was not correct
                        if (!lastAnswerWasCorrect) {
                            show("wrong");
                            setTimeout(function() {
                                hide("wrong");
                            }, 1000);
                        }
                        hide("right");
                    }
                }
            }
        }

        function hide(id) {
            document.getElementById(id).style.display = "none";
        }

        function show(id) {
            document.getElementById(id).style.display = "block";
        }

        // Button actions
        document.getElementById("home-button").onclick = function() {
            window.location.href = 'index.html'; // Replace with actual home page URL
        };
        document.getElementById("replay-button").onclick = function() {
            playing = false;
            document.querySelector(".victory-screen").style.display = "none";
            initializeGame(level);  // Replay the current level
        };
        document.getElementById("replay-again-button").onclick = function() {
            playing = false;
            document.querySelector(".try-again-screen").style.display = "none";
            initializeGame(level);  // Replay the current level
        };
        document.getElementById("home-again-button").onclick = function() {
            window.location.href = 'index.html'; // Replace with actual home page URL
        };
        document.getElementById("next-level-button").addEventListener("click", nextLevel);

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
            response.sendRedirect("index.html"); // Redirect to the next level
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
