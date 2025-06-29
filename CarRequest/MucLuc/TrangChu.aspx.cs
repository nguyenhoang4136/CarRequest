using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CarRequest.MucLuc
{
    public partial class TrangChu : System.Web.UI.Page
    {
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

            /*if (Session["User"] == null)
            {
                Response.Redirect("DangNhap.aspx");
            }*/
            load_background_homepage();
        }

        protected List<string> homepage_background_list = new List<string>();
        protected string random_homepage_background;
        protected void load_background_homepage()
        {
            string folderPath = Server.MapPath("~/Picture_Resources/TrangChu/");
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
                    homepage_background_list.Add(ResolveUrl("~/Picture_Resources/TrangChu/" + filename));
                }

                // Random ảnh đầu tiên
                Random rand = new Random();
                int index = rand.Next(imageFiles.Length);
                string selectedFile = Path.GetFileName(imageFiles[index]);
                random_homepage_background = ResolveUrl("~/Picture_Resources/TrangChu/" + selectedFile);
            }
        }

    }
}