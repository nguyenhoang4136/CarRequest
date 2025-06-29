<%@ Page Title="✅ Phê duyệt đơn" Language="C#" AutoEventWireup="true" CodeBehind="PheDuyetDon.aspx.cs" Inherits="CarRequest.MucLuc.PheDuyetDon" MasterPageFile="~/Site.Master" %>

<asp:Content ID="Head" ContentPlaceHolderID="MainHead" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
    <style>
        body, input, select, button, textarea {
            font-family: 'Times New Roman', Times, serif;
            font-size: 16px;
            transition: all 0.2s ease-in-out;
        }

        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        #MainContent {
            display: flex;
            justify-content: center;
        }

        #main_content {
            margin: 0 auto;
        }

        #main {
            min-height: 100%;
            background: linear-gradient(to right, #fff3e0, #f1f8e9);
            padding: 40px 10px;
        }

        .main-title {
            text-align: center;
            color: #2e7d32;
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 30px;
            margin-top: 10px;
        }

        @media (max-width: 576px) {
            .main-title {
                font-size: 28px;
            }
        }

        .report-label {
            display: block;
            background-color: #f5f7fa;
            color: #2c3e50;
            border: 1px solid #d6dde5;
            padding: 12px 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            font-weight: 500;
            font-size: 16px;
            animation: fadeInUp 0.5s ease;
            text-align: center;
        }

        #gv {
            font-family: 'Segoe UI', sans-serif;
            font-size: 15px;
            border-collapse: collapse;
            margin-top: 20px;
        }
        /* Thiết kế gridview */
        .modern-gridview {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            font-family: 'Segoe UI', sans-serif;
            font-size: 15px;
            background-color: #f9f9fc;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 18px rgba(0, 0, 0, 0.08);
            animation: fadeIn 0.5s ease-in-out;
        }

        .modern-gridview th {
            background: linear-gradient(to right, #4a90e2, #007aff);
            color: white;
            padding: 14px 18px;
            text-align: center;
            font-weight: 600;
            border-bottom: 1px solid #e0e0e0;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .modern-gridview td {
            padding: 14px 18px;
            color: #2f2f2f;
            border-bottom: 1px solid #ececec;
            background-color: #ffffff;
            text-align: center;
            transition: background 0.3s ease;
        }

        .modern-gridview tr:hover td {
            background: #f0f7ff;
        }

        .modern-gridview .selected-row td {
            background-color: #e0f7fa;
            font-weight: bold;
            color: #00695c;
        }

        .modern-gridview td:last-child,
        .modern-gridview th:last-child {
            border-right: none;
        }

        @media screen and (max-width: 768px) {
            .modern-gridview, .modern-gridview thead, .modern-gridview tbody, .modern-gridview th, .modern-gridview td, .modern-gridview tr {
                display: block;
            }

            .modern-gridview th {
                display: none;
            }

            .modern-gridview td {
                text-align: left;
                padding-left: 50%;
                position: relative;
                border: none;
                border-bottom: 1px solid #eee;
            }

            .modern-gridview td::before {
                content: attr(data-label);
                position: absolute;
                left: 18px;
                top: 14px;
                font-weight: bold;
                color: #555;
                white-space: nowrap;
            }
        }

        .modern-gridview .pager {
            text-align: center;
            padding: 12px;
            font-weight: bold;
            color: #4a90e2;
            background-color: #f1f1f1;
            border-top: 1px solid #ddd;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Hiệu ứng cho div bao quanh gridview */
        .table-responsive {
            animation: fadeInUp 0.6s ease;
            overflow-x: auto;
            margin: 0 auto;
        }

        /* Hiệu ứng cho các nút */
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

        /* Căn chỉnh gridview */
        #div_gridview table {
            width: 90%;
            min-width: 800px;
            table-layout: auto;
            white-space: nowrap;
            margin: 0 auto;
        }
    </style>
</asp:Content>

<asp:Content ID="Body" ContentPlaceHolderID="MainContent" runat="server">
    <div id="main">
        <br />
        <h1 class="main-title animate__animated animate__fadeInDown"> Danh sách các đơn chờ phê duyệt </h1>
        <br />
        <div id="main_content">
            <asp:Label id="lbl_Report" runat="server" CssClass="report-label" Text=""></asp:Label>
            <br />

            <div id="actionButtons" runat="server" style="text-align: center; margin: 10px auto;">
                <asp:Button id="btn_Approve" runat="server" Text="✅ Duyệt đơn" CssClass="btn btn-success modern-btn" OnClick="btn_Approve_Click" />
                &nbsp;
                <asp:Button id="btn_Reject" runat="server" Text="❌ Từ chối đơn" CssClass="btn btn-danger modern-btn" OnClick="btn_Reject_Click" />
            </div>

            <div class="table-responsive mb-4" id="div_gridview">
                <asp:GridView id="gv_Show_Pending" runat="server" CssClass="modern-gridview" AutoGenerateColumns="False" GridLines="Both" DataKeyNames="id">
                    <Columns>
                        <asp:TemplateField HeaderText="Chọn">
                            <HeaderTemplate>
                                Chọn tất cả &nbsp;
                                <asp:CheckBox ID="chk_SelectAll" runat="server" AutoPostBack="false" onclick="toggleSelectAll(this)" />
                            </HeaderTemplate>

                            <ItemTemplate>
                                <asp:CheckBox ID="chk_Select" runat="server" AutoPostBack="false" onclick="onCheckBoxChanged(this)" />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Gửi lên cấp trên">
                            <ItemTemplate>
                                <asp:DropDownList id="ddl_Send_To" runat="server" CssClass="form-control center-dropdown" Visible="false" />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="cur_status" HeaderText="Trạng thái đơn" />
                        <asp:BoundField DataField="id" HeaderText="Mã đơn" />
                        <asp:BoundField DataField="requester_name" HeaderText="Người yêu cầu" />
                        <asp:BoundField DataField="div_name" HeaderText="Bộ phận" />
                        <asp:BoundField DataField="register_date" HeaderText="Ngày đăng ký" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:BoundField DataField="pick_up_from" HeaderText="Điểm đón" />
                        <asp:BoundField DataField="destination" HeaderText="Điểm đến" />
                        <asp:BoundField DataField="purpose" HeaderText="Mục đích" />
                        <asp:BoundField DataField="quantity" HeaderText="Số lượng" />
                        <asp:BoundField DataField="using_date" HeaderText="Ngày sử dụng" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:BoundField DataField="from_time" HeaderText="Thời gian khởi hành dự kiến" />
                        <asp:BoundField DataField="to_time" HeaderText="Thời gian đến dự kiến" />
                    </Columns>
                </asp:GridView>

            </div>
        </div>
    </div>

    <%-- Script --%>
    <script type="text/javascript">
        function toggleSelectAll(source) {
            var grid = document.getElementById('<%= gv_Show_Pending.ClientID %>');
            var checkboxes = grid.querySelectorAll("input[id*='chk_Select']");

            checkboxes.forEach(function (cb) {
                cb.checked = source.checked;
            });

            toggleButtonsAndDropdowns();
        }

        function toggleButtonsAndDropdowns() {
            var grid = document.getElementById('<%= gv_Show_Pending.ClientID %>');
            var checkboxes = grid.querySelectorAll("input[id*='chk_Select']");

            var btn_Approve = document.getElementById('<%= btn_Approve.ClientID %>');
            var btn_Reject = document.getElementById('<%= btn_Reject.ClientID %>');

            if (checkboxes.length === 0) {
                btn_Approve.style.display = "none";
                btn_Reject.style.display = "none";
                return;
            }

            btn_Approve.style.display = "inline-block";
            btn_Reject.style.display = "inline-block";

            let anyChecked = false;
            checkboxes.forEach(function (cb) {
                if (cb.checked) {
                    anyChecked = true;
                }
            });

            btn_Approve.disabled = !anyChecked;
            btn_Reject.disabled = !anyChecked;
        }

        function onCheckBoxChanged(chk) {
            toggleButtonsAndDropdowns();
        }

        window.onload = function () {
            setTimeout(toggleButtonsAndDropdowns, 200);
        };
    </script>
</asp:Content>
