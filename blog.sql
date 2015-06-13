USE [master]
GO
/****** Object:  Database [dreamCoderBlog]    Script Date: 13-Jun-15 11:19:39 PM ******/
CREATE DATABASE [dreamCoderBlog]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'dreamCoderBlog', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\dreamCoderBlog.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'dreamCoderBlog_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\dreamCoderBlog_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [dreamCoderBlog] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [dreamCoderBlog].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [dreamCoderBlog] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET ARITHABORT OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [dreamCoderBlog] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [dreamCoderBlog] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [dreamCoderBlog] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET  DISABLE_BROKER 
GO
ALTER DATABASE [dreamCoderBlog] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [dreamCoderBlog] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [dreamCoderBlog] SET  MULTI_USER 
GO
ALTER DATABASE [dreamCoderBlog] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [dreamCoderBlog] SET DB_CHAINING OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [dreamCoderBlog] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [dreamCoderBlog]
GO
/****** Object:  StoredProcedure [dbo].[GetCommentByPid]    Script Date: 13-Jun-15 11:19:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetCommentByPid](@pid as int)
as
select c.cid,c.uid,c.pid,c.dateOfComment,c.comment,u.fName,u.lName,u.image from comment as c join userInfo as u on c.uid=u.uid where c.pid=@pid

GO
/****** Object:  StoredProcedure [dbo].[GetPostByPid]    Script Date: 13-Jun-15 11:19:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetPostByPid](@pid as int)
 as
select p.pid,p.title,p.post,u.fName,u.lName,u.about,u.image,p.dateOfPost,p.hitCount from post as p join userInfo as u on u.uid=p.uid where p.pid=@pid

GO
/****** Object:  StoredProcedure [dbo].[myPostPublish]    Script Date: 13-Jun-15 11:19:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[myPostPublish](@uid as int)
as
 select p.pid,p.title,p.post,u.fName,u.lName,u.about,u.image,p.dateOfPost,p.hitCount, p.status from post as p join userInfo as u on u.uid=p.uid where p.status='p' and u.uid=@uid order by p.dateOfPost desc

GO
/****** Object:  StoredProcedure [dbo].[myPostUnPublish]    Script Date: 13-Jun-15 11:19:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[myPostUnPublish](@uid as int)
as
 select p.pid,p.title,p.post,u.fName,u.lName,u.about,u.image,p.dateOfPost,p.hitCount, p.status from post as p join userInfo as u on u.uid=p.uid where p.status='S' and u.uid=@uid order by p.dateOfPost desc

GO
/****** Object:  StoredProcedure [dbo].[search]    Script Date: 13-Jun-15 11:19:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[search] (@search as varchar(50)) 
as
if @search='<p' or @search='</p' or @search='<a' or @search='</a' or @search='href'
or @search='src' or @search='class'or @search='http' or @search='https' or @search='<p>' 
or @search='</p>' or @search='<b>' or @search='<i>' or @search='</b>' or @search='</i>'
or @search='style'
begin
select p.pid, p.title, p.post, u.fName, u.lName, u.about, u.image, p.dateOfPost, p.hitCount
from post  as p join userInfo as u 
on u.uid=p.uid 
where p.status='p' and (p.post like '%'+@search+'%' or p.title like '%'+@search+'%' 
or u.fName like '%'+@search+'%' or u.lName like '%'+@search+'%' )
Union 
select p.pid, p.title, p.post, u.fName, u.lName, u.about, u.image, p.dateOfPost, p.hitCount
from post as p  join userInfo as u 
on u.uid=p.uid join
(select pid from comment where comment like '%'+@search+'%' group by pid)
c on p.pid=c.pid where p.status='p'
except
select p.pid, p.title, p.post, u.fName, u.lName, u.about, u.image, p.dateOfPost, p.hitCount
from post as p join userInfo as u 
on u.uid=p.uid where p.post like '%'+@search+'%' and p.status='p'
end
else
begin
select p.pid, p.title, p.post, u.fName, u.lName, u.about, u.image, p.dateOfPost, p.hitCount
from post  as p join userInfo as u 
on u.uid=p.uid 
where p.status='p' and (p.post like '%'+@search+'%' or p.title like '%'+@search+'%' 
or u.fName like '%'+@search+'%' or u.lName like '%'+@search+'%') 
Union 
select p.pid, p.title, p.post, u.fName, u.lName, u.about, u.image, p.dateOfPost, p.hitCount
from post as p  join userInfo as u 
on u.uid=p.uid join
(select pid from comment where comment like '%'+@search+'%' group by pid)
c on p.pid=c.pid where p.status='p'
end

GO
/****** Object:  Table [dbo].[comment]    Script Date: 13-Jun-15 11:19:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[comment](
	[cid] [int] IDENTITY(1,1) NOT NULL,
	[uid] [int] NOT NULL,
	[pid] [int] NOT NULL,
	[dateOfComment] [datetime] NULL,
	[comment] [varchar](max) NOT NULL,
 CONSTRAINT [PK_comment] PRIMARY KEY CLUSTERED 
(
	[cid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[login]    Script Date: 13-Jun-15 11:19:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[login](
	[lid] [int] IDENTITY(1,1) NOT NULL,
	[email] [varchar](50) NOT NULL,
	[password] [varchar](50) NOT NULL,
 CONSTRAINT [PK_login] PRIMARY KEY CLUSTERED 
(
	[lid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[post]    Script Date: 13-Jun-15 11:19:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[post](
	[pid] [int] IDENTITY(1,1) NOT NULL,
	[title] [varchar](200) NULL,
	[post] [varchar](max) NOT NULL,
	[dateOfPost] [datetime] NULL,
	[hitCount] [int] NULL,
	[status] [varchar](1) NULL,
	[uid] [int] NOT NULL,
 CONSTRAINT [PK_post] PRIMARY KEY CLUSTERED 
(
	[pid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[userInfo]    Script Date: 13-Jun-15 11:19:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[userInfo](
	[uid] [int] IDENTITY(1,1) NOT NULL,
	[fName] [varchar](50) NOT NULL,
	[lName] [varchar](50) NOT NULL,
	[about] [varchar](500) NULL,
	[image] [varchar](10) NULL,
	[lid] [int] NOT NULL,
 CONSTRAINT [PK_userInfo] PRIMARY KEY CLUSTERED 
(
	[uid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[mostRecentPost]    Script Date: 13-Jun-15 11:19:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[mostRecentPost] as
 select top 5 p.pid,p.title,p.post,u.fName,u.lName,u.about,u.image,p.dateOfPost,p.hitCount from post as p join userInfo as u on u.uid=p.uid where p.status='p' order by p.dateOfPost desc

GO
/****** Object:  View [dbo].[mostViewedPost]    Script Date: 13-Jun-15 11:19:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[mostViewedPost] as
 select top 5 p.pid,p.title,p.post,u.fName,u.lName,u.about,u.image,p.dateOfPost,p.hitCount from post as p join userInfo as u on u.uid=p.uid where p.status='p' order by p.hitCount desc

GO
SET IDENTITY_INSERT [dbo].[comment] ON 

INSERT [dbo].[comment] ([cid], [uid], [pid], [dateOfComment], [comment]) VALUES (1, 1, 9, CAST(0x0000A4B300000000 AS DateTime), N'Nice Post')
INSERT [dbo].[comment] ([cid], [uid], [pid], [dateOfComment], [comment]) VALUES (2, 4, 9, CAST(0x0000A4B300E1A417 AS DateTime), N'Thanks')
INSERT [dbo].[comment] ([cid], [uid], [pid], [dateOfComment], [comment]) VALUES (3, 4, 10, CAST(0x0000A4B300E1CD4F AS DateTime), N'What do you wants to say?')
INSERT [dbo].[comment] ([cid], [uid], [pid], [dateOfComment], [comment]) VALUES (4, 1, 10, CAST(0x0000A4B300E1F685 AS DateTime), N'About history')
INSERT [dbo].[comment] ([cid], [uid], [pid], [dateOfComment], [comment]) VALUES (5, 4, 10, CAST(0x0000A4B300E22961 AS DateTime), N'Whom History?')
INSERT [dbo].[comment] ([cid], [uid], [pid], [dateOfComment], [comment]) VALUES (6, 1, 5, CAST(0x0000A4B3012D5101 AS DateTime), N'What You Think About This Post?')
INSERT [dbo].[comment] ([cid], [uid], [pid], [dateOfComment], [comment]) VALUES (7, 1, 5, CAST(0x0000A4B3012D5ACF AS DateTime), N'What You Think About This Post?')
INSERT [dbo].[comment] ([cid], [uid], [pid], [dateOfComment], [comment]) VALUES (8, 1, 10, CAST(0x0000A4B3012F5406 AS DateTime), N'I don''t know ')
INSERT [dbo].[comment] ([cid], [uid], [pid], [dateOfComment], [comment]) VALUES (9, 1, 10, CAST(0x0000A4B3012F63B6 AS DateTime), N'I don''t know ')
INSERT [dbo].[comment] ([cid], [uid], [pid], [dateOfComment], [comment]) VALUES (10, 1, 9, CAST(0x0000A4B3016364BD AS DateTime), N'Welcome')
INSERT [dbo].[comment] ([cid], [uid], [pid], [dateOfComment], [comment]) VALUES (11, 1, 9, CAST(0x0000A4B301636FC3 AS DateTime), N'Welcome')
INSERT [dbo].[comment] ([cid], [uid], [pid], [dateOfComment], [comment]) VALUES (12, 1, 9, CAST(0x0000A4B301639B2B AS DateTime), N'I don''t know')
INSERT [dbo].[comment] ([cid], [uid], [pid], [dateOfComment], [comment]) VALUES (13, 1, 9, CAST(0x0000A4B301648850 AS DateTime), N'What You Think About This Post?')
INSERT [dbo].[comment] ([cid], [uid], [pid], [dateOfComment], [comment]) VALUES (14, 1, 9, CAST(0x0000A4B3016499BC AS DateTime), N'What You Think About This Post?')
INSERT [dbo].[comment] ([cid], [uid], [pid], [dateOfComment], [comment]) VALUES (15, 1, 9, CAST(0x0000A4B30164A95B AS DateTime), N'Welcome')
INSERT [dbo].[comment] ([cid], [uid], [pid], [dateOfComment], [comment]) VALUES (16, 3, 10, CAST(0x0000A4B4001CA640 AS DateTime), N'What are you doing here?')
SET IDENTITY_INSERT [dbo].[comment] OFF
SET IDENTITY_INSERT [dbo].[login] ON 

INSERT [dbo].[login] ([lid], [email], [password]) VALUES (1, N'yeasinmahi72@yahoo.com', N'arafat7218')
INSERT [dbo].[login] ([lid], [email], [password]) VALUES (3, N'tarikseo@gmail.com', N'tarik')
INSERT [dbo].[login] ([lid], [email], [password]) VALUES (4, N'ananna.rahman92@gmail.com', N'Ananna')
INSERT [dbo].[login] ([lid], [email], [password]) VALUES (5, N'y@y.com', N's')
INSERT [dbo].[login] ([lid], [email], [password]) VALUES (6, N'farida1.igb@gmail.com', N'farida')
SET IDENTITY_INSERT [dbo].[login] OFF
SET IDENTITY_INSERT [dbo].[post] ON 

INSERT [dbo].[post] ([pid], [title], [post], [dateOfPost], [hitCount], [status], [uid]) VALUES (4, N'Yeasin', N'<p style="text-align: center;"><span style="font-size: 52px;"><u><em><strong>I am CSE Student</strong></em></u></span></p>', CAST(0x0000A4B200662B4F AS DateTime), 7, N's', 1)
INSERT [dbo].[post] ([pid], [title], [post], [dateOfPost], [hitCount], [status], [uid]) VALUES (5, N'Arafat', N'Carl Nielsen (1865–1931) was a Danish musician, conductor and violinist, widely recognized as his country''s greatest composer. Brought up by poor, musically talented parents, he attended the Royal Conservatory in Copenhagen from 1884 through 1886, and premiered his Op 1, Suite for Strings at the age of 23. The following year, he began a 16-year stint as a second violinist in the Royal Danish Orchestra under the conductor Johan Svendsen, and later taught at the Royal Danish Academy of Music from 1916 until his death. While his symphonies, concertos and choral music are now internationally acclaimed, Nielsen''s career and personal life were marked by many difficulties, often reflected in his music. The works he composed between 1897 and 1904 are sometimes ascribed to his "psychological" period, resulting mainly from a turbulent marriage with the sculptor Anne Marie Brodersen. Nielsen is especially noted for his six symphonies, his Wind Quintet and his concertos for violin, flute and clarinet. For many years, he appeared on the Danish hundred-kroner banknote. The Carl Nielsen Museum in Odense documents his life and that of his wife. Many performances of his works are scheduled in 2015, the 150th anniversary of his birth. (Full article...)', CAST(0x0000A4B20144CA19 AS DateTime), 31, N'p', 1)
INSERT [dbo].[post] ([pid], [title], [post], [dateOfPost], [hitCount], [status], [uid]) VALUES (8, N'SEIP: Background and Objective', N'<p>  </p><p>Growth of the economy and employment opportunities in Bangladesh is restricted, among others, by skills shortages. The current skills supply systems do not meet the skill demand because of inadequate throughput and a mismatch between skills supply and skills demand. The current production of skilled workers is not focused on industry demand and is segmented and poorly coordinated. The teacher/instructor training program produces a small number of graduates with inadequate pedagogical and technical skills. The process of selection and deployment of instructors in the public skill training institutions is slow and inefficient. The informal nature of the employment market in Bangladesh, which covers 87.5 percent of employment (LFS 2010), has neither encouraged industry to significantly engage in formal training, apprenticeship or employment nor inspired potential workers to explore formal training so as to seek employment in domestic and external markets. As a result, the role of the industry sectors has remained largely marginal. This will require building networks with a variety of industry sectors, chambers and business houses around the country; to motivate and engage them. In this respect, utilizing the services of private sector think tanks and organizations which enjoy solid linkages and the confidence of the private sector and industry will therefore be essential for building and sustaining any such partnership between the industry sectors, training institutions, potential employees and the government. The ministries involved in the project will be encouraged to partner with chambers and think tanks to achieve the required employment outcomes of their training programmes.</p><p>  </p><p>A National Skills Development Policy (NSDP) was approved by the Government in January 2012. The NSDP emphasizes the imperative need to improve the supply of human resources with necessary skills and attitudes to meet the industry demand for skilled workers. The NSDP emphasizes the importance of better alignment of Technical and Vocational Education and Training (TVET) with skills development systems and industry skills demand. The NSDP also promotes changes in TVET system management, pedagogy, and certification as well as expansion of the system, along with effective planning, coordination and monitoring of skills development activities by ministries, development partners, industry, public and private training providers. The ILO-EC TVET Reform Project has supported significant reforms on many fronts including national qualifications and quality assurance arrangements.</p><p>  </p><p>Government in the meantime has established the National Technical Vocational Qualifications Framework (NTVQF) and the National Skills Quality Assurance System (NSQAS) and associated documentation of regulations and manuals as per recommendation of NSDP. These developments meet some of the core changes within the skills production system that are necessary to meet the industry demand of the supply of skilled workers.</p><p>  </p><p>Objective of the Project: The overall objective of the project is to qualitatively and quantitatively expand the skilling capacity of identified public and private training providers by establishing and operationalizing a responsive skill eco system and delivery mechanism through a combination of well-defined set of funding triggers and targeted capacity support. Specifically, the objectives are to:</p><p>  </p><p style="text-align: left;">&nbsp;&nbsp;&nbsp;&nbsp;(i) improve job focused skills along with up-skilling of the existing workforce to enhance productivity and growth of industry sectors</p><p style="text-align: left;">  </p><p style="text-align: left;">&nbsp;&nbsp;&nbsp;&nbsp;(ii) impart skills training linked to gainful employment or self-employment through PKSF partners and their livelihood programs;</p><p style="text-align: left;">  </p><p style="text-align: left;">&nbsp;&nbsp;&nbsp;&nbsp;(iii) develop a network of training providers that are endorsed by industry for providing excellence of training to meet the skills needs of employers;</p><p style="text-align: left;">  </p><p style="text-align: left;">&nbsp;&nbsp;&nbsp;&nbsp;(iv) establish and implement a strategy to address the special needs of groups specified in the NSDP and ensure their participation in SEIP programs.</p><p style="text-align: left;">  </p><p style="text-align: left;">&nbsp;&nbsp;&nbsp;&nbsp;(v) implement a vocational trainer development program for trainers and assessors and a management leadership program for training provider management reflecting NSDP requirements;</p><p style="text-align: left;">  </p><p style="text-align: left;">&nbsp;&nbsp;&nbsp;&nbsp;(vi) Strengthen capacity of BTEB in approving training providers registration process, course accreditation and monitoring quality assurance and implementation procedures of training providers.</p><p style="text-align: left;">  </p><p style="text-align: left;">&nbsp;&nbsp;&nbsp;&nbsp;(vii) support the training providers for capacity development to ensure quality training delivery mechanism.</p><p style="text-align: left;">  </p><p style="text-align: left;">&nbsp;&nbsp;&nbsp;&nbsp;(viii) establish and institutionalize a credible recognition of prior earning (RPL) system;</p><p style="text-align: left;">  </p><p style="text-align: left;">&nbsp;&nbsp;&nbsp;&nbsp;(ix) support the NSDC and key government ministries to strengthen institutional arrangements to enable the TVET system to meet policy objectives within a coherent skills development framework; and</p><p style="text-align: left;">  </p><p style="text-align: left;">&nbsp;&nbsp;&nbsp;&nbsp;(x) support the establishment and operationalization of a National Human Resources Development Fund (NHRDF).</p><p>  </p><p><br></p><p><img class="fr-image-dropped fr-fin fr-dib" alt="Image title" src="http://i.froala.com/download/a39b702e868e0e90b776888e1532eb2ad3d69c9d.jpg?1433875676" width="300"><br></p><p>The project will have four components:&nbsp;<br>  </p><p>  </p><p>&nbsp;&nbsp;&nbsp;&nbsp;(I) Market response inclusive skills training delivered,&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;(II) Quality Assurance System strengthened,&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;(III) Institutions strengthened, and&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;(IV) Effective program management.</p><p><br></p>', CAST(0x0000A4B3000D3A79 AS DateTime), 4, N's', 4)
INSERT [dbo].[post] ([pid], [title], [post], [dateOfPost], [hitCount], [status], [uid]) VALUES (9, N'BITM SEIP Training Program', N'<p>BASIS, through Skills for Employment Investment Program (SEIP) will to train up 23,000 over the contract period of 3 years. 5000, 9000 and 9000 trainees will be trained in the 1st, 2nd and 3rd year respectively. BASIS institute of Technology &amp; Management (BITM) is planning to proposed twelve courses for new entrants and two courses for up skilling programs under this SEIP project.<img class="fr-fin fr-dib" alt="Image title" src="http://i.froala.com/download/4bce677f2c35af808cb94449f7057c0bcb34424c.jpg?1433875985" width="733"></p>', CAST(0x0000A4B3000E7D15 AS DateTime), 15, N'p', 4)
INSERT [dbo].[post] ([pid], [title], [post], [dateOfPost], [hitCount], [status], [uid]) VALUES (10, N'History', N'<p style="text-align: left;">This article is about the academic discipline.  For a general history of human beings, see <a href="https://en.wikipedia.org/wiki/History_of_the_world" title="History of the world">History of the world</a>.  For other uses, see <a href="https://en.wikipedia.org/wiki/History_%28disambiguation%29" title="History (disambiguation)">History (disambiguation)</a>.</p><p style="text-align: center;"><a href="https://en.wikipedia.org/wiki/File:Gyzis_006_%28%CE%97istoria%29.jpeg"><img title="Historical Image" class="fr-image-dropped fr-fin fr-dii" alt="Historical Image" src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/02/Gyzis_006_%28%CE%97istoria%29.jpeg/220px-Gyzis_006_%28%CE%97istoria%29.jpeg" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/0/02/Gyzis_006_%28%CE%97istoria%29.jpeg/330px-Gyzis_006_%28%CE%97istoria%29.jpeg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/0/02/Gyzis_006_%28%CE%97istoria%29.jpeg/440px-Gyzis_006_%28%CE%97istoria%29.jpeg 2x" data-file-width="750" data-file-height="750" height="220" width="220"></a>                </p><p>  </p><p> </p><p><b>History</b> (from <a href="https://en.wikipedia.org/wiki/Ancient_Greek" title="Ancient Greek">Greek</a> <span lang="el">?st???a</span>, <i>historia</i>, meaning "inquiry, knowledge acquired by investigation")<sup id="cite_ref-JosephJanda_2-0"><a href="https://en.wikipedia.org/wiki/History#cite_note-JosephJanda-2">[2]</a></sup> is the study of the past, particularly how it relates to humans.<sup id="cite_ref-3"><a href="https://en.wikipedia.org/wiki/History#cite_note-3">[3]</a></sup><sup id="cite_ref-4"><a href="https://en.wikipedia.org/wiki/History#cite_note-4">[4]</a></sup> It is an <a href="https://en.wikipedia.org/wiki/Umbrella_term" title="Umbrella term">umbrella term</a>  that relates to past events as well as the memory, discovery,  collection, organization, presentation, and interpretation of  information about these events. Scholars who write about history are  called <a href="https://en.wikipedia.org/wiki/Historian" title="Historian">historians</a>. Events occurring prior to written record are considered <a href="https://en.wikipedia.org/wiki/Prehistory" title="Prehistory">prehistory</a>.</p><p>History can also refer to the academic discipline which uses a <a href="https://en.wikipedia.org/wiki/Narrative" title="Narrative">narrative</a>  to examine and analyse a sequence of past events, and objectively  determine the patterns of cause and effect that determine them.<sup id="cite_ref-evans1_5-0"><a href="https://en.wikipedia.org/wiki/History#cite_note-evans1-5">[5]</a></sup><sup id="cite_ref-6"><a href="https://en.wikipedia.org/wiki/History#cite_note-6">[6]</a></sup> Historians sometimes debate the <a href="https://en.wikipedia.org/wiki/Historiography" title="Historiography">nature of history</a>  and its usefulness by discussing the study of the discipline as an end  in itself and as a way of providing "perspective" on the problems of the  present.<sup id="cite_ref-evans1_5-1"><a href="https://en.wikipedia.org/wiki/History#cite_note-evans1-5">[5]</a></sup><sup id="cite_ref-Tosh1_7-0"><a href="https://en.wikipedia.org/wiki/History#cite_note-Tosh1-7">[7]</a></sup><sup id="cite_ref-8"><a href="https://en.wikipedia.org/wiki/History#cite_note-8">[8]</a></sup><sup id="cite_ref-9"><a href="https://en.wikipedia.org/wiki/History#cite_note-9">[9]</a></sup></p><p>Stories common to a particular culture, but not supported by external sources (such as the tales surrounding <a href="https://en.wikipedia.org/wiki/King_Arthur" title="King Arthur">King Arthur</a>) are usually classified as <a href="https://en.wikipedia.org/wiki/Cultural_heritage" title="Cultural heritage">cultural heritage</a> or <a href="https://en.wikipedia.org/wiki/Legend" title="Legend">legends</a>, because they do not support the "disinterested investigation" required of the discipline of history.<sup id="cite_ref-10"><a href="https://en.wikipedia.org/wiki/History#cite_note-10">[10]</a></sup><sup id="cite_ref-Low1_11-0"><a href="https://en.wikipedia.org/wiki/History#cite_note-Low1-11">[11]</a></sup> <a href="https://en.wikipedia.org/wiki/Herodotus" title="Herodotus">Herodotus</a>, a 5th-century BC <a href="https://en.wikipedia.org/wiki/Greek_historiography" title="Greek historiography">Greek historian</a> is considered within the Western tradition to be the "father of history", and, along with his contemporary <a href="https://en.wikipedia.org/wiki/Thucydides" title="Thucydides">Thucydides</a>,  helped form the foundations for the modern study of human history.  Their work continues to be read today and the divide between the  culture-focused Herodotus and the military-focused Thucydides remains a  point of contention or approach in modern historical writing. In the  Eastern tradition, a state chronicle the <a href="https://en.wikipedia.org/wiki/Spring_and_Autumn_Annals" title="Spring and Autumn Annals">Spring and Autumn Annals</a> was known to be compiled from as early as 722 BC although only 2nd century BC texts survived.</p><p>Ancient influences have helped spawn variant interpretations of the  nature of history which have evolved over the centuries and continue to  change today. The modern study of history is wide-ranging, and includes  the study of specific regions and the study of certain topical or  thematical elements of historical investigation. Often history is taught  as part of primary and secondary education, and the academic study of  history is a <a href="https://en.wikipedia.org/wiki/List_of_academic_disciplines#History" title="List of academic disciplines">major discipline</a> in University studies.</p>', CAST(0x0000A4B3005AF76E AS DateTime), 49, N'p', 1)
INSERT [dbo].[post] ([pid], [title], [post], [dateOfPost], [hitCount], [status], [uid]) VALUES (11, N'??????? ???????? ???? ???? ????? ???? ??????? ????? ???? ????? ? ???? ????????? ?????? ??????', N'<p>???????? ???? ???? ??’???? ???????? ??????? ????? ???? ?? ???????  ????? ??????? ??-?? ?? ???? ???????? ??? ????? ????? ??? ??????????  ???????? ???? ???? ????????? ???? ?? ??? ?????????? ???? ???? ???? ??  ??? ????? ???? ?? ??????? ?? ??? ?? ???? ?????, ?????? ???? ????  ????????? ?? ?? ????? ?????? ??????? ???????</p><h2><strong>???????? ???? ???? ??????? ????? ???? ???? ????????? ?????? ?????? </strong></h2><p>????????  ???? ???? ????? ???? ?? ??????? ????? ??????? ??????? ?????? ???? ????  ????? ????? ???? ???? ??????? ???? ????? ????? ?????? ???? ?????????  ?????? ?????? ??? ????? ??? ????? ???? ????????? ????? ????? ????? ???  ??????&nbsp; ????? ???? ???? ?????? ?????? ?????</p><h3>???? ????????? ????? ????? ????????? ???? ????? ??????? ??????? ???????? ?????</h3><p><a href="http://www.crictunes.com/archives/478" target="_blank">????? ???????? ? ???? ?????????</a></p><p><a href="http://www.crictunes.com/archives/486" target="_blank">????? ???????? ? ???? ?????????</a></p><p><a href="http://www.crictunes.com/archives/732" target="_blank">???? ???? ???? ?????????</a></p><h2><strong>???????? ???? ???? ??????? ????? ???? ???? ????? ?????? ?????? </strong></h2><p>???????? ???? ???? ????? ???? ?? ??????? ????? ????? ?? ?? ??? ?? ???? ????? ????? ???? ???? <a href="http://www.crictunes.com/scorecard" target="_blank">?? ????? ????</a>? ??? ???? ???? ?? ? ??? ?????? <img class="fr-dii fr-fin" data-lazy-loaded="true" src="http://www.crictunes.com/wp-includes/images/smilies/simple-smile.png" alt=":)">?????? ???? ???? ????? ????? ?????? ??? <a href="http://m.espncricinfo.com/ci/engine/match/870729.html" target="_blank">????? ????? ????</a>?</p><h2><strong>???????? ???? ???? ??????? ????? ???? ???????</strong></h2><h3><strong>???????? ??</strong></h3><p><strong>???????? ???????</strong>:  &nbsp;???????? ???? (???????), ????? ????? (??-???????), ????? ?????,  ??????? ??, ????? ?????, ????? ?? ?????, ????? ?????, ?????? ????,  ???????? ????, ???? ????? ????, ??????? ????? ????, ????? ?????, ??????  ????? ? ???? ????? ????</p><h3><strong>???? ??</strong></h3><p>?????  ????? (???????), ?????? ????, ???? ??????, ????? ?????, ??????? ??????,  ??????? ???????, ????? ?????, ????????? ????, ?????????? ??????, ?????  ???, ??? ?????, ????????? ?????, ???? ????, ???? ?????? ? ?????? ??????</p>', CAST(0x0000A4B500D0A87E AS DateTime), 0, N'p', 6)
INSERT [dbo].[post] ([pid], [title], [post], [dateOfPost], [hitCount], [status], [uid]) VALUES (12, N'?????? ?? ????????????? ????????? ???? ??? ? ???? ??? ????????????? ??? ????? ??????', N'<p>???? ???? ???? ??? ??????? ????? ???? ???? ?????? ????? ??? ??????</p><p>??? ???? ???? ??????? ???,?????? ?? ??? ????? ?? ????? ????</p><p>?????  ?????? ??? ???????? ????? ?? ?????? ???????? ?? ????????? ????? ??  ?????????? ???????? ?????? ????? ?? ?? ??? ??? ????????? ????? ?? ?????  ????? ???? ????? &nbsp;?? ????? ???? ?? ??? ???? ????? ?????? ?????? ????  ????</p><p><span id="media_0"><img class="fr-dii fr-fin" data-lazy-loaded="true" src="http://paimages.prothom-alo.com/contents/cache/images/300x0x1/uploads/media/2015/06/12/87ed89f5cce7f67c13cc490553fa7822-Gionee-Marathon-M5-compressed.jpg" alt="????? ??" width="300"></span>?????  ?? ????????????? ????? ?????? ????? ?? ?? ????????????? ?????????  ???????????? ?????? ?? ??????????? ????? ??? ???? ????????? ????? ????  ??? ????????????? ??? ????? ?????? ? ????? ?? ?????? ?????  ?????-???????? ????? ? ????????? ?????, ????????? ???? ???????????????,  ???????? ???, ????? ????? ????????, ????????? ???????? ????, ????? ???  ????? ????????? ??? ????? ?????? ?????????????? ????????????  ?????????????? ??????? ???????? ?????? ???? ?? ????????????? ????????  ?????? ???????????? ?.? ?? ???????????? ???????? ?.? ?????????? ????  ?????? ??? ????? ??????? ????? ????????? ?????? ????? ?? ????? ?????  ??????? (???? ??? ???? ???????) ????? ????????? ???????? ??????? ?????  ??? ?????????? ????? ??? ????????? ????? ???? ?? ??? ? ??? ???? ???????  ??????? ?? ???????? ??????? ??????? ? ?????? ?????? ?????? ?????????????  ???????? ??? ??? ????? ??? ????????????????? ???? ?????????? ?????  ?????? ?????? ??????</p>', CAST(0x0000A4B6000DD58F AS DateTime), 3, N'p', 1)
SET IDENTITY_INSERT [dbo].[post] OFF
SET IDENTITY_INSERT [dbo].[userInfo] ON 

INSERT [dbo].[userInfo] ([uid], [fName], [lName], [about], [image], [lid]) VALUES (1, N'Yeasin', N'Arafat', N'I am CSE student of AIUB', N'1.jpg', 1)
INSERT [dbo].[userInfo] ([uid], [fName], [lName], [about], [image], [lid]) VALUES (3, N'Tarik', N'Rahman', NULL, N'0.jpg', 3)
INSERT [dbo].[userInfo] ([uid], [fName], [lName], [about], [image], [lid]) VALUES (4, N'Ananna', N'Rahman', NULL, N'0.jpg', 4)
INSERT [dbo].[userInfo] ([uid], [fName], [lName], [about], [image], [lid]) VALUES (5, N'c', N'k', NULL, N'0.jpg', 5)
INSERT [dbo].[userInfo] ([uid], [fName], [lName], [about], [image], [lid]) VALUES (6, N'Farida ', N'Yeasmin', NULL, N'0.jpg', 6)
SET IDENTITY_INSERT [dbo].[userInfo] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_login]    Script Date: 13-Jun-15 11:19:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_login] ON [dbo].[login]
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[comment] ADD  CONSTRAINT [DF_comment_dateOfDate]  DEFAULT (getdate()) FOR [dateOfComment]
GO
ALTER TABLE [dbo].[post] ADD  CONSTRAINT [DF_post_title]  DEFAULT ('untitled') FOR [title]
GO
ALTER TABLE [dbo].[post] ADD  CONSTRAINT [DF_post_dateOfPost]  DEFAULT (getdate()) FOR [dateOfPost]
GO
ALTER TABLE [dbo].[post] ADD  CONSTRAINT [DF_post_hitCount]  DEFAULT ((0)) FOR [hitCount]
GO
ALTER TABLE [dbo].[post] ADD  CONSTRAINT [DF_post_satatus]  DEFAULT ('s') FOR [status]
GO
ALTER TABLE [dbo].[userInfo] ADD  CONSTRAINT [DF_userInfo_image]  DEFAULT ('0.jpg') FOR [image]
GO
ALTER TABLE [dbo].[comment]  WITH CHECK ADD  CONSTRAINT [FK_comment_post] FOREIGN KEY([pid])
REFERENCES [dbo].[post] ([pid])
GO
ALTER TABLE [dbo].[comment] CHECK CONSTRAINT [FK_comment_post]
GO
ALTER TABLE [dbo].[comment]  WITH CHECK ADD  CONSTRAINT [FK_comment_userInfo] FOREIGN KEY([uid])
REFERENCES [dbo].[userInfo] ([uid])
GO
ALTER TABLE [dbo].[comment] CHECK CONSTRAINT [FK_comment_userInfo]
GO
ALTER TABLE [dbo].[post]  WITH CHECK ADD  CONSTRAINT [FK_post_userInfo] FOREIGN KEY([uid])
REFERENCES [dbo].[userInfo] ([uid])
GO
ALTER TABLE [dbo].[post] CHECK CONSTRAINT [FK_post_userInfo]
GO
ALTER TABLE [dbo].[userInfo]  WITH CHECK ADD  CONSTRAINT [FK_userInfo_login] FOREIGN KEY([lid])
REFERENCES [dbo].[login] ([lid])
GO
ALTER TABLE [dbo].[userInfo] CHECK CONSTRAINT [FK_userInfo_login]
GO
USE [master]
GO
ALTER DATABASE [dreamCoderBlog] SET  READ_WRITE 
GO
