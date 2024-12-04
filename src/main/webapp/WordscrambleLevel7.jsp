<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>   
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Word Scramble Level7</title>
    <link rel="stylesheet" href="word.css">
    <script src="js/script.js" defer></script>
    <script src="js/word.js"></script>
    <style>
        /* Reset some basic elements */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Arial', sans-serif;
            background: linear-gradient(135deg, #e1f722, #00c6ff);
            color: #333;
            display: flex;
            flex-direction: column;
            align-items: center;
            height: 100vh;
            justify-content: center;
        }

        .container {
            background: linear-gradient(135deg, #e1f722, #00c6ff);
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
            padding: 40px;
            width: 400px;
            text-align: center;
        }

        h1 {
            margin-bottom: 20px;
            font-size: 28px;
            color: #333;
        }

        .word {
            font-size: 33px;
            font-weight: 500;
            text-align: center;
            letter-spacing: 19px;
            margin-right: -24px;
            text-transform: uppercase;
        }

        .details {
            font-size: 16px;
            color: #777;
            margin-bottom: 15px;
        }

        input[type="text"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            margin-bottom: 15px;
            font-size: 16px;
            transition: border-color 0.3s;
        }

        input[type="text"]:focus {
            border-color: #4a90e2;
            outline: none;
        }

        .buttons {
            display: flex;
            justify-content: space-between;
        }

        button {
            background-color: #4a90e2;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 20px;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.3s;
        }

        button:hover {
            background-color: #357ab8;
            transform: translateY(-2px);
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

        .timer {
            font-size: 1.5em;
            color: #141111;
         
            margin-bottom: 20px;
        }
        
    </style>
</head>

<body>
    <div class="victory-screen" id="victory-screen">
        <h1>Level <span id="victory-level-number">7</span> Completed!</h1>
        <div class="score">Score: <span id="score">0</span></div>
        <div class="buttons">
            <button id="replay-button">Replay</button>&nbsp;&nbsp;
            <button id="home-button" onclick="location.href='index.html'">Home</button>&nbsp;&nbsp;
            <button id="next-level-button">Next Level</button>
        </div>
    </div>

    <div class="try-again-screen" id="try-again-screen">
        <h1>Incorrect!</h1>
        <div class="buttons">
            <button id="replay-try-again-button">Replay</button>
            <button id="home-try-again-button" onclick="location.href='index.html'">Home</button>
        </div>
    </div>
    <h4 style="font-size: 2.5em;">Word Scramble Level-7</h4>
    <div class="timer">🕥 Time Left: <span id="timer">20</span> seconds</div>
    <br>
    <div class="container">
        
        <h2>Word Scramble</h2>
        <div class="content">
            <p class="word"></p>
            <div class="details">
                <p class="hint">Hint: <span></span></p>
            </div>
            <input type="text" placeholder="Enter a valid word">
            <div class="buttons">
                <button class="refresh-word">Refresh Word</button>
                <button class="check-word">Check Word</button>
            </div>
        </div>
    </div>

<!-- Hidden Form for Submitting Game Progress -->
	<form id="gameProgressForm" method="POST" style="display: none;">
    <input type="hidden" name="userId" value="<%= session.getAttribute("user_id") %>">
    <input type="hidden" name="gameId" value="9"> <!-- Replace with actual game ID -->
    <input type="hidden" name="completedLevel" value="1"> <!-- Track level completion -->
    <input type="hidden" name="score" value="3"> <!-- Track score -->
	</form>
    <script>
        const words = [
        { word: "computer", hint: "Electronic device for processing data" },
    { word: "garden", hint: "Area for growing plants and flowers" },
    { word: "ocean", hint: "Large body of saltwater" },
    { word: "mountain", hint: "Natural elevation of the Earth's surface" },
        ];

        const wordText = document.querySelector(".word"),
            hintText = document.querySelector(".hint span"),
            timeText = document.getElementById("timer"),
            inputField = document.querySelector("input[type='text']"),
            refreshBtn = document.querySelector(".refresh-word"),
            checkBtn = document.querySelector(".check-word"),
            victoryScreen = document.getElementById("victory-screen"),
            tryAgainScreen = document.getElementById("try-again-screen"),
            scoreDisplay = document.getElementById("score");

        let correctWord, timer, score = 2;

        const initTimer = maxTime => {
            clearInterval(timer);
            timer = setInterval(() => {
                if (maxTime > 0) {
                    maxTime--;
                    timeText.innerText = maxTime;
                } else {
                    clearInterval(timer);
                    tryAgainScreen.style.display = 'block'; // Show incorrect screen on timeout
                }
            }, 1000);
        };

        const initGame = () => {
            initTimer(20);
            let randomObj = words[Math.floor(Math.random() * words.length)];
            let wordArray = randomObj.word.split("");
            for (let i = wordArray.length - 1; i > 0; i--) {
                let j = Math.floor(Math.random() * (i + 1));
                [wordArray[i], wordArray[j]] = [wordArray[j], wordArray[i]];
            }
            wordText.innerText = wordArray.join("");
            hintText.innerText = randomObj.hint;
            correctWord = randomObj.word.toLowerCase();
            inputField.value = "";
            inputField.setAttribute("maxlength", correctWord.length);
        };

        const checkWord = () => {
            let userWord = inputField.value.toLowerCase();
            if (!userWord) return; // Do nothing if no input
            if (userWord === correctWord) {
                score++;
                scoreDisplay.innerText = score;
                victoryScreen.style.display = 'block';
                clearInterval(timer);
            } else {
                tryAgainScreen.style.display = 'block';
                clearInterval(timer);
            }
        };

        function nextLevel() {
            // Disable the button to prevent multiple clicks
            document.getElementById('next-level-button').disabled = true;

            // Submit the hidden form
            document.getElementById('gameProgressForm').submit();

            // If you want to show a message or perform actions after submission, 
            // you can do that here, but keep in mind that the page will navigate 
            // after form submission.
        }
        document.getElementById("next-level-button").addEventListener("click", nextLevel);

        refreshBtn.addEventListener("click", initGame);
        checkBtn.addEventListener("click", checkWord);
        document.getElementById("replay-button").addEventListener("click", () => {
            victoryScreen.style.display = 'none';
            score = 2; // Reset score
            scoreDisplay.innerText = score;
            initGame();
        });
        document.getElementById("replay-try-again-button").addEventListener("click", () => {
            tryAgainScreen.style.display = 'none';
            initGame();
        });

        initGame();  // Start the game initially
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
            response.sendRedirect("WordscrambleLevel8.jsp"); // Redirect to the next level
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
