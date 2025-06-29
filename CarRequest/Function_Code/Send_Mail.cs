using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Windows;

namespace CarRequest.Function_Code
{
    public class Send_Mail
    {
        public static void Send_Mail_Outlook(string mail_subject, string mail_from, string mail_to, string mail_cc, string mail_body)
        {
            // Gửi email
            using (MailMessage mail = new MailMessage())
            {
                mail.From = new MailAddress(mail_from);
                mail.To.Add(mail_to);
                if (!string.IsNullOrWhiteSpace(mail_cc))
                {
                    mail.CC.Add(mail_cc);
                }
                mail.Subject = mail_subject;
                mail.Body = mail_body;
                mail.IsBodyHtml = true;

                using (SmtpClient smtp = new SmtpClient("sbox.asahi-intecc.com")) // Máy chủ SMTP của Email
                {
                    smtp.Credentials = new NetworkCredential(mail_from, ""); // Email và mật khẩu
                    smtp.EnableSsl = false;
                    smtp.Send(mail);
                }
            }
        }
    }
}