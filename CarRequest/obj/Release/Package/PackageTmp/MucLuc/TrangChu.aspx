<%@ Page Title="🏠 Trang chủ" Language="C#" AutoEventWireup="true" CodeBehind="TrangChu.aspx.cs" Inherits="CarRequest.MucLuc.TrangChu" MasterPageFile="~/Site.Master"%>

<asp:Content ID="Head" ContentPlaceHolderID="MainHead" runat="server">
    <style>
        #div_main{
            /*display: inline-block;*/
            /*width: 100%;*/
            min-height: 100vh;
            height: auto;
            margin: 0 auto;
            /*background-image: url('<%= ResolveUrl("~/Picture_Resources/BackGround/BackGround_1.jpg") %>');*/
            background-image: url('<%= random_homepage_background %>');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }

        .list-group-item {
            border-left: 0px hidden #007bff;
            border-top: 0px hidden #007bff;
            border-bottom: 0px hidden #007bff;
            border-right: 0px hidden #007bff;
            font-size: 16px;
        }

        .container-fluid {
            padding-left: 0 !important;
            padding-right: 0 !important;
            margin-left: 0 !important;
            margin-right: 0 !important;
            overflow-x: hidden;
        }

    </style>
</asp:Content>

<asp:Content ID="Body" ContentPlaceHolderID="MainContent" runat="server">
    <div id="div_main">
        <script type="text/javascript">
            const backgroundImages = [
            <% for (int i = 0; i < homepage_background_list.Count; i++) { %>
                "<%= homepage_background_list[i] %>"<%= (i < homepage_background_list.Count - 1 ? "," : "") %>
            <% } %>
            ];

            function changeBackground() {
                const div = document.getElementById("div_main");
                let currentBg = div.style.backgroundImage;
                let newImage;
                do {
                    const randomIndex = Math.floor(Math.random() * backgroundImages.length);
                    newImage = backgroundImages[randomIndex];
                } while (currentBg.includes(newImage) && backgroundImages.length > 1);
                div.style.backgroundImage = `url('${newImage}')`;
            }

            window.onload = function () {
                const div = document.getElementById("div_main");
                div.addEventListener("click", changeBackground);
            };
        </script>
        <div class="container-fluid">
            <div class="row">
                <!-- Trái -->
                <%--<div class="col-sm-4" style="text-align: center; color: brown; ">
                    <h2 style="background-color: white; border-radius: 25px; display: inline-block; padding-left: 10px; padding-right: 10px; "> Học vấn </h2>
                    <ul class="list-group" style="border-radius: 25px; ">
                        <li class="list-group-item">
                            <asp:Image ID="logo_hpu2" runat="server" Width="200px" Height="120px" ImageUrl="~/Picture_Resources/logo_hpu2.jpg" AlternateText="Lỗi hiển thị ảnh"/>
                        </li>
                        <li class="list-group-item" style="color: brown; ">
                            <strong> Đại học sư phạm hà nội 2 </strong>
                        </li>
                        <li class="list-group-item" style="color: brown; ">
                            <strong> Công nghệ thông tin </strong>
                        </li>
                        <li class="list-group-item" style="color: brown; ">
                            <strong> Khóa: 46 (2020 - 2024) </strong>
                        </li>
                        <li class="list-group-item" style="color: brown; ">
                            <asp:Image ID="icon2" width="7%" runat="server" ImageUrl="~/Picture_Resources/big_smile.png" AlternateText="Lỗi hiển thị ảnh"/>
                        </li>
                    </ul>
                    <br />
                    <br />
                    <br />
                </div>

                <!-- Giữa -->
                <div class="col-sm-4" style="text-align: center; color: green; ">
                    <h2 style="background-color: white; border-radius: 25px; display: inline-block; padding-left: 10px; padding-right: 10px; ">Thông tin cá nhân</h2>
                    <ul class="list-group" style="color: green; border-radius: 25px; ">
                        <li class="list-group-item">
                            <asp:Image ID="img_Avatar" ImageUrl="~/Picture_Resources/hamster.jpg" runat="server" Width="200px" Height="120px" AlternateText="Ảnh đại diện bị lỗi"/>
                        </li>
                        <li class="list-group-item" style="color: green; ">
                            <strong> 🆔 Họ & tên: Nguyễn Huy Hoàng </strong>
                        </li>
                        <li class="list-group-item" style="color: green; ">
                            <strong> 📍 Địa chỉ: Phúc Yên - Vĩnh Phúc </strong>
                        </li>
                        <li class="list-group-item" style="color: green; ">
                            <strong> 💻 Công việc chính: Thợ code </strong>
                            <asp:Image ID="icon1" ImageUrl="~/Picture_Resources/shame.png" width="7%" runat="server" AlternateText="Ảnh bị lỗi"/>
                        </li>
                        <li class="list-group-item" style="color: green; ">
                            <strong> 📞 Điện thoại: 0973858209 </strong>
                        </li>
                    </ul>
                    <br />
                    <br />
                    <br />
                </div>

                <!-- Phải -->
                <div class="col-sm-4" style="text-align: center; color: chocolate; ">
                    <h2 style="background-color: white; border-radius: 25px; display: inline-block; padding-left: 10px; padding-right: 10px; "> Kinh nghiệm làm việc </h2>
                    <ul class="list-group" style="color: chocolate; border-radius: 25px;">
                        <li class="list-group-item">
                            <asp:Image ID="img_Arcadyan" ImageUrl="~/Picture_Resources/img_arcadyan.jpg" runat="server" Width="200px" Height="120px" AlternateText="Lỗi hiển thị ảnh"/>
                        </li>
                        <li class="list-group-item" style="color: chocolate; ">
                            <strong> Thời gian: 12/2023 - 02/2025 </strong>
                        </li>
                        <li class="list-group-item" style="color: chocolate; ">
                            <strong> Công ty TNHH Arcadyan Technology Việt Nam </strong>
                        </li>
                        <li class="list-group-item" style="color: chocolate; ">
                            <strong> Bộ phận: SFIS </strong>
                        </li>
                        <li class="list-group-item" style="color: chocolate; ">
                            <asp:Image ID="icon3" ImageUrl="~/Picture_Resources/byebye.png" width="7%" runat="server" AlternateText="Ảnh 3 bị lỗi"/>
                        </li>
                    </ul>
                    <br />
                    <br />
                    <br />
                </div>--%>

            </div>
        </div>
    </div>

    <div id="footer">
        <div class="container-fluid">
            <div class="row">
                <div class="col-sm-6" style="text-align: center; color: #AA0000; ">
                    <br />
                    <strong> 
                        Made by Hoàng <br />
                        Manage by IS-Team <br />
                        &copy; Copyright - <%:DateTime.Now.Year%> <br />
                        All Rights Reserved
                    </strong>
                    <br /> &nbsp
                </div>

                <div class="col-sm-6" style="text-align: center; color: #FFFF00; ">
                    <br />
                    <strong> 
                        “Restart” – thần dược của dân IT. <br />
                        Không chạy? ⟶ Khởi động lại. <br />
                        Lỗi lạ? ⟶ Khởi động lại. <br />
                        Không biết vì sao lỗi? ⟶ Khởi động lại trước rồi tính tiếp! 🚀 
                    </strong>
                    <br /> &nbsp
                </div>
            </div>
        </div>
    </div>
</asp:Content>

