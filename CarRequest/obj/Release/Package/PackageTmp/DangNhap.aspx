<%@ Page Title="🔒 Đăng nhập" Language="C#" AutoEventWireup="true" CodeBehind="DangNhap.aspx.cs" Inherits="CarRequest.DangNhap" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@600&display=swap" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Lobster&display=swap" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Chewy&display=swap" rel="stylesheet" />
        <link href="~/Picture_Resources/Icon/CarRequest.ico" rel="icon" type="image/x-icon" />

        <script type="text/javascript">
            function focusPassword(e) {
                if (e.key === "Enter" || e.keyCode === 13) {
                    e.preventDefault();
                    var pwdBox = document.getElementById('<%= txt_Password.ClientID %>');
                    if (pwdBox) {
                        pwdBox.focus();
                    }
                    return false;
                }
                return true;
            }

            window.addEventListener('pageshow', function (event) {
                if (event.persisted) {
                    window.location.href = "~/MucLuc/TrangChu.aspx"; // window.location.reload();
                }
            });
        </script>

        <style>
            @font-face {
                font-family: 'Doris';
                src: url('/fonts/Doris-Regular.woff2') format('woff2'),
                     url('/fonts/Doris-Regular.woff') format('woff');
                font-weight: normal;
                font-style: normal;
            }

            body {
                font-size: large; 
                font-family: 'Times New Roman';
                /*background-color: #CCFFFF;*/
                /*background-image: url('<%= ResolveUrl("~/Picture_Resources/Gif/BackGround_1.gif") %>');*/
                background-image: url('<%= random_login_background %>');
                background-size: cover;
                background-position: center;
                background-repeat: no-repeat;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                animation: fadeIn 1s ease-out;
            }

            /* Hiệu ứng khi trang tải */
            @keyframes fadeIn {
                0% { opacity: 0; }
                100% { opacity: 1; }
            }

            /* Hiệu ứng cho box đăng nhập */
            .login-box {
                width: 400px;
                padding: 40px;
                text-align: center;
                /*background: linear-gradient(145deg, #ffffff, #f0f9ff);*/
                background-color: rgba(255, 255, 255, 0.5);
                border-radius: 15px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
                opacity: 0;
                animation: slideUp 1s forwards;
                backdrop-filter: blur(20px);
                -webkit-backdrop-filter: blur(20px);
                border: 1px solid rgba(255, 255, 255, 0.3);
                transition: transform 0.3s ease;
            }

            .login-box:hover {
                transform: translateY(-3px); /* hiệu ứng nổi khi hover */
            }

            @keyframes slideUp {
                0% { transform: translateY(30px); opacity: 0; }
                100% { transform: translateY(0); opacity: 1; }
            }

            /* Các ô nhập liệu */
            .col1, .col2 {
                padding: 10px;
                text-align: left;
                font-family: 'Indie Flower', cursive;
                color: #CC0000;
                font-weight: bold;
            }

            .col2 input {
                width: 100%;
                padding: 10px;
                border: 2px solid #ccc;
                border-radius: 15px;
                transition: all 0.3s;
                font-family: 'Indie Flower', cursive;
                color: #9b59b6;
            }

            /* Khi người dùng focus vào ô nhập liệu */
            .col2 input:focus {
                border-color: #3498db;
                outline: none;
                box-shadow: 0 0 5px rgba(52, 152, 219, 0.5);
            }

            /* Nút đăng nhập */
            #btn_Login {
                padding: 10px 20px;
                background-color: #3498db;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: all 0.3s ease;
                font-family: 'Chewy', cursive;
                font-size: 18px;
            }

            #btn_Login:hover {
                background-color: #2980b9;
            }

            /* Hiệu ứng cho thông báo lỗi */
            #lbl_Message {
                /*display: none;*/
                color: #3333FF;
                font-size: 14px;
                margin-top: 10px;
                animation: fadeInMessage 0.5s ease-out forwards;
            }

            @keyframes fadeInMessage {
                0% { opacity: 0; }
                100% { opacity: 1; }
            }

            #t_DangNhap {
                margin: 0 auto;
            }

            /* Hiệu ứng xuất hiện cho tiêu đề */
            .heading-effect {
                font-family: 'Lobster', cursive;
                color: #e67e22;
                font-size: 40px;
                opacity: 0;
                transform: translateY(-20px);
                animation: headingFadeIn 1s ease-out forwards;
                animation-delay: 0.3s;
                background-color: #e0f7fa;
                display: inline-block;
                border-radius: 25px;
                padding: 5px 20px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }

            /* Keyframe cho tiêu đề */
            @keyframes headingFadeIn {
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Hiệu ứng cho phần đăng ký */
            .register-link {
                color: #003366;
                font-weight: bold;
                text-decoration: none;
                transition: color 0.3s ease, transform 0.3s ease;
            }

            .register-link:hover {
                text-decoration: underline;
            }

            #register-frame {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                border: 3px solid transparent;
                border-radius: 15px;
                z-index: 1;
                animation: borderRun 3s linear infinite;
                box-shadow: 0 0 10px rgba(0, 255, 255, 0.5);
            }

            @keyframes borderRun {
                0% {
                    border-color: red;
                    box-shadow: 0 0 10px red;
                }
                25% {
                    border-color: orange;
                    box-shadow: 0 0 15px orange;
                }
                50% {
                    border-color: yellow;
                    box-shadow: 0 0 15px yellow;
                }
                75% {
                    border-color: limegreen;
                    box-shadow: 0 0 15px limegreen;
                }
                100% {
                    border-color: red;
                    box-shadow: 0 0 10px red;
                }
            }

            #overlay {
                transition: opacity 0.3s ease;
                opacity: 0;
                pointer-events: all;
            }
            
            #overlay.show {
                display: block;
                opacity: 1;
            }
        </style>
    </head>

    <body>
        <form id="login_form" runat="server" autocomplete="on">
            <div style="text-align: center;">
                <h2 class="heading-effect"> ĐĂNG NHẬP </h2>
            </div>

            <div class="login-box">
                <table id="t_DangNhap">
                    <!-- Hàng 1: Tên đăng nhập -->
                    <tr>
                        <td class="col1"> Mã nhân viên <br /> Employee Code</td>
                        <td class="col2">
                            <asp:TextBox id="txt_EmpCode" runat="server" placeholder="Nhập mã nhân viên" onkeydown="return focusPassword(event);" />
                        </td>
                    </tr>

                    <!-- Hàng 2: Mật khẩu -->
                    <tr>
                        <td class="col1">Mật khẩu <br /> PassWord</td>
                        <td class="col2">
                            <asp:TextBox id="txt_Password" runat="server" textmode="Password" placeholder="Nhập mật khẩu" />
                        </td>
                    </tr>

                    <!-- Hàng 3: Đăng ký tài khoản -->
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <span style="font-size: 14px; color: #2c3e50;">
                                Bạn chưa có tài khoản? &nbsp;
                                <a href="DangKy.aspx" class="register-link"> Đăng ký ngay </a>
                            </span>
                        </td>
                    </tr>

                    <!-- Hàng 4: Thông báo -->
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <asp:Label id="lbl_Message" runat="server" />
                        </td>
                    </tr>

                    <!-- Hàng 5: Nút đăng nhập -->
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <asp:Button id="btn_Login" runat="server" text="Đăng nhập" OnClick="btn_Login_Click" />
                        </td>
                    </tr>

                </table>
            </div>
        </form>

        <!-- Hộp chứa iframe đăng ký -->
        <%--<div id="register-box"
             class="ui-dialog ui-corner-all ui-widget ui-widget-content ui-front pop ui-draggable"
             role="dialog"
             aria-labelledby="ui-id-register"
             style="width: 600px; height: 800px; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%);
                    z-index: 1001; display: none; box-shadow: 0 8px 24px rgba(0,0,0,0.2); border-radius: 15px; background-color: rgba(255,255,255,0.9);
                    backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); border: 1px solid rgba(255,255,255,0.3);">
            <!-- Nội dung: iframe -->
            <div class="ui-dialog-content ui-widget-content"
                 style="position: relative; width: 100%; height: 100%; text-align: center; ">
                <iframe id="register-frame" src="DangKy.aspx?<%= DateTime.Now.Ticks %>" frameborder="0" >
                </iframe>
            </div>
        </div>

        <div id="overlay"
             style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
                    background-color: rgba(0, 0, 0, 0.3); z-index: 1000;">
        </div>--%>

        <%--Java Script--%>
        <script type="text/javascript">
            const loginBackgrounds = [
                <% for (int i = 0; i < login_background_list.Count; i++) { %>
                    "<%= login_background_list[i] %>"<%= (i < login_background_list.Count - 1 ? "," : "") %>
                <% } %>
            ];

            function changeLoginBackground(event) {
                const registerBox = document.getElementById("register-box");
                const overlay = document.getElementById("overlay");

                // Nếu đang mở hộp đăng ký → không đổi nền
                if (registerBox && registerBox.style.display === "block") {
                    return;
                }

                // Nếu click trong login-box hoặc heading-effect thì bỏ qua
                if (event.target.closest('.login-box') || event.target.closest('.heading-effect')) {
                    return;
                }

                const body = document.body;
                let currentBg = body.style.backgroundImage;
                let newImage;
                do {
                    const randomIndex = Math.floor(Math.random() * loginBackgrounds.length);
                    newImage = loginBackgrounds[randomIndex];
                } while (currentBg.includes(newImage) && loginBackgrounds.length > 1);
                body.style.backgroundImage = `url('${newImage}')`;
            }

            window.onload = function () {
                document.body.addEventListener("click", changeLoginBackground);
            };

            // Click mở đăng ký
            /*function openRegisterDialog() {
                const registerBox = document.getElementById("register-box");
                const overlay = document.getElementById("overlay");
                if (registerBox) registerBox.style.display = "block";
                if (overlay) overlay.style.display = "block";
            }

            document.addEventListener("DOMContentLoaded", function () {
                const registerLink = document.querySelector(".register-link");

                if (registerLink) {
                    registerLink.addEventListener("click", function (e) {
                        e.preventDefault();
                        openRegisterDialog();
                    });
                }
            });*/
        </script>

    </body>
</html>
