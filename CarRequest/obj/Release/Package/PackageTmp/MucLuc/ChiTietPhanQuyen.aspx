<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChiTietPhanQuyen.aspx.cs" Inherits="CarRequest.MucLuc.ChiTietPhanQuyen" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Phân quyền chi tiết</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            animation: gradientBG 15s ease infinite;
            background: linear-gradient(-45deg, #ffecd2, #fcb69f, #a1c4fd, #c2e9fb);
            background-size: 400% 400%;
            padding: 20px;
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

        .container {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            /*max-width: 800px;*/
            margin: 0 auto;
        }

        /* Hiệu ứng các row của gridview */
        .row {
            min-width: 140px;
            margin-bottom: 5px;
        }

        .row {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        label {
            font-weight: bold;
            display: inline-block;
            width: 140px;
        }

        select, input[type="button"], input[type="submit"] {
            padding: 6px 10px;
            font-size: 14px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        /* Hiệu ứng ddl */
        select {
            padding: 8px 14px;
            font-size: 15px;
            border-radius: 6px;
            border: 1px solid #ced4da;
            background-color: #ffffff;
            box-shadow: inset 0 1px 2px rgba(0,0,0,0.1);
            transition: border 0.3s ease;
            min-width: 180px;
        }

        select:focus {
            border-color: #007bff;
            outline: none;
        }

        /* Hiệu ứng các nút */
        .btn {
            padding: 10px 18px;
            font-size: 15px;
            border-radius: 8px;
            margin: 5px 8px 10px 0;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            cursor: pointer;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(0,0,0,0.2);
            opacity: 0.9;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
            border: none;
        }

        .btn-success {
            background-color: #28a745;
            color: white;
            border: none;
        }

        .message {
            margin-top: 10px;
            color: green;
        }

        /* Gridview*/
        .gridview-wrapper {
            margin-top: 30px;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .table-responsive {
            animation: fadeInUp 0.6s ease;
            overflow-x: auto;
            margin: 0 auto;
        }

        /*Thiết kế phần diền thông tin*/
        table {
            width: 100%;
            border-collapse: collapse;
        }

        table th, table td {
            padding: 8px;
            border: 1px solid #dee2e6;
            text-align: center;
        }

        table th {
            background-color: #007bff;
            color: white;
        }

        /*-- Hiệu ứng nút đóng --*/
        .close-button-container {
            position: relative;
        }

        /* Nút đóng */
        .btn-close {
            position: absolute;
            top: -12px;
            right: -12px;
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 50%;
            width: 36px;
            height: 36px;
            font-size: 18px;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            transition: background-color 0.3s ease, transform 0.2s ease;
            cursor: pointer;
            z-index: 10;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeOutZoom {
            from {
                opacity: 1;
                transform: scale(1);
            }
            to {
                opacity: 0;
                transform: scale(0.7);
            }
}

        .btn-close:hover {
            background-color: #c82333;
            transform: scale(1.1);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="close-button-container">
                <input type="button" value="×" title="Đóng" class="btn-close" onclick="closeWithEffect();" />
            </div>

            <h1>
                <asp:Label ID="lbl_Header" runat="server" />
            </h1>

            <div class="row">
                <label>Mã nhân viên:</label>
                <asp:Label ID="lblEmpCode" runat="server" />
            </div>

            <%--<div class="row">
                <label>Tên nhân viên:</label>
                <asp:Label ID="lbl_EmpName" runat="server" />
            </div>--%>

            <div class="row">
                <label>Vai trò:</label>
                <asp:Label ID="lblRoleLevel" runat="server" />
            </div>

            <div class="row">
                <label>Bộ phận:</label>
                <asp:DropDownList ID="ddl_DivCode" runat="server" />
            </div>

            <div class="row">
                <label> Mức độ:</label>
                <asp:DropDownList ID="ddl_ConfirmTier" runat="server" Visible="false">
                    <asp:ListItem Text="Mức 1" Value="1" />
                    <asp:ListItem Text="Mức 2" Value="2" />
                </asp:DropDownList>

                <asp:DropDownList ID="ddl_ApproveTier" runat="server" Visible="false">
                    <asp:ListItem Text="Mức 1" Value="1" />
                    <asp:ListItem Text="Mức 2" Value="2" />
                </asp:DropDownList>
            </div>

            <asp:Button ID="btn_Add_Right" runat="server" Text="➕ Thêm quyền" CssClass="btn btn-success animate__animated animate__fadeInLeft" OnClick="btn_Add_Right_Click" />

            <asp:Button ID="btn_Delete_Right" runat="server" Text="🗑️ Xóa quyền" CssClass="btn btn-danger animate__animated animate__fadeInRight" OnClick="btn_Delete_Right_Click" />


            <div class="message animate__animated" id="msgBox" runat="server">
                <asp:Label ID="lblMessage" runat="server" />
            </div>

            <div class="gridview-wrapper table-responsive mb-4">
                <asp:GridView ID="gv_User_Rights" runat="server" AutoGenerateColumns="false" CssClass="table" DataKeyNames="div_name">
                    <Columns>
                        <asp:BoundField DataField="div_name" HeaderText="Bộ phận" />
                        <asp:BoundField DataField="confirm_tier" HeaderText="Confirm" />
                        <asp:BoundField DataField="approve_tier" HeaderText="Approve" />

                        <asp:TemplateField HeaderText="Chọn">
                            <HeaderTemplate>
                                Chọn tất cả &nbsp;
                                <asp:CheckBox ID="chk_SelectAll" runat="server" AutoPostBack="false" onclick="toggleSelectAll(this)" />
                            </HeaderTemplate>

                            <ItemTemplate>
                                <asp:CheckBox ID="chk_Select" runat="server" AutoPostBack="false" onclick="onCheckBoxChanged(this)" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>

        <%-- Script --%>
    <script type="text/javascript">
        function toggleSelectAll(source) {
            var grid = document.getElementById('<%= gv_User_Rights.ClientID %>');
            var checkboxes = grid.querySelectorAll("input[id*='chk_Select']");

            checkboxes.forEach(function (cb) {
                cb.checked = source.checked;
            });

            toggleButtonsAndDropdowns();
        }

        function onCheckBoxChanged(chk) {
            toggleButtonsAndDropdowns();
        }

        window.onload = function () {
            setTimeout(toggleButtonsAndDropdowns, 200);
        };
        // Hiệu ứng đóng
        function closeWithEffect() {
            const container = document.querySelector('.container');
            container.style.animation = 'fadeOutZoom 0.5s ease forwards';
            setTimeout(() => {
                if (window.parent && typeof window.parent.closeIframePopup === 'function') {
                    window.parent.closeIframePopup();
                }
            }, 450); // trễ một chút để hiệu ứng kịp chạy
        }
    </script>

</body>
</html>
