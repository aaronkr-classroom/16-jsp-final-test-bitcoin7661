<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Register</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/public/css/bootstrap.min.css" />
    <script>
        function validateForm() {
            let name = document.getElementById("floatingName").value.trim();
            let email = document.getElementById("floatingEmail").value.trim();
            let phone = document.getElementById("floatingPhone").value.trim();
            let password = document.getElementById("password").value.trim();

            if (name === "") {
                alert("이름을 입력하세요.");
                return false;
            }
            if (email === "") {
                alert("이메일을 입력하세요.");
                return false;
            }
            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                alert("올바른 이메일 형식이 아닙니다.");
                return false;
            }
            if (phone === "" || isNaN(phone)) {
                alert("전화번호를 숫자로 입력하세요.");
                return false;
            }
            if (password === "") {
                alert("비밀번호를 입력하세요.");
                return false;
            }
            return true;
        }
    </script>
</head>

<body>
<%
    // 서버 측 데이터 처리
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String[] hobbies = request.getParameterValues("hobbies");
        String password = request.getParameter("password");

        String hobbyString = (hobbies != null) ? String.join(",", hobbies) : "";

        try {
            // 데이터베이스 연결
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/userdb", "root", "password");

            // 회원 정보 저장
            String query = "INSERT INTO users (name, email, phone, gender, hobbies, password) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, name);
            pstmt.setString(2, email);
            pstmt.setString(3, phone);
            pstmt.setString(4, gender);
            pstmt.setString(5, hobbyString);
            pstmt.setString(6, password); // 실제로는 비밀번호를 암호화해야 합니다.

            pstmt.executeUpdate();
            out.println("<div class='alert alert-success'>회원가입이 완료되었습니다!</div>");
            conn.close();
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>오류 발생: " + e.getMessage() + "</div>");
        }
    }
%>

<!-- 회원가입 폼 -->
<div class="container col-xl-10 col-xxl-8 px-4 py-5">
    <div class="row align-items-center g-lg-5 py-3">
        <div class="col-lg-7 text-center text-lg-start">
            <h1 class="display-4">Register</h1>
            <p class="lead">Sign up to access exclusive features.</p>
        </div>

        <div class="col-md-10 mx-auto col-lg-5">
            <form class="p-4 p-md-5 border rounded-3 bg-light" method="POST" onsubmit="return validateForm();">
                <div class="form-floating mb-3">
                    <input type="text" class="form-control" id="floatingName" name="name" placeholder="Name" required />
                    <label for="floatingName">Name</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="email" class="form-control" id="floatingEmail" name="email" placeholder="name@example.com" required />
                    <label for="floatingEmail">Email</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="tel" class="form-control" id="floatingPhone" name="phone" placeholder="Phone" required />
                    <label for="floatingPhone">Phone</label>
                </div>
                <div class="mb-3">
                    <label>Gender:</label><br>
                    <input type="radio" id="male" name="gender" value="Male" required />
                    <label for="male">Male</label>
                    <input type="radio" id="female" name="gender" value="Female" />
                    <label for="female">Female</label>
                </div>
                <div class="mb-3">
                    <label>Hobbies:</label><br>
                    <input type="checkbox" id="cricket" name="hobbies" value="Cricket" />
                    <label for="cricket">Cricket</label>
                    <input type="checkbox" id="football" name="hobbies" value="Football" />
                    <label for="football">Football</label>
                    <input type="checkbox" id="chess" name="hobbies" value="Chess" />
                    <label for="chess">Chess</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="password" class="form-control" id="password" name="password" placeholder="Password" required />
                    <label for="password">Password</label>
                </div>
                <button class="w-100 btn btn-lg btn-primary" type="submit">Register</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
