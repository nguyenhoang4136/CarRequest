<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ThongBao.aspx.cs" Inherits="CarRequest.MucLuc.ThongBao" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Thông báo</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"
    />
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            text-align: center;
            background: #f9f9f9;
        }

        .msg {
            font-size: 20px;
            color: #4CAF50;
            margin-top: 10px;
            max-width: 400px;
            text-align: center;
            animation: pulse 2.5s infinite;
        }

        .checkmark {
            color: #4CAF50;
            font-size: 28px;
            font-weight: bold;
            margin-top: 5px;
            user-select: none;
            animation: pulse 2.5s infinite;
            text-align: center;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .btn-close {
            margin-top: 10px;
            padding: 12px 28px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            font-size: 16px;
            position: relative;
            overflow: hidden;
        }

        /* Ripple effect */
        .btn-close:focus:not(:active)::after,
        .btn-close:active::after {
            content: "";
            position: absolute;
            border-radius: 50%;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            pointer-events: none;
            animation: ripple 0.6s ease-out;
            background: rgba(255, 255, 255, 0.5);
        }

        @keyframes ripple {
            from {
                transform: scale(0);
                opacity: 0.7;
            }
            to {
                transform: scale(2.5);
                opacity: 0;
            }
        }
    </style>
</head>
<body class="animate__animated animate__fadeIn">
    <div class="msg">
        <%= Server.UrlDecode(Request.QueryString["msg"] ?? "").Replace("\n", "<br />") %>
    </div>

    <div class="checkmark">
        ✔
    </div>

    <button class="btn-close" onclick="closePopup()">
        Đóng
    </button>

    <script>
        function closePopup() {
            const popup = window.parent.document.getElementById('successPopup');
            // Dùng animate.css scaleOut + fadeOut cùng lúc
            popup.classList.remove("animate__fadeInDownBig");
            popup.classList.add("animate__fadeOut", "animate__zoomOut");

            setTimeout(() => {
                popup.style.display = 'none';
                popup.classList.remove("animate__fadeOut", "animate__zoomOut");
            }, 800);
        }
    </script>

</body>
</html>
