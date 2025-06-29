<%@ Page Title="🚗 Đăng ký xe" Language="C#" AutoEventWireup="true" CodeBehind="DangKyXe.aspx.cs" Inherits="CarRequest.MucLuc.DangKyXe" MasterPageFile="~/Site.Master" %>

<asp:Content ID="Head" ContentPlaceHolderID="MainHead" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <style>
        /* --- Font hiện đại và tông màu sáng --- */
        body, input, select, button, textarea {
            /*font-family: 'Poppins', 'Segoe UI', sans-serif;*/
            font-size: 16px;
            transition: all 0.2s ease-in-out;
            height: 100%;
        }

        #MainContent, #form_wrapper {
            display: flex;
            justify-content: center;
        }

        #main_content {
            margin: 0 auto;
        }

        /* Body */
        #main {
            min-height: 100%;
            padding: 40px 10px;
            background: linear-gradient(to right, #e0f7fa, #f1f8e9);
            /*background: linear-gradient(-45deg, #e0f7fa, #66FFFF, #CCCCFF, #66FFCC, #66FF99, #CCFF99, #FFFF99, #FFFFCC, #FFFFFF, #f1f8e9);*/

            background-size: 400% 400%;
            animation: gradientBG 2s ease infinite;
        }

        @keyframes gradientBG {
            0% {
                background-position: 0% 50%;
            }
            50% {
                background-position: 100% 50%;
            }
            100% {
                background-position: 0% 50%;
            }
        }

        /* Tiêu đề chính */
        .main-title {
            text-align: center;
            color: #2e7d32;
            /*color: #FFFFFF;*/
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 30px;
            margin-top: 10px;
        }

        #fun_title {
            text-transform: uppercase;
        }

        #fun_title:hover {
            animation: shake 2s infinite;
        }

        @keyframes shake {
            0% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            50% { transform: translateX(5px); }
            75% { transform: translateX(-5px); }
            100% { transform: translateX(0); }
        }

        /* Container hiện đại */
        .form-container {
            display: grid;
            /*grid-template-columns: 1fr 1fr;*/
            grid-template-columns: repeat(4, 1fr);
            gap: 50px;
            max-width: 90%;
            margin: 0 auto;
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            padding: 50px;
        }

        /* Mỗi dòng trong form */
        .form-row {
            margin-bottom: 20px;
            display: flex;
            flex-direction: column;
        }

        /* Label cho input */
        .form-row label {
            font-weight: 600;
            margin-bottom: 8px;
            color: #2e7d32;
        }

        /* Input, select, textbox... */
        .form-control, input[type="date"], input[type="number"], input[type="text"] {
            width: 100%;
            padding: 10px 14px;
            border-radius: 8px;
            border: 1px solid #ccc;
            background-color: #f9f9f9;
            outline: none;
            font-size: 16px;
        }

        .form-control, input[type="date"], input[type="number"], input[type="text"], select {
            line-height: 1.5;
            height: auto;
        }

        .form-control:focus, input:focus, select:focus, textarea:focus {
            border-color: #4caf50;
            box-shadow: 0 0 5px rgba(76, 175, 80, 0.3);
            background-color: #ffffff;
        }

        /* Nút đăng ký */
        .btn-success {
            background-color: #4caf50;
            border: none;
            color: white;
            padding: 12px 24px;
            border-radius: 10px;
            cursor: pointer;
            font-weight: bold;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }

        .btn-success:hover {
            background-color: #388e3c;
        }

        /* Responsive Mobile */
        /*@media (max-width: 768px) {
            .form-container {
                padding: 20px;
                grid-template-columns: 1fr;
                margin: 0 auto;
            }

            .form-row {
                margin-bottom: 16px;
            }

            .main-title {
                font-size: 28px;
            }

            .form-row.full-width {
                grid-column: span 1;
            }
        }*/

        /* Nút đăng ký full hàng ngang */
        .form-row.full-width {
            grid-column: span 3;
            text-align: center;
            align-items: center;
        }

        @media (max-width: 992px) {
            .form-container {
                grid-template-columns: repeat(2, 1fr);
            }

            .form-row.full-width {
                grid-column: span 2;
                align-items: center;
            }
        }

        @media (max-width: 576px) {
            .form-container {
                grid-template-columns: 1fr;
                margin: 0 auto;
            }

            .main-title {
                font-size: 28px;
            }

            .form-row.full-width {
                grid-column: span 1;
                align-items: center;
            }
        }

        /* Hiệu ứng cho phần thông báo */
        #popup_Frame {
            width:100%;
            height:100%;
            border:none;
        }

        .border-run {
            border: 4px solid red;
            animation: borderRun 2s infinite;
            border-radius: 16px;
        }

        /* Chạy đổi màu viền */
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

        /* Tùy chỉnh layout cho phần quy trình */
        .approval-flow-row {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 8px 0;
            grid-column: span 4;
        }

        .user-dropdown {
            flex: 1;
            padding: 6px 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
            min-width: 200px;
        }

    </style>

    <%-- Script --%>
    <script>
        function updateEnableBtnDangKy() {
            const pickUp = document.getElementById("txt_PickUpFrom").value.trim();
            const destination = document.getElementById("txt_Destination").value.trim();
            const timeFrom = document.getElementById("date_TimeFrom").value;
            const timeTo = document.getElementById("date_TimeTo").value;
            const quantity = document.getElementById("num_Quantity").value;
            const btn = document.getElementById("btn_DangKy");

            let enable = true;

            if (!pickUp || !destination) {
                enable = false;
            }

            if (timeFrom && timeTo && timeFrom >= timeTo) {
                enable = false;
            }

            if (!quantity || isNaN(quantity) || parseInt(quantity) < 1) {
                enable = false;
            }

            btn.disabled = !enable;
        }

        window.addEventListener("DOMContentLoaded", function () {
            updateEnableBtnDangKy();

            document.getElementById("txt_PickUpFrom").addEventListener("input", updateEnableBtnDangKy);
            document.getElementById("txt_Destination").addEventListener("input", updateEnableBtnDangKy);
            document.getElementById("date_TimeFrom").addEventListener("input", updateEnableBtnDangKy);
            document.getElementById("date_TimeTo").addEventListener("input", updateEnableBtnDangKy);
            document.getElementById("num_Quantity").addEventListener("input", updateEnableBtnDangKy);
        });
    </script>

