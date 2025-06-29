using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;

namespace CarRequest
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }

        protected void Application_AcquireRequestState(object sender, EventArgs e)
        {
            var context = HttpContext.Current;
            string path = context.Request.Url.AbsolutePath.ToLower();

            // Nếu là trang đăng nhập hoặc trang gốc thì cho phép
            if (path.EndsWith("/carrequest/") || path.Contains("dangnhap") || path.EndsWith("/dangky"))
            {
                return;
            }

            // Nếu chưa login, chuyển về trang đăng nhập
            if (context.Session != null && context.Session["User"] == null)
            {
                context.Response.Redirect("~/");
            }
        }
    }
}