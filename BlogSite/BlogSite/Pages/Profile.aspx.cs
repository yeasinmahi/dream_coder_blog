using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BlogSite.BLL;
using BlogSite.Model;
using HtmlAgilityPack;

namespace BlogSite.Pages
{
    public partial class Profile : System.Web.UI.Page
    {
        BlogManager blogManager = new BlogManager();
        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (Session["userInfo"] == null)
            {
                Response.Redirect("index.aspx");
            }
            UserInfo userInfo = (UserInfo)Session["userInfo"];
            nameText.InnerText = userInfo.UserName;
            emailText.Text = userInfo.Email;
            aboutText.Text = userInfo.About;
            img.Src = "../images/user/" + userInfo.UserImage;

            List<Post> posts;
            if (postDropDown.SelectedItem.Value == "1")
            {
                posts = blogManager.GetMyPostPublished(userInfo.Uid);
            }
            else
            {
                posts = blogManager.GetMyPostUnPublished(userInfo.Uid);
            }
            LoadMyPost(posts);
        }

        private void LoadMyPost(List<Post> posts )
        {
            
            string innerHtml = "";
            foreach (Post post in posts)
            {
                HtmlDocument doc = new HtmlDocument();
                doc.LoadHtml(post.PostBody);
                string body = doc.DocumentNode.InnerText;
                string postBody;
                if (body.Length < 251)
                {
                    postBody = body;
                }
                else
                {
                    postBody = body.Substring(0, 250);
                }

                innerHtml += @"<div runat='server' class='post_box'><img src='../images/user/" + post.UserImage +
                             @"' class='image_wrapper' alt='Image' />
                    <p><span>Posted <a href='#'>" + post.Name + @"</a></span> | <a href='#'>" + post.DateOfPost +
                             @"</a> | <span>Viewed <a href='#'>" + post.HitCount + @"</a></span> | <span><a href='#'>" +
                             post.TotalComments + @"</a> Comments</span></p>
                        <h2 class='postHead'>" + post.PostTitle + @"</h2>
                        <div>" + postBody + @"</div>
                        <a class='more float_r' href='blog_post.aspx?pid=" + post.PostId + @"'>More</a>
                        <div class='cleaner'></div></div>";
            }
            postDiv.InnerHtml = innerHtml;
        }
    }
}