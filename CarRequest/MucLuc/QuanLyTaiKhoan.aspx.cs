using CarRequest.Function_Code;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarRequest.MucLuc
{
    public partial class QuanLyTaiKhoan : System.Web.UI.Page
    {
        string con_str = ConDB.connection_string;
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["User"] == null)
            {
                Response.Redirect("DangNhap.aspx");
            }
            else
            {
                string user_role = ConDB.get_user_role_level(Session["User"].ToString());
                if (user_role != "0")
                {
                    Response.Redirect("~/MucLuc/TrangChu.aspx");
                }
            }

            if (!IsPostBack)
            {
                Dictionary<string, string> currentRoles = new Dictionary<string, string>();
                foreach (GridViewRow row in gv_Show_Accounts.Rows)
                {
                    string empCode = gv_Show_Accounts.DataKeys[row.RowIndex].Value.ToString();
                    DropDownList ddl = (DropDownList)row.FindControl("ddl_UserRole");
                    if (ddl != null)
                    {
                        currentRoles[empCode] = ddl.SelectedValue;
                    }
                }
                ViewState["CurrentRoles"] = currentRoles;

                ddl_Filter.SelectedIndex = 0;
                LoadAccounts(ddl_Filter.SelectedIndex);
                btn_Enable_or_Disable.Text = set_enable_or_disiable();
            }
            else
            {

            }
            btn_Change_UserRole.Visible = ddl_Filter.SelectedIndex != 0;
        }

        protected void ddl_Filter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadAccounts(ddl_Filter.SelectedIndex);
            btn_Enable_or_Disable.Text = set_enable_or_disiable();
        }

        protected string set_enable_or_disiable()
        {
            string text = string.Empty;
            if (ddl_Filter.SelectedIndex == 0)
            {
                text = "Kích hoạt tài khoản";
            }
            else if (ddl_Filter.SelectedIndex == 1)
            {
                text = "Khóa tài khoản";
            }
            return text;
        }

        private void LoadAccounts(int isActivatedFilter)
        {
            gv_Show_Accounts.DataSource = null;

            string sql = @"select a.emp_code, a.emp_name, a.email, a.is_activated, isnull(b.user_role_name, '') as user_role_name, a.user_role_level
                           from CAR_REQUEST_USER a left join CAR_REQUEST_USER_ROLE b on a.user_role_level = b.user_role_level
                           where a.is_activated = @is_activated and (a.user_role_level <> 0 or a.user_role_level is null)";

            SqlParameter[] pr_sql = new SqlParameter[]
            {
                new SqlParameter("@is_activated", isActivatedFilter)
            };

            DataTable dt = ConDB.dt_ThucThiCauLenh(sql, pr_sql, con_str);
            gv_Show_Accounts.DataSource = dt;
            gv_Show_Accounts.DataBind();

            if (dt.Rows.Count == 0)
            {
                btn_Delete.Enabled = false;
                btn_Enable_or_Disable.Enabled = false;
                btn_Change_UserRole.Enabled = false;
            }
            gv_Show_Accounts.Columns[3].Visible = (ddl_Filter.SelectedIndex != 0);
            gv_Show_Accounts.Columns[4].Visible = (ddl_Filter.SelectedIndex != 0);
        }

        
        protected void btn_Enable_or_Disable_Click(object sender, EventArgs e)
        {
            foreach (GridViewRow row in gv_Show_Accounts.Rows)
            {
                CheckBox chkRow = (CheckBox)row.FindControl("chk_Select");
                SqlParameter[] pr_sql = null;

                if (chkRow != null && chkRow.Checked)
                {
                    string empCode = gv_Show_Accounts.DataKeys[row.RowIndex].Value.ToString();
                    DropDownList ddlRole = (DropDownList)row.FindControl("ddl_UserRole");
                    string roleName = ddlRole.Text;
                    string sql = string.Empty;

                    if (ddl_Filter.SelectedIndex == 0)
                    {
                        sql = @"update CAR_REQUEST_USER set is_activated = 1,
                                user_role_level = (select user_role_level from CAR_REQUEST_USER_ROLE where user_role_name = @user_role_name)
                                where emp_code = @empCode";

                        pr_sql = new SqlParameter[]
                        {
                            new SqlParameter("@user_role_name", SqlDbType.NVarChar) { Value = roleName },
                            new SqlParameter("@empCode", empCode)
                        };
                    }
                    else if (ddl_Filter.SelectedIndex == 1)
                    {
                        sql = @"update CAR_REQUEST_USER set is_activated = 0 where emp_code = @emp_code";
                        pr_sql = new SqlParameter[]
                        {
                            new SqlParameter("@emp_code", empCode)
                        };
                    }

                    if (!string.IsNullOrEmpty(sql))
                    {
                        ConDB.dt_ThucThiCauLenh(sql, pr_sql, con_str);
                    }
                }
            }
            LoadAccounts(ddl_Filter.SelectedIndex);
        }

        protected void btn_Delete_Click(object sender, EventArgs e)
        {
            foreach (GridViewRow row in gv_Show_Accounts.Rows)
            {
                CheckBox chkRow = (CheckBox)row.FindControl("chk_Select");
                if (chkRow != null && chkRow.Checked)
                {
                    string empCode = gv_Show_Accounts.DataKeys[row.RowIndex].Value.ToString();
                    string sql_DeleteAccount = @"delete from CAR_REQUEST_USER where emp_code = @emp_code";

                    SqlParameter[] pr_DeleteAccount = new SqlParameter[]
                    {
                        new SqlParameter("@emp_code", empCode)
                    };

                    ConDB.dt_ThucThiCauLenh(sql_DeleteAccount, pr_DeleteAccount, con_str);
                }
            }
            LoadAccounts(ddl_Filter.SelectedIndex);
        }

        protected void gv_Show_Accounts_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView drv = (DataRowView)e.Row.DataItem;
                DropDownList ddlRole = (DropDownList)e.Row.FindControl("ddl_UserRole");

                if (ddlRole != null)
                {
                    DataTable dtRoles = GetUserRoles();
                    ddlRole.DataSource = dtRoles;
                    ddlRole.DataTextField = "user_role_name";
                    ddlRole.DataValueField = "user_role_name";
                    ddlRole.DataBind();

                    string currentRole = drv["user_role_name"].ToString();
                    if (!string.IsNullOrEmpty(currentRole))
                    {
                        ListItem item = ddlRole.Items.FindByValue(currentRole);
                        if (item != null)
                        {
                            ddlRole.SelectedValue = currentRole;
                        }
                    }
                    /*ddlRole.Enabled = true;*/
                    ddlRole.Visible = true;
                }
            }
        }

        private DataTable GetUserRoles()
        {
            string sql = "select user_role_name from CAR_REQUEST_USER_ROLE where user_role_level <> 0";
            return ConDB.dt_ThucThiCauLenh(sql, null, con_str);
        }

        protected void btn_Change_UserRole_Click(object sender, EventArgs e)
        {
            foreach (GridViewRow row in gv_Show_Accounts.Rows)
            {
                CheckBox chkRow = (CheckBox)row.FindControl("chk_Select");
                if (chkRow != null && chkRow.Checked)
                {
                    string empCode = gv_Show_Accounts.DataKeys[row.RowIndex].Value.ToString();
                    DropDownList ddlRole = (DropDownList)row.FindControl("ddl_UserRole");
                    string roleName = ddlRole.Text;
                    string sql_Change_User_Role = @"update CAR_REQUEST_USER set user_role_level = (select user_role_level from CAR_REQUEST_USER_ROLE where user_role_name = @user_role_name) where emp_code = @emp_code";

                    SqlParameter[] pr_Change_User_Role = new SqlParameter[]
                    {
                        new SqlParameter("@user_role_name", SqlDbType.NVarChar) { Value = roleName },
                        new SqlParameter("@emp_code", empCode)
                    };

                    ConDB.dt_ThucThiCauLenh(sql_Change_User_Role, pr_Change_User_Role, con_str);
                }
            }
            LoadAccounts(ddl_Filter.SelectedIndex);
        }
    }
}