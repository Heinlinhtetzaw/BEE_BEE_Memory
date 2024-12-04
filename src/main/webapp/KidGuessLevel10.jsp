<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Guess a Word Game level-10</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: sans-serif;
        }

        body {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background: rgb(99, 188, 230);
        }

        .wrapper {
            width: 430px;
            background: #fff;
            border-radius: 10px;
        }

        .wrapper h1 {
            font-size: 25px;
            font-weight: 500;
            padding: 20px 25px;
            border-bottom: 1px solid #ccc;
        }

        .content {
            margin: 25px 25px 35px;
        }

        .typing-input {
            z-index: -999;
            opacity: 0;
            position: absolute;
        }

        .inputs {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }

        .inputs input {
            height: 57px;
            width: 56px;
            margin: 4px;
            font-size: 24px;
            font-weight: 500;
            background: none;
            text-align: center;
            text-transform: uppercase;
            color: rgb(99, 188, 230);
            border-radius: 5px;
            border: 1px solid #b5b5b5;
        }

        .details {
            margin: 20px 0 25px;
        }

        .details p {
            font-size: 19px;
            margin-bottom: 10px;
        }

        .reset-btn {
            width: 100%;
            padding: 15px 0;
            border: none;
            outline: none;
            border-radius: 5px;
            font-size: 17px;
            color: #fff;
            background: rgb(99, 188, 230);
            cursor: pointer;
        }

        h2 {
            font-size: 1.8em;
            color: #fff;
            text-transform: uppercase;
            letter-spacing: 0.1em;
        }

        .victory-screen,
        .try-again-screen {
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

        .score {
            font-size: 1.5em;
            margin: 10px 0;
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
            color: #141111;
        }
    </style>
</head>

<body>


    <div class="victory-screen">
        <h1>Level <span id="victory-level-number">10</span> Completed!</h1>
        <div class="score">Score: <span id="score">0</span></div>
        <div class="buttons">
            <button id="replay-button">Replay</button>&nbsp;&nbsp;
            <button id="home-button">Home</button>&nbsp;&nbsp;
            <button id="next-level-button">Next Level</button>&nbsp;&nbsp;
        </div>
    </div>

    <div class="try-again-screen" id="try-again-screen">
        <h1>Incorrect!</h1>
        <div class="buttons">
            <button id="replay-try-again-button">Replay</button>
            <button id="home-try-again-button">Home</button>
        </div>
    </div>

    <div class="wrapper">
        <div class="container">
            <center><h2 style="background-color:rgb(99, 188, 230);">Gusses Word Level-10<br></h2></center>
            
            <center><div class="timer" style="background-color:rgb(99, 188, 230);">🕥 Time Left: <span id="timer">20</span> seconds<br><br></div></center>
            
        </div>
        <h1>Guess the word</h1>
        <div class="content">
            <input type="text" class="typing-input" maxlength="1">
            <div class="inputs"></div>
            <div class="details">
                <p class="hint">Hint: <span></span></p>
                <p class="guess-left">Remaining Guesses: <span></span></p>
                <p class="wrong-letters">Wrong Letters: <span></span></p>
            </div>
            <button class="reset-btn">Reset Game</button>
        </div>
    </div>

<!-- Hidden Form for Submitting Game Progress -->
	<form id="gameProgressForm" method="POST" style="display: none;">
    <input type="hidden" name="userId" value="<%= session.getAttribute("user_id") %>">
    <input type="hidden" name="gameId" value="10"> <!-- Replace with actual game ID -->
    <input type="hidden" name="completedLevel" value="1"> <!-- Track level completion -->
    <input type="hidden" name="score" value="3"> <!-- Track score -->
	</form>
    <script>
        const wordList = [
        {

word: "cheese",
hint: "what do we put on a sandwich?"

},

{

word: "cake",
hint: "what is a sweet treat?"

},


{

word: "midicine",
hint: "what should you drink if you are sick?"

}
        ];

        const inputs = document.querySelector(".inputs"),
            resetBtn = document.querySelector(".reset-btn"),
            wrongLetter = document.querySelector(".wrong-letters span"),
            hint = document.querySelector(".hint span"),
            guessLeft = document.querySelector(".guess-left span"),
            typingInput = document.querySelector(".typing-input"),
            levelNumberDisplay = document.getElementById("level-number"),
            timerDisplay = document.getElementById("timer"),
            scoreDisplay = document.getElementById("score");

        let word, maxGuesses, corrects = [], incorrects = [], score = 0;
        let timer, timeLeft = 20;

        function startTimer() {
            timeLeft = 20;
            timerDisplay.innerText = timeLeft;
            timer = setInterval(() => {
                timeLeft--;
                timerDisplay.innerText = timeLeft;
                if (timeLeft <= 0) {
                    clearInterval(timer);
                    showTryAgainScreen();
                }
            }, 1000);
        }

        function randomWord() {
            const randomObj = wordList[Math.floor(Math.random() * wordList.length)];
            word = randomObj.word;
            maxGuesses = 8;
            corrects = [];
            incorrects = [];

            hint.innerText = randomObj.hint;
            guessLeft.innerText = maxGuesses;
            wrongLetter.innerText = '';

            inputs.innerHTML = Array.from(word).map(() => `<input type="text" disabled>`).join('');
            startTimer();
        }

        function initGame(e) {
            const key = e.target.value.toLowerCase();

            if (key.match(/^[a-z]$/) && !incorrects.includes(key) && !corrects.includes(key)) {
                if (word.includes(key)) {
                    for (let i = 0; i < word.length; i++) {
                        if (word[i] === key) {
                            corrects.push(key);
                            inputs.querySelectorAll("input")[i].value = key;
                        }
                    }
                } else {
                    maxGuesses--;
                    incorrects.push(key);
                }

                guessLeft.innerText = maxGuesses;
                wrongLetter.innerText = incorrects.join(', ');

                if (corrects.length === word.length) {
                    clearInterval(timer);
                    handleVictory();
                }

                if (maxGuesses === 0) {
                    clearInterval(timer);
                    showTryAgainScreen();
                }
            }
            typingInput.value = "";
        }

        function handleVictory() {
            score += 3;
            scoreDisplay.innerText = score;
            document.querySelector(".victory-screen").style.display = "block";
            document.getElementById("victory-level-number").innerText = 10;
        }

        function showTryAgainScreen() {
            document.querySelector(".try-again-screen").style.display = "block";
            inputs.querySelectorAll("input").forEach((input, index) => {
                input.value = word[index];
            });
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
        resetBtn.addEventListener("click", () => {
            randomWord();
        });

        document.getElementById("replay-button").addEventListener("click", () => {
            document.querySelector(".victory-screen").style.display = "none";
            score = 0;
            scoreDisplay.innerText = score;
            randomWord();
        });

        document.getElementById("home-button").addEventListener("click", () => {
            window.location.href = 'index.html'; // Change to your home page URL
        });

        document.getElementById("next-level-button").addEventListener("click", nextLevel);


        document.getElementById("replay-try-again-button").addEventListener("click", () => {
            document.querySelector(".try-again-screen").style.display = "none";
            randomWord();
        });

        document.getElementById("home-try-again-button").addEventListener("click", () => {
            window.location.href = 'index.html'; // Change to your home page URL
        });

        typingInput.addEventListener("input", initGame);
        inputs.addEventListener("click", () => typingInput.focus());
        document.addEventListener("keydown", () => typingInput.focus());

        randomWord();
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
