using CarRequest.Function_Code;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Reflection.Emit;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Hosting;

namespace CarRequest
{
    public partial class DangKy : System.Web.UI.Page
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
            else
            {
                if (!IsPostBack)
                {
                    // Lấy dữ liệu vào dropdownlist
                    /*string sql = "select div_name from CAR_REQUEST_DIVISION where div_code <> 0";
                    ConDB.load_data_into_dropdownlist(sql, ddl_Division, null, 0, true);*/
                    txt_EmpCode.Focus();
                }
            }
        }

        protected void btn_Register_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txt_EmpCode.Text))
            {
                lbl_Report.Text = "Chưa nhập mã nhân viên";
                return;
            }
            else if (string.IsNullOrWhiteSpace(txt_Password.Text))
            {
                lbl_Report.Text = "Chưa nhập mật khẩu";
                return;
            }
            else if (string.IsNullOrWhiteSpace(txt_ConfirmPassword.Text))
            {
                lbl_Report.Text = "Chưa nhập xác nhận mật khẩu";
                return;
            }
            else if (string.IsNullOrWhiteSpace(txt_EmpName.Text))
            {
                lbl_Report.Text = "Chưa nhập họ và tên";
                return;
            }
            else if (string.IsNullOrWhiteSpace(txt_Email.Text))
            {
                lbl_Report.Text = "Chưa nhập email";
                return;
            }
            else if (txt_Password.Text != txt_ConfirmPassword.Text)
            {
                lbl_Report.Text = "Mật khẩu không trùng khớp!";
                return;
            }
            try
            {
                btn_Register.Enabled = false;
                // Check tài khoản đã tồn tại chưa
                string sql_get_emp_code = "select count(emp_code) from CAR_REQUEST_USER where emp_code = @emp_code";

                SqlParameter[] pr_get_emp_code = new SqlParameter[]
                {
                    new SqlParameter("@emp_code", txt_EmpCode.Text)
                };

                if (ConDB.dt_ThucThiCauLenh(sql_get_emp_code, pr_get_emp_code, con_str).Rows[0][0].ToString() != "0")
                {
                    lbl_Report.Text = "Mã nhân viên này đã tồn tại";
                    return;
                }

                // Thêm dữ liệu
                /*string sql_get_DivCode = "select div_code from CAR_REQUEST_DIVISION where div_name = @div_name";
                int div_code = 0;

                SqlParameter[] pr_get_DivCode = new SqlParameter[]
                {
                    new SqlParameter("@div_name", ddl_Division.Text)
                };
                DataTable dt = ConDB.dt_ThucThiCauLenh(sql_get_DivCode, pr_get_DivCode, con_str);
                if (dt.Rows.Count > 0)
                {
                    div_code = Convert.ToInt32(dt.Rows[0][0]);
                }*/

                string base64_Avatar = Convert_Image_To_Base64("~/Picture_Resources/Avatar/avatar_default.jpg");
                string sql_register = "insert into CAR_REQUEST_USER (emp_code, emp_pass, emp_name, email, last_time_update_password, is_activated, avatar_base64) " +
                    "values (@emp_code, @emp_pass, @emp_name, @email, getdate(), 0, @avatar_base64)";

                SqlParameter[] pr_register = new SqlParameter[]
                {
                    new SqlParameter("@emp_code", txt_EmpCode.Text),
                    new SqlParameter("@emp_pass", txt_Password.Text),
                    new SqlParameter("@emp_name", SqlDbType.NVarChar) { Value = txt_EmpName.Text },
                    new SqlParameter("@email", txt_Email.Text),
                    new SqlParameter("@avatar_base64", base64_Avatar)
                };

                ConDB.dt_ThucThiCauLenh(sql_register, pr_register, con_str);

                // Gửi mail
                string subject = "Car Request - Đăng ký tài khoản";
                string mailFrom = "CR_Register_Account@asahi-intecc.com";
                string mailTo = "hanoi-is6@asahi-intecc.com";
                string cc = "";
                /*string cc = "hanoi-is@asahi-intecc.com";*/
                string body = "Thời gian đăng ký: " + DateTime.Now.ToString("HH:mm:ss") + " ngày " + DateTime.Now.ToString("dd/MM/yyyy") + "<br/>"
                            + "Mã nhân viên: " + txt_EmpCode.Text + "<br/>"
                            + "Tên nhân viên: " + txt_EmpName.Text + "<br/>"
                            + "Email: " + txt_Email.Text + "<br />"
                            + "Link web: http://172.16.33.123/CarRequest/";
                //Send_Mail.Send_Mail_Outlook(subject, mailFrom, mailTo, cc, body);
                lbl_Report.Text = string.Empty;
            }
            finally
            {
                Response.Redirect("DangNhap.aspx");
            }
        }

        public static string Convert_Image_To_Base64(string duong_dan_tuong_doi)
        {
            try
            {
                string duong_dan_chinh_xac = HostingEnvironment.MapPath(duong_dan_tuong_doi);

                if (string.IsNullOrEmpty(duong_dan_chinh_xac) || !File.Exists(duong_dan_chinh_xac))
                {
                    return "";
                }

                byte[] imageBytes = File.ReadAllBytes(duong_dan_chinh_xac);
                return Convert.ToBase64String(imageBytes);
            }
            catch
            {
                return "N/A";
            }
        }

        protected void btn_Go_Login_Click(object sender, EventArgs e)
        {
            Response.Redirect("DangNhap.aspx");
        }
    }
}