<%@ Page Title="🕒 Lịch sử đăng ký" Language="C#" AutoEventWireup="true" CodeBehind="LichSuDangKy.aspx.cs" Inherits="CarRequest.MucLuc.LichSuDangKy" MasterPageFile="~/Site.Master" %>

<asp:Content ID="Head" ContentPlaceHolderID="MainHead" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <style>
        /* --- Font tổng thể phần body --- */
        body, input, select, button, textarea {
            font-family: 'Times New Roman', Times, serif
            /*font-family: 'Poppins', 'Segoe UI', sans-serif;*/
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
            background: linear-gradient(to right, #e0f7fa, #f1f8e9);
            padding: 40px 10px;
        }

        /* --- Header H1 --- */
        /* Tiêu đề chính */
        .main-title {
            text-align: center;
            color: #CC6600;
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

        /* --- Phần report --- */
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

        /* --- Thiết kế gridview --- */
        #gv {
            font-family: 'Segoe UI', sans-serif;
            font-size: 15px;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .modern-gridview {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            font-family: 'Segoe UI', sans-serif;
            font-size: 15px;
            background-color: #ffffff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        /* Header */
        .modern-gridview th {
            /*background-color: #4CAF50;*/
            background: linear-gradient(to right, #4CAF50, #81C784);
            color: white;
            padding: 14px 18px;
            text-align: center;
            font-weight: 600;
            border-bottom: 2px solid #e0e0e0;
        }

        /* Row */
        .modern-gridview td {
            padding: 12px 18px;
            color: #333;
            border-bottom: 1px solid #f0f0f0;
            border-right: 1px solid #e0e0e0;
        }

        .modern-gridview td:last-child {
            border-right: none;
        }

        /* Hover */
        .modern-gridview tr:hover td {
            background-color: #e8f5e9;
            transition: background-color 0.25s ease;
        }

        /* Selected row */
        .modern-gridview .selected-row td {
            background-color: #c8e6c9;
            font-weight: bold;
            color: #2e7d32;
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

        /* Pager styling if used */
        .modern-gridview .pager {
            text-align: center;
            padding: 10px;
            font-weight: bold;
            color: #4CAF50;
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
            <div class="table-responsive mb-4" id="div_gridview" style="width: 100%">
                <asp:GridView id="gv" runat="server" CssClass="modern-gridview" AutoGenerateColumns="True" GridLines="Both">
                </asp:GridView>
            </div>

        </div>
    </div>
</asp:Content>