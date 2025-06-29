using CarRequest.Function_Code;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarRequest
{
    public partial class DangNhap : System.Web.UI.Page
    {
        string con_str = ConDB.connection_string;
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
                Response.Redirect("~/MucLuc/TrangChu.aspx");
            }

            if (!IsPostBack)
            {
                txt_EmpCode.Focus();
            }
            load_background_login();
        }

        protected List<string> login_background_list = new List<string>();
        protected string random_login_background;
        protected void load_background_login()
        {
            string folderPath = Server.MapPath("~/Picture_Resources/DangNhap/");
            string[] imageFiles = Directory.GetFiles(folderPath)
                .Where(type => (type.EndsWith(".gif", StringComparison.OrdinalIgnoreCase)
                         || type.EndsWith(".jpg", StringComparison.OrdinalIgnoreCase)
                         || type.EndsWith(".png", StringComparison.OrdinalIgnoreCase)))
                .ToArray();

            if (imageFiles.Length > 0)
            {
                foreach (var file in imageFiles)
                {
                    string filename = Path.GetFileName(file);
                    login_background_list.Add(ResolveUrl("~/Picture_Resources/DangNhap/" + filename));
                }

                Random rand = new Random();
                int index = rand.Next(imageFiles.Length);
                string selectedFile = Path.GetFileName(imageFiles[index]);
                random_login_background = ResolveUrl("~/Picture_Resources/DangNhap/" + selectedFile);
            }
        }

        protected void btn_Login_Click(object sender, EventArgs e)
        {
            string empcode = txt_EmpCode.Text.Trim();
            string password = txt_Password.Text.Trim();
            string sql_check_pass = "select emp_code from CAR_REQUEST_USER where emp_code = @emp_code and emp_pass = @emp_pass";
            SqlParameter[] pr_check_pass = new SqlParameter[]
            {
                new SqlParameter("@emp_code", empcode),
                new SqlParameter("@emp_pass", password)
            };
            if (ConDB.dt_ThucThiCauLenh(sql_check_pass, pr_check_pass, con_str).Rows.Count > 0)
            {
                string sql_check_active_status = "select emp_code from CAR_REQUEST_USER where emp_code = @emp_code and emp_pass = @emp_pass and is_activated = 1";
                SqlParameter[] pr_check_active_status = new SqlParameter[]
                {
                    new SqlParameter("@emp_code", empcode),
                    new SqlParameter("@emp_pass", password)
                };
                DataTable dt = ConDB.dt_ThucThiCauLenh(sql_check_active_status, pr_check_active_status, con_str);
                if (dt.Rows.Count > 0)
                {
                    Session["User"] = dt.Rows[0]["emp_code"].ToString();
                    Response.Redirect("~/MucLuc/TrangChu.aspx");
                }
                else
                {
                    lbl_Message.Text = ("Tài khoản chưa được phê duyệt <br /> Vui lòng liên hệ quản trị viên để được hỗ trợ").ToUpper();
                }
            }
            else
            {
                lbl_Message.Text = ("Sai mã nhân viên hoặc mật khẩu").ToUpper();
            }
        }

        protected void lnk_Register_Click(object sender, EventArgs e)
        {
            Response.Redirect("DangKy.aspx");
        }

    }
}