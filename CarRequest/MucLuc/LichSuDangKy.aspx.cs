using CarRequest.Function_Code;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarRequest.MucLuc
{
    public partial class LichSuDangKy : System.Web.UI.Page
    {
        string con_str = ConDB.connection_string;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("DangNhap.aspx");
            }
            lbl_Report.Text = string.Empty;
            load_Data();
        }

        protected void load_Data()
        {
            string sql = "select * from CAR_REQUEST_WIPTRACKING";
            DataTable dt = ConDB.dt_ThucThiCauLenh(sql, null, con_str);

            if (dt.Rows.Count > 0)
            {
                gv.DataSource = dt;
                gv.DataBind();
                lbl_Report.Text = "Số lượng đơn chờ ký duyệt là " + dt.Rows.Count.ToString();
                lbl_Report.ForeColor = Color.BlueViolet;
            }
            else
            {
                lbl_Report.Text = "Không có đơn nào cần ký duyệt";
                lbl_Report.ForeColor = Color.Red;
            }
        }
    }
}