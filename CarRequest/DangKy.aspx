<%@ Page Title="📝 Đăng ký" Language="C#" AutoEventWireup="true" CodeBehind="DangKy.aspx.cs" Inherits="CarRequest.DangKy" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title> Đăng ký tài khoản </title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
    <script type="text/javascript">
        function focusNextOnEnter(e) {
            if (e.key === "Enter" || e.keyCode === 13) {
                e.preventDefault();

                // Danh sách các ô input theo thứ tự
                var fields = [
                    document.getElementById('<%= txt_EmpCode.ClientID %>'),
                    document.getElementById('<%= txt_Password.ClientID %>'),
                    document.getElementById('<%= txt_ConfirmPassword.ClientID %>'),
                    document.getElementById('<%= txt_EmpName.ClientID %>'),
                    document.getElementById('<%= txt_Email.ClientID %>')
                ];

                var current = document.activeElement;

                for (var i = 0; i < fields.length; i++) {
                    if (fields[i] === current && i + 1 < fields.length) {
                        fields[i + 1].focus();
                        break;
                    }
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

        /* Reset cơ bản */
        html, body {
            /*height: 100%;*/
            height: 100vh;
            margin: 0;
            /*font-family: 'Times New Roman', sans-serif;*/
            font-family: 'Doris', serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* Box form */
        .register-box {
            max-height: 80vh;
            overflow-y: auto;
            width: 100%;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.37);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.25);
            padding: 40px 30px;
            box-sizing: border-box;
            /*color: #fff;*/
            color: #fefefe;
        }

        /* Tiêu đề */
        /*.register-box h2 {*/
        h2 {
            font-weight: 600;
            font-size: 28px;
            margin-bottom: 30px;
            text-align: center;
            letter-spacing: 1.5px;
            color: #ffffff;
            text-shadow: 0 0 5px rgba(0, 0, 0, 0.6);
        }

        /* Bảng bố cục */
        table {
            width: 100%;
            border-collapse: collapse;
        }

        td.col1 {
            padding: 10px 0;
            font-weight: 600;
            font-size: 14px;
            vertical-align: middle;
            /*color: #e0e0e0;*/
            width: 40%;
            user-select: none;
            color: #ffffff;
            text-shadow: 0 0 5px rgba(0, 0, 0, 0.6);
        }

        td.col2 {
            padding: 10px 0;
            width: 60%;
        }

        /* Input style */
        input[type="text"],
        input[type="password"] {
            width: 100%;
            height: 50px;
            padding: 12px 15px;
            border: none;
            border-radius: 20px;
            font-size: 16px;
            font-weight: 400;
            color: #333;
            box-sizing: border-box;
            transition: box-shadow 0.3s ease, border 0.3s ease;
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            outline: none;
            box-shadow: 0 0 10px #8e44ad;
            border: 1px solid #8e44ad;
        }

        .input-style {
            width: 100%;
            height: 50px;
            padding: 12px 15px;
            border: none;
            border-radius: 20px;
            font-size: 16px;
            font-weight: 400;
            color: #333;
            box-sizing: border-box;
            transition: box-shadow 0.3s ease, border 0.3s ease;
        }

        .input-style:focus {
            outline: none;
            box-shadow: 0 0 10px #8e44ad;
            border: 1px solid #8e44ad;
        }

        /* Thông báo lỗi */
        #<%= lbl_Report.ClientID %>, 
        .report {
            color: #ff6b6b;
            font-size: 14px;
            margin: 10px 0 20px 0;
            text-align: center;
            min-height: 18px;
        }

        /* Nút bấm */
        .btn {
            width: 30%;
            padding: 12px 0;
            font-size: 16px;
            font-weight: 600;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            color: #fff;
        }

        .btn-register {
            background-color: #8e44ad;
            margin-right: 4%;
        }

        .btn-register:hover {
            background-color: #732d91;
        }

        .btn-cancel {
            background-color: #c0392b;
        }

        .btn-cancel:hover {
            background-color: #922b21;
        }

        /* Căn nút */
        .btn-group {
            display: flex;
            justify-content: center;
            margin-top: 10px;
        }
        /* Hiệu ứng quay tròn waiting */
        .spinner {
            border: 5px solid rgba(255, 255, 255, 0.3);
            border-top: 5px solid #fff;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            animation: spin 0.8s linear infinite;
            margin: auto;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>

    <script type="text/javascript">
        function waitting_for_register() {
            var report = document.getElementById('<%= lbl_Report.ClientID %>');
            var spinner = document.getElementById('loading-spinner');
            if (report) report.textContent = "";
            if (spinner) spinner.style.display = "block";
            return true;
        }

        setTimeout(function () {
            if (window.top !== window.self) {
                window.parent.document.getElementById('register-box').style.display = 'none';
                window.parent.document.getElementById('overlay').style.display = 'none';
                document.body.classList.remove('blur-active');
            }
        }, 500);
    </script>
</head>
<body>
    <form id="form_DangKy" runat="server" autocomplete="off" onsubmit="return waitting_for_register();">
        <h2> ĐĂNG KÝ TÀI KHOẢN </h2>

        <div class="register-box">
            <table>
                <tr>
                    <td class="col1"> Mã nhân viên <br /> Employee Code </td>
                    <td class="col2">
                        <asp:TextBox id="txt_EmpCode" runat="server" placeholder="Nhập mã nhân viên" onkeydown="return focusNextOnEnter(event);" />
                    </td>
                </tr>

                <tr>
                    <td class="col1"> Mật khẩu <br /> Password </td>
                    <td class="col2">
                        <asp:TextBox id="txt_Password" runat="server" TextMode="Password" placeholder="Nhập mật khẩu" onkeydown="return focusNextOnEnter(event);" />
                    </td>
                </tr>

                <tr>
                    <td class="col1"> Nhập lại mật khẩu <br /> Confirm Password </td>
                    <td class="col2">
                        <asp:TextBox id="txt_ConfirmPassword" runat="server" TextMode="Password" placeholder="Xác nhận mật khẩu" onkeydown="return focusNextOnEnter(event);" />
                    </td>
                </tr>

                <tr>
                    <td class="col1">Tên nhân viên<br />Full Name</td>
                    <td class="col2">
                        <asp:TextBox id="txt_EmpName" runat="server" placeholder="Nhập họ và tên" onkeydown="return focusNextOnEnter(event);" />
                    </td>
                </tr>

                <%--<tr>
                    <td class="col1"> Bộ phận <br /> Division </td>
                    <td class="col2">
                        <asp:DropDownList id="ddl_Division" runat="server" CssClass="input-style">

                        </asp:DropDownList>
                    </td>
                </tr>--%>

                <tr>
                    <td class="col1">Email</td>
                    <td class="col2">
                        <asp:TextBox id="txt_Email" runat="server" CssClass="input-style" TextMode="Email" placeholder="example@email.com" onkeydown="return focusNextOnEnter(event);" />
                    </td>
                </tr>

                <%--<tr>
                    <td class="col1">Vai trò<br />User Role</td>
                    <td class="col2">
                        <asp:DropDownList id="ddl_UserRole" runat="server" CssClass="input-style">
                            <asp:ListItem Text="-- Chọn vai trò --" Value="" />
                            <asp:ListItem Text="Người dùng" Value="1" />
                            <asp:ListItem Text="Quản trị viên" Value="2" />
                        </asp:DropDownList>
                    </td>
                </tr>--%>

                <tr>
                    <td colspan="2" style="text-align: center; ">
                        <asp:Label id="lbl_Report" runat="server" CssClass="report" />
                    </td>
                </tr>

            </table>

            <div id="loading-spinner" style="display: none; text-align: center; margin-top: 10px;">
                <div class="spinner"></div>
                <p style="color: white;"> đang xử lý yêu cầu, vui lòng đợi... </p>
            </div>
        </div>
        <br />
        <div class="btn-group">
            <asp:Button id="btn_Register" runat="server" AutoPostBack="true" CssClass="btn btn-register" Text="Đăng ký" OnClientClick="return waitting_for_register();"  OnClick="btn_Register_Click" />
            <asp:Button id="btn_Go_Login" runat="server" AutoPostBack="true" CssClass="btn btn-cancel" Text="Về đăng nhập" OnClick="btn_Go_Login_Click" />
            <%--<button type="button" class="btn btn-cancel" onclick="closeIframe();"> ✖ Quay lại </button>--%>
        </div>
    </form>
</body>
</html>
