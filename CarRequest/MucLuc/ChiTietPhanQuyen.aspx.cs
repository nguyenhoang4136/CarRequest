using CarRequest.Function_Code;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Reflection.Emit;
using System.Web.UI.WebControls;

namespace CarRequest.MucLuc
{
    public partial class ChiTietPhanQuyen : System.Web.UI.Page
    {
        string con_str = ConDB.connection_string;
        string empCode = string.Empty;
        string empName = string.Empty;
        string roleLevel = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            empCode = Request.QueryString["emp_code"];
            empName = ConDB.get_emp_name(empCode);
            roleLevel = Request.QueryString["role_level"];
            if (!IsPostBack)
            {
                lblEmpCode.Text = empCode;
                /*lbl_EmpName.Text = empName;*/
                lblRoleLevel.Text = roleLevel == "2" ? "Confirm" : "Approve";

                Load_Divisions();
                Load_User_Rights(empCode);

                ddl_ConfirmTier.Visible = roleLevel == "2";
                ddl_ApproveTier.Visible = roleLevel == "3";
            }
            lbl_Header.Text = "Phân quyền chi tiết cho tài khoản của " + empName;
        }

        private void Load_Divisions()
        {
            string sql = "select div_code, div_name from CAR_REQUEST_DIVISION where div_code <> 0 order by div_code";
            DataTable dt = ConDB.dt_ThucThiCauLenh(sql, null, con_str);
            ddl_DivCode.DataSource = dt;
            ddl_DivCode.DataTextField = "div_name";
            ddl_DivCode.DataValueField = "div_code";
            ddl_DivCode.DataBind();
        }

        private void Load_User_Rights(string empCode)
        {
            /*string sql = @"select b.div_name, a.confirm_tier, a.approve_tier
                           from CAR_REQUEST_USER_ROLE_DETAIL a
                           join CAR_REQUEST_DIVISION b ON a.div_code = b.div_code
                           where a.emp_code = @emp_code and a.user_role_level = @role_level";

            SqlParameter[] pr = new SqlParameter[]
            {
                new SqlParameter("@emp_code", empCode),
                new SqlParameter("@role_level", roleLevel)
            };*/
            string sql = @"select b.div_name, a.confirm_tier, a.approve_tier
                           from CAR_REQUEST_USER_ROLE_DETAIL a
                           join CAR_REQUEST_DIVISION b ON a.div_code = b.div_code
                           where a.emp_code = @emp_code";

            SqlParameter[] pr = new SqlParameter[]
            {
                new SqlParameter("@emp_code", empCode)
            };

            DataTable dt = ConDB.dt_ThucThiCauLenh(sql, pr, con_str);
            gv_User_Rights.DataSource = dt;
            gv_User_Rights.DataBind();
        }

        protected void btn_Add_Right_Click(object sender, EventArgs e)
        {
            string empCode = Request.QueryString["emp_code"];
            int divCode = int.Parse(ddl_DivCode.SelectedValue);
            /*int roleLevel = int.Parse(Request.QueryString["role_level"]);*/

            int confirmTier = ddl_ConfirmTier.Visible ? int.Parse(ddl_ConfirmTier.SelectedValue) : 0;
            int approveTier = ddl_ApproveTier.Visible ? int.Parse(ddl_ApproveTier.SelectedValue) : 0;

            // Kiểm tra xem đã tồn tại chưa
            string sql_check = @"select count(*) from CAR_REQUEST_USER_ROLE_DETAIL 
                                where emp_code = @emp_code and div_code = @div_code";

            SqlParameter[] pr_check = new SqlParameter[]
            {
                new SqlParameter("@emp_code", empCode),
                new SqlParameter("@div_code", divCode),
                new SqlParameter("@user_role_level", roleLevel)
            };

            DataTable dt_check = ConDB.dt_ThucThiCauLenh(sql_check, pr_check, con_str);

            if (Convert.ToInt32(dt_check.Rows[0][0]) > 0)
            {
                // Update nếu đã có
                string insertSql = @"update CAR_REQUEST_USER_ROLE_DETAIL 
                                    set confirm_tier = @confirm_tier, approve_tier = @approve_tier, user_role_level = @user_role_level
                                    where emp_code = @emp_code and div_code = @div_code";

                SqlParameter[] insertPr = new SqlParameter[]
                {
                    new SqlParameter("@confirm_tier", confirmTier),
                    new SqlParameter("@approve_tier", approveTier),
                    new SqlParameter("@emp_code", empCode),
                    new SqlParameter("@div_code", divCode),
                    new SqlParameter("@user_role_level", roleLevel)
                };

                ConDB.dt_ThucThiCauLenh(insertSql, insertPr, con_str);

                lblMessage.Text = "✅ Đã cập nhật lại quyền " + lblRoleLevel.Text + " cho " + empName + " thành công!";
                lblMessage.ForeColor = System.Drawing.Color.Green;
            }
            else
            {
                // Insert nếu chưa có
                string sql_insert = @"insert into CAR_REQUEST_USER_ROLE_DETAIL (emp_code, div_code, user_role_level, confirm_tier, approve_tier)
                                values (@emp_code, @div_code, @role_level, @confirm_tier, @approve_tier)";

                SqlParameter[] pr_insert = new SqlParameter[]
                {
                new SqlParameter("@emp_code", empCode),
                new SqlParameter("@div_code", divCode),
                new SqlParameter("@role_level", roleLevel),
                new SqlParameter("@confirm_tier", confirmTier),
                new SqlParameter("@approve_tier", approveTier)
                };

                ConDB.dt_ThucThiCauLenh(sql_insert, pr_insert, con_str);

                lblMessage.Text = "✅ Thêm quyền " + lblRoleLevel.Text + " cho " + empName + " thành công!";
                lblMessage.ForeColor = System.Drawing.Color.Green;
            }
            // Refresh grid
            Load_User_Rights(empCode);
        }

        protected void btn_Delete_Right_Click(object sender, EventArgs e)
        {
            int count = 0;
            foreach (GridViewRow row in gv_User_Rights.Rows)
            {
                CheckBox chk = (CheckBox)row.FindControl("chk_Select");
                if (chk != null && chk.Checked)
                {
                    string divName = gv_User_Rights.DataKeys[row.RowIndex]?.Value.ToString();
                    string sql_insert = @"delete from CAR_REQUEST_USER_ROLE_DETAIL
                                            where emp_code = @emp_code 
                                                and div_code = (select div_code from CAR_REQUEST_DIVISION where div_name = @div_name)";

                    SqlParameter[] pr_insert = new SqlParameter[]
                    {
                        new SqlParameter("@emp_code", empCode),
                        new SqlParameter("@div_name", divName)
                    };

                    ConDB.dt_ThucThiCauLenh(sql_insert, pr_insert, con_str);
                    count++;
                }
            }

            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = count > 0 ? $"Đã xóa {count} quyền." : "Vui lòng chọn quyền để xóa.";
            Load_User_Rights(empCode);
        }


    }
}
