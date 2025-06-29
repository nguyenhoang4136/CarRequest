<%@ Page Title="👤 Quản lý tài khoản" Language="C#" AutoEventWireup="true" CodeBehind="QuanLyTaiKhoan.aspx.cs" Inherits="CarRequest.MucLuc.QuanLyTaiKhoan" MasterPageFile="~/Site.Master" %>

<asp:Content ID="Head" ContentPlaceHolderID="MainHead" runat="server">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
        }

        /* Body */
        #main {
            min-height: 100%;
            background: linear-gradient(to right, #e0f7fa, #f1f8e9);
            padding: 40px 10px;
        }

        #btn_location {
            align-items: center;
            justify-content: center;
        }

        .page-wrapper {
            background: linear-gradient(to right, #667eea, #764ba2);
            max-width: 1500px;
            margin: 0 auto;
            padding: 40px 10px;
            background: linear-gradient(145deg, #ffffff, #f0f4ff);
            border-radius: 15px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease-in-out;
        }

        .page-title {
            font-size: 28px;
            font-weight: 700;
            color: #4f46e5;
            text-align: center;
            margin-bottom: 30px;
        }
        /* Căn chỉnh table */
        .filter-row {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }

        .filter-row label {
            font-weight: 500;
            margin-bottom: 0;
            color: #374151;
        }

        .filter-dropdown {
            width: 150px;
            border-radius: 8px;
            padding: 5px;
            font-size: 14px;
            text-align: center;
            text-align-last: center;
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none; 
        }

        .table {
            font-size: 15px;
            text-align: center;
        }

        .table th {
            background-color: #6366f1;
            color: white;
            text-align: center;
        }

        .table tr:hover {
            background-color: #f3f4f6;
            transition: background-color 0.3s ease;
        }

        /* Responsive */
        @media (max-width: 576px) {
            .filter-row {
                flex-direction: column;
                align-items: stretch;
                align-items: center;
                justify-content: center;
            }

            .filter-dropdown {
                width: 100%;
            }
        }

        /* Căn chỉnh dropdownlist */
        .center-dropdown {
            display: block;
            margin: 0 auto;
            text-align: center;
            width: 50%;
            height: 30px;
            padding: 4px;
            font-size: 14px;
        }

        /* Căn chỉnh gridview */
        #div_gridview table {
            width: 90%;
            min-width: 800px;
            table-layout: auto;
            white-space: nowrap;
            margin: 0 auto;
        }

        /* -- Hiệu ứng cho các nút --*/
        .modern-btn {
            padding: 10px 18px;
            font-size: 15px;
            border-radius: 8px;
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin: 5px;
            display: none;
        }

        .modern-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(0,0,0,0.2);
            opacity: 0.9;
        }

        .btn-warning {
            background-color: #fbbf24;
            color: #1f2937;
        }

        .btn-primary {
            background-color: #3b82f6;
            color: #fff;
        }

        .btn-danger {
            background-color: #ef4444;
            color: #fff;
        }

        /*------------------
        Thiết kế phần iframe */
        /* Khung popup chính */
        #popup_iframe {
            display: none;
            position: fixed;
            top: 5%;
            left: 20%;
            width: 60%;
            height: 90%;
            z-index: 9999;
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            padding: 5px;
        }

        /* Viền động chạy màu */
        #popup_iframe::before {
            content: "";
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            z-index: -1;
            background: linear-gradient(60deg, #e63946, #f1c40f, #2ecc71, #3498db, #9b59b6, #e63946);
            background-size: 300% 300%;
            animation: gradientBorder 6s linear infinite;
            border-radius: 22px;
        }

        /* Animation chạy màu quanh viền */
        @keyframes gradientBorder {
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

        /* Iframe bên trong */
        #iframe_detail {
            width: 100%;
            height: 100%;
            border: none;
            border-radius: 16px;
        }

        /* Hiệu ứng hiện */
        .fade-in {
            animation: fadeIn 0.3s ease forwards;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: scale(0.95);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

    </style>
</asp:Content>

<asp:Content ID="Body" ContentPlaceHolderID="MainContent" runat="server">
    <div id="main">
        <div class="page-wrapper">
            <h2 class="page-title"> QUẢN LÝ TÀI KHOẢN </h2>

            <div class="filter-row">
                <label for="ddl_Filter"> Trạng thái tài khoản </label>

                <asp:DropDownList ID="ddl_Filter" runat="server" AutoPostBack="true"
                    CssClass="form-control filter-dropdown"
                    OnSelectedIndexChanged="ddl_Filter_SelectedIndexChanged">
                    <asp:ListItem Text="Chưa kích hoạt" Value="0" />
                    <asp:ListItem Text="Đã kích hoạt" Value="1" />
                </asp:DropDownList>
            </div>

            <div id="actionButtons" runat="server" style="text-align: center; margin: 10px auto;">
                <asp:Button id="btn_Enable_or_Disable" runat="server" ClientIDMode="Static" CssClass="btn modern-btn btn-warning" Enabled="true" OnClick="btn_Enable_or_Disable_Click" />
                &nbsp;
                <asp:Button id="btn_Change_UserRole" runat="server" ClientIDMode="Static" Text="Thay đổi quyền" CssClass="btn modern-btn btn-primary" Enabled="true" OnClick="btn_Change_UserRole_Click" />
                &nbsp;
                <asp:Button id="btn_Delete" runat="server" ClientIDMode="Static" Text="Xóa" CssClass="btn modern-btn btn-danger" Enabled="true" OnClick="btn_Delete_Click"/>
            </div>

            <div class="table-responsive mb-4" id="div_gridview">
                <asp:GridView ID="gv_Show_Accounts" runat="server" AutoGenerateColumns="false" CssClass="table table-bordered table-hover shadow-sm bg-white" DataKeyNames="emp_code" OnRowDataBound="gv_Show_Accounts_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="emp_code" HeaderText="Mã nhân viên" />
                        <asp:BoundField DataField="emp_name" HeaderText="Tên nhân viên" />
                        <asp:BoundField DataField="email" HeaderText="Email" />
                        <%--<asp:BoundField DataField="div_name" HeaderText="Tên bộ phận" />--%>

                        <asp:TemplateField HeaderText="Phân quyền">
                            <ItemTemplate>
                                <asp:DropDownList id="ddl_UserRole" runat="server" CssClass="form-control center-dropdown" Visible="false" />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Chi tiết">
                            <ItemTemplate>
                                <asp:Button ID="btn_ShowDetail" runat="server" Text="[+]" CssClass="btn-detail" 
                                    OnClientClick='<%# Eval("user_role_level").ToString() == "2" || Eval("user_role_level").ToString() == "3" ? "showRoleDetail(\"" + Eval("emp_code") + "\", " + Eval("user_role_level") + "); return false;" : "return false;" %>' 
                                    Visible='<%# Eval("user_role_level").ToString() == "2" || Eval("user_role_level").ToString() == "3" %>' />
                            </ItemTemplate>
                        </asp:TemplateField>

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
    </div>

    <!-- Overlay nền mờ ngăn tương tác -->
    <div id="iframe_overlay" style="display:none; margin: 0 auto; position:fixed; top:0; left:0; width:100vw; height:100vh; background-color:rgba(0,0,0,0.4); z-index:9998;">
    </div>

    <!-- Popup iframe hiển thị nổi -->
    <div id="popup_iframe" class="border-run">
        <iframe id="iframe_detail"></iframe>
    </div>

    <%-- Script --%>
    <script type="text/javascript">
        /*-- Xử lý sự kiện tick --*/
        function toggleSelectAll(source) {
            var grid = document.getElementById('<%= gv_Show_Accounts.ClientID %>');
            var checkboxes = grid.querySelectorAll("input[id*='chk_Select']");

            checkboxes.forEach(function (cb) {
                cb.checked = source.checked;
            });

            toggleButtonsAndDropdowns();
        }

        function toggleButtonsAndDropdowns() {
            var grid = document.getElementById('<%= gv_Show_Accounts.ClientID %>');
            var checkboxes = grid.querySelectorAll("input[id*='chk_Select']");

            // Nếu không có dòng dữ liệu => ẩn hết nút
            if (checkboxes.length === 0) {
                document.getElementById('<%= btn_Delete.ClientID %>').style.display = "none";
                document.getElementById('<%= btn_Enable_or_Disable.ClientID %>').style.display = "none";
                document.getElementById('<%= btn_Change_UserRole.ClientID %>').style.display = "none";
                return;
            }

            // Có dữ liệu => Hiện nút nhưng kiểm tra enable/disable
            let anyChecked = false;

            checkboxes.forEach(function (cb) {
                var row = cb.closest("tr");
                var ddl = row.querySelector("select[id*='ddl_UserRole']");
                var btn_add_right = row.querySelector("input[id*='btn_ShowDetail']")

                if (ddl) {
                    ddl.disabled = !cb.checked;
                }

                if (btn_add_right) {
                    btn_add_right.disabled = !cb.checked;
                }
                
                if (cb.checked) {
                    anyChecked = true;
                }
            });

            const btns = [
                document.getElementById('<%= btn_Delete.ClientID %>'),
                document.getElementById('<%= btn_Enable_or_Disable.ClientID %>'),
                document.getElementById('<%= btn_Change_UserRole.ClientID %>')
            ];

            btns.forEach(function (btn) {
                btn.style.display = "inline-block";
                btn.disabled = !anyChecked;
            });
        }


        function onCheckBoxChanged(chk) {
            toggleButtonsAndDropdowns();
        }

        window.onload = function () {
            setTimeout(toggleButtonsAndDropdowns, 200);
        };

        /*-- Xử lý sự kiện hiện phân quyền chi tiết --*/
        function showRoleDetail(empCode, roleLevel) {
            var url = "ChiTietPhanQuyen.aspx?emp_code=" + empCode + "&role_level=" + roleLevel;
            var iframe = document.getElementById("iframe_detail");

            iframe.src = url;

            var overlay = document.getElementById("iframe_overlay");
            var popup = document.getElementById("popup_iframe");

            overlay.style.display = "block";
            popup.style.display = "block";

            // Reset animation cũ nếu có
            popup.classList.remove("fade-out");
            overlay.classList.remove("fade-out");

            // Thêm hiệu ứng vào khi hiện
            popup.classList.add("fade-in");
            overlay.classList.add("fade-in");
        }

        function closeIframePopup() {
            document.getElementById("iframe_overlay").style.display = "none";
            document.getElementById("popup_iframe").style.display = "none";
        }
    </script>
</asp:Content>
