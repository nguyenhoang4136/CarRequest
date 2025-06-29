using CarRequest.Function_Code;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarRequest.MucLuc
{
    public partial class PheDuyetDon : System.Web.UI.Page
    {
        string con_str = ConDB.connection_string;
        string user_role_level = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("DangNhap.aspx");
            }
            else
            {
                user_role_level = ConDB.get_user_role_level(Session["User"].ToString());
                if (user_role_level == "1")
                {
                    Response.Redirect("~/MucLuc/TrangChu.aspx");
                }
            }

            if (!IsPostBack)
            {
                LoadData();
            }
        }

        private void LoadData()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(con_str))
                {
                    string sql = @"select id, requester_name, div_name, register_date, pick_up_from, 
                                        destination, purpose, quantity, using_date, from_time, to_time, cur_status
                                    from CAR_REQUEST_WIPTRACKING where user_role_level_next = (select user_role_level from CAR_REQUEST_USER where emp_code = @emp_code)
                                    order by register_date desc";

                    SqlParameter[] pr = new SqlParameter[]
                    {
                        new SqlParameter("@emp_code", Session["User"].ToString())
                    };

                    DataTable dt = ConDB.dt_ThucThiCauLenh(sql, pr, con_str);

                    gv_Show_Pending.DataSource = dt;
                    gv_Show_Pending.DataBind();
                    if (dt.Rows.Count > 0)
                    {
                        lbl_Report.Text = "Số đơn chờ duyệt: " + dt.Rows.Count;
                        lbl_Report.ForeColor = Color.BlueViolet;
                    }
                    else
                    {
                        lbl_Report.Text = "Hiện không có đơn nào cần phê duyệt";
                        lbl_Report.ForeColor = Color.BlueViolet;
                    }
                }
            }
            catch (Exception ex)
            {
                lbl_Report.Text = "Lỗi: " + ex.Message;
                lbl_Report.ForeColor = Color.BlueViolet;
            }
        }

        private List<string> GetSelectedRequestIds()
        {
            List<string> selectedIds = new List<string>();

            foreach (GridViewRow row in gv_Show_Pending.Rows)
            {
                CheckBox chk = (CheckBox)row.FindControl("chkSelect");
                if (chk != null && chk.Checked)
                {
                    string requestId = gv_Show_Pending.DataKeys[row.RowIndex].Value.ToString();
                    selectedIds.Add(requestId);
                }
            }
            return selectedIds;
        }


        protected void btn_Approve_Click(object sender, EventArgs e)
        {
            var selectedIds = GetSelectedRequestIds();
            foreach (string id in selectedIds)
            {
                // Update WT
                if (user_role_level == "6")
                {
                    string sql = "update CAR_REQUEST_WIPTRACKING set cur_status = N'Approved' where id = '" + id + "'";
                    ConDB.dt_ThucThiCauLenh(sql, null, con_str);
                }
                else
                {
                    /*string sql = "update CAR_REQUEST_WIPTRACKING set cur_status = N'Approved' where id = '" + id + "'";
                    ConDB.dt_ThucThiCauLenh(sql, null, con_str);*/
                }

                // Insert WL
                string sql_insert_WipLog = @"insert into CAR_REQUEST_WIPLOG (id, emp_code, user_role_level, cur_status, confirm_time) 
                                            values (@id, @emp_code, @user_role_level, @cur_status, getdate())";
                SqlParameter[] pr_insert_WipLog = new SqlParameter[]
                {
                    new SqlParameter("@id", id),
                    new SqlParameter("@emp_code", Session["User"].ToString()),
                    new SqlParameter("@user_role_level", user_role_level),
                    new SqlParameter("@cur_status", "Approved")
                };
                ConDB.dt_ThucThiCauLenh(sql_insert_WipLog, pr_insert_WipLog, con_str);
            }
            LoadData();
        }

        protected void btn_Reject_Click(object sender, EventArgs e)
        {
            var selectedIds = GetSelectedRequestIds();
            foreach (string id in selectedIds)
            {
                // Update WT
                string sql = "update CAR_REQUEST_WIPTRACKING set cur_status = N'Rejected' where id = '" + id + "'";
                ConDB.dt_ThucThiCauLenh(sql, null, con_str);

                // Insert WL
                string sql_insert_WipLog = @"insert into CAR_REQUEST_WIPLOG (id, emp_code, user_role_level, cur_status, confirm_time) 
                                            values (@id, @emp_code, @user_role_level, @cur_status, getdate())";
                SqlParameter[] pr_insert_WipLog = new SqlParameter[]
                {
                    new SqlParameter("@id", id),
                    new SqlParameter("@emp_code", Session["User"].ToString()),
                    new SqlParameter("@user_role_level", user_role_level),
                    new SqlParameter("@cur_status", "Rejected")
                };
                ConDB.dt_ThucThiCauLenh(sql_insert_WipLog, pr_insert_WipLog, con_str);
            }
            LoadData();
        }

    }
}