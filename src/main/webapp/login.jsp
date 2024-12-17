<%@ page import="java.sql.*" %>
<%
    String username = request.getParameter("j_username");
    String password = request.getParameter("j_password");
    boolean isValidUser = false;

    if (username != null && password != null) {
        try {
            // 데이터베이스 연결
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/userdb", "root", "password");

            String query = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                isValidUser = true;
                session.setAttribute("username", username); // 세션에 사용자 정보 저장
            }

        } catch (Exception e) {
            out.println("오류 발생: " + e.getMessage());
        }
    }

    if (isValidUser) {
        response.sendRedirect("welcome.jsp"); // 로그인 성공 시
    } else if (username != null && password != null) {
        out.println("<script>alert('로그인 실패: 아이디 또는 비밀번호가 잘못되었습니다.');</script>");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
    <h2>Login</h2>
    <form method="POST" action="login.jsp">
        <label>Username:</label>
        <input type="text" name="j_username" required><br>
        <label>Password:</label>
        <input type="password" name="j_password" required><br>
        <button type="submit">Login</button>
    </form>
</body>
</html>
