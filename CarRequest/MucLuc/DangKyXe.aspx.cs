using Microsoft.Ajax.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CarRequest.Function_Code;
using Org.BouncyCastle.Math.Field;

namespace CarRequest.MucLuc
{
    public partial class DangKyXe : System.Web.UI.Page
    {
        string user_role = string.Empty;
        string emp_code = string.Empty;
        string con_str = ConDB.connection_string;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("DangNhap.aspx");
            }
            else
            {
                emp_code = Session["User"].ToString();
                user_role = ConDB.get_user_role_level(Session["User"].ToString());
                if (!IsPostBack)
                {
                    if (user_role == "6")
                    {
                        /*send_to.Visible = false;*/
                    }
                    else
                    {
                        /*string sql = @"select user_role_name from CAR_REQUEST_USER_ROLE 
                        where user_role_level in (select user_role_next_level from CAR_REQUEST_ROUTE where user_role_level = @user_role_level)";
                        SqlParameter[] pr = new SqlParameter[]
                        {
                        new SqlParameter("@user_role_level", user_role_level)
                        };
                        ConDB.load_data_into_dropdownlist(sql, ddl_Send_To, pr, 0, false);*/

                        // Lấy ngày mặc định
                        /*date_RegisterDate.Value = DateTime.Now.ToString("yyyy-MM-dd");*/
                        date_UsingDate.Value = DateTime.Now.ToString("yyyy-MM-dd");
                        date_TimeFrom.Text = DateTime.Now.ToString("HH:mm");
                        date_TimeTo.Text = DateTime.Now.ToString("HH:mm");
                    }

                    LoadApprovalFlow(Convert.ToByte(user_role));
                }
            }
        }

        [Serializable]
        private class ApprovalStep
        {
            public byte RoleLevel { get; set; }
            public string RoleName { get; set; }
            public List<UserInfo> Users { get; set; }
        }

        [Serializable]
        private class UserInfo
        {
            public string EmpCode { get; set; }
            public string EmpName { get; set; }
        }

        private void LoadApprovalFlow(byte currentLevel)
        {

            // 1. Lấy danh sách role
            var dtRoles = ConDB.dt_ThucThiCauLenh("select user_role_level, user_role_name from CAR_REQUEST_USER_ROLE where user_role_level > @level", new[]
            {
                new SqlParameter("@level", currentLevel)
            }, con_str);

            // 2. Lấy danh sách user theo role
            var dtUsers = ConDB.dt_ThucThiCauLenh("select emp_code, emp_name, user_role_level from CAR_REQUEST_USER", null, con_str);

            // 3. Tạo danh sách ApprovalStep
            List<ApprovalStep> steps = new List<ApprovalStep>();

            foreach (DataRow row in dtRoles.Rows)
            {
                byte level = Convert.ToByte(row["user_role_level"]);
                string name = row["user_role_name"].ToString();

                var users = dtUsers.AsEnumerable()
                    .Where(u => Convert.ToByte(u["user_role_level"]) == level)
                    .Select(u => new UserInfo
                    {
                        EmpCode = u["emp_code"].ToString(),
                        EmpName = u["emp_name"].ToString()
                    }).ToList();

                steps.Add(new ApprovalStep
                {
                    RoleLevel = level,
                    RoleName = name,
                    Users = users
                });
                ViewState["ApprovalSteps"] = steps;
            }

            rpt_ApprovalFlow.DataSource = steps;
            rpt_ApprovalFlow.DataBind();
        }

        protected void rpt_ApprovalFlow_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var data = (ApprovalStep)e.Item.DataItem;
                var ddl = (DropDownList)e.Item.FindControl("ddl_Users");

                ddl.DataSource = data.Users;
                ddl.DataTextField = "EmpName";
                ddl.DataValueField = "EmpCode";
                ddl.DataBind();
                ddl.Items.Insert(0, new ListItem("-- Chọn người duyệt --", ""));
            }
        }

        /*protected void add_data_to_ddl_Send_To()
        {
            string sql = @"select user_role_name, user_role_level
                            from CAR_REQUEST_USER_ROLE 
                            where user_role_level in 
                                (select user_role_next_level 
                                from CAR_REQUEST_ROUTE 
                                where user_role_level = @user_role_level)";

            SqlParameter[] pr = new SqlParameter[]
            {
                new SqlParameter("@user_role_level", user_role)
            };

            DataTable dt = ConDB.dt_ThucThiCauLenh(sql, pr, con_str);

            if (dt.Rows.Count > 0)
            {
                ddl_Send_To.DataSource = dt;
                ddl_Send_To.DataTextField = "user_role_name";
                ddl_Send_To.DataValueField = "user_role_level";
                ddl_Send_To.DataBind();

                *//*ddl_Send_To.Items.Insert(0, new ListItem("-- Chọn cấp duyệt --", ""));*//*
            }
            else
            {
                *//*ddl_Send_To.Items.Clear();
                ddl_Send_To.Items.Insert(0, new ListItem("-- Không có cấp duyệt tiếp theo --", ""));*//*
            }
        }*/


        protected void btn_DangKy_Click(object sender, EventArgs e)
        {
            // Tạo ID
            string get_date = DateTime.Now.ToString("ddMMyy");
            string fixed_code = "CR_" + get_date + "_";
            string sql_get_max_id_today = "select top 1 id from CAR_REQUEST_WIPTRACKING where id like @id order by id desc";
            string new_id = fixed_code + "0001";
            SqlParameter[] pr_get_max_id_today = new SqlParameter[]
            {
                new SqlParameter("@id", fixed_code + "%")
            };
            DataTable dt = ConDB.dt_ThucThiCauLenh(sql_get_max_id_today, pr_get_max_id_today, con_str);
            if (dt.Rows.Count > 0)
            {
                string max_id_today = dt.Rows[0][0].ToString();
                int serial = int.Parse(max_id_today.Substring(max_id_today.Length - 4));
                new_id = fixed_code + (serial + 1).ToString("D4");
            }

            // Lấy user_role_level_next
            string user_role_level_next = string.Empty;
            if (user_role == "7")
            {
                user_role_level_next = "7";
            }
            else
            {
                /*string sql_get_next_level = "select user_role_level from CAR_REQUEST_USER_ROLE where user_role_name = @user_role_name";
                SqlParameter[] pr_get_next_level = new SqlParameter[]
                {
                    new SqlParameter("@user_role_name", SqlDbType.NVarChar) { Value = ddl_Send_To.SelectedValue }
                };
                DataTable dt_get_next_level = ConDB.dt_ThucThiCauLenh(sql_get_next_level, pr_get_next_level, con_str);
                if (dt_get_next_level.Rows.Count > 0)
                {
                    user_role_level_next = dt_get_next_level.Rows[0][0].ToString();
                }*/

                // Lấy bước tiếp theo từ chk_ApprovalFlow (đã được chọn)
                List<int> selectedSteps = new List<int>();
                foreach (RepeaterItem item in rpt_ApprovalFlow.Items)
                {
                    CheckBox chk = (CheckBox)item.FindControl("role-checkbox");
                    DropDownList ddl = (DropDownList)item.FindControl("ddl_Users");

                    if (chk != null && chk.Checked && ddl != null && !string.IsNullOrEmpty(ddl.SelectedValue))
                    {
                        int roleLevel = Convert.ToInt32(ddl.SelectedValue);
                        selectedSteps.Add(roleLevel);
                    }
                }

                if (selectedSteps.Any())
                {
                    user_role_level_next = selectedSteps.Min().ToString();
                }
            }

            // Lấy user_role_level, requester_name, div_code
            string sql_get_user_role_level = "select user_role_level, emp_name from CAR_REQUEST_USER where emp_code = @emp_code";
            SqlParameter[] pr_get_user_role_level = new SqlParameter[]
            {
                new SqlParameter("@emp_code", Session["User"].ToString())
            };

            dt = ConDB.dt_ThucThiCauLenh(sql_get_user_role_level, pr_get_user_role_level, con_str);
            string user_role_level = string.Empty;
            string emp_name = string.Empty;
            string div_code = string.Empty;
            if ( dt.Rows.Count > 0 )
            {
                user_role_level = dt.Rows[0]["user_role_level"].ToString();
                emp_name = dt.Rows[0]["emp_name"].ToString();
                div_code = dt.Rows[0]["div_code"].ToString();
            }

            // Lấy curent_status
            string cur_status = "Pending";
            if (user_role_level == "7")
            {
                cur_status = "Approved";
            }

            // Lấy div_name
            string sql_get_div_name = "select div_name from CAR_REQUEST_DIVISION where div_code = @div_code";
            SqlParameter[] pr_get_div_name = new SqlParameter[]
            {
                new SqlParameter("@div_code", div_code)
            };
            dt = ConDB.dt_ThucThiCauLenh(sql_get_div_name, pr_get_div_name, con_str);
            string div_name = string.Empty;
            if (dt.Rows.Count > 0 )
            {
                div_name = dt.Rows[0]["div_name"].ToString();
            }

            // Lấy ngày đăng ký
            string sql = "select cast(getdate() as date)";
            dt = ConDB.dt_ThucThiCauLenh(sql, null, con_str);
            DateTime register_date = Convert.ToDateTime(dt.Rows[0][0]);

            // Tạo dữ liệu WipTracking
            string sql_insert_WipTracking = @"insert into CAR_REQUEST_WIPTRACKING 
                                    (id, user_role_level, user_role_level_next, cur_status, emp_code, requester_name, div_name, register_date, pick_up_from, destination, purpose, quantity, using_date, from_time, to_time)
                                    values
                                    (@id, @user_role_level, @user_role_level_next,  @cur_status, @emp_code, @requester_name, @div_name, @register_date, @pick_up_from, @destination, @purpose, @quantity, @using_date, @from_time, @to_time)";

            SqlParameter[] pr_insert_WipTracking = new SqlParameter[]
            {
                new SqlParameter("@id", new_id),
                new SqlParameter("@user_role_level", user_role_level),
                new SqlParameter("@user_role_level_next", user_role_level_next),
                new SqlParameter("@cur_status", cur_status),
                new SqlParameter("@emp_code", emp_code),
                new SqlParameter("@requester_name", emp_name),
                new SqlParameter("@div_name", div_name),
                new SqlParameter("@register_date", register_date),
                new SqlParameter("@pick_up_from", txt_PickUpFrom.Text),
                new SqlParameter("@destination", txt_Destination.Text),
                new SqlParameter("@purpose", ddl_Purpose.SelectedValue),
                new SqlParameter("@quantity", int.Parse(num_Quantity.Value)),
                new SqlParameter("@using_date", date_UsingDate.Value),
                new SqlParameter("@from_time", date_TimeFrom.Text),
                new SqlParameter("@to_time", date_TimeTo.Text)
            };
            ConDB.dt_ThucThiCauLenh(sql_insert_WipTracking, pr_insert_WipTracking, con_str);

            // Ghi lại lịch sử WipLog
            string sql_insert_WipLog = "insert into CAR_REQUEST_WIPLOG (id, emp_code, user_role_level, cur_status, confirm_time) values (@id, @emp_code, @user_role_level, @cur_status, getdate())";
            SqlParameter[] pr_insert_WipLog = new SqlParameter[]
            {
                new SqlParameter("@id", new_id),
                new SqlParameter("@emp_code", emp_code),
                new SqlParameter("@user_role_level", user_role_level),
                new SqlParameter("@cur_status", cur_status)
            };
            ConDB.dt_ThucThiCauLenh(sql_insert_WipLog, pr_insert_WipLog, con_str);

            // Gửi mail thông báo
            //gui_mail();

            // Thông báo OK
            string encodedMsg = HttpUtility.UrlEncode("Đăng ký xe thành công!\nMã đơn: " + new_id);
            string script = $@"document.getElementById('popup_Frame').src = 'ThongBao.aspx?msg={encodedMsg}';
                               document.getElementById('successPopup').style.display = 'block';";

            ScriptManager.RegisterStartupScript(this, this.GetType(), "showPopup", script, true);
        }

        protected void get_file()
        {
            string networkPath = @"\\172.16.33.40\Information System\06. common\08. LICENSE\4. License office\List License Office.xlsx";
            string fileName = "LICENSE_WINDOW_10_11.xlsx";

            // Tài khoản domain hoặc local user trên máy \\172.16.33.40
            string username = @"ADV\hanoi-is6";
            string password = "asahi25";

            var credentials = new System.Net.NetworkCredential(username, password);

            using (new NetworkConnection(@"\\172.16.33.40\Information System", credentials))
            {
                byte[] fileBytes = System.IO.File.ReadAllBytes(networkPath);

                // Trả file về trình duyệt
                Response.Clear();
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName);
                Response.BinaryWrite(fileBytes);
                Response.End();
            }
        }

        void gui_mail()
        {
            /*string getdate = DateTime.Now.ToString("dd/MM/yyyy, HH:mm:ss");*/
            string subject = "Car Request - Test";
            string mailFrom = "anonymous@asahi-intecc.com";
            string mailTo = "hanoi-is6@asahi-intecc.com";
            string cc = string.Empty;
            string body = "Đã đăng ký xe thành công. " + Environment.NewLine + "Thời gian: " + DateTime.Now.ToString("HH:mm:ss") + " ngày " + DateTime.Now.ToString("dd/MM/yyyy");
            Send_Mail.Send_Mail_Outlook(subject, mailFrom, mailTo, cc, body);
        }
    }
}