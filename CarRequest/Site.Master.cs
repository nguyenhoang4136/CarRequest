using CarRequest.Function_Code;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Reflection.Emit;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarRequest
{
    public partial class SiteMaster : MasterPage
    {
        static string con_str = ConDB.connection_string;
        protected void Page_Load(object sender, EventArgs e)
        {
            // Ngăn cache trang hiện tại
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();
            Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1));
            Response.Cache.SetRevalidation(HttpCacheRevalidation.AllCaches);
            Response.Cache.SetNoServerCaching();
            Response.AppendHeader("Pragma", "no-cache");
            Response.AppendHeader("Expires", "-1");

            if (Session["User"] != null)
            {
                lbl_ShowUserName.Text = "Xin chào: " + ConDB.get_emp_name(Session["User"].ToString());
                string user_role_level = ConDB.get_user_role_level(Session["User"].ToString());

                // Set quyền dùng chức năng cho các tài khoản
                if (user_role_level != "0")
                {
                    li_QuanLyTaiKhoan.Visible = false;
                    li_QuanLy.Visible = false;
                }

                if (user_role_level == "1")
                {
                    li_PheDuyetDon.Visible = false;
                }

                string avatar_string = ConDB.get_User_Avatar(Session["User"].ToString());
                img_Avatar.ImageUrl = avatar_string;
            }
            else
            {
                lbl_ShowUserName.Text = "Khách lạ ghé thăm";
            }
        }

        protected void link_Logout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();
            Response.Redirect("~/");
        }
    }
}