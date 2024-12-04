<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="./css/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
   
        <div class="background"></div>
            
            <form action="LoginServlet" method="post">
            <div class="Login">
            <h2>Login</h2>
                <div class="LoginForm">
                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" required>
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" required>
                   <button type="submit">Login</button>
                </div>
                
                 <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
            <% if (errorMessage != null) { %>
                <p align="center" style="color:red;"><%= errorMessage %></p>
            <% } %>
                <p align="center">Don't have an account?<a href="Register.jsp">Register</a></p><br>
                <p class="btn"><a href="guest.html"><i class="fa-solid fa-arrow-left"></i>Back</a></p>
                
                
        </div>
    </form>
    
    
</body>
</html>