</asp:Content>


<asp:Content ID="Body" ContentPlaceHolderID="MainContent" runat="server">
    <div id="main">
        <h1 class="main-title animate__animated animate__fadeInDown">
            <div id="fun_title">
                🚗 Tạo đơn đăng ký xe
            </div>
        </h1>

        <div id="main_content">
            <div class="table-responsive mb-4" id="form_wrapper" style="width: 100%">
                <div class="form-container animate__animated animate__fadeInUp">
                    <%--<div class="form-row">
                        <label>Division / Bộ phận</label>
                        <asp:DropDownList ID="ddl_Division" runat="server" CssClass="form-control" OnSelectedIndexChanged="ddl_Division_SelectedIndexChanged"></asp:DropDownList>
                    </div>--%>

                    <div class="form-row">
                        <label>Purpose / Mục đích sử dụng</label>
                        <asp:DropDownList ID="ddl_Purpose" runat="server" CssClass="form-control" >
                            <asp:ListItem>Đưa đón NV ra ngoài công tác/Go on business trip</asp:ListItem>
                            <asp:ListItem>Vận chuyển hàng hóa/Transport de marchandises</asp:ListItem>
                            <asp:ListItem>Đưa đón NV đi Tlip 3/Go to Tlip3</asp:ListItem>
                            <asp:ListItem>Đưa đón NV đi dự đám tang/Go to a funeral</asp:ListItem>
                            <asp:ListItem>Đưa đón NV đi Party/ Go to Party</asp:ListItem>
                            <asp:ListItem>Mục đích khác/Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <%--<div class="form-row">
                        <label> Register Date / Ngày đăng ký </label>
                        <input type="date" id="date_RegisterDate" runat="server" class="form-control" />
                    </div>--%>

                    <div class="form-row">
                        <label> Using Date / Ngày dùng xe </label>
                        <input type="date" id="date_UsingDate" runat="server" class="form-control" />
                    </div>

                    <div class="form-row">
                        <label> Pick up from / Điểm đón </label>
                        <asp:TextBox id="txt_PickUpFrom" runat="server" CssClass="form-control" ClientIDMode="Static" ></asp:TextBox>
                    </div>

                    <div class="form-row">
                        <label>Destination / Điểm đến</label>
                        <asp:TextBox id="txt_Destination" runat="server" CssClass="form-control" ClientIDMode="Static" ></asp:TextBox>
                    </div>

                    <div class="form-row">
                        <label>Time From / (Thời gian) Từ</label>
                        <asp:TextBox id="date_TimeFrom" runat="server" CssClass="form-control" TextMode="Time" ClientIDMode="Static" ></asp:TextBox>
                    </div>

                    <div class="form-row">
                        <label>Time To / (Thời gian) Đến</label>
                        <asp:TextBox id="date_TimeTo" runat="server" CssClass="form-control" TextMode="Time" ClientIDMode="Static" ></asp:TextBox>
                    </div>

                    <div class="form-row">
                        <label>Quantity (People / Goods) / Số lượng</label>
                        <input type="number" id="num_Quantity" runat="server" ClientIDMode="Static" min="1" value="1" max="1000" step="1" class="form-control" />
                    </div>

                    <%--<div id="send_to" runat="server" class="form-row">
                        <label> Send to / Gửi đến </label>
                        <asp:DropDownList id="ddl_Send_To" runat="server" CssClass="form-control" >
                        </asp:DropDownList>
                    </div>--%>

                    <div  class="form-row full-width">
                        <label>Approval Flow / Quy trình ký duyệt:</label>
                        <asp:Repeater ID="rpt_ApprovalFlow" runat="server" OnItemDataBound="rpt_ApprovalFlow_ItemDataBound">
                            <ItemTemplate>
                                <div class="approval-flow-row">
                                    <label>
                                        <input type="checkbox" class="role-checkbox" onchange="toggleDropdown(this)" />
                                        <%# Eval("RoleName") %>
                                    </label>
                                    <asp:DropDownList ID="ddl_Users" runat="server" CssClass="user-dropdown" style="display:none;"></asp:DropDownList>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>


                    <div class="form-row full-width">
                        <asp:Button id="btn_DangKy" runat="server" Text="Đăng ký xe" ClientIDMode="Static" CssClass="btn btn-success" OnClientClick="showLoading();" OnClick="btn_DangKy_Click" />
                    </div>

                </div>
            </div>
        </div>
    </div>

    <%-- Thông báo --%>
    <div id="successPopup" class="animate__animated" style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh; background-color:rgba(0,0,0,0.4); z-index:9999;">
        <div id="popupContent" class="animate__animated border-run" style="width: 400px; height: 220px; margin: 10% auto; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 8px rgba(0,0,0,0.2);">
            <iframe id="popup_Frame" ></iframe>
        </div>
    </div>

    <%-- Script --%>
    <script>
        function toggleDropdown(checkbox) {
            const dropdown = checkbox.closest('.approval-flow-row').querySelector('.user-dropdown');
            dropdown.style.display = checkbox.checked ? 'block' : 'none';
        }
    </script>

</asp:Content>