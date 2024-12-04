<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>3Number Game Combination Game level8</title>
    <style>
        body {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            background-color: #7CC0CF;
            font-family: 'Fira Mono', monospace;
            color: #0d0404;
            margin: 0;
        }
        .container h1 {
            color: black;
        }
        .game {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 600px;
            margin: 0.25rem auto;
            justify-content: center;
        }
        .target {
            border: thin solid #0e0505;
            width: 300px;
            height: 75px;
            font-size: 45px;
            text-align: center;
            background: #fff;
            border-radius: 5px;
        }
        .challenge-numbers {
            width: 100%;
            margin: 1.5rem auto;
        }
        .number {
            border: thin solid rgb(55, 158, 94);
            background: #fff;
            width: 50%;
            text-align: center;
            font-size: 36px;
            border-radius: 5px;
            margin: 5px;
            display: inline-block;
            cursor: pointer;
        }
        .timer-value {
            color: red;
            font-size: 150%;
        }
        .footer {
            display: flex;
            width: 100%;
            justify-content: space-between;
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
        .timer {
            font-size: 1.5em;
            color: #fff;
        }
        .score {
            font-size: 1.5em;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>3Number Game - Level <span id="level-number">8</span></h1>
        <div class="game">
            <div class="target">?</div>
            <div class="challenge-numbers">
                <div id="1" onclick="select(event)" class="number">?</div>
                <div id="2" onclick="select(event)" class="number">?</div>
                <div id="3" onclick="select(event)" class="number">?</div>
                <div id="4" onclick="select(event)" class="number">?</div>
                <div id="5" onclick="select(event)" class="number">?</div>
                <div id="6" onclick="select(event)" class="number">?</div>
            </div>
            <div class="footer">
                <span class="timer-value">Timer : </span><div class="timer-value"></div>
                <button id="start-button">Start Game</button>
            </div>
            <h3>In 15 secs, select 3 numbers from above which sum up to the number in the topmost text field. Click "Start Game" to Start and "Play Again" when done!!</h3>
        </div>
    </div>
    <div class="victory-screen">
        <h1>Level <span id="victory-level-number">8</span> Complete!</h1>
        <div class="score">Score : 19</div>
        <div class="buttons">
            <button id="home-button">Home</button>
            <button id="replay-button">Replay</button>
            <button id="next-level-button" onclick="nextLevel()">Next Level</button>
        </div>
    </div>
    <div class="try-again-screen">
        <h1>Incorrect!</h1>
        <p id="correct-answer" style="color: black; font-size: 1.2em;"></p>
        <div class="buttons">
            <button id="replay-again-button">Replay</button>
            <button id="home-again-button">Home</button>
        </div>
    </div>
    
<!-- Hidden Form for Submitting Game Progress -->
	<form id="gameProgressForm" method="POST" style="display: none;">
    <input type="hidden" name="userId" value="<%= session.getAttribute("user_id") %>">
    <input type="hidden" name="gameId" value="5"> <!-- Replace with actual game ID -->
    <input type="hidden" name="completedLevel" value="1"> <!-- Track level completion -->
    <input type="hidden" name="score" value="3"> <!-- Track score -->
	</form>
    
    <script>
        var interval = 0;
        var numbers = [];
        var answer = new Array(3);
        var count = 1;
        var sum = 0;
        var level = 8;
        var timeExpired = false;  

        function startGame() {
            freezeGame(false);
            timeExpired = false;  

            var target_number = 10 * level;  
            var numDivs = document.getElementsByClassName("number");

            for (var i = 0; i < numDivs.length; i++) {
                var num = randNum(rnd() * 10 * (i + 1));
                if (num <= 1) {
                    num = num + Math.round(i * randNum(i)) + i;
                }
                numDivs[i].innerHTML = num;
                numbers.push(num);
            }

            numbers = shuffleArray(numbers);

            var a = numbers[0],
                b = numbers[numbers.length - 1],
                c = numbers[Math.floor(numbers.length / 2)];

            document.getElementsByClassName("target")[0].innerHTML = a + b + c;

            document.getElementsByClassName("target")[0].style.backgroundColor = "#ccc";

            for (var x = 0; x < numDivs.length; x++) {
                numDivs[x].style.backgroundColor = "#eee";
                numbers = [];
                sum = 0;
                count = 1;
                answer = [];
                clearInterval(interval);
            }

            [answer[0], answer[1], answer[2]] = [a, b, c];
            startTimer(15);
        }

        function shuffleArray(array) {
            var currentIndex = array.length, temporaryValue, randomIndex;

            while (0 !== currentIndex) {
                randomIndex = Math.floor(Math.random() * currentIndex);
                currentIndex -= 1;

                temporaryValue = array[currentIndex];
                array[currentIndex] = array[randomIndex];
                array[randomIndex] = temporaryValue;
            }

            return array;
        }

        function select(event) {
            var index = event.target.id - 1;
            var num = parseInt(document.getElementsByClassName("number")[index].innerHTML);

            if (count <= 3) {
                sum += num;
                count++;
                document.getElementsByClassName("number")[index].style.backgroundColor = "#028482";
            }

            if (count > 3) {
                if (sum == document.getElementsByClassName("target")[0].innerHTML) {
                    document.getElementById("victory-level-number").innerText = level;
                    document.querySelector(".victory-screen").style.display = "block";
                } else {
                    document.querySelector(".try-again-screen").style.display = "block";
                    document.getElementById("correct-answer").innerText = "The correct answer is: " + answer.join(", ");
                }
                freezeGame(true);
            }
        }

        function startTimer(secs) {
            var _secs = secs;
            document.getElementsByClassName("timer-value")[0].innerHTML = "Timer : " + _secs;
            interval = setInterval(function () {
                _secs--;
                document.getElementsByClassName("timer-value")[0].innerHTML = "Timer : " + _secs;
                if (_secs === 0) {
                    clearInterval(interval);
                    timeExpired = true;  
                    if (sum != document.getElementsByClassName("target")[0].innerHTML) {
                        freezeGame(true);
                        document.querySelector(".try-again-screen").style.display = "block";
                        document.getElementById("correct-answer").innerText = "The correct answer is: " + answer.join(", ");
                    }
                }
            }, 1000);
        }

        function freezeGame(freeze = true) {
            var buttons = document.getElementsByTagName("button");

            if (freeze === true) {
                document.getElementsByClassName("target")[0].style.backgroundColor = "Red";
            }

            for (var index = 0; index < buttons.length; index++) {
                if (freeze === false)
                    buttons[index].setAttribute("disabled", "disabled");
                else
                    buttons[index].removeAttribute("disabled");
            }
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
        function replay() {
            document.querySelector(".try-again-screen").style.display = "none";
            document.querySelector(".victory-screen").style.display = "none"; // Hide victory screen
            startGame();
        }

        function goHome() {
            window.location.href = 'index.html'; 
        }

        function rnd() {
            var today = new Date();
            var seed = today.getTime();
            seed = (seed * 9301 + 49297) % 233280;
            return seed / (233280.0);
        }

        function randNum(number) {
            return Math.floor(rnd() * number);
        }

        document.getElementById("start-button").addEventListener("click", startGame);
        document.getElementById("home-button").addEventListener("click", goHome);
        document.getElementById("replay-button").addEventListener("click", replay);
        document.getElementById("replay-again-button").addEventListener("click", replay);
        document.getElementById("home-again-button").addEventListener("click", goHome);
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
            response.sendRedirect("3NumberLevel9.jsp"); // Redirect to the next level
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
