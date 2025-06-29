using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using System.Windows;

namespace CarRequest.Function_Code
{
    public class ConDB
    {
        //string strCon = "Data Source = 10.120.15.117; User ID = shopfloor; Password = happy123; Integrated Security = False";
        //public static string connection_string = "Data Source = 172.16.33.123; User ID = itaih; Password = 123456; Initial Catalog = IT_CarRequest; Integrated Security = False; TrustServerCertificate = True";
        public static string connection_string = "Data Source = HOANG_LAPTOP\\SQLEXPRESS; User ID = hoang; Password = hoang290701; Initial Catalog = WEB_DB; Integrated Security = False; TrustServerCertificate = True";
        public static DataTable dt_ThucThiCauLenh(string sql, SqlParameter[] parameters, string conStr)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
            return dt;
        }

        public static DataTable dt_ThucThiCauLenh_Origin(string sql, string conStr)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();
                using (SqlDataAdapter da = new SqlDataAdapter(sql, con))
                {
                    da.Fill(dt);
                }
            }
            return dt;
        }

        public static string get_emp_name(string emp_code)
        {
            string sql = "select emp_name from CAR_REQUEST_USER where emp_code = @emp_code";

            SqlParameter[] pr = new SqlParameter[]
            {
                new SqlParameter("@emp_code", emp_code)
            };

            return ConDB.dt_ThucThiCauLenh(sql, pr, connection_string).Rows[0][0].ToString();
        }

        public static string get_user_role_level(string session_user)
        {
            string sql = @"select user_role_level from CAR_REQUEST_USER where emp_code = @session_user";
            SqlParameter[] pr = new SqlParameter[]
            {
                new SqlParameter("@session_user", session_user)
            };
            DataTable dt = ConDB.dt_ThucThiCauLenh(sql, pr, connection_string);
            if (dt.Rows.Count > 0)
            {
                return dt.Rows[0][0].ToString();
            }
            return string.Empty;
        }

        public static string get_user_role_name(string session_user)
        {
            string sql = @"select user_role_name 
                            from CAR_REQUEST_USER_ROLE a join CAR_REQUEST_USER b on a.user_role_level = b.user_role_level
                            where b.emp_code = @session_user";
            SqlParameter[] pr = new SqlParameter[]
            {
                new SqlParameter("@session_user", session_user)
            };
            DataTable dt = ConDB.dt_ThucThiCauLenh(sql, pr, connection_string);
            if (dt.Rows.Count > 0)
            {
                return dt.Rows[0][0].ToString();
            }
            return string.Empty;
        }

        public static string get_User_Avatar(string empCode)
        {
            string sql_get_avatar = @"select avatar_base64 from CAR_REQUEST_USER where emp_code = @emp_code";
            SqlParameter[] pr_get_avatar = new SqlParameter[]
            {
                new SqlParameter("@emp_code", empCode)
            };

            DataTable dt = ConDB.dt_ThucThiCauLenh(sql_get_avatar, pr_get_avatar, connection_string);
            if (dt.Rows.Count > 0)
            {
                string base64Avatar = dt.Rows[0]["avatar_base64"]?.ToString();
                if (!string.IsNullOrEmpty(base64Avatar))
                {
                    return $"data:image/jpeg;base64,{base64Avatar}";
                }
            }
            return "https://i.pravatar.cc/36";
        }

        public static void load_data_into_dropdownlist(string sql, DropDownList ddl, SqlParameter[] parameters, int selected_index, bool add_alt)
        {
            ddl.Items.Clear();
            using (SqlConnection con = new SqlConnection(connection_string))
            {
                con.Open();
                using (SqlCommand cm = new SqlCommand(sql, con))
                {
                    if (parameters != null)
                    {
                        cm.Parameters.AddRange(parameters);
                    }
                    using (SqlDataReader reader = cm.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            if (!reader.IsDBNull(0))
                            {
                                ddl.Items.Add(reader.GetString(0));
                            }
                        }
                    }
                }
            }
            if (add_alt)
            {
                ddl.Items.Add("Khác / Alt");
                ddl.SelectedIndex = selected_index;
            }
        }
    }
